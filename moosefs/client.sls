{% from "moosefs/map.jinja" import moosefs with context %}

{% set fs_folder = "mfs-1.6.27" %}
{% set fs_pkg_url = "http://moosefs.org/tl_files/mfscode/mfs-1.6.27-5.tar.gz" %}

include:
  - moosefs

Install_Master:
  cmd.run:
    - name: |
        cd /tmp
        wget -c {{ fs_pkg_url }} -O mfs.tar.gz
        tar -xzvf mfs.tar.gz
        cd {{ fs_folder }}
        ./configure --prefix=/usr --sysconfdir=/etc/moosefs --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfsmaster --disable-mfschunkserver 
        make
        make install
    - cwd: /tmp
    - shell: /bin/bash
    - timeout: 600
    - user: root

/etc/moosefs/mfs/mfsmaster.cfg:
  file.managed:
    - source: salt://moosefs/template/mfsmaster.tmpl
    - user: root
    - group: root
    - mode: 755

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
