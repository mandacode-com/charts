{{/*
Expand the name of the chart.
*/}}
{{- define "mandacode-auth.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mandacode-auth.fullname" -}}
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
{{- define "mandacode-auth.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mandacode-auth.labels" -}}
helm.sh/chart: {{ include "mandacode-auth.chart" . }}
{{ include "mandacode-auth.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mandacode-auth.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mandacode-auth.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mandacode-auth.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mandacode-auth.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
  Config map name
*/}}
{{- define "core.configMapName" -}}
{{- default (printf "%s-core-config" .Release.Name) .Values.core.configMapName }}
{{- end }}

{{/*
  Cookie Secret Name
*/}}
{{- define "core.cookie.secretName" -}}
{{- default (printf "%s-core-cookie-secret" .Release.Name) .Values.cookie.secretName }}
{{- end }}

{{/*
  Databse Secret Name
*/}}
{{- define "core.database.secretName" -}}
{{- default (printf "%s-core-db-secret" .Release.Name) .Values.database.secretName }}
{{- end }}

{{/*
  Session Storage Secret Name
*/}}
{{- define "core.session.storage.secretName" -}}
{{- default (printf "%s-core-session-storage-secret" .Release.Name) .Values.session.storage.secretName }}
{{- end }}

{{/*
  JWT Access Secret Name
*/}}
{{- define "core.jwt.access.secretName" -}}
{{- default (printf "%s-core-jwt-access-secret" .Release.Name) .Values.jwt.access.secretName }}
{{- end }}
{{/*
  JWT Refresh Secret Name
*/}}
{{- define "core.jwt.refresh.secretName" -}}
{{- default (printf "%s-core-jwt-refresh-secret" .Release.Name) .Values.jwt.refresh.secretName }}
{{- end }}

{{/*
  JWT Email Verification Secret Name
*/}}
{{- define "core.jwt.emailVerification.secretName" -}}
{{- default (printf "%s-core-jwt-email-secret" .Release.Name) .Values.jwt.emailVerification.secretName }}
{{- end }}
