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
{%- set mfstopology_file = master | traverse("files:mfstopology") %}

moosefs-master-config-mfstopology-file-managed:
  file.managed:
    - name: {{ mfstopology_file }}
    - source: {{ files_switch(["mfstopology.cfg.jinja"],
                              use_subpath=True,
                              lookup="moosefs-master-config-mfstopology-file-managed"
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
        moosefs: {{ master | json }}
