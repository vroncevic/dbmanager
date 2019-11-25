package User::AddUser;
#
# @brief    Add new user to db/table
# @version  ver.1.0
# @date     Mon Aug 22 16:09:02 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use strict;
use warnings;
use DBI;
use Exporter;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/bin';
use Employee::GetMaxEid qw(get_max_eid);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use InfoMessage qw(info_message);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(add_user);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Add new user to db/table
# @params  Values required argument structure - hash structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use User::AddUser qw(add_user);
# use Status;
#
# ...
#
# if(add_user(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub add_user {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        my $maxEid;
        if(get_max_eid(\%argStructure, \$maxEid) == $SUCCESS) {
            $msg = "Select from table [$argStructure{DBTE}]";
            info_debug_message($msg);
            my ($stmtGetUnid, $sthUnid, $rvUnid, @existingEids);
            $stmtGetUnid = qq (
                SELECT $argStructure{DBTE}.eid, $argStructure{DBTE}.username,
                $argStructure{DBTE}.uid FROM $argStructure{DBTE};
            );
            $sthUnid = $argStructure{DBI}->prepare($stmtGetUnid);
            $rvUnid = $sthUnid->execute() || die($DBI::errstr);
            if($rvUnid < 0) {
                error_message($DBI::errstr);
                return ($NOT_SUCCESS);
            }
            my ($name ,$udid, $fname);
            $name = "$argStructure{OPT}->{NAME}";
            $udid = "$argStructure{OPT}->{UDID}";
            $fname = "$argStructure{OPT}->{FNAME}";
            while(my @unid = $sthUnid->fetchrow_array()) {
                if(("$name" eq "$unid[1]") || ("$udid" eq "$unid[2]")) {
                    $msg = "User $name (ID $udid) already exist";
                    error_message($msg);
                    return ($NOT_SUCCESS);
                }
                push(@existingEids, $unid[0]);
            }
            my ($i, @missingEids, $stmtAddUser, $sthAddUser, $rvAddUser);
            foreach (@existingEids) {
                if($_ != ++$i) {
                    push(@missingEids, $i .. $_ - 1);
                    $i = $_;
                }
            }
            if(defined($missingEids[0])) {
                $maxEid = $missingEids[0];
            } else {
                $maxEid = $maxEid + 1;
            }
            $msg = "Insert to table [$argStructure{DBTE}]";
            info_message($msg);
            $stmtAddUser = qq (
                INSERT INTO $argStructure{DBTE} \(eid, username, uid, fullname\)
                VALUES \($maxEid, \'$name\', $udid, \'$fname\'\);
            );
            $sthAddUser = $argStructure{DBI}->prepare($stmtAddUser);
            $rvAddUser = $sthAddUser->execute() || die($DBI::errstr);
            if($rvAddUser < 0) {
                error_message($DBI::errstr);
                return ($NOT_SUCCESS);
            }
            $msg = "Done";
            info_debug_message($msg);
            return ($SUCCESS);
        }
        return ($NOT_SUCCESS);
    }
    $msg = "Missing argument [ARGUMENT_STRUCTURE]";
    error_message($msg);
    return ($NOT_SUCCESS);
}

1;
__END__

=head1 NAME

User::AddUser - Add new user to db/table

=head1 SYNOPSIS

    use User::AddUser qw(add_user);
    use Status;

    ...

    if(add_user(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION 

Add new user to db/table

=head2 EXPORT

add_user - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
