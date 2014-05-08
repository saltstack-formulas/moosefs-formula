{% from "moosefs/map.jinja" import moosefs with context %}

{% set fs_pkg_url = "http://moosefs.org/tl_files/mfscode/mfs-1.6.27-5.tar.gz" %}

include:
  - moosefs

Install_Metalogger:
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
    - unless: fs_pkg_url={{ fs_pkg_url }};test -x /usr/sbin/mfsmetalogger && test $(/usr/sbin/mfsmetalogger -v | cut -d ':' -f 2 | tr -d ' ' ) = ${fs_pkg_url##*/} | cut -d '-' -f 2

/etc/init.d/mfsmetalogger:
  file.managed:
{% if grains['os_family'] == 'RedHat' %}
    - source: salt://moosefs/files/redhat/mfsmetalogger.init
{% elif grains['os_family'] == 'Debian' %}
    - source: salt://moosefs/files/debian/mfsmetalogger.init
{% endif %}
    - user: root
    - group: root
    - mode: 755
  service:
    - running
    - name: mfsmetalogger
    - enable: True
    - require:
      - file: /etc/init.d/mfsmetalogger
    - watch:
      - file: /etc/mfs/mfsmetalogger.cfg

/etc/mfs/mfsmetalogger.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsmetalogger.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'
