{{- define "main-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "main-app.fullname" -}}
{{ include "main-app.name" . }}-{{ .Release.Name }}
{{- end }}
