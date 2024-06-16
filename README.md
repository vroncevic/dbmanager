# DB manager

**dbmanager** is tool for operating db.

Developed in **[perl](https://www.perl.org/)** code: **100%**.

A README file is required for CPAN modules since CPAN extracts the
README file from a module distribution so that people browsing the
archive can use it get an idea of the modules uses. It is usually a
good idea to provide version information here so that people can
decide whether fixes for the module are worth downloading.

![Perl package](https://github.com/vroncevic/dbmanager/workflows/dbmanager_checker/badge.svg?branch=master) [![GitHub issues open](https://img.shields.io/github/issues/vroncevic/dbmanager.svg)](https://github.com/vroncevic/dbmanager/issues) [![GitHub contributors](https://img.shields.io/github/contributors/vroncevic/dbmanager.svg)](https://github.com/vroncevic/dbmanager/graphs/contributors)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installation](#installation)
- [Dependencies](#dependencies)
- [Library structure](#library-structure)
- [Docs](#docs)
- [Copyright and licence](#copyright-and-licence)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

Follow instructions from README for each module.

Set INSTALL_BASE=/usr/local/perl/

### Dependencies

**dbmanager** requires next modules and libraries

Check requires from README for each module.

### Library structure

```bash
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
```

### Docs

[![Documentation Status](https://readthedocs.org/projects/dbmanager/badge/?version=latest)](https://dbmanager.readthedocs.io/projects/dbmanager/en/latest/?badge=latest)

More documentation and info at

* [dbmanager.readthedocs.io](https://dbmanager.readthedocs.io/en/latest/)
* [www.perl.org](https://www.perl.org/)

### Copyright and licence

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Copyright (C) 2016 - 2024 by [vroncevic.github.io/dbmanager](https://vroncevic.github.io/dbmanager/)

**dbmanager** is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.
