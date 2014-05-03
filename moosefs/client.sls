{% from "moosefs/map.jinja" import moosefs with context %}

{% set fs_version = "1.6.27" %}
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
        ./configure --prefix=/usr --sysconfdir=/etc/moosefs --localstatedir=/var/lib --with-default-user=mfs --with-default-group=mfs --disable-mfsmaster --disable-mfschunkserver 
        make
        make install
        make clean
    - cwd: /usr/src/
    - shell: /bin/bash
    - timeout: 600
    - user: root
    - unless: fs_pkg_url={{ fs_pkg_url }};test -x /usr/bin/mfsmount && test $(/usr/bin/mfsmount --version 2>&1 > /dev/null | grep 'MFS version' | cut -d ' ' -f 3 | tr -d ' ' ) = ${fs_pkg_url##*/} | cut -d '-' -f 2
