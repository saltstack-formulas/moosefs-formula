# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_metalogger_config_cleaned = tplroot ~ '.metalogger.config.cleaned' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_metalogger_config_cleaned }}

moosefs-metalogger-package-cleaned-pkg-removed:
  pkg.removed:
    - name: {{ moosefs.metalogger.pkg.name }}
    - require:
      - sls: {{ sls_metalogger_config_cleaned }}
