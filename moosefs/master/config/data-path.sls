# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_package_installed = tplroot ~ ".master.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_master_package_installed }}

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

moosefs-master-config-data-path-file-directory:
  file.directory:
    - name: {{ data_path }}
    - dir_mode: 750
    - file_mode: 640
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - require:
      - sls: {{ sls_master_package_installed }}
