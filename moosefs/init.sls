# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

{%- set includes = [] %}
{%- set components = [
      "master",
      "metalogger",
      "chunkserver",
      "cgi",
      "cgiserv",
      "client",
      "cli",
      "netdump",
    ] %}

{%- for component in components %}
{%-   if moosefs | traverse(component ~ ":enabled", False) %}
{%-     do includes.append("." ~ component) %}
{%-   endif %}
{%- endfor %}

include: {{ includes }}
