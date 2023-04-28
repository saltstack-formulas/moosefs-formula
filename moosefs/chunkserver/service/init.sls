# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
{%- if moosefs | traverse("chunkserver:service:enabled", False) | to_bool %}
  - .running
{%- else %}
  - .cleaned
{%- endif %}
