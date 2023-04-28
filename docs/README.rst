.. _readme:

moosefs-formula
===============

|img_travis| |img_sr| |img_pc|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/moosefs-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/moosefs-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Formula to set up MooseFS.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

Special notes
-------------

The default values of configuration files are defined under the
``default`` key of each component in `moosefs/parameters/defaults.yaml
</moosefs/parameters/defaults.yaml>`_.

Available states
----------------

.. contents::
   :local:

``moosefs``
^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This apply all subcomponent states based on configuration data:

- `moosefs.master`_ is applied if ``master:enabled`` is ``true``
- `moosefs.metalogger`_ is applied if ``metalogger:enabled`` is
  ``true``
- `moosefs.chunkserver`_ is applied if ``chunkserver:enabled`` is
  ``true``
- `moosefs.cgi`_ is applied if ``cgi:enabled`` is ``true``
- `moosefs.cgiserv`_ is applied if ``cgiserv:enabled`` is ``true``
- `moosefs.client`_ is applied if ``client:enabled`` is ``true``
- `moosefs.cli`_ is applied if ``cli:enabled`` is ``true``
- `moosefs.netdump`_ is applied if ``netdump:enabled`` is ``true``

By default, all components are disabled but can be applied
individually by running their states directly.

``moosefs.cleaned``
^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove all components of MooseFS:

- stop and disable the services
- remove the configuration files
- uninstall packages

The running data are preserved.

``moosefs.master``
^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the MooseFS metadata server ``mfsmaster``:

- install the packages with `moosefs.master.package`_
- configure the service with `moosefs.master.config`_
- enable and start the service with `moosefs.master.service`_ if
  ``master:service:enabled`` is ``true``, default to ``false``

``moosefs.master.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the MooseFS metadata server ``mfsmaster``:

- stop and disable the service with `moosefs.master.service.cleaned`_
- remove the configuration of the service with
  `moosefs.master.config.cleaned`_
- uninstall the packages with `moosefs.master.package.cleaned`_

``moosefs.master.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the MooseFS metadata server package only.

``moosefs.master.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the MooseFS metadata server package only, it depends on
`moosefs.master.config.cleaned`_.

``moosefs.master.config``
^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Configure the MooseFS metadata server.

``moosefs.master.config.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the MooseFS metadata server configuration files.

``moosefs.master.config.data-path``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enforce presence and perms on the configured ``DATA_PATH``.

``moosefs.master.config.mfsmaster``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate the MooseFS metadata server configuration file
``mfsmaster.cfg``.

``moosefs.master.config.mfsexports``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate the MooseFS metadata server configuration file
``mfsexports.cfg``.

``moosefs.master.config.mfstopology``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate the MooseFS metadata server configuration file
``mfstopology.cfg``.

``moosefs.master.config.metadata``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Initialize the MooseFS metadata server database with the empty
``/var/lib/mfs/metadata.mfs.empty`` file if required.

``moosefs.master.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Enable and start the MooseFS metadata server service with
`moosefs.master.service.running`_ if ``master:service:enabled`` is
``true``.

Stop and disable the MooseFS metadata server service with
`moosefs.master.service.cleaned`_ if ``master:service:enabled`` is
``false``, the default.

``moosefs.master.service.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Stop and disable the MooseFS metadata server service.

``moosefs.master.service.running``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable and start the MooseFS metadata server service.

``moosefs.metalogger``
^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the MooseFS metadata replication (backup) server
``mfsmetalogger``:

- install the package with `moosefs.metalogger.package`_
- configure the service with `moosefs.metalogger.config`_
- enable and start the service with `moosefs.metalogger.service`_ if
  ``metalogger:service:enabled`` is ``true``, default to ``false``

``moosefs.metalogger.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the MooseFS metadata replication (backup) server
``mfsmetalogger``:

- stop and disable the service with
  `moosefs.metalogger.service.cleaned`_
- remove the configuration of the service with
  `moosefs.metalogger.config.cleaned`_
- uninstall the packages with `moosefs.metalogger.package.cleaned`_

``moosefs.metalogger.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the MooseFS metadata replication (backup) server package only.

``moosefs.metalogger.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the MooseFS metadata replication (backup) server package
only, it depends on `moosefs.metalogger.config.cleaned`_.

``moosefs.metalogger.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Configure the MooseFS metadata replication (backup) server.

``moosefs.metalogger.config.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the MooseFS metadata replication (backup) server configuration
files.

``moosefs.metalogger.config.data-path``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enforce presence and perms on the configured ``DATA_PATH``.

``moosefs.metalogger.config.mfsmetalogger``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate the MooseFS metadata replication (backup) server
configuration file ``mfsmetalogger.cfg``.

``moosefs.metalogger.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Enable and start the MooseFS metadata replication (backup) server
service with `moosefs.metalogger.service.running`_ if
``metalogger:service:enabled`` is ``true``.

Stop and disable the MooseFS metadata replication (backup) server
service with `moosefs.metalogger.service.cleaned`_ if
``metalogger:service:enabled`` is ``false``, the default.

``moosefs.metalogger.service.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Stop and disable the MooseFS metadata replication (backup) server
service.

``moosefs.metalogger.service.running``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable and start the MooseFS metadata replication (backup) server
service.

``moosefs.chunkserver``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the MooseFS data server ``mfschunkserver``:

- install the package with `moosefs.chunkserver.package`_
- configure the service with `moosefs.chunkserver.config`_
- enable and start the service with `moosefs.chunkserver.service`_ if
  ``chunkserver:service:enabled`` is ``true``, default to ``false``

``moosefs.chunkserver.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the MooseFS data server ``mfschunkserver``:

- stop and disable the service with
  `moosefs.chunkserver.service.cleaned`_
- remove the configuration of the service with
  `moosefs.chunkserver.config.cleaned`_
- uninstall the packages with `moosefs.chunkserver.package.cleaned`_

``moosefs.chunkserver.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the MooseFS data server package only.

``moosefs.chunkserver.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the MooseFS data server package only, it depends on
`moosefs.chunkserver.config.cleaned`_.

``moosefs.chunkserver.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Configure the MooseFS data server.

``moosefs.chunkserver.config.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the MooseFS data server configuration files.

``moosefs.chunkserver.config.data-path``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enforce presence and perms on the configured ``DATA_PATH``.

``moosefs.chunkserver.config.mfschunkserver``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate the MooseFS data server configuration file
``mfschunkserver.cfg``.

``moosefs.chunkserver.config.mfshdd``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generate the MooseFS data server configuration file
``mfshdd.cfg``.

``moosefs.chunkserver.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Enable and start the MooseFS data server service with
`moosefs.chunkserver.service.running`_ if
``chunkserver:service:enabled`` is ``true``.

Stop and disable the MooseFS data server service with
`moosefs.chunkserver.service.cleaned`_ if
``chunkserver:service:enabled`` is ``false``, the default.

``moosefs.chunkserver.service.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Stop and disable the MooseFS data server service.

``moosefs.chunkserver.service.running``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable and start the MooseFS data server service.

``moosefs.client``
^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the MooseFS mount and client tools:

- install the packages with `moosefs.client.package`_
- configure the mount points with `moosefs.client.config`_

``moosefs.client.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the MooseFS mount and client tools:

- remove the mount points `moosefs.client.config.cleaned`_
- uninstall the packages with `moosefs.client.package.cleaned`_

``moosefs.client.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the MooseFS mount and client tools packages only.

``moosefs.client.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the MooseFS mount and client tools packages only, it depends
on `moosefs.client.config.cleaned`_.

``moosefs.client.config``
^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

- configure the mount points with `moosefs.client.config.mounts`_
- configure the default MooseFS mount options with
  `moosefs.client.config.mfsmount`_

``moosefs.client.config.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the mount configurations.

``moosefs.client.config.mounts``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Configure the mount points defined in ``client:config:mounts``
dictionary.

``moosefs.client.config.mfsmount``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Configure the default options for ``mfsmount`` defined in
``client:config:default_options`` list.

``moosefs.cgiserv``
^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the simple CGI-capable HTTP server to run MooseFS CGI monitor:

- install the packages with `moosefs.cgiserv.package`_
- configure the service with `moosefs.cgiserv.config`_
- enable and start the service with `moosefs.cgiserv.service`_ if
  ``chunkserver:cgiserv:enabled`` is ``true``, default to ``false``

``moosefs.cgiserv.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the simple CGI-capable HTTP server to run MooseFS CGI monitor:

- stop and disable the service with
  `moosefs.cgiserv.service.cleaned`_
- remove the configuration of the service with
  `moosefs.cgiserv.config.cleaned`_
- uninstall the packages with `moosefs.cgiserv.package.cleaned`_

``moosefs.cgiserv.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the simple CGI-capable HTTP server to run MooseFS CGI monitor
package only.

It depends on `moosefs.cgi.package`_.

``moosefs.cgiserv.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the simple CGI-capable HTTP server to run MooseFS CGI monitor
package only, it depends on `moosefs.cgiserv.config.cleaned`_.

``moosefs.cgiserv.config``
^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Configure the simple CGI-capable HTTP server to run MooseFS CGI monitor.

``moosefs.cgiserv.config.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the simple CGI-capable HTTP server to run MooseFS CGI monitor
configuration file.

``moosefs.cgiserv.service``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Enable and start the simple CGI-capable HTTP server to run MooseFS CGI
monitor service with `moosefs.cgiserv.service.running`_ if
``cgiserv:service:enabled`` is ``true``.

Stop and disable the simple CGI-capable HTTP server to run MooseFS CGI
monitor service with `moosefs.cgiserv.service.cleaned`_ if
``cgiserv:service:enabled`` is ``false``, the default.

``moosefs.cgiserv.service.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Stop and disable the simple CGI-capable HTTP server to run MooseFS CGI
monitor service.

``moosefs.cgiserv.service.running``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Enable and start the simple CGI-capable HTTP server to run MooseFS CGI
monitor service.

``moosefs.cgi``
^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the CGI application to monitor MooseFS through master/metadata
server.

``moosefs.cgi.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the CGI application to monitor MooseFS through master/metadata
server.

``moosefs.cgi.package``
^^^^^^^^^^^^^^^^^^^^^^^

Install the CGI application to monitor MooseFS through master/metadata
server package only.

``moosefs.cgi.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the CGI application to monitor MooseFS through
master/metadata server package only.

``moosefs.cli``
^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Install the MooseFS monitoring utility ``mfscli``.

``moosefs.cli.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

Remove the MooseFS monitoring utility ``mfscli``.

``moosefs.cli.package``
^^^^^^^^^^^^^^^^^^^^^^^

Install the MooseFS monitoring utility package only.

``moosefs.cli.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the MooseFS monitoring utility package only.

``moosefs.netdump``
^^^^^^^^^^^^^^^^^^^

Install the MooseFS monitoring tool ``mfsnetdump`` utility.

``moosefs.netdump.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Remove the MooseFS monitoring tool ``mfsnetdump`` utility.

``moosefs.netdump.package``
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Install the MooseFS monitoring tool ``mfsnetdump`` utility package
only.

``moosefs.netdump.package.cleaned``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Uninstall the MooseFS monitoring tool ``mfsnetdump`` utility package
only.

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``moosefs`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
