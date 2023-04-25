# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_cgi_package_installed = tplroot ~ '.cgi.package.installed' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_cgi_package_installed }}

moosefs-cgiserv-package-installed-pkg-installed:
  pkg.installed:
    - name: {{ moosefs.cgiserv.pkg.name }}
    - require:
        - sls: {{ sls_cgi_package_installed }}
