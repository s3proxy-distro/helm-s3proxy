{{- define "s3proxy.properties" -}}
LOG_LEVEL={{ .Values.logLevel | default "info" }}
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
            {{- $access_secret | b64dec }}
        {{- else }}
jclouds.credential={{ .Values.config.jclouds.azureblob.secretValue }}
        {{- end }}
    {{- end }}
{{- end }}
{{- end }}
jclouds.regions=""us-east-1"
