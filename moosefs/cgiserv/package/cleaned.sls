# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_cgiserv_config_cleaned = tplroot ~ '.cgiserv.config.cleaned' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs with context %}

include:
  - {{ sls_cgiserv_config_cleaned }}

moosefs-cgiserv-package-cleaned-pkg-removed:
  pkg.removed:
    - name: {{ moosefs.cgiserv.pkg.name }}
    - require:
      - sls: {{ sls_cgiserv_config_cleaned }}
