# -*- coding: utf-8 -*-
# vim: ft=yaml
---
moosefs:
  master:
    enabled: true
    service:
      enabled: true

    config:
      # Enfore chunkserver authentication
      auth_code: yYyzqzZw5PvZ74pQAd8M1Uqa7PWGznlycVGTEzHDGG

  metalogger:
    enabled: true
    service:
      enabled: true

    config:
      master_host: {{ salt["grains.get"]("id") }}

  chunkserver:
    enabled: true
    service:
      enabled: true

    config:
      # Enfore chunkserver authentication
      auth_code: yYyzqzZw5PvZ74pQAd8M1Uqa7PWGznlycVGTEzHDGG

      hdds:
        /srv/moosefs-storage: {}

      master_host: {{ salt["grains.get"]("id") }}

  cgiserv:
    enabled: true
    service:
      enabled: false

  cli:
    enabled: true

  client:
    enabled: true
    config:
      mounts:
        "/mnt":
          device: "127.0.0.1:/"
          user: man
          group: nogroup
...
