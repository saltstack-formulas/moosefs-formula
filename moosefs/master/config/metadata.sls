# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_package_installed = tplroot ~ ".master.package.installed" %}
{%- set sls_master_data_path = tplroot ~ ".master.config.data-path" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_master_package_installed }}
  - {{ sls_master_data_path }}

{%- set master = moosefs.master %}
{%- set default_config = master | traverse("default") %}
{%- set user = master
      | traverse(
          "config:working_user",
          default_config | traverse("working_user")
      ) %}
{%- set group = master
      | traverse(
          "config:working_group",
          default_config | traverse("working_group")
      ) %}
{%- set data_path = master
      | traverse(
          "config:data_path",
          default_config | traverse("data_path")
      ) %}
{%- set metadata_file = master | traverse("files:metadata") %}

{#- Do not create the empty metadata DB if there is any backup #}
{#- Match metalogger backup files too #}
moosefs-master-config-metadata-file-copy:
  file.copy:
    - name: {{ metadata_file }}
    - source: {{ metadata_file ~ ".empty" }}
    - mode: 640
    - user: {{ user }}
    - group: {{ group }}
    - require:
      - sls: {{ sls_master_package_installed }}
      - sls: {{ sls_master_data_path }}
    - unless:
      - fun: file.path_exists_glob
        path: {{ data_path ~ "/metadata*mfs.back*" }}
