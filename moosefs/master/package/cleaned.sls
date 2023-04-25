# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_config_cleaned = tplroot ~ ".master.config.cleaned" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_master_config_cleaned }}

moosefs-master-package-cleaned-pkg-removed:
  pkg.removed:
    - name: {{ moosefs.master.pkg.name }}
    - require:
      - sls: {{ sls_master_config_cleaned }}
