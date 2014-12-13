{% from "moosefs/map.jinja" import moosefs with context %}

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
        ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfschunkserver --disable-mfsmount 
        make
        make install
        make clean
        rm -f /etc/mfs/*.dist
        rm -f /var/lib/mfs/metadata.mfs.empty
        rm -Rf /usr/src/${fs_pkg_url##*/} mfs-$(echo ${fs_pkg_url##*/} | cut -d '-' -f 2)
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

Run_mfsmaster:
  service.running:
    - name: mfsmaster
    - enable: True
    - require:
      - file: /etc/init.d/mfsmaster
    - watch:
      - file: /etc/mfs/mfsmaster.cfg
      - file: /etc/mfs/mfsexports.cfg
      - file: /etc/mfs/mfsmetalogger.cfg
      {% if pillar.get('mfstopology_config') is defined and pillar.get('mfstopology_config') is not none %}
      - file: /etc/mfs/mfstopology.cfg
      {% endif %}
     
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

Run_mfscgiserv:
  service.running:
    - name: mfscgiserv
    - enable: True
    - require:
      - file: /etc/init.d/mfscgiserv
    - watch:
      - file: /etc/mfs/mfsmaster.cfg
      - file: /etc/mfs/mfsexports.cfg
      - file: /etc/mfs/mfsmetalogger.cfg
      {% if pillar.get('mfstopology_config') is defined and pillar.get('mfstopology_config') is not none %}
      - file: /etc/mfs/mfstopology.cfg
      {% endif %}

/etc/mfs/mfsmaster.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsmaster.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'

/etc/mfs/mfsexports.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsexports.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'

/etc/mfs/mfsmetalogger.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsmetalogger.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'

{% if pillar.get('mfstopology_config') is defined and pillar.get('mfstopology_config') is not none %}
/etc/mfs/mfstopology.cfg:
  file.managed:
    - source: salt://moosefs/template/mfstopology.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'
{% endif %}

/var/lib/mfs/metadata.mfs:
  file.managed:
    - source: salt://moosefs/files/metadata.mfs
    - replace: false
    - user: root
    - group: root
    - mode: 755
