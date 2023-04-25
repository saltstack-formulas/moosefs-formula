# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_client_package_installed = tplroot ~ ".client.package.installed" %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}
{%- from tplroot ~ "/libs/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_client_package_installed }}

{%- set client = moosefs.client %}
{%- set mfsmount_file = client | traverse("files:mfsmount") %}

moosefs-client-config-mfsmount-file-managed:
  file.managed:
    - name: {{ mfsmount_file }}
    - source: {{ files_switch(["mfsmount.cfg.jinja"],
                              use_subpath=True,
                              lookup="moosefs-client-config-mfsmount-file-managed"
                 )
              }}
    - mode: 644
    - user: root
    - group: root
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_client_package_installed }}
    - context:
        client: {{ client | json }}
