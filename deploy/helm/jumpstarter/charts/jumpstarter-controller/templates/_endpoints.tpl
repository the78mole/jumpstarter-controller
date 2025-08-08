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
Get the effective namespace - processes templateable namespace if provided
*/}}
{{- define "jumpstarter.namespace" -}}
{{- if .Values.templateableNamespace -}}
{{- tpl .Values.templateableNamespace . -}}
{{- else if .Values.namespace -}}
{{- .Values.namespace -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective image - processes templateable image if provided
*/}}
{{- define "jumpstarter.image" -}}
{{- if .Values.templateableImage -}}
{{- tpl .Values.templateableImage . -}}
{{- else -}}
{{- .Values.image -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective tag - processes templateable tag if provided
*/}}
{{- define "jumpstarter.tag" -}}
{{- if .Values.templateableTag -}}
{{- tpl .Values.templateableTag . -}}
{{- else if .Values.tag -}}
{{- .Values.tag -}}
{{- else -}}
{{- .Chart.AppVersion -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc hostname - processes templateable hostname if provided
*/}}
{{- define "jumpstarter.grpc.hostname" -}}
{{- if .Values.grpc.templateableHostname -}}
{{- tpl .Values.grpc.templateableHostname . -}}
{{- else if .Values.grpc.hostname -}}
{{- .Values.grpc.hostname -}}
{{- else -}}
grpc.{{ .Values.global.baseDomain | required "grpc.hostname, grpc.templateableHostname, or global.baseDomain must be provided" }}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc router hostname - processes templateable router hostname if provided
*/}}
{{- define "jumpstarter.grpc.routerHostname" -}}
{{- if .Values.grpc.templateableRouterHostname -}}
{{- tpl .Values.grpc.templateableRouterHostname . -}}
{{- else if .Values.grpc.routerHostname -}}
{{- .Values.grpc.routerHostname -}}
{{- else -}}
router.{{ .Values.global.baseDomain | required "grpc.routerHostname, grpc.templateableRouterHostname, or global.baseDomain must be provided" }}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc endpoint - processes templateable endpoint if provided
*/}}
{{- define "jumpstarter.grpc.endpoint" -}}
{{- if .Values.grpc.templateableEndpoint -}}
{{- tpl .Values.grpc.templateableEndpoint . -}}
{{- else if .Values.grpc.endpoint -}}
{{- .Values.grpc.endpoint -}}
{{- else -}}
{{- include "jumpstarter.grpc.hostname" . -}}:{{- .Values.grpc.tls.port -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective grpc router endpoint - processes templateable router endpoint if provided
*/}}
{{- define "jumpstarter.grpc.routerEndpoint" -}}
{{- if .Values.grpc.templateableRouterEndpoint -}}
{{- tpl .Values.grpc.templateableRouterEndpoint . -}}
{{- else if .Values.grpc.routerEndpoint -}}
{{- .Values.grpc.routerEndpoint -}}
{{- else -}}
{{- include "jumpstarter.grpc.routerHostname" . -}}:{{- .Values.grpc.tls.port -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective TLS secret - processes templateable secret if provided
*/}}
{{- define "jumpstarter.grpc.tls.secret" -}}
{{- if .Values.grpc.tls.templateableSecret -}}
{{- tpl .Values.grpc.tls.templateableSecret . -}}
{{- else -}}
{{- .Values.grpc.tls.secret -}}
{{- end -}}
{{- end -}}

{{/*
Get the effective ingress class - processes templateable class if provided
*/}}
{{- define "jumpstarter.grpc.ingress.class" -}}
{{- if .Values.grpc.ingress.templateableClass -}}
{{- tpl .Values.grpc.ingress.templateableClass . -}}
{{- else -}}
{{- .Values.grpc.ingress.class -}}
{{- end -}}
{{- end -}}