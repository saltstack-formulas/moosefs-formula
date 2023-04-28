# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_master_package_installed = tplroot ~ ".master.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}
{%- from tplroot ~ "/libs/libtofs.jinja" import files_switch with context %}

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
{%- set mfsmaster_file = master | traverse("files:mfsmaster") %}

moosefs-master-config-mfsmaster-file-managed:
  file.managed:
    - name: {{ mfsmaster_file }}
    - source: {{ files_switch(["mfsmaster.cfg.jinja"],
                              use_subpath=True,
                              lookup="moosefs-master-config-mfsmaster-file-managed"
                 )
              }}
    - mode: 640
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_master_package_installed }}
    - context:
        master: {{ master | json }}
        tplroot: {{ tplroot }}
