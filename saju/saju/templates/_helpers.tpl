{{/*
Expand the name of the chart.
*/}}
{{- define "saju-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "saju-core.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "saju-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "saju-core.labels" -}}
helm.sh/chart: {{ include "saju-core.chart" . }}
{{ include "saju-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "saju-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "saju-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "saju-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "saju-core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "saju.auth.secretName" -}}
{{ printf "%s-auth-secret" .Release.Name }}
{{- end }}

{{- define "saju.database.host" -}}
{{- if .Values.database.host -}}
{{ .Values.database.host }}
{{- else -}}
{{ printf "%s.%s.svc.cluster.local" .Values.postgresql.fullnameOverride .Release.Namespace }}
{{- end }}
{{- end }}

{{- define "saju.database.secretName" -}}
{{ printf "%s-database-secret" .Release.Name }}
{{- end}}
