# Default Helm-Values

TrueCharts is primarily build to supply TrueNAS SCALE Apps.
However, we also supply all Apps as standard Helm-Charts. In this document we aim to document the default values in our values.yaml file.

Most of our Apps also consume our "common" Helm Chart.
If this is the case, this means that all values.yaml values are set to the common chart values.yaml by default. This values.yaml file will only contain values that deviate from the common chart.
You will, however, be able to use all values referenced in the common chart here, besides the values listed in this document.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalVolumeMounts[0].mountPath | string | `"/config/custom-cont-init.d"` |  |
| additionalVolumeMounts[0].name | string | `"qbittorrent-scripts"` |  |
| additionalVolumes[0].emptyDir | object | `{}` |  |
| additionalVolumes[0].name | string | `"qbittorrent-scripts"` |  |
| env | object | `{}` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/k8s-at-home/qbittorrent"` |  |
| image.tag | string | `"v4.3.8@sha256:d224ead6e97bbd655a18b6d23a76c8bed23098c9c9d745bcd6e84feea31fd494"` |  |
| persistence.config.accessMode | string | `"ReadWriteOnce"` |  |
| persistence.config.enabled | bool | `true` |  |
| persistence.config.mountPath | string | `"/config"` |  |
| persistence.config.size | string | `"100Gi"` |  |
| persistence.config.type | string | `"pvc"` |  |
| securityContext.readOnlyRootFilesystem | bool | `false` |  |
| service.main.ports.main.port | int | `8080` |  |
| service.torrent.enabled | bool | `true` |  |
| service.torrent.ports.tcp.enabled | bool | `true` |  |
| service.torrent.ports.tcp.port | int | `6881` |  |
| service.torrent.ports.tcp.protocol | string | `"TCP"` |  |
| service.torrent.ports.udp.enabled | bool | `true` |  |
| service.torrent.ports.udp.port | int | `6881` |  |
| service.torrent.ports.udp.protocol | string | `"UDP"` |  |
| service.torrent.type | string | `"ClusterIP"` |  |

All Rights Reserved - The TrueCharts Project
