# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{%- set includes = [] %}
{%- set components = [
      "netdump",
      "cli",
      "client",
      "cgiserv",
      "cgi",
      "chunkserver",
      "metalogger",
      "master",
    ] %}

{%- for component in components %}
{%-   do includes.append("." ~ component ~ ".cleaned") %}
{%- endfor %}

include: {{ includes }}
