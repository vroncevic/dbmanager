package Department::AddDepartment;
#
# @brief    Add new department to db/table
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
use Department::GetMaxDid qw(get_max_did);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use InfoMessage qw(info_message);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(add_department);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Add new department to db/table
# @param   Value required argument structure - hash structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use Department::AddDepartment qw(add_department);
# use Status;
#
# ...
#
# if(add_department(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub add_department {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        my $maxDid;
        if(get_max_did(\%argStructure, \$maxDid) == $SUCCESS) {
            $msg = "Select from table [$argStructure{DBTD}]";
            info_debug_message($msg);
            my ($stmtGetDnid, $sthDnid, $rvDnid);
            $stmtGetDnid = qq (
                SELECT $argStructure{DBTD}.did, $argStructure{DBTD}.department,
                $argStructure{DBTD}.gid FROM $argStructure{DBTD};
            );
            $sthDnid = $argStructure{DBI}->prepare($stmtGetDnid);
            $rvDnid = $sthDnid->execute() || die($DBI::errstr);
            if($rvDnid < 0) {
                error_message($DBI::errstr);
                return ($NOT_SUCCESS);
            }
            my (@dnid, @existingDids, $dname, $udid, $i, @missingDids);
            $dname = "$argStructure{NAME}";
            $udid = "$argStructure{UDID}";
            while(@dnid = $sthDnid->fetchrow_array()) {
                if(("$dname" eq "$dnid[1]") || ("$udid" eq "$dnid[2]")) {
                    $msg = "Department $dname (ID $udid) already exist";
                    info_message($msg);
                    return ($NOT_SUCCESS);
                }
                push(@existingDids, $dnid[0]);
            }
            foreach (@existingDids) {
                if($_ != ++$i) {
                    push(@missingDids, $i .. $_ - 1);
                    $i = $_;
                }
            }
            if(defined($missingDids[0])) {
                $maxDid = $missingDids[0];
            } else {
                $maxDid = $maxDid + 1;
            }
            $msg = "Insert to table [$argStructure{DBTD}]";
            info_message($msg);
            my ($stmtAddDepartment, $sthAddDepartment, $rvAddDepartment);
            $stmtAddDepartment = qq (
                INSERT INTO $argStructure{DBTD} \(did, department, gid\)
                VALUES \($maxDid , \'$dname\', $udid\);
            );
            $sthAddDepartment = $argStructure{DBI}->prepare($stmtAddDepartment);
            $rvAddDepartment = $sthAddDepartment->execute() ||
                die($DBI::errstr);
            if($rvAddDepartment < 0) {
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

Department::AddDepartment - Add new department to db/table

=head1 SYNOPSIS

    use Department::AddDepartment qw(add_department);
    use Status;

    ...

    if(add_department(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Add new department to db/table

=head2 EXPORT

add_department - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
