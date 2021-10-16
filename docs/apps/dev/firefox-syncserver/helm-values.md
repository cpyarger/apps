# Default Helm-Values

TrueCharts is primarily build to supply TrueNAS SCALE Apps.
However, we also supply all Apps as standard Helm-Charts. In this document we aim to document the default values in our values.yaml file.

Most of our Apps also consume our "common" Helm Chart.
If this is the case, this means that all values.yaml values are set to the common chart values.yaml by default. This values.yaml file will only contain values that deviate from the common chart.
You will, however, be able to use all values referenced in the common chart here, besides the values listed in this document.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| env.FF_SYNCSERVER_FORCE_WSGI_ENVIRON | string | `"true"` |  |
| env.FF_SYNCSERVER_PUBLIC_URL | string | `"firefox-syncserver.192.168.1.189.nip.io"` |  |
| env.PUID | string | `"568"` |  |
| env.TZ | string | `"America/Los_Angeles"` |  |
| envValueFrom.DB_HOST.secretKeyRef.key | string | `"url"` |  |
| envValueFrom.DB_HOST.secretKeyRef.name | string | `"dbcreds"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/crazy-max/firefox-syncserver"` |  |
| image.tag | string | `"1.8.0@sha256:15aeaaec65295711260807fe49020b2e446e60d6e094d60a1cfd96c7ebf2b9ce"` |  |
| podSecurityContext.runAsGroup | int | `0` |  |
| podSecurityContext.runAsUser | int | `0` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.existingSecret | string | `"dbcreds"` |  |
| postgresql.postgresqlDatabase | string | `"firefox-syncserver"` |  |
| postgresql.postgresqlUsername | string | `"firefox-syncserver"` |  |
| secret.FF_SYNCSERVER_SECRET | string | `"5up3rS3kr1t"` |  |
| securityContext.allowPrivilegeEscalation | bool | `true` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| securityContext.runAsNonRoot | bool | `false` |  |
| service.main.ports.main.port | int | `5000` |  |

All Rights Reserved - The TrueCharts Project
