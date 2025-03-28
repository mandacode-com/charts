local core = require("apisix.core")
local jwt = require("resty.jwt")
local hmac = require("resty.hmac")
local resty_string = require("resty.string")
local validators = require("resty.jwt-validators")

local schema = {
	type = "object",
	properties = {
		force_auth = { type = "boolean", default = false },
		gateway_header_prefix = { type = "string", default = "X-Gateway-" },
		public_key = { type = "string" },
		hmac_secret = { type = "string" },
		exposed_payload_keys = {
			type = "array",
			items = {
				type = "string",
			},
			default = {
        "UUID",
        "Role",
			},
		},
	},
	required = { "public_key", "hmac_secret" },
	additionalProperties = false,
}

local plugin_name = "rsa-jwt"

local _M = {
	version = 0.1,
	priority = 1000,
	name = plugin_name,
	schema = schema,
}

-- @function unauthorized
local function unauthorized(message)
	core.response.exit(401, { message = message })
end

-- @function get_bearer_token
local function get_bearer_token(header)
	if not header then
		return nil
	end

	if header:sub(1, 7):lower() == "bearer " then
		return header:sub(8)
	end

	return nil
end

-- @function verify_jwt
local function verify_jwt(token, public_key)
	local jwt_obj = jwt:load_jwt(token)
	if not jwt_obj.valid or not jwt_obj.payload then
		return nil, "Invalid JWT token"
	end

	local claim_spec = {
		exp = validators.is_not_expired(),
		iat = validators.is_not_before(),
	}

	local jwt_verify = jwt:verify_jwt_obj(public_key, jwt_obj, claim_spec)

	if not jwt_verify.verified then
		return nil, "JWT verification failed"
	end

	return jwt_obj.payload, nil
end

-- @function check_schema
function _M.check_schema(conf)
	return core.schema.check(schema, conf)
end

-- @function access
function _M.access(conf, ctx)
	local auth_header = core.request.header(ctx, "Authorization")
	local token = get_bearer_token(auth_header)

	if not token then
		if conf.force_auth then
			unauthorized("Missing or Invalid Authorization header")
		end
		return
	end

	local payload, err = verify_jwt(token, conf.public_key)
	if not payload then
		if conf.force_auth then
			unauthorized(err)
		end
		return
	end

	local signing_parts = { token }

	for _, key in ipairs(conf.exposed_payload_keys or {}) do
		local value = payload[key]
		if value then
			local sanitized_value = type(value) == "string" and value:gsub("[\r\n]", "") or tostring(value)
			core.request.set_header(ctx, conf.gateway_header_prefix .. key, sanitized_value)
			signing_parts[#signing_parts + 1] = sanitized_value
		end
	end

	local signing_data = table.concat(signing_parts, ":")
	local signer = hmac:new(conf.hmac_secret, hmac.ALGOS.SHA256)
	local mac_hex = resty_string.to_hex(signer:final(signing_data))

	core.request.set_header(ctx, conf.gateway_header_prefix .. "MAC", mac_hex)
end

return _M
