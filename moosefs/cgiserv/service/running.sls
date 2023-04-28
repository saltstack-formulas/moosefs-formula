# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_cgiserv_config_moosefs_cgiserv = tplroot ~ '.cgiserv.config.moosefs-cgiserv' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_cgiserv_config_moosefs_cgiserv }}

moosefs-cgiserv-service-running-service-running:
  service.running:
    - name: {{ moosefs.cgiserv.service.name }}
    - enable: True
    - reload: True
    - watch:
      - sls: {{ sls_cgiserv_config_moosefs_cgiserv }}
