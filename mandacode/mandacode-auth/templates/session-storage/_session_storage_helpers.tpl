{{- define "app.session.storage.secretName" }}
{{- if .Values.session.storage.existingSecret -}}
{{- .Values.session.storage.existingSecret }}
{{- else -}}
{{ printf "%s-session-storage-secret" .Release.Name }}
{{- end }}
{{- end }}
