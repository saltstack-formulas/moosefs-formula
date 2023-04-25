# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_metalogger_service_cleaned = tplroot ~ '.metalogger.service.cleaned' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_metalogger_service_cleaned }}

moosefs-metalogger-config-cleaned-mfsmetalogger-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("metalogger:files:mfsmetalogger") }}
    - require:
      - sls: {{ sls_metalogger_service_cleaned }}
