{{- define "s3proxy.clientAccessKeyId" -}}
{{- if .Values.existingSecretName }}
{{- $secretObj := (lookup "v1" "Secret" .Release.Namespace  .Values.existingSecretName) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $access_key := (get $secretData "AWS_ACCESS_KEY_ID") | default (randAlphaNum 16 | b64enc) }}
{{- $access_key }}
{{- else }}
{{- $baseName := include "s3proxy.fullname" . -}}
{{- $fullName := printf "%s-%s" $baseName "awsclient" -}}
{{- $secretObj := (lookup "v1" "Secret" .Release.Namespace (print $fullName)) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $access_key := (get $secretData "AWS_ACCESS_KEY_ID") | default (randAlphaNum 16 | b64enc) }}
{{- $access_key }}
{{- end }}
{{- end }}

{{- define "s3proxy.clientSecretAccessKey" -}}
{{- if .Values.existingSecretName }}
{{- $secretObj := (lookup "v1" "Secret" .Release.Namespace  .Values.existingSecretName) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $access_secret := (get $secretData "AWS_SECRET_ACCESS_KEY") | default (randAlphaNum 16 | b64enc) }}
{{- $access_secret }}
{{- else }}
{{- $baseName := include "s3proxy.fullname" . -}}
{{- $fullName := printf "%s-%s" $baseName "awsclient" -}}
{{- $secretObj := (lookup "v1" "Secret" .Release.Namespace (print $fullName)) | default dict }}
{{- $secretData := (get $secretObj "data") | default dict }}
{{- $access_secret := (get $secretData "AWS_SECRET_ACCESS_KEY") | default (randAlphaNum 32 | b64enc) }}
{{- $access_secret }}
{{- end }}
{{- end }}

{{- define "s3proxy.properties" -}}
LOG_LEVEL={{ .Values.logLevel | default "info" }}
# S3 Client using the proxy will auth
{{- $clientAccessKeyId := include "s3proxy.clientAccessKeyId" . }}
s3proxy.identity={{ $clientAccessKeyId | b64dec }}
{{- $clientSecretAccessKey := include "s3proxy.clientSecretAccessKey" . }}
s3proxy.credential={{ $clientSecretAccessKey | b64dec }}
#General config
s3proxy.authorization={{ .Values.config.s3proxy.authorization }}
s3proxy.endpoint=http://0.0.0.0:{{ .Values.service.port }}
s3proxy.ignore-unknown-headers={{ .Values.config.s3proxy.ignoreUnknownHeaders }}
s3proxy.read-only-blobstore={{ .Values.config.s3proxy.readOnlyBlobStore }}
s3proxy.v4-max-non-chunked-request-size={{ printf "%s" .Values.config.s3proxy.v4MaxNonChunkedRequestSize }}
#Jclouds Config
jclouds.provider={{ .Values.config.jclouds.provider }}
{{- if eq .Values.config.jclouds.provider "filesystem" }}
jclouds.filesystem.basedir={{ .Values.config.jclouds.filesystem.baseDir }}
{{- end }}
#Azureblob
{{- if eq .Values.config.jclouds.provider "azureblob" }}
jclouds.azureblob.auth={{ .Values.config.jclouds.azureblob.auth }}
jclouds.endpoint={{ .Values.config.jclouds.azureblob.endpoint }}
jclouds.azureblob.tenantId={{ .Values.config.jclouds.azureblob.tenantId }}
jclouds.azureblob.account={{ .Values.config.jclouds.azureblob.account }}
    {{- if eq .Values.config.jclouds.azureblob.auth "azureKey" }}
jclouds.identity={{ .Values.config.jclouds.azureblob.account }}
        {{- if .Values.config.jclouds.azureblob.secretName }}
            {{- $secretObj := (lookup "v1" "Secret" .Release.Namespace .Values.config.jclouds.azureblob.secretName) | default dict }}
            {{- $secretData := (get $secretObj "data") | default dict }}
            {{- $access_secret := (get $secretData "JCLOUDS_CREDENTIAL") }}
            {{- $access_secret }}
        {{- else }}
jclouds.credential={{ .Values.config.jclouds.azureblob.secretValue }}
        {{- end }}
    {{- end }}
{{- end }}
jclouds.region=us-east-1
{{- end }}
