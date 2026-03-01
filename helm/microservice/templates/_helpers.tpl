{{- define "microservice.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "microservice.fullname" -}}
{{ include "microservice.name" . }}-{{ .Release.Name }}
{{- end }}