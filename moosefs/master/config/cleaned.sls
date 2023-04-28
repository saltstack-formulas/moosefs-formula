# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_service_cleaned = tplroot ~ ".master.service.cleaned" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_master_service_cleaned }}

moosefs-master-config-cleaned-mfsmaster-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("master:files:mfsmaster") }}
    - require:
      - sls: {{ sls_master_service_cleaned }}

moosefs-master-config-cleaned-mfstopology-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("master:files:mfstopology") }}
    - require:
      - sls: {{ sls_master_service_cleaned }}

moosefs-master-config-cleaned-mfsexports-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("master:files:mfsexports") }}
    - require:
      - sls: {{ sls_master_service_cleaned }}

moosefs-master-config-cleaned-moosefs-master-default-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("master:files:moosefs-master-default") }}
    - require:
      - sls: {{ sls_master_service_cleaned }}

