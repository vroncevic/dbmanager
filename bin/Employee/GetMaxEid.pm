package Employee::GetMaxEid;
#
# @brief    Get max employee id from db/table
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
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(get_max_eid);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Get max employee id from db/table
# @params  Values required
#            argument structure - hash structure with parameters
#            max eid [output]   - MAX employee id
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use Employee::GetMaxEid qw(get_max_eid);
# use Status;
#
# ...
#
# if(get_max_eid(\%argStructure, \$maxEid) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub get_max_eid {
    my %argStructure = %{$_[0]};
    my $finalMaxEid = $_[1];
    my $msg = "None";
    if(%argStructure) {
        $msg = "Select from table [$argStructure{DBTE}]";
        info_debug_message($msg);
        my ($stmtMaxEid, $sthMaxEid, $rvMaxEid, $maxEidRef, $maxEid);
        $stmtMaxEid = qq (
            SELECT $argStructure{DBTE}.eid FROM $argStructure{DBTE}
            WHERE $argStructure{DBTE}.eid =
            \(SELECT MAX\($argStructure{DBTE}.eid\) FROM $argStructure{DBTE}\);
        );
        $sthMaxEid = $argStructure{DBI}->prepare($stmtMaxEid);
        $rvMaxEid = $sthMaxEid->execute() || die($DBI::errstr);
        if($rvMaxEid < 0) {
            error_message($DBI::errstr);
            return ($NOT_SUCCESS);
        }
        $maxEidRef = $sthMaxEid->fetchrow_hashref();
        $maxEid = 0;
        $maxEid = $maxEidRef->{eid};
        if($maxEid == 0) {
            $msg = "Failed to get max employee id from db/table";
            error_message($msg);
            return ($NOT_SUCCESS);
        }
        ${$finalMaxEid} = $maxEid;
        $msg = "Done";
        info_debug_message($msg);
        return ($SUCCESS);
    }
    $msg = "Missing argument [ARGUMENT_STRUCTURE]";
    error_message($msg);
    return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

Employee::GetMaxEid - Get max employee id from db/table

=head1 SYNOPSIS

    use Employee::GetMaxEid qw(get_max_eid);
    use Status;

    ...

    if(get_max_eid(\%argStructure, \$maxEid) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Get max employee id from db/table

=head2 EXPORT

get_max_eid - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
