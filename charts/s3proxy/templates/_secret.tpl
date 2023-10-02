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
{{- $access_secret := (get $secretData "AWS_SECRET_ACCESS_KEY") | default (randAlphaNum 16 | b64enc) }}
{{- $access_secret }}
{{- end }}
{{- end }}
