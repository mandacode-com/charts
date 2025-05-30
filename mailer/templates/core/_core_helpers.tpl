{{/*
Expand the name of the chart.
*/}}
{{- define "app.core.name" -}}
{{- if .Values.nameOverride }}
{{- .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- else -}}
core
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.core.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "app.core.name" .) | trunc 63 | trimSuffix "-" }}
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
Create the name of the service account to use
*/}}
{{- define "app.core.serviceAccountName" -}}
{{- if .Values.core.serviceAccount.create }}
{{- default (include "app.core.fullname" .) .Values.core.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
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
Transport secret name
*/}}
{{- define "app.core.transport.secretName" }}
{{- if .Values.core.transport.existingSecret }}
{{- .Values.core.transport.existingSecret | quote }}
{{- else -}}
{{ printf "%s-transport-secret" .Release.Name }}
{{- end }}
{{- end }}
