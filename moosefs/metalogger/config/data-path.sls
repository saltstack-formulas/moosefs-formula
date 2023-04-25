# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_metalogger_package_installed = tplroot ~ ".metalogger.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_metalogger_package_installed }}

{%- set metalogger = moosefs.metalogger %}
{%- set default_config = metalogger | traverse("default") %}
{%- set user = metalogger
      | traverse(
          "config:working_user",
          default_config | traverse("working_user")
      ) %}
{%- set group = metalogger
      | traverse(
          "config:working_group",
          default_config | traverse("working_group")
      ) %}
{%- set data_path = metalogger
      | traverse(
          "config:data_path",
          default_config | traverse("data_path")
      ) %}

moosefs-metalogger-config-data-path-file-directory:
  file.directory:
    - name: {{ data_path }}
    - dir_mode: 750
    - file_mode: 640
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - require:
      - sls: {{ sls_metalogger_package_installed }}
