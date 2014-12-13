{% from "moosefs/map.jinja" import moosefs with context %}

{% set fs_pkg_url = "http://moosefs.org/tl_files/mfscode/mfs-1.6.27-5.tar.gz" %}

include:
  - moosefs

Install_Chunk:
  cmd.run:
    - name: |
        fs_pkg_url={{ fs_pkg_url }}
        cd /usr/src/
        wget -c $fs_pkg_url
        tar -xzvf ${fs_pkg_url##*/}
        cd mfs-$(echo ${fs_pkg_url##*/} | cut -d '-' -f 2)
        ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfsmaster 
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
    - unless: fs_pkg_url={{ fs_pkg_url }};test -x /usr/sbin/mfschunkserver && test $(/usr/sbin/mfschunkserver -v | cut -d ':' -f 2 | tr -d ' ' ) = ${fs_pkg_url##*/} | cut -d '-' -f 2

/etc/init.d/mfschunkserver:
  file.managed:
{% if grains['os_family'] == 'RedHat' %}
    - source: salt://moosefs/files/redhat/mfschunkserver.init
{% elif grains['os_family'] == 'Debian' %}
    - source: salt://moosefs/files/debian/mfschunkserver.init
{% endif %}
    - user: root
    - group: root
    - mode: 755

Run_mfschunkserver:
  service.running:
    - name: mfschunkserver
    - enable: True
    - watch:
      - file: /etc/mfs/mfschunkserver.cfg
      - file: /etc/mfs/mfshdd.cfg

/etc/mfs/mfschunkserver.cfg:
  file.managed:
    - source: salt://moosefs/template/mfschunkserver.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'

/etc/mfs/mfshdd.cfg:
  file.managed:
    - source: salt://moosefs/template/mfshdd.tmpl
    - user: root
    - group: root
    - mode: 755
    - template: 'jinja'

{% for mount_point in pillar.get('mfshdd_config', {}) %}
{{ mount_point }}:
  file.directory:
    - user: mfs
    - group: mfs
    - mode: 744
    - makedirs: True
    - recurse:
      - user
      - group
{% endfor %}
