package User::UserToGroup;
#
# @brief    Add user to group in db/table
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
use Department::GetDid qw(get_did);
use Employee::GetEid qw(get_eid);
use Employee::GetMaxEid qw(get_max_eid);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use InfoMessage qw(info_message);
use CheckStatus qw(check_status);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(user_to_group);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Add user to group in db/table
# @param   Value required argument structure - hash structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use User::UserToGroup qw(user_to_group);
# use Status;
#
# ...
#
# if(user_to_group(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub user_to_group {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        my ($eid, $did, %status);
        %status = (
            eid => get_eid(\%argStructure, \$eid),
            did => get_did(\%argStructure, \$did)
        );
        if(check_status(\%status) == $SUCCESS) {
            $msg = "Select from table [$argStructure{DBTC}]";
            info_debug_message($msg);
            my ($stmtGetEdid, $sthGetEdid, $rvGetEdid);
            $stmtGetEdid = qq (
                SELECT $argStructure{DBTC}.eid, $argStructure{DBTC}.did
                FROM $argStructure{DBTC};
            );
            $sthGetEdid = $argStructure{DBI}->prepare($stmtGetEdid);
            $rvGetEdid = $sthGetEdid->execute() or die($DBI::errstr);
            if($rvGetEdid < 0){
                error_message($DBI::errstr);
                return ($NOT_SUCCESS);
            }
            my ($name, $fname) = ("$argStructure{NAME}","$argStructure{FNAME}");
            while(my @edid = $sthGetEdid->fetchrow_array()) {
                if(("$edid[0]" eq "$eid") || ("$edid[1]" eq "$did")) {
                    $msg = "User $name already in $fname department";
                    error_message($msg);
                    return ($NOT_SUCCESS);
                }
            }
            $msg = "Insert to table [$argStructure{DBTC}]";
            info_message($msg);
            my ($stmtUser2Group, $sthUser2Group, $rvUser2Group);
            $stmtUser2Group = qq (
                INSERT INTO $argStructure{DBTC} \(eid, did\)
                VALUES \($eid, $did\);
            );
            $sthUser2Group = $argStructure{DBI}->prepare($stmtUser2Group);
            $rvUser2Group = $sthUser2Group->execute() || die($DBI::errstr);
            if($rvUser2Group < 0) {
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

User::UserToGroup - Add user to group in db/table

=head1 SYNOPSIS

    use User::UserToGroup qw(user_to_group);
    use Status;

    ...

    if(user_to_group(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Add user to group in db/table

=head2 EXPORT

user_to_group - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
