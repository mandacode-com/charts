local core = require("apisix.core")

local schema = {
	type = "object",
	properties = {
		enabled = { type = "boolean", default = true },
		force_auth = { type = "boolean", default = false },
		gateway_auth_header = { type = "string", default = "X-Gateway-Verified" },
		public_key = { type = "string" },
		hmac_secret = { type = "string" },
		exposed_payload_keys = {
			type = "array",
			items = {
				type = "string",
			},
			default = {
				"uuid",
				"role",
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

  local parts = core.utils.split(header, " ")
  if #parts ~= 2 or parts[1]:lower() ~= "bearer" then
    return nil
  end

  return parts[2]
end

-- @function check_schema
function _M.check_schema(conf)
	return core.schema.check(schema, conf)
end

-- @function access
function _M.access(conf, ctx)
	-- Check if the plugin is enabled
	if not conf.enabled then
		return
	end

	local auth_header = core.request.header(ctx, "Authorization")
	local token = get_bearer_token(auth_header)
	if not token then
		if conf.force_auth then
			unauthorized("Missing or Invalid Authorization header")
		end
		return
	end

	core.request.set_header(ctx, conf.gateway_auth_header, "test")
end

return _M
