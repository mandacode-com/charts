{{- define "app.core.openai.secretName" }}
{{- if .Values.core.openai.existingSecret -}}
{{ .Values.core.openai.existingSecret }}
{{- else -}}
{{ printf "%s-core-openai-secret" .Release.Name }}
{{- end }}
{{- end }}

{{- define "app.gateway.secretName" }}
{{- if .Values.gateway.existingSecret -}}
{{ .Values.gateway.existingSecret }}
{{- else -}}
{{ printf "%s-gateway-secret" .Release.Name }}
{{- end }}
{{- end }}

{{- define "app.database.secretName" }}
{{- if .Values.database.existingSecret -}}
{{ .Values.database.existingSecret }}
{{- else -}}
{{ printf "%s-db-secret" .Release.Name }}
{{- end }}
{{- end }}
