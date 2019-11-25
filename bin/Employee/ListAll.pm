package Employee::ListAll;
#
# @brief    List all details from db/table
# @version  ver.1.0
# @date     Mon Aug 22 16:09:02 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use strict;
use warnings;
use DBI;
use Exporter;
use Text::Table;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(list_all);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   List all details from db/table
# @param   Value required argument structure - hash structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use Employee::ListAll qw(list_all);
# use Status;
#
# ...
#
# if(list_all(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub list_all {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        $msg = "Select from table [$argStructure{DBTC}]";
        info_debug_message($msg);
        my ($stmtListAll, $sthListAll, $rvListAll, @listAllDetails);
        my $table = Text::Table->new(
            "Employee ID", "Full name", "User name",
            "Department", "User ID", "Group ID"
        );
        $stmtListAll = qq (
            SELECT $argStructure{DBTE}.eid, $argStructure{DBTE}.fullname,
            $argStructure{DBTE}.username, $argStructure{DBTD}.department,
            $argStructure{DBTE}.uid, $argStructure{DBTD}.gid
            FROM $argStructure{DBTE} INNER JOIN $argStructure{DBTC}
            ON \($argStructure{DBTE}.eid = $argStructure{DBTC}.eid\)
            INNER JOIN $argStructure{DBTD}
            ON \($argStructure{DBTD}.did = $argStructure{DBTC}.did\);
        );
        $sthListAll = $argStructure{DBI}->prepare($stmtListAll);
        $rvListAll = $sthListAll->execute() or die($DBI::errstr);
        if($rvListAll < 0){
            error_message($DBI::errstr);
            return ($NOT_SUCCESS);
        }
        while(@listAllDetails = $sthListAll->fetchrow_array()) {
            $table->add(
                $listAllDetails[0], $listAllDetails[1], $listAllDetails[2],
                $listAllDetails[3], $listAllDetails[4], $listAllDetails[5]
            );
        }
        $table->add(' ');
        print($table);
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

Employee::ListAll - List all details from db/table

=head1 SYNOPSIS

    use Employee::ListAll qw(listAll);
    use Status;

    ...

    if(listAll(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

List all details from db/table

=head2 EXPORT

list_all - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
