{{/*
Name
*/}}
{{- define "app.tokenService.name" -}}
{{- if .Values.tokenService.nameOverride }}
{{- .Values.tokenService.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
token-service
{{- end }}
{{- end }}

{{/*
Fullname
*/}}
{{- define "app.tokenService.fullname" }}
{{- if .Values.tokenService.fullnameOverride }}
{{- .Values.tokenService.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-token-service" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.tokenService.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.tokenService.labels" -}}
helm.sh/chart: {{ include "app.tokenService.chart" . }}
{{ include "app.tokenService.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.tokenService.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.tokenService.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Config map name
*/}}
{{- define "app.tokenService.configMapName" }}
{{- if .Values.tokenService.configMapName }}
{{ .Values.tokenService.configMapName }}
{{- else -}}
{{ printf "%s-token-service-config" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Service Account Name
*/}}
{{- define "app.tokenService.serviceAccountName" }}
{{- if .Values.tokenService.serviceAccount.create }}
{{- default (include "app.tokenService.fullname" .) .Values.tokenService.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.tokenService.serviceAccount.name }}
{{- end }}
{{- end }}
