# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs with context %}

moosefs-netdump-package-cleaned-pkg-removed:
  pkg.removed:
    - name: {{ moosefs.netdump.pkg.name }}
