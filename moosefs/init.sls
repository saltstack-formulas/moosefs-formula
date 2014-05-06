{% from "moosefs/map.jinja" import moosefs with context %}


build_essestial:
  pkg.installed:
    - pkgs:
{% for required_pkg in moosefs.required_pkgs %}
      - {{ required_pkg }}
{% endfor %}

mfs-group:
  group.present:
    - name: mfs
    - system: True

mfs:
  user.present:
    - name: mfs
    - fullname: MooseFS
    - home: /home/mfs
    - createhome: True
    - groups:
      - mfs
