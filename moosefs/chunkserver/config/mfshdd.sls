# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_chunkserver_package_installed = tplroot ~ ".chunkserver.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}
{%- from tplroot ~ "/libs/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_chunkserver_package_installed }}

{%- set chunkserver = moosefs.chunkserver %}
{%- set default_config = chunkserver | traverse("default") %}
{%- set user = chunkserver
      | traverse(
          "config:working_user",
          default_config | traverse("working_user")
      ) %}
{%- set group = chunkserver
      | traverse(
          "config:working_group",
          default_config | traverse("working_group")
      ) %}
{%- set mfshdd_file = chunkserver | traverse("files:mfshdd") %}

{#- Fail to generate the configuration file if storage paths are missing #}
{%- for hdd in chunkserver | traverse("config:hdds", {}) | list %}
{%-   set hdd_id = hdd | replace('/', '-') %}
moosefs-chunkserver-config-hdd-{{ hdd_id }}-file.directory:
  file.directory:
    - name: {{ hdd }}
    - user: {{ user }}
    - group: {{ group }}
    - mode: 750
    - require_in:
      - file: moosefs-chunkserver-config-mfshdd-file-managed
{%- endfor %}

moosefs-chunkserver-config-mfshdd-file-managed:
  file.managed:
    - name: {{ mfshdd_file }}
    - source: {{ files_switch(["mfshdd.cfg.jinja"],
                              use_subpath=True,
                              lookup="moosefs-chunkserver-config-mfshdd-file-managed"
                 )
              }}
    - mode: 640
    - user: {{ user }}
    - group: {{ group }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_chunkserver_package_installed }}
    - context:
        chunkserver: {{ chunkserver | json }}
