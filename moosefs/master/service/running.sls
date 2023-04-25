# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_data_path = tplroot ~ ".master.config.data-path" %}
{%- set sls_master_config_mfsmaster = tplroot ~ ".master.config.mfsmaster" %}
{%- set sls_master_config_mfsexports = tplroot ~ ".master.config.mfsexports" %}
{%- set sls_master_config_mfstopology = tplroot ~ ".master.config.mfstopology" %}
{%- set sls_master_config_metadata = tplroot ~ ".master.config.metadata" %}
{%- set sls_master_config_moosefs_master_default = tplroot ~ ".master.config.moosefs-master-default" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_master_data_path }}
  - {{ sls_master_config_mfsmaster }}
  - {{ sls_master_config_mfsexports }}
  - {{ sls_master_config_mfstopology }}
  - {{ sls_master_config_metadata }}
  - {{ sls_master_config_moosefs_master_default }}

moosefs-master-service-running-service-running:
  service.running:
    - name: {{ moosefs.master.service.name }}
    - enable: True
    - reload: True
    - watch:
      - sls: {{ sls_master_data_path }}
      - sls: {{ sls_master_config_mfsmaster }}
      - sls: {{ sls_master_config_mfsexports }}
      - sls: {{ sls_master_config_mfstopology }}
      - sls: {{ sls_master_config_metadata }}
      - sls: {{ sls_master_config_moosefs_master_default }}
