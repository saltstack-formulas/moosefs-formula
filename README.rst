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

Install mfsmaster and mfsmetalogger and configure

.. code:: yaml

    mfsmaster_config:
      MATOML_LISTEN_HOST: "*"
      MATOML_LISTEN_PORT: 9419
      MATOML_LOG_PRESERVE_SECONDS: 600
      MATOCS_LISTEN_HOST: "*"
      MATOCS_LISTEN_PORT: 9420
      MATOCL_LISTEN_HOST: "*"
      MATOCL_LISTEN_PORT: 9421
      WORKING_USER: "mfs"
      WORKING_GROUP: "mfs"
      SYSLOG_IDENT: "mfsmaster"
      DATA_PATH: "/var/lib/mfs"
    mfsmetalogger_config:
      MASTER_HOST: "mfsmaster"
      MASTER_PORT: 9419
      MASTER_TIMEOUT: 60
      WORKING_USER: "mfs"
      WORKING_GROUP: "mfs"
      SYSLOG_IDENT: "mfsmetalogger"
    mfstopology_config: |
      192.168.1.0/24                1
    mfsexports_config: |
      *                       /       rw,alldirs,maproot=0
      *                       .       rw


``moosefs.metalogger``
-------

Install mfsmetalogger and config.

.. code:: yaml

    mfsmetalogger_config:
      MASTER_HOST: "mfsmaster"
      MASTER_PORT: 9419
      MASTER_TIMEOUT: 60
      WORKING_USER: "mfs"
      WORKING_GROUP: "mfs"
      SYSLOG_IDENT: "mfsmetalogger"
      LOCK_MEMORY: 0
      NICE_LEVEL: -19
      DATA_PATH: "/var/lib/mfs"
      BACK_LOGS: 50
      BACK_META_KEEP_PREVIOUS: 3
      META_DOWNLOAD_FREQ: 24
      MASTER_RECONNECTION_DELAY: 5


``moosefs.chunk``
-------

Install mfschunkserver and config.

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
