{{- define "router.endpoint" }}{{ if .Values.grpc.routerHostname }}{{ .Values.grpc.routerHostname }}{{ else }}router.{{ .Values.global.baseDomain | required "grpc.routerHostname or global.baseDomain must be set"}}{{ end }}{{- end }}
{{- define "controller.endpoint" }}{{ if .Values.grpc.hostname }}{{ .Values.grpc.hostname }}{{ else }}grpc.{{ .Values.global.baseDomain | required "grpc.hostname or global.baseDomain must be set"}}{{ end }}{{- end }}

{{/*
Process a templateable value with tpl if it exists, otherwise return the default value
Usage: {{ include "jumpstarter.templateable" (dict "templateableValue" .Values.templateableImage "defaultValue" .Values.image "context" .) }}
*/}}
{{- define "jumpstarter.templateable" -}}
{{- if .templateableValue -}}
{{- tpl .templateableValue .context -}}
{{- else -}}
{{- .defaultValue -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective namespace - processes namespaceOverride if provided
*/}}
{{- define "jumpstarter.namespace" -}}
{{- if .Values.namespaceOverride -}}
{{- tpl .Values.namespaceOverride . -}}
{{- else if .Values.namespace -}}
{{- .Values.namespace -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective image - processes imageOverride if provided
*/}}
{{- define "jumpstarter.image" -}}
{{- if .Values.imageOverride -}}
{{- tpl .Values.imageOverride . -}}
{{- else -}}
{{- .Values.image -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective tag - processes tagOverride if provided
*/}}
{{- define "jumpstarter.tag" -}}
{{- if .Values.tagOverride -}}
{{- tpl .Values.tagOverride . -}}
{{- else if .Values.tag -}}
{{- .Values.tag -}}
{{- else -}}
{{- .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc hostname - processes hostnameOverride if provided
*/}}
{{- define "jumpstarter.grpc.hostname" -}}
{{- if .Values.grpc.hostnameOverride -}}
{{- tpl .Values.grpc.hostnameOverride . -}}
{{- else if .Values.grpc.hostname -}}
{{- .Values.grpc.hostname -}}
{{- else -}}
grpc.{{ .Values.global.baseDomain | required "grpc.hostname, grpc.hostnameOverride, or global.baseDomain must be provided" }}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc router hostname - processes routerHostnameOverride if provided
*/}}
{{- define "jumpstarter.grpc.routerHostname" -}}
{{- if .Values.grpc.routerHostnameOverride -}}
{{- tpl .Values.grpc.routerHostnameOverride . -}}
{{- else if .Values.grpc.routerHostname -}}
{{- .Values.grpc.routerHostname -}}
{{- else -}}
router.{{ .Values.global.baseDomain | required "grpc.routerHostname, grpc.routerHostnameOverride, or global.baseDomain must be provided" }}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc endpoint - processes endpointOverride if provided
*/}}
{{- define "jumpstarter.grpc.endpoint" -}}
{{- if .Values.grpc.endpointOverride -}}
{{- tpl .Values.grpc.endpointOverride . -}}
{{- else if .Values.grpc.endpoint -}}
{{- .Values.grpc.endpoint -}}
{{- else -}}
{{- include "jumpstarter.grpc.hostname" . -}}:{{- .Values.grpc.tls.port -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc router endpoint - processes routerEndpointOverride if provided
*/}}
{{- define "jumpstarter.grpc.routerEndpoint" -}}
{{- if .Values.grpc.routerEndpointOverride -}}
{{- tpl .Values.grpc.routerEndpointOverride . -}}
{{- else if .Values.grpc.routerEndpoint -}}
{{- .Values.grpc.routerEndpoint -}}
{{- else -}}
{{- include "jumpstarter.grpc.routerHostname" . -}}:{{- .Values.grpc.tls.port -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective TLS secret - processes secretOverride if provided
*/}}
{{- define "jumpstarter.grpc.tls.secret" -}}
{{- if .Values.grpc.tls.secretOverride -}}
{{- tpl .Values.grpc.tls.secretOverride . -}}
{{- else -}}
{{- .Values.grpc.tls.secret -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective ingress class - processes classOverride if provided
*/}}
{{- define "jumpstarter.grpc.ingress.class" -}}
{{- if .Values.grpc.ingress.classOverride -}}
{{- tpl .Values.grpc.ingress.classOverride . -}}
{{- else -}}
{{- .Values.grpc.ingress.class -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "jumpstarter.labels" -}}
{{ include "jumpstarter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jumpstarter.selectorLabels" -}}
app.kubernetes.io/name: jumpstarter-controller
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create common annotations
*/}}
{{- define "jumpstarter.annotations" -}}
{{- $annotations := dict -}}
{{- if .Values.commonAnnotations -}}
{{- $annotations = mustMerge $annotations (tpl (toYaml .Values.commonAnnotations) . | fromYaml) -}}
{{- end -}}
{{- if $annotations -}}
{{- toYaml $annotations -}}
{{- end -}}
{{- end -}}

{{/*
Create pod annotations for controller
*/}}
{{- define "jumpstarter.podAnnotations" -}}
{{- $annotations := dict -}}
{{- if .Values.commonAnnotations -}}
{{- $annotations = mustMerge $annotations (tpl (toYaml .Values.commonAnnotations) . | fromYaml) -}}
{{- end -}}
{{- if .Values.podAnnotations -}}
{{- $annotations = mustMerge $annotations (tpl (toYaml .Values.podAnnotations) . | fromYaml) -}}
{{- end -}}
{{- if $annotations -}}
{{- toYaml $annotations -}}
{{- end -}}
{{- end -}}

{{/*
Create pod annotations for router
*/}}
{{- define "jumpstarter.router.podAnnotations" -}}
{{- $annotations := dict -}}
{{- if .Values.commonAnnotations -}}
{{- $annotations = mustMerge $annotations (tpl (toYaml .Values.commonAnnotations) . | fromYaml) -}}
{{- end -}}
{{- if .Values.router.podAnnotations -}}
{{- $annotations = mustMerge $annotations (tpl (toYaml .Values.router.podAnnotations) . | fromYaml) -}}
{{- end -}}
{{- if $annotations -}}
{{- toYaml $annotations -}}
{{- end -}}
{{- end -}}