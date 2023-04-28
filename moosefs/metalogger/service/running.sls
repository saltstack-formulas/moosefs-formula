# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_metalogger_data_path = tplroot ~ ".metalogger.config.data-path" %}
{%- set sls_metalogger_config_mfsmetalogger = tplroot ~ '.metalogger.config.mfsmetalogger' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_metalogger_data_path }}
  - {{ sls_metalogger_config_mfsmetalogger }}

moosefs-metalogger-service-running-service-running:
  service.running:
    - name: {{ moosefs.metalogger.service.name }}
    - enable: True
    - reload: True
    - watch:
      - sls: {{ sls_metalogger_data_path }}
      - sls: {{ sls_metalogger_config_mfsmetalogger }}
