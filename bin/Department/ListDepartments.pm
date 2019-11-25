package Department::ListDepartments;
#
# @brief    List departments from db/table
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
our @EXPORT = qw(list_departments);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   List departments from db/table
# @param   Value required argument structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use Department::ListDepartments qw(list_departments);
# use Status;
#
# ...
#
# if (list_departments(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub list_departments {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        $msg = "Select from table [$argStructure{DBTD}]";
        info_debug_message($msg);
        my $table = Text::Table->new(
            "Department ID", "Department name", "Group ID"
        );
        my ($stmtListDepartments, $sthListDepartments, $rvListDeartments);
        $stmtListDepartments = qq (
            SELECT $argStructure{DBTD}.did, $argStructure{DBTD}.department,
            $argStructure{DBTD}.gid FROM $argStructure{DBTD};
        );
        $sthListDepartments = $argStructure{DBI}->prepare($stmtListDepartments);
        $rvListDeartments = $sthListDepartments->execute() ||
            die($DBI::errstr);
        if($rvListDeartments < 0){
            error_message($DBI::errstr);
            return ($NOT_SUCCESS);
        }
        while(my @listDepartments = $sthListDepartments->fetchrow_array()) {
            $table->add(
                $listDepartments[0], $listDepartments[1], $listDepartments[2]
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

Department::ListDepartments - List departments from db/table

=head1 SYNOPSIS

    use Department::ListDepartments qw(list_departments);
    use Status;

    ...

    if (list_departments(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

List departments from db/table

=head2 EXPORT

list_departments - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
