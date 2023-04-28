# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_metalogger_package_installed = tplroot ~ ".metalogger.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}
{%- from tplroot ~ "/libs/libtofs.jinja" import files_switch with context %}

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
{%- set mfsmetalogger_file = metalogger
      | traverse("files:mfsmetalogger") %}

moosefs-metalogger-config-mfsmetalogger-file-managed:
  file.managed:
    - name: {{ mfsmetalogger_file }}
    - source: {{ files_switch(["mfsmetalogger.cfg.jinja"],
                              use_subpath=True,
                              lookup="moosefs-metalogger-config-mfsmetalogger-file-managed"
                 )
              }}
    - mode: 640
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_metalogger_package_installed }}
    - context:
        metalogger: {{ metalogger | json }}
        tplroot: {{ tplroot }}
