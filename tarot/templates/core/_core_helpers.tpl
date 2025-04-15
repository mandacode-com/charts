{{/*
Name
*/}}
{{- define "app.core.name" -}}
{{- if .Values.core.nameOverride }}
{{- .Values.core.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
core
{{- end }}
{{- end }}

{{/*
Fullname
*/}}
{{- define "app.core.fullname" }}
{{- if .Values.core.fullnameOverride }}
{{- .Values.core.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-core" .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "app.core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.core.labels" -}}
helm.sh/chart: {{ include "app.core.chart" . }}
{{ include "app.core.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Config map name
*/}}
{{- define "app.core.configMapName" }}
{{- if .Values.core.configMapName }}
{{ .Values.core.configMapName }}
{{- else -}}
{{ printf "%s-core-config" .Release.Name }}
{{- end }}
{{- end }}

{{/*
Service Account Name
*/}}
{{- define "app.core.serviceAccountName" }}
{{- if .Values.core.serviceAccount.create }}
{{- default (include "app.core.fullname" .) .Values.core.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.core.serviceAccount.name }}
{{- end }}
{{- end }}
