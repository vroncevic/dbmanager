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
use Pod::Usage;
use Getopt::Long;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/bin';
use ProcessArgs qw(process_args);
use DBManager qw(dbmanager);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use Utils qw(def);
use Status;
our $TOOL_DBG="false";

#
# @brief   Main entry point
# @param   Value optional help | manual
# @exitval Script tool dbmanager exit with integer value
#            0   - success operation
#            127 - run as root user
#            128 - wrong argument(s)
#            129 - failed to do db operation
#
my ($add, $del, $list, $name, $fname, $udid, $id, $help, $man, %args, %dbarg);

if(@ARGV > 0) {
    GetOptions(
        'add=s' => \$add, 'name=s' => \$name, 'fname=s'=> \$fname,
        'udid=i' => \$udid, 'id=i' => \$id, 'del=s' => \$del,
        'list=s' => \$list, 'help|?' => \$help, 'manual' => \$man
    ) || pod2usage(2);
    %args = (
        ADD => $add, DEL => $del, LIST => $list,
        NAME => $name, FNAME => $fname, UDID => $udid,
        ID => $id, HELP => $help, MAN => $man
    );
}

my $username = (getpwuid($>));
my $uid = ($<);

if(($username eq "root") && ($uid == 0)) {
    if(def($help) == $SUCCESS) {
        pod2usage(1);
    } elsif(def($man) == $SUCCESS) {
        pod2usage(VERBOSE => 2);
    } else {
        if(process_args(\%args, \%dbarg) == $SUCCESS) {
            if(dbmanager(\%dbarg) == $SUCCESS) {
                exit(0);
            }
            exit(129);
        }
        exit(128);
    }
}
exit(127);

__END__

############################ POD dbmanager_run.pl ##############################

=head1 NAME

dbmanager - operations with user/department database

=head1 SYNOPSIS

Use:

    dbmanager [options]

    [options] add del list help manual

Examples:

    # Add operation examples
    dbmanager --add department --name IT -udid 1000
    dbmanager --add user --fname "Vladimir Roncevic" --name vroncevic -udid 10001
    dbmanager --add user2group --fname IT --name vroncevic

    # Delete operation examples
    dbmanager --del user --name vroncevic
    dbmanager --del department --name IT

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
    128 - wrong argument(s)
    129 - failed to do db operation

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

############################ POD dbmanager_run.pl ##############################
