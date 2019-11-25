package Department::DelDepartment;
#
# @brief    Delete department from db/table by department name
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
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use InfoMessage qw(info_message);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(del_department);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Delete department from db/table by department name
# @param   Value required argument structure - hash structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use Department::DelDepartment qw(del_department);
# use Status;
#
# ...
#
# if(del_department(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub del_department {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        my $did;
        if(get_did(\%argStructure, \$did) == $SUCCESS) {
            $msg = "Delete from table [$argStructure{DBTC}]";
            info_debug_message($msg);
            my ($stmtDelDid, $sthDelDid, $rvDelDid);
            $stmtDelDid = qq (
                DELETE FROM $argStructure{DBTC}
                WHERE $argStructure{DBTC}.did = $did;
            );
            $sthDelDid = $argStructure{DBI}->prepare($stmtDelDid);
            $rvDelDid = $sthDelDid->execute() or die($DBI::errstr);
            if($rvDelDid < 0) {
                error_message($DBI::errstr);
                return ($NOT_SUCCESS);
            }
            $msg = "Delete from table [$argStructure{DBTD}]";
            info_message($msg);
            my ($stmtDelDepartment, $sthDelDepartment, $rvDepartment);
            $stmtDelDepartment = qq (
                DELETE FROM $argStructure{DBTD}
                WHERE $argStructure{DBTD}.did = $did;
            );
            $sthDelDepartment = $argStructure{DBI}->prepare($stmtDelDepartment);
            $rvDepartment = $sthDelDepartment->execute() || die($DBI::errstr);
            if($rvDepartment < 0) {
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

Department::DelDepartment - Delete department from db/table by department name

=head1 SYNOPSIS

    use Department::DelDepartment qw(del_department);
    use Status;

    ...

    if(del_department(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Delete department from db/table by department name

=head2 EXPORT

del_department - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
