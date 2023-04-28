# -*- mode: salt; coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_client_package_installed = tplroot ~ '.client.package.installed' %}
{%- from tplroot ~ "/libs/map.jinja" import mapdata as moosefs without context %}

include:
  - {{ sls_client_package_installed }}

{%- set default_mount_opts = [
      '_netdev', 'mfsdelayedinit', 'noatime', 'nodev', 'nosuid'
    ] %}
{%- set mfs_invisible_options = [
      "mfscfgfile", "mfsmeta", "mfsmaster", "mfsport", "mfsbind",
      "mfsproxy", "mfssubfolder", "mfspassword", "mfscfgfile",
      "mfsdebug", "mfsmeta", "mfsflattrash", "mfsdelayedinit",
      "mfsmkdircopysgid", "mfssugidclearmode", "mfscachemode",
      "mfscachemode", "mfsattrcacheto", "mfsxattrcacheto",
      "mfsentrycacheto", "mfsdirentrycacheto", "mfsnegentrycacheto",
      "mfsgroupscacheto", "mfsrlimitnofile", "mfsnice", "mfsmemlock",
      "mfslimitarenas", "mfsallowoomkiller", "mfsfsyncmintime",
      "mfswritecachesize", "mfsreadaheadsize", "mfsreadaheadleng",
      "mfsreadaheadtrigger", "mfserroronlostchunk", "mfserroronnospace",
      "mfsioretries", "mfstimeout", "mfslogretry", "mfsmaster",
      "mfsport", "mfsbind", "mfsproxy", "mfssubfolder", "mfspassword",
      "mfspassfile", "mfsmd5pass", "mfsdonotrememberpassword",
      "mfspreflabels", "mfsnoxattrs", "mfsnoposixlocks", "mfsnobsdlocks"
    ] %}

{%- set mounts = moosefs | traverse("client:config:mounts", {}) %}

{%- for mount, params in mounts.items() %}
{%-   set mount_id = mount | replace('/', '-') %}
{%-   set device = params.get('device') %}
{%-   set device_prefix='mfs' %}
{%-   set device_parts = device.split(':') %}
{%-   set device_host = device_parts[0:-1] | join(':') %}
{%-   set device_path = device_parts[-1] %}
{%-   set options = params.get('options', default_mount_opts) %}
{%-   if 'mfsmeta' in options %}
{%-     set device_prefix = device_prefix ~ 'meta' %}
{%-   endif %}

moosefs-client-config-mounts-{{ mount_id }}-mount-mounted:
  mount.mounted:
    - name: {{ mount }}
    - device: {{ device }}
    - fstype: moosefs
    - opts: {{ options | sort }}
    - dump: 0
    - pass_num: 0
    - mount: {{ params.get('mount', True) | to_bool }}
    - mkmnt: {{ params.get('mkmnt', True) | to_bool }}
    - persist: {{ params.get('persist', True) | to_bool }}
    - device_name_regex:
      - {{ device_prefix }}#{{ device_host ~ '(?::[0-9]*)?' }}
    - extra_mount_invisible_options: {{ mfs_invisible_options }}
    - require:
      - sls: {{ sls_client_package_installed }}

moosefs-client-config-mounts-{{ mount_id }}-file-directory:
  file.directory:
    - name: {{ mount }}
    - user: {{ params.get('user', 'root') }}
    - group: {{ params.get('group', 'root') }}
    - dir_mode: {{ params.get('dir_mode', '700') }}
    - file_mode: {{ params.get('file_mode', '600') }}
    - require:
      - mount: moosefs-client-config-mounts-{{ mount_id }}-mount-mounted
    - onlyif:
        - fun: mount.is_mounted
          name: {{ mount }}
{%- endfor %}
