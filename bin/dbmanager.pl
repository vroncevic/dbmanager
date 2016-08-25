#!/usr/bin/env perl
#
# @brief    Database manager 
# @version  ver.1.0
# @date     Wed Aug 17 11:13:57 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use strict;
use warnings;
use DBI;
use Sys::Hostname;
use Getopt::Long;
use Pod::Usage;
use ListAll qw(listAll);
use ListEmployees qw(listEmployees);
use ListDepartments qw(listDepartments);
use DelUser qw(delUser);
use AddUser qw(addUser);
use AddDepartment qw(addDepartment);
use DelDepartment qw(delDepartment);
use UserToGroup qw(userToGroup);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Logging;
use Configuration;
use Notification;
use Status;

my $cfg = dirname(dirname(abs_path($0))) . "/conf/dbmanager.cfg";
my $log = dirname(dirname(abs_path($0))) . "/log/dbmanager.log";
our $TOOL_DBG="false"; 

#
# @brief   Operations with user/department database
# @param   Value required hash argument structure
# @exitval Function dbmanager exit with integer value
#			0   - success operation 
# 			128 - wrong arguments of ADD USER operation
# 			129 - wrong arguments of ADD DEPARTMENT operation
# 			130 - wrong arguments of ADD USER2GROUP operation
# 			131 - wrong arguments of ADD operation
# 			132 - wrong arguments of DEL USER operation
# 			133 - wrong arguments of DEL DEPARTMENT operation
# 			134 - wrong arguments of DEL operation
# 			135 - wrong arguments of LIST operation
# 			136 - wrong first argument of tool
# 			137 - failed to load configuration from config file
# 			138 - failed to add new user
# 			139 - failed to add new department
# 			140 - failed to add user to department
# 			141 - failed to delete user
# 			142 - failed to delete department
# 			143 - failed to list users
# 			144 - failed to list departments
# 			145 - failed to list all
# 			146 - failed to parse first argument
# 
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# dbmanager()
#
sub dbmanager {
	my $fCaller = (caller(0))[3];
	my $host = hostname();
	my %ops = %{$_[0]};
	my %preferences;
	my $preferencesRef = \%preferences;
	my $status = 1;
	$status = readpref($cfg, $preferencesRef);
	if($status == $NOT_SUCCESS) {
		exit(137);
	}
	my $driver = "Pg"; 
	my $database = "$preferences{DB_NAME}";
	my $dbname = "dbname=$database";
	my $dbhost = "host=$preferences{DB_HOST}";
	my $dbport = "port=$preferences{DB_PORT}";
	my $dsn = "DBI:$driver:$dbname;$dbhost;$dbport";
	my $userid = "$preferences{DB_USER}";
	my $password = "$preferences{DB_PASSWORD}";
	my $dbh = DBI->connect($dsn, $userid, $password, {RaiseError => 1}) 
		or die($DBI::errstr);
	if("$ops{OPS}" eq "ADD") {
		if((defined($ops{NAME})) && (defined($ops{UDID}))) {
			if(("$ops{ADD}" eq "user") && (defined($ops{FNAME}))) {
				$status = addUser($dbh, \%ops);
				if($status == $NOT_SUCCESS) {
					exit(138);
				}
			} elsif("$ops{ADD}" eq "department") {
				$status = addDepartment($dbh, \%ops);
				if($status == $NOT_SUCCESS) {
					exit(139);
				}
			}
		} elsif((defined($ops{FNAME})) && (defined($ops{NAME}))) {
			if("$ops{ADD}" eq "user2group") {
				$status = userToGroup($dbh, \%ops);
				if($status == $NOT_SUCCESS) {
					exit(140);
				}
			}
		}
	} elsif("$ops{OPS}" eq "DEL") {
		if("$ops{DEL}" eq "user") {
			$status = delUser($dbh, $ops{NAME});
			if($status == $NOT_SUCCESS) {
				exit(141);
			}
		} elsif("$ops{DEL}" eq "department") {
			$status = delDepartment($dbh, $ops{NAME});
			if($status == $NOT_SUCCESS) {
				exit(142);
			}
		}
	} elsif("$ops{OPS}" eq "LIST") {
		if("$ops{LIST}" eq "users") {
			$status = listEmployees($dbh);
			if($status == $NOT_SUCCESS) {
				exit(143);
			}
		} elsif("$ops{LIST}" eq "departments") {
			$status = listDepartments($dbh);
			if($status == $NOT_SUCCESS) {
				exit(144);
			}
		} elsif("$ops{LIST}" eq "all") {
			$status = listAll($dbh);
			if($status == $NOT_SUCCESS) {
				exit(145);
			}
		}
	} else {
		exit(146);
	}
	$dbh->disconnect();
	exit(0);
}

#
# @brief   Main entry point
# @param   Value optional help | manual
# @exitval Script tool dbmanager exit with integer value
#			0   - success operation 
# 			127 - run as root user
# 			128 - wrong arguments of ADD USER operation
# 			129 - wrong arguments of ADD DEPARTMENT operation
# 			130 - wrong arguments of ADD USER2GROUP operation
# 			131 - wrong arguments of ADD operation
# 			132 - wrong arguments of DEL USER operation
# 			133 - wrong arguments of DEL DEPARTMENT operation
# 			134 - wrong arguments of DEL operation
# 			135 - wrong arguments of LIST operation
# 			136 - wrong first argument of tool
# 			137 - failed to load configuration from config file
# 			138 - failed to add new user
# 			139 - failed to add new department
# 			140 - failed to add user to department
# 			141 - failed to delete user
# 			142 - failed to delete department
# 			143 - failed to list users
# 			144 - failed to list departments
# 			145 - failed to list all
# 			146 - failed to parse first argument
#
my $add;
my $name;
my $fname;
my $udid;
my $id;
my $del;
my $list;
my $help;
my $man;
my %dbarg;

if (@ARGV > 0) {
	GetOptions(
		'add=s'	 => \$add,
		'name=s' => \$name,
		'fname=s'=> \$fname,
		'udid=i' => \$udid,
		'id=i'	 => \$id,
		'del=s'  => \$del,
		'list=s' => \$list,
		'help|?' => \$help,
		'manual' => \$man) or pod2usage(2);
}

my $username = (getpwuid($>));
my $uid = ($<);

if(($username eq "root") && ($uid == 0)) {
	if(defined($help)) {
		pod2usage(1);
	} elsif(defined($man)) {
		pod2usage(VERBOSE => 2);
	} else {
		if((defined($add)) || (defined($del)) || (defined($list))) {
			if((defined($add)) && ((defined($name)))) {
				$dbarg{OPS}="ADD";
				if("$add" eq "user") {
					$dbarg{ADD}="user";
					if((defined($fname)) && (defined($name)) && (defined($udid))) {
						$dbarg{FNAME}="$fname";
						$dbarg{NAME}="$name";
						$dbarg{UDID}="$udid";
					} else {
						exit(128);
					}
				} elsif("$add" eq "department") {
					$dbarg{ADD}="department";
					if((defined($name)) && (defined($udid))) {
						$dbarg{NAME}="$name";
						$dbarg{UDID}="$udid";
					} else {
						exit(129);
					}
				} elsif("$add" eq "user2group") {
					$dbarg{ADD}="user2group";
					if((defined($fname)) && (defined($name))) {
						$dbarg{FNAME}="$fname";
						$dbarg{NAME}="$name";
					} else {
						exit(130);
					}
				} else {
					exit(131);
				}
			} elsif(defined($del)) {
				$dbarg{OPS}="DEL";
				if("$del" eq "user") {
					$dbarg{DEL}="user";
					if(defined($name)) {
						$dbarg{NAME}="$name";
					} else {
						exit(132);
					}
				} elsif("$del" eq "department") {
					$dbarg{DEL}="department";
					if(defined($name)) {
						$dbarg{NAME}="$name";
					} else {
						exit(133);
					}
				} else {
					exit(134);
				}
			} elsif(defined($list)) {
				$dbarg{OPS}="LIST";
				if("$list" eq "users") {
					$dbarg{LIST}="users";
				} elsif("$list" eq "departments") {
					$dbarg{LIST}="departments";
				} elsif("$list" eq "all") {
					$dbarg{LIST}="all";
				} else {
					exit(135);
				}
			} else {
				pod2usage(1);
			}
			dbmanager(\%dbarg);
		}
		exit(136);
	}
}
exit(127);

__END__

############################## POD dbmanager.pl ################################

=head1 NAME

dbmanager - operations with user/department database

=head1 SYNOPSIS

Use:

    dbmanager [options] 
    
    [options] add del list help manual

Examples:

    # Add operation examples
    dbmanager --add department --name developer -udid 701
    dbmanager --add user --fname "Vladimir Roncevic" --name vroncevic -udid 1034
    dbmanager --add user2group --fname developer --name vroncevic
    
    # Delete operation examples
    dbmanager --del user --name vroncevic
    dbmanager --del department --name developer
    
    # List operation examples
    dbmanager --list users
    dbmanager --list departments
    dbmanager --list all
    
    # Print this option
    dbmanager --help

    # Print code of tool
    dbmanager --manual
    
    # Return values
    0   - success operation 
    127 - run as root user
    128 - wrong arguments of ADD USER operation
    129 - wrong arguments of ADD DEPARTMENT operation
    130 - wrong arguments of ADD USER2GROUP operation
    131 - wrong arguments of ADD operation
    132 - wrong arguments of DEL USER operation
    133 - wrong arguments of DEL DEPARTMENT operation
    134 - wrong arguments of DEL operation
    135 - wrong arguments of LIST operation
    136 - wrong first argument of tool
    137 - failed to load configuration from config file
    138 - failed to add new user
    139 - failed to add new department
    140 - failed to add user to department
    141 - failed to delete user
    142 - failed to delete department
    143 - failed to list users
    144 - failed to list departments
    145 - failed to list all
    146 - failed to parse first argument

=head1 DESCRIPTION

This script is for operations with user/department database.

=head1 ARGUMENTS

dbmanager takes the following arguments:

=over 4

=item add

    add
  
    (Optional.) Add new user/department to database

=item del

    del
  
    (Optional.) Delete user/department from database

=item list

    list
  
    (Optional.) List users/departments/all from database

=item help

    help

    (Optional.) Show help info information

=item manual

    manual

    (Optional.) Display manual

=back

=head1 AUTHORS

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>.

=head1 COPYRIGHT

This program is distributed under the Frobas License.

=head1 DATE

17-Aug-2016

=cut

############################## POD dbmanager.pl ################################
