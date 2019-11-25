package ProcessArgs;
#
# @brief    Process arguments from CLI
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
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use CheckStatus qw(check_status);
use OrCheckStatus qw(or_check_status);
use Utils qw(def);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(process_args);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Process arguments from CLI
# @param   Value required hash argument structure with parameters
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use ProcessArgs qw(process_args);
#
# ...
#
# if(process_args(\%argStructure) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub process_args {
    my %argStructure = %{$_[0]};
    my $dbarg = $_[1];
    my $msg = "None";
    if(%argStructure) {
        $msg = "db operation";
        info_debug_message($msg);
        my %adl =(
            ADD => def($argStructure{ADD}),
            DEL => def($argStructure{DEL}),
            LIST => def($argStructure{LIST})
        );
        if(or_check_status(\%adl) == $SUCCESS) {
            my %an = (
                ADD => def($argStructure{ADD}), NAME => def($argStructure{NAME})
            );
            if(check_status(\%an) == $SUCCESS) {
                if("$argStructure{ADD}" eq "user") {
                    $$dbarg{OPS}="ADD_USER";
                    my %au = (
                        FN => def($argStructure{FNAME}),
                        NAME => def($argStructure{NAME}),
                        ID => def($argStructure{UDID})
                    );
                    if(check_status(\%au) == $SUCCESS) {
                        $$dbarg{FNAME}="$argStructure{FNAME}";
                        $$dbarg{NAME}="$argStructure{NAME}";
                        $$dbarg{UDID}="$argStructure{UDID}";
                    } else {
                        return ($NOT_SUCCESS);
                    }
                } elsif("$argStructure{ADD}" eq "department") {
                    $$dbarg{OPS}="ADD_DEPARTMENT";
                    my %ad = (
                        NAME => def($argStructure{NAME}),
                        DEP => def($argStructure{UDID})
                    );
                    if(check_status(\%ad) == $SUCCESS) {
                        $$dbarg{NAME}="$argStructure{NAME}";
                        $$dbarg{UDID}="$argStructure{UDID}";
                    } else {
                        return ($NOT_SUCCESS);
                    }
                } elsif("$argStructure{ADD}" eq "user2group") {
                    $$dbarg{OPS}="ADD_USER_TO_GROUP";
                    my %u2d = (
                        FN => def($argStructure{FNAME}),
                        NAME => def($argStructure{NAME})
                    );
                    if(check_status(\%u2d) == $SUCCESS) {
                        $$dbarg{FNAME}="$argStructure{FNAME}";
                        $$dbarg{NAME}="$argStructure{NAME}";
                    } else {
                        return ($NOT_SUCCESS);
                    }
                } else {
                    return ($NOT_SUCCESS);
                }
            } elsif(def($argStructure{DEL}) == $SUCCESS) {
                if("$argStructure{DEL}" eq "user") {
                    $$dbarg{OPS}="DEL_USER";
                    if(def($argStructure{NAME}) == $SUCCESS) {
                        $$dbarg{NAME}="$argStructure{NAME}";
                    } else {
                        return ($NOT_SUCCESS);
                    }
                } elsif("$argStructure{DEL}" eq "department") {
                    $$dbarg{OPS}="DEL_DEPARTMENT";
                    if(def($argStructure{NAME}) == $SUCCESS) {
                        $$dbarg{NAME}="$argStructure{NAME}";
                    } else {
                        return ($NOT_SUCCESS);
                    }
                } else {
                    return ($NOT_SUCCESS);
                }
            } elsif(def($argStructure{LIST}) == $SUCCESS) {
                if("$argStructure{LIST}" eq "users") {
                    $$dbarg{OPS}="LIST_USERS";
                } elsif("$argStructure{LIST}" eq "departments") {
                    $$dbarg{OPS}="LIST_DEPARTMENTS";
                } elsif("$argStructure{LIST}" eq "all") {
                    $$dbarg{OPS}="LIST_ALL";
                } else {
                    return ($NOT_SUCCESS);
                }
            } else {
                return ($NOT_SUCCESS);
            }
            return ($SUCCESS);
        }
    }
    $msg = "Missing argument [ARGUMENT_STRUCTURE]";
    error_message($msg);
    return ($NOT_SUCCESS);
}

1;
__END__

=head1 NAME

ProcessArgs - Process arguments from CLI

=head1 SYNOPSIS

    use ProcessArgs qw(process_args);

    ...

    if(process_args(\%argStructure) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Process arguments from CLI

=head2 EXPORT

process_args - return 0 for success, else 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
