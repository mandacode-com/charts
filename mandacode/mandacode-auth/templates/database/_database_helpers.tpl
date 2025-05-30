{{- define "app.database.secretName" }}
{{- if .Values.database.existingSecret }}
{{- .Values.database.existingSecret }}
{{- else -}}
{{ printf "%s-db-secret" .Release.Name }}
{{- end }}
{{- end }}
