moosefs
=========

Formula to set up moosefs.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``moosefs.master``
-------

coming soon

``moosefs.metalogger``
-------

coming soon

``moosefs.chunk``
-------

Install mfschunkserver and configure.

.. code:: yaml
mfschunkserver_config:
  MASTER_HOST: "mfsmaster"
  MASTER_PORT: 9420
  MASTER_TIMEOUT: 60
  HDD_CONF_FILENAME: "/etc/moosefs/mfs/mfshdd.cfg"
  WORKING_USER: "mfs"
  WORKING_GROUP: "mfs"
  BIND_HOST: "*"
  DATA_PATH: "/var/lib/mfs"
mfshdd_config:
  - '/mnt/mfschunks1'
  - '/mnt/mfschunks2'


``moosefs.client``
-------

coming soon
