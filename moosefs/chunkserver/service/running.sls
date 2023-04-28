# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_chunkserver_data_path = tplroot ~ ".chunkserver.config.data-path" %}
{%- set sls_chunkserver_config_mfschunkserver = tplroot ~ '.chunkserver.config.mfschunkserver' %}
{%- set sls_chunkserver_config_mfshdd = tplroot ~ '.chunkserver.config.mfshdd' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_chunkserver_data_path }}
  - {{ sls_chunkserver_config_mfschunkserver }}
  - {{ sls_chunkserver_config_mfshdd }}

moosefs-chunkserver-service-running-service-running:
  service.running:
    - name: {{ moosefs.chunkserver.service.name }}
    - enable: True
    - reload: True
    - watch:
      - sls: {{ sls_chunkserver_data_path }}
      - sls: {{ sls_chunkserver_config_mfschunkserver }}
      - sls: {{ sls_chunkserver_config_mfshdd }}
