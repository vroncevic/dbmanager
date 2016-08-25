package DelUser;
#
# @brief    Delete user by username
# @version  ver.1.0
# @date     Mon Aug 22 16:09:02 CEST 2016
# @company  Frobas IT Department, www.frobas.com 2016
# @author   Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
use 5.018002;
use strict;
use warnings;
use Exporter;
use DBI;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(delUser);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Delete user by username
# @params  Values required database handler and username
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use DelUser qw(delUser);
#
# ...
# 
# my $status = delUser($dbh, $username);
#
# if ($status == $SUCCESS) {
#	# true
#	# notify admin | user
# } else {
#	# false
#	# return $NOT_SUCCESS
#	# or
#	# exit 128
# }
#
sub delUser {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	my $username = $_[1];
	if((defined($dbHandler)) && (defined($username))) {
		my $stmtEid = qq(
			SELECT employee_info.eid FROM employee_info 
			WHERE employee_info.username=\'$username\';
		);
		my $sthEid = $dbHandler->prepare($stmtEid);
		my $rvEid = $sthEid->execute() or die($DBI::errstr);
		if($rvEid < 0){
			print($DBI::errstr);
		}
		my $eidRef = $sthEid->fetchrow_hashref();
		my $eid = 0;
		$eid = $eidRef->{eid};
		if($eid == 0) {
			$msg="Failed to get employee ID";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			return ($NOT_SUCCESS);
		}
		my $stmtDelFromCompany = qq(
			DELETE FROM company WHERE company.eid=$eid;
		);
		my $sthDelFromCompany = $dbHandler->prepare($stmtDelFromCompany);
		my $rvDelFromCompany = $sthDelFromCompany->execute() or 
			die($DBI::errstr);
		if($rvDelFromCompany < 0){
			print($DBI::errstr);
		}
		my $stmtDelUser = qq(
			DELETE FROM employee_info WHERE employee_info.eid=$eid;
		);
		my $sthDelUser = $dbHandler->prepare($stmtDelUser);
		my $rvDelUser = $sthDelUser->execute() or die($DBI::errstr);
		if($rvDelUser < 0){
			print($DBI::errstr);
		}
		$msg="Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument(s) [DB_HANDLER] and [DB_USERNAME]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

DelUser - Delete user by username

=head1 SYNOPSIS

	use DelUser qw(delUser);

	...

	my $status = delUser($dbh, $username);

	if ($status == $SUCCESS) {
		# true
		# notify admin | user
	} else {
		# false
		# return $NOT_SUCCESS
		# or
		# exit 128
	}

=head1 DESCRIPTION

Delete user

=head2 EXPORT

delUser - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
