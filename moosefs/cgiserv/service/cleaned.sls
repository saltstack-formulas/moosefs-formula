# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

moosefs-cgiserv-service-cleaned-service-dead:
  service.dead:
    - name: {{ moosefs.cgiserv.service.name }}
    - enable: False
