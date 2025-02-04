{{/*
This template serves as a blueprint for all Ingress objects that are created
within the common library.
*/}}
{{- define "common.classes.ingress" -}}
  {{- $fullName := include "common.names.fullname" . -}}
  {{- $ingressName := $fullName -}}
  {{- $values := .Values.ingress -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.ingress -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $ingressName = printf "%v-%v" $ingressName $values.nameOverride -}}
  {{- end -}}

  {{- $primaryService := get .Values.service (include "common.service.primary" .) -}}
  {{- $defaultServiceName := $fullName -}}
  {{- if and (hasKey $primaryService "nameOverride") $primaryService.nameOverride -}}
    {{- $defaultServiceName = printf "%v-%v" $defaultServiceName $primaryService.nameOverride -}}
  {{- end -}}
  {{- $defaultServicePort := get $primaryService.ports (include "common.classes.service.ports.primary" (dict "values" $primaryService)) -}}

  {{- $isStable := include "common.capabilities.ingress.isStable" . }}

  {{- $mddwrNamespace := "default" }}
  {{- if $values.ingressClassName }}
  {{- $mddwrNamespace := ( printf "ix-%s" $values.ingressClassName ) }}
  {{- end }}

  {{- $fixedMiddlewares := "" }}
  {{- if $values.enableFixedMiddlewares }}
  {{ range $index, $fixedMiddleware := $values.fixedMiddlewares }}
      {{- if $index }}
      {{ $fixedMiddlewares = ( printf "%v, %v-%v@%v" $fixedMiddlewares $mddwrNamespace $fixedMiddleware "kubernetescrd" ) }}
      {{- else }}
      {{ $fixedMiddlewares = ( printf "%v-%v@%v" $mddwrNamespace $fixedMiddleware "kubernetescrd" ) }}
      {{- end }}
  {{ end }}
  {{- end }}

  {{- $middlewares := "" }}
  {{ range $index, $middleware := $values.middlewares }}
      {{- if $index }}
      {{ $middlewares = ( printf "%v, %v-%v@%v" $middlewares $mddwrNamespace $middleware "kubernetescrd" ) }}
      {{- else }}
      {{ $middlewares = ( printf "%v-%v@%v" $mddwrNamespace $middleware "kubernetescrd" ) }}
      {{- end }}
  {{ end }}

  {{- if and ( $fixedMiddlewares ) ( $middlewares ) }}
    {{ $middlewares = ( printf "%v, %v" $fixedMiddlewares $middlewares ) }}
  {{- else if $fixedMiddlewares }}
      {{ $middlewares = ( printf "%s" $fixedMiddlewares ) }}
  {{ end }}

---
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ $ingressName }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
    {{- with $values.labels }}
       {{- toYaml . | nindent 4 }}
    {{- end }}
  annotations:
    "traefik.ingress.kubernetes.io/router.entrypoints": {{ $values.entrypoint | default "websecure" }}
    "traefik.ingress.kubernetes.io/router.middlewares": {{ $middlewares | quote }}
  {{- with $values.annotations }}
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if and $isStable $values.ingressClassName }}
  ingressClassName: {{ $values.ingressClassName }}
  {{- end }}
  {{- if $values.tls }}
  tls:
    {{- range $index, $tlsValues :=  $values.tls }}
    - hosts:
        {{- range $tlsValues.hosts }}
        - {{ tpl . $ | quote }}
        {{- end }}
      {{- if $tlsValues.scaleCert }}
      secretName: {{ ( printf "%v-%v-%v-%v-%v" $ingressName "tls" $index "ixcert" $tlsValues.scaleCert ) }}
      {{- else if .secretName }}
      secretName: {{ tpl .secretName $ | quote}}
      {{- end }}
    {{- end }}
  {{- end }}
  rules:
  {{- range $values.hosts }}
    - host: {{ tpl .host $ | quote }}
      http:
        paths:
          {{- range .paths }}
          {{- $service := $defaultServiceName -}}
          {{- $port := $defaultServicePort.port -}}
          {{- if .service -}}
            {{- $service = default $service .service.name -}}
            {{- $port = default $port .service.port -}}
          {{- end }}
          - path: {{ tpl .path $ | quote }}
            {{- if $isStable }}
            pathType: {{ default "Prefix" .pathType }}
            {{- end }}
            backend:
              {{- if $isStable }}
              service:
                name: {{ $service }}
                port:
                  number: {{ $port }}
              {{- else }}
              serviceName: {{ $service }}
              servicePort: {{ $port }}
              {{- end }}
          {{- end }}
  {{- end }}
{{- end }}
