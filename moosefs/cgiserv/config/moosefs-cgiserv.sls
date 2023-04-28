# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_cgiserv_package_installed = tplroot ~ ".cgiserv.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}
{%- from tplroot ~ "/libs/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_cgiserv_package_installed }}

{%- set cgiserv = moosefs.cgiserv %}
{%- set default_config = cgiserv | traverse("default") %}
{%- set user = cgiserv
      | traverse(
          "config:working_user",
          default_config | traverse("working_user")
      ) %}
{%- set group = cgiserv
      | traverse(
          "config:working_group",
          default_config | traverse("working_group")
      ) %}
{%- set moosefs_cgiserv_file = cgiserv | traverse("files:moosefs-cgiserv") %}

moosefs-cgiserv-config-moosefs-cgiserv-file-managed:
  file.managed:
    - name: {{ moosefs_cgiserv_file }}
    - source: {{ files_switch(["moosefs-cgiserv.jinja"],
                              use_subpath=True,
                              lookup="moosefs-cgiserv-config-moosefs-cgiserv-file-managed"
                 )
              }}
    - template: jinja
    - require:
      - sls: {{ sls_cgiserv_package_installed }}
    - context:
        cgiserv: {{ cgiserv | json }}
        tplroot: {{ tplroot }}
