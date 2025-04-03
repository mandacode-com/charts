{{- define "app.database.secretName" }}
{{- if .Values.database.existingSecret -}}
{{ .Values.database.existingSecret }}
{{- else -}}
{{ printf "%s-db-secret" .Release.Name }}
{{- end }}
{{- end }}

{{- define "app.session.storage.secretName" }}
{{- if .Values.session.storage.existingSecret -}}
{{ .Values.session.storage.existingSecret }}
{{- else -}}
{{ printf "%s-session-storage-secret" .Release.Name }}
{{- end }}
{{- end }}

{{- define "app.core.oauth.secretName" }}
{{- if .Values.core.oauth.existingSecret }}
{{ .Values.core.oauth.existingSecret }}
{{- else -}}
{{ printf "%s-oauth-secret" .Release.Name }}
{{- end }}
{{- end }}

{{- define "app.core.cookie.secretName" }}
{{- if .Values.core.cookie.existingSecret }}
{{ .Values.core.cookie.existingSecret }}
{{- else -}}
{{ printf "%s-core-cookie-secret" .Release.Name }}
{{- end }}
{{- end }}
