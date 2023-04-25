# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_chunkserver_config_cleaned = tplroot ~ '.chunkserver.config.cleaned' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs with context %}

include:
  - {{ sls_chunkserver_config_cleaned }}

moosefs-chunkserver-package-cleaned-pkg-removed:
  pkg.removed:
    - name: {{ moosefs.chunkserver.pkg.name }}
    - require:
      - sls: {{ sls_chunkserver_config_cleaned }}
