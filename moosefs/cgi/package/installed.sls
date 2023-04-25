# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

moosefs-cgi-package-installed-pkg-installed:
  pkg.installed:
    - name: {{ moosefs.cgi.pkg.name }}
