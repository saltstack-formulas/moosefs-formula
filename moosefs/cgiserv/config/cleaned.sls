# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_cgiserv_service_cleaned = tplroot ~ ".cgiserv.service.cleaned" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_cgiserv_service_cleaned }}

moosefs-cgiserv-config-cleaned-moosefs-cgiserv-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("cgiserv:files:moosefs-cgiserv") }}
    - require:
      - sls: {{ sls_cgiserv_service_cleaned }}
