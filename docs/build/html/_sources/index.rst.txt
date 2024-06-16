DB manager
------------

**dbmanager** is tool for operating db.

Developed in `perl <https://www.perl.org/>`_ code.

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have and any
other information that should be provided before the modules are installed.

|dbmanager checker| |dbmanager github issues| |dbmanager github contributors|

|dbmanager documentation status|

.. |dbmanager checker| image:: https://github.com/vroncevic/dbmanager/actions/workflows/dbmanager_checker.yml/badge.svg
   :target: https://github.com/vroncevic/dbmanager/actions/workflows/dbmanager_checker.yml

.. |dbmanager github issues| image:: https://img.shields.io/github/issues/vroncevic/dbmanager.svg
   :target: https://github.com/vroncevic/dbmanager/issues

.. |dbmanager github contributors| image:: https://img.shields.io/github/contributors/vroncevic/dbmanager.svg
   :target: https://github.com/vroncevic/dbmanager/graphs/contributors

.. |dbmanager documentation status| image:: https://readthedocs.org/projects/dbmanager/badge/?version=master
   :target: https://dbmanager.readthedocs.io/?badge=master

.. toctree::
   :maxdepth: 4
   :caption: Contents

   self

Installation
-------------

Used next development environment

|debian linux os|

.. |debian linux os| image:: https://raw.githubusercontent.com/vroncevic/dbmanager/dev/docs/debtux.png

Navigate to release `page`_ download and extract release archive.

.. _page: https://github.com/vroncevic/dbmanager/releases

To install **dbmanager** 

Follow instructions from README for each module.

Set INSTALL_BASE=/usr/local/perl/

Dependencies
-------------

**dbmanager** requires next modules and libraries

Check requires from README for each module.

Library structure
--------------------

**dbmanager** is based on MOP.

Library structure

.. code-block:: bash

    dbmanager
        ├── bin/
        │   ├── DBManager.pm
        │   ├── dbmanager_run.pl
        │   ├── DBOperation.pm
        │   ├── Department/
        │   │   ├── AddDepartment.pm
        │   │   ├── DelDepartment.pm
        │   │   ├── GetDepartmentNames.pm
        │   │   ├── GetDid.pm
        │   │   ├── GetMaxDid.pm
        │   │   └── ListDepartments.pm
        │   ├── Employee/
        │   │   ├── GetEid.pm
        │   │   ├── GetFullnames.pm
        │   │   ├── GetMaxEid.pm
        │   │   ├── GetUsernames.pm
        │   │   ├── ListAll.pm
        │   │   └── ListEmployees.pm
        │   ├── ProcessArgs.pm
        │   └── User/
        │       ├── AddUser.pm
        │       ├── DelUser.pm
        │       ├── GetGids.pm
        │       ├── GetUids.pm
        │       └── UserToGroup.pm
        ├── conf/
        │   └── dbmanager.cfg
        ├── log/
        │   └── dbmanager.log
        └── sql/
            └── dbmanager.sql

Copyright and licence
----------------------

|license: gpl v3| |license: apache 2.0|

.. |license: gpl v3| image:: https://img.shields.io/badge/License-GPLv3-blue.svg
   :target: https://www.gnu.org/licenses/gpl-3.0

.. |license: apache 2.0| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0

Copyright (C) 2016 - 2024 by `vroncevic.github.io/dbmanager <https://vroncevic.github.io/dbmanager>`_

**dbmanager** is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

Indices and tables
------------------

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
