
{{- define "common.resourceTemplate" -}}
resources:
  {{- toYaml .Values.resources | nindent 2 }}
{{- end -}}


{{- define "common.labels" -}}
app.kubernetes.io/name: {{ include "common.names.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.names.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Generic service template
*/}}
{{- define "common.service" -}}
{{- $fullName := include "common.names.fullname" . -}}
apiVersion: {{ .Values.service.apiversion | default "v1" }}
kind: Service
metadata:
  name: {{ template "common.names.fullname" . }}
  labels:
    app: {{ include "common.names.fullname" . | default .Values.service.appLabel  }}
    {{- with .Values.service.additionalLabels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  ports:
    - name: {{ .Values.service.mainPort.name | default "http" }}
      port: {{ .Values.service.mainPort.port | default 80 }}
      protocol: {{ .Values.service.mainPort.protocol | default "TCP" }}
      targetPort: {{ .Values.service.mainPort.targetPort | default 5000 }}
    {{- if .Values.service.actuatorPort }}
    - name: actuator
      protocol: TCP
      port: {{ .Values.service.actuatorPort.port | default 8080 }}
      targetPort: {{ .Values.service.actuatorPort.targetPort | default 8080 }}
    {{- end }}
  selector:
    app: {{ .Values.service.selectorApp | default $fullName }}
  sessionAffinity: {{ .Values.service.sessionAffinity | default "None" }}
  type: {{ .Values.service.type | default "ClusterIP" }}
{{- end }}