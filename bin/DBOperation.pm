package DBOperation;
#
# @brief    Operations with user/department database
# @version  ver.1.0
# @date     Wed Aug 17 11:13:57 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use strict;
use warnings;
use Exporter;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/bin';
use Employee::ListAll qw(list_all);
use Employee::ListEmployees qw(list_employees);
use User::AddUser qw(add_user);
use User::DelUser qw(del_user);
use User::UserToGroup qw(user_to_group);
use Department::AddDepartment qw(add_department);
use Department::DelDepartment qw(del_department);
use Department::ListDepartments qw(list_departments);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use InfoMessage qw(info_message);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(db_operation);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Operations with user/department database
# @param   Value required hash argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use DBOperation qw(db_operation);
#
# ...
#
# if(db_operation(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub db_operation {
    my %argStructure = %{$_[0]};
    my $msg = "None";
    if(%argStructure) {
        $msg = "db operation";
        info_debug_message($msg);
        if("$argStructure{OPT}->{OPS}" eq "ADD_USER") {
            if(add_user(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "ADD_DEPARTMENT") {
            if(add_department(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "ADD_USER_TO_GROUP") {
            if(user_to_group(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "DEL_USER") {
            if(del_user(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "DEL_DEPARTMENT") {
            if(del_department(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "LIST_USERS") {
            if(list_employees(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "LIST_DEPARTMENTS") {
            if(list_departments(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } elsif("$argStructure{OPT}->{OPS}" eq "LIST_ALL") {
            if(list_all(\%argStructure) == $NOT_SUCCESS) {
                return ($NOT_SUCCESS);
            }
        } else {
            return ($NOT_SUCCESS);
        }
        return ($SUCCESS);
    }
    $msg = "Missing argument [ARGUMENT_STRUCTURE]";
    error_message($msg);
    return ($NOT_SUCCESS);
}

1;
__END__

=head1 NAME

DBOperation - Operations with user/department database

=head1 SYNOPSIS

    use DBOperation qw(db_operation);

    ...

    if(db_operation(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Operations with user/department database

=head2 EXPORT

db_operation - return 0 for success, else none 0

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
