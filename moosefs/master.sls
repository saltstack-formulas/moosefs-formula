{% from "moosefs/map.jinja" import moosefs with context %}

{% set fs_version = "1.6.27" %}
{% set fs_pkg_url = "http://moosefs.org/tl_files/mfscode/mfs-1.6.27-5.tar.gz" %}

include:
  - moosefs

Install_Master:
  cmd.run:
    - name: |
        fs_pkg_url={{ fs_pkg_url }}
        cd /usr/src/
        wget -c $fs_pkg_url
        tar -xzvf ${fs_pkg_url##*/}
        cd mfs-$(echo ${fs_pkg_url##*/} | cut -d '-' -f 2)
        ./configure --prefix=/usr --sysconfdir=/etc/moosefs --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfschunkserver --disable-mfsmount 
        make
        make install
        make clean
    - cwd: /usr/src/
    - shell: /bin/bash
    - timeout: 600
    - user: root
    - unless: fs_pkg_url={{ fs_pkg_url }};test -x /usr/sbin/mfsmaster && test $(/usr/sbin/mfsmaster -v | cut -d ':' -f 2 | tr -d ' ' ) = ${fs_pkg_url##*/} | cut -d '-' -f 2

/etc/init.d/mfsmaster:
  file.managed:
{% if grains['os_family'] == 'RedHat' %}
    - source: salt://moosefs/files/redhat/mfsmaster.init
{% elif grains['os_family'] == 'Debian' %}
    - source: salt://moosefs/files/debian/mfsmaster.init
{% endif %}
    - user: root
    - group: root
    - mode: 755
  service:
    - running
    - name: mfsmaster
    - enable: True
    - watch:
      - file: /etc/moosefs/mfs/mfsmaster.cfg
      - file: /etc/moosefs/mfsexports.cfg
      - file: /etc/moosefs/mfsmetalogger.cfg
      - file: /etc/moosefs/mfstopology.cfg
     
/etc/init.d/mfscgiserv:
  file.managed:
{% if grains['os_family'] == 'RedHat' %}
    - source: salt://moosefs/files/redhat/mfscgiserv.init
{% elif grains['os_family'] == 'Debian' %}
    - source: salt://moosefs/files/debian/mfscgiserv.init
{% endif %}
    - user: root
    - group: root
    - mode: 755 
  service:
    - running
    - name: mfscgiserv
    - enable: True
    - watch:
      - file: /etc/moosefs/mfs/mfsmaster.cfg
      - file: /etc/moosefs/mfsexports.cfg
      - file: /etc/moosefs/mfsmetalogger.cfg
      - file: /etc/moosefs/mfstopology.cfg

/etc/moosefs/mfs/mfsmaster.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsmaster.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'
    - context:
      mfsmaster_config: {{ pillar.get('mfsmaster_config', {})|json }}

/etc/moosefs/mfsexports.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsexports.tmpl
    - user: root
    - group: root
    - mode: 755

/etc/moosefs/mfsmetalogger.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsmetalogger.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'
    - context:
      mfsmetalogger_config: {{ pillar.get('mfsmetalogger_config', {})|json }}

/etc/moosefs/mfstopology.cfg:
  file.managed:
    - source: salt://moosefs/template/mfstopology.tmpl
    - user: root
    - group: root
    - mode: 755

/var/lib/mfs/metadata.mfs:
  file.managed:
    - source: salt://moosefs/files/metadata.mfs
    - replace: false
    - user: root
    - group: root
    - mode: 755
