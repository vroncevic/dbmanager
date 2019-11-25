package DBManager;
#
# @brief    Database manager
# @version  ver.1.0
# @date     Wed Aug 17 11:13:57 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use strict;
use warnings;
use DBI;
use Exporter;
use Pod::Usage;
use Getopt::Long;
use Cwd qw(abs_path);
use File::Basename qw(dirname);
use lib dirname(dirname(abs_path(__FILE__))) . '/bin';
use DBOperation qw(db_operation);
use lib dirname(dirname(abs_path(__FILE__))) . '/../../lib/perl5';
use InfoDebugMessage qw(info_debug_message);
use ErrorMessage qw(error_message);
use InfoMessage qw(info_message);
use Logging qw(logging);
use Configuration qw(read_preference);
use Notification qw(notify);
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(dbmanager);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Database manager
# @param   Value required hash argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use DBManager qw(dbmanager);
#
# ...
#
# if(dbmanager(\%dbarg) == $SUCCESS) {
#    # true
#    # notify admin | user
# } else {
#    # false
#    # return $NOT_SUCCESS
#    # or
#    # exit 128
# }
#
sub dbmanager {
    my %opt = %{$_[0]};
    my $msg = "None";
    if(%opt) {
        my ($cfg, $log, %preferences);
        $cfg = dirname(dirname(abs_path(__FILE__))) . "/conf/dbmanager.cfg";
        $log = dirname(dirname(abs_path(__FILE__))) . "/log/dbmanager.log";
        if(read_preference($cfg, \%preferences) == $SUCCESS) {
            my ($database, $dbHost, $dbPort, $dsn, $dbUser, $dbPassword, $dbh);
            $database = "dbname=$preferences{DB_NAME}";
            $dbHost = "host=$preferences{DB_HOST}";
            $dbPort = "port=$preferences{DB_PORT}";
            $dsn = "DBI:Pg:$database;$dbHost;$dbPort";
            $dbUser = "$preferences{DB_USER}";
            $dbPassword = "$preferences{DB_PASSWORD}";
            $dbh = DBI->connect(
                $dsn, $dbUser, $dbPassword, {RaiseError => 1}
            ) || die($DBI::errstr);
            my %argStructure = ();
            $argStructure{DBI} = $dbh;
            $argStructure{DBTE} = "$preferences{DB_TABLE_EMPLOYEE}";
            $argStructure{DBTD} = "$preferences{DB_TABLE_DEPARTMENT}";
            $argStructure{DBTC} = "$preferences{DB_TABLE_COMPANY}";
            $argStructure{OPT} = \%opt;
            if(db_operation(\%argStructure) == $SUCCESS) {
                $dbh->disconnect();
                $msg = "Done";
                info_debug_message($msg);
                return ($SUCCESS);
            }
            $dbh->disconnect();
            $msg = "Failed to do database operation";
            error_message($msg);
            return ($NOT_SUCCESS);
        }
        return ($NOT_SUCCESS);
    }
    $msg = "Missing argument [OPTION_STRUCTURE]";
    error_message($msg);
    return ($NOT_SUCCESS);
}

1;
__END__

=head1 NAME

DBManager - Database manager

=head1 SYNOPSIS

    use DBManager qw(dbmanager);

    ...

    if(dbmanager(\%dbarg) == $SUCCESS) {
        # true
        # notify admin | user
    } else {
        # false
        # return $NOT_SUCCESS
        # or
        # exit 128
    }

=head1 DESCRIPTION

Database manager

=head2 EXPORT

dbmanager - return 0 for success, else none 0

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
