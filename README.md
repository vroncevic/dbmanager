DB Manager for users (Perl scripts)
================================================================================

The README is used to introduce the modules and provide instructions on
how to install the modules, any machine dependencies it may have (for
example C compilers and installed libraries) and any other information
that should be provided before the modules are installed.

A README file is required for CPAN modules since CPAN extracts the
README file from a module distribution so that people browsing the
archive can use it get an idea of the modules uses. It is usually a
good idea to provide version information here so that people can
decide whether fixes for the module are worth downloading.

INSTALLATION

To install this module type the following:

	cp -R ~/dbmanager/bin/ /root/scripts/dbmanager/ver.1.0/

	cp -R ~/dbmanager/conf/ /root/scripts/dbmanager/ver.1.0/

	cp -R ~/dbmanager/log/ /root/scripts/dbmanager/ver.1.0/
	
Location of perl-util

	/root/scripts/lib/perl5/
	
Create SQLPostgres database with tables (more details in SQL file)

	/root/scripts/dbmanager/ver.1.0/sql/dbmanager.sql

DEPENDENCIES

This module requires these other modules and libraries:

  	strict
	warnings
	use DBI;
	Sys::Hostname;
	Getopt::Long;
	Exporter
	Sys::Hostname
	Getopt::Long
	File::Basename
	Pod::Usage
	Text::Table
	Logging (from perl-util project)
	Configuration (from perl-util project)
	Notification (from perl-util project)
	Status (from perl-util project)

COPYRIGHT AND LICENCE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

