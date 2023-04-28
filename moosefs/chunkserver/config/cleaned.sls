# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_chunkserver_service_cleaned = tplroot ~ ".chunkserver.service.cleaned" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_chunkserver_service_cleaned }}

moosefs-chunkserver-config-cleaned-mfschunkserver-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("chunkserver:files:mfschunkserver") }}
    - require:
      - sls: {{ sls_chunkserver_service_cleaned }}

moosefs-chunkserver-config-cleaned-mfshdd-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("chunkserver:files:mfshdd") }}
    - require:
      - sls: {{ sls_chunkserver_service_cleaned }}
