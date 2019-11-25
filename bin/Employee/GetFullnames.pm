package Employee::GetFullnames;
#
# @brief    Get Fullnames from db/table
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
our @EXPORT = qw(get_full_names);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Get Fullnames from db/table
# @params  Values required
#            argument structure - hash structure with parameters
#            usernames [output] - array with names
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use Employee::GetUsernames qw(get_full_names);
# use Status;
#
# ...
#
# if(get_full_names(\%argStructure, \@fullnames) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub get_full_names {
    my %argStructure = %{$_[0]};
    my $names = $_[1];
    my $msg = "None";
    if(%argStructure) {
        $msg = "Select from table [$argStructure{DBTE}]";
        info_debug_message($msg);
        my ($stmtGetNames, $sthGetNames, $rvGetNames, @listNames, $i, $name);
        $stmtGetNames = qq (
            SELECT $argStructure{DBTE}.fullname FROM $argStructure{DBTE};
        );
        $sthGetNames = $argStructure{DBI}->prepare($stmtGetNames);
        $rvGetNames = $sthGetNames->execute() || die($DBI::errstr);
        if($rvGetNames < 0) {
            error_message($DBI::errstr);
            return ($NOT_SUCCESS);
        }
        while(@listNames = $sthGetNames->fetchrow_array()) {
            for($i = 0; $i < scalar(@listNames); $i++) {
                $name = $listNames[$i];
                push(@{$names}, $name);
            }
        }
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

Employee::GetFullnames - Get Fullnames from db/table

=head1 SYNOPSIS

    use Employee::GetFullnames qw(get_full_names);
    use Status;

    ...

    if(get_full_names(\%argStructure, \@fullnames) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Get Fullnames from db/table

=head2 EXPORT

get_full_names - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
