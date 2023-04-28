# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

{%- set mounts = moosefs | traverse("client:config:mounts", {}) %}

moosefs-client-config-cleaned-mfsmount-file-absent:
  file.absent:
    - name: {{ moosefs | traverse("client:files:mfsmount") }}

{%- for mount, params in mounts.items() %}
{%-   set mount_id = mount | replace('/', '-') %}

moosefs-client-config-mounts-{{ mount_id }}-mount-unmounted:
  mount.unmounted:
    - name: {{ mount }}
    - persist: True
{%- endfor %}
