package UserToGroup;
#
# @brief    Add user to department
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
our @EXPORT = qw(userToGroup);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Add user to department
# @params  Values required database handler and hash structure with details
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use UserToGroup qw(userToGroup);
#
# ...
#
# my $status = userToGroup($dbh);
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
sub userToGroup {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	my %ops = %{$_[1]};
	if((defined($dbHandler)) && (%ops)) {
		my $stmtMaxEid = qq(
			SELECT company.eid FROM company 
			WHERE company.eid = \(SELECT MAX\(company.eid\) FROM company\);
		);
		my $sthMaxEid = $dbHandler->prepare($stmtMaxEid);
		my $rvMaxEid = $sthMaxEid->execute() or die($DBI::errstr);
		if($rvMaxEid < 0){
			print($DBI::errstr);
		}
		my $maxEidRef = $sthMaxEid->fetchrow_hashref();
		my $maxEid = 0;
		$maxEid = $maxEidRef->{eid};
		if($maxEid == 0) {
			print("\nFailed to get MAX ID of users in department\n\n");
			$msg="Failed to get MAX ID form company table";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			return ($NOT_SUCCESS);
		}
		my $stmtGetEid = qq(
			SELECT employee_info.eid
			FROM employee_info WHERE 
			employee_info.username=\'$ops{NAME}\';
		);
		my $sthGetEid = $dbHandler->prepare($stmtGetEid);
		my $rvUnid = $sthGetEid->execute() or die($DBI::errstr);
		if($rvUnid < 0){
			print($DBI::errstr);
		}
		my $eidRef = $sthGetEid->fetchrow_hashref();
		my $eid = $eidRef->{eid};
		my $stmtGetDid = qq(
			SELECT department_info.did 
			FROM department_info 
			WHERE department_info.department=\'$ops{FNAME}\';
		);
		my $sthGetDid = $dbHandler->prepare($stmtGetDid);
		my $rv_did = $sthGetDid->execute() or die($DBI::errstr);
		if($rv_did < 0){
			print($DBI::errstr);
		}
		my $didRef = $sthGetDid->fetchrow_hashref();
		my $did = $didRef->{did};
		my $stmtGetEdid = qq(
			SELECT company.eid, company.did FROM company;
		);
		my $sthGetEdid = $dbHandler->prepare($stmtGetEdid);
		my $rvGetEdid = $sthGetEdid->execute() or die($DBI::errstr);
		if($rvGetEdid < 0){
			print($DBI::errstr);
		}
		while(my @edid = $sthGetEdid->fetchrow_array()) {
			if(("$edid[0]" eq "$eid") || ("$edid[1]" eq "$did")) {
				$msg = "User $ops{NAME} already in $ops{FNAME} department";
				print("\n" . $msg . "\n\n");
				return ($NOT_SUCCESS);
			}
		}
		my $addToDepartment = qq(
			INSERT INTO company \(eid, did\) 
			VALUES \($eid, $did\);
		);
		my $sthAddToDepartment = $dbHandler->prepare($addToDepartment);
		my $rvAddToDepartment = $sthAddToDepartment->execute() or 
			die($DBI::errstr);
		if($rvAddToDepartment < 0){
			print($DBI::errstr);
		}
		$msg="Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument(s) [DB_HANDLER] and [EMPLOYEE_ID]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

UserToGroup - Add user to department

=head1 SYNOPSIS

	use UserToGroup qw(userToGroup);

	...

	my $status = userToGroup($dbh);

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

Add user to department

=head2 EXPORT

userToGroup - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
