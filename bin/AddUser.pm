package AddUser;
#
# @brief    Add new user
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
our @EXPORT = qw(addUser);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Add new user
# @params  Values required database handler and hash structure with details
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use AddUser qw(addUser);
#
# ...
#
# my $status = addUser($dbh, \%ops);
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
sub addUser {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	my %ops = %{$_[1]};
	if((defined($dbHandler)) && (%ops)) {
		my $stmtMaxEid = qq(
			SELECT employee_info.eid
			FROM employee_info 
			where 
			employee_info.eid = 
			\(SELECT MAX\(employee_info.eid\) FROM employee_info\);
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
			print("\nFailed to get MAX ID of users\n\n");
			$msg="Failed to get MAX ID form employee_info table";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			return ($NOT_SUCCESS);
		}
		my $stmtGetUnid = qq(
			SELECT employee_info.eid, employee_info.username, 
			employee_info.uid FROM employee_info;
		);
		my $sthUnid = $dbHandler->prepare($stmtGetUnid);
		my $rvUnid = $sthUnid->execute() or die($DBI::errstr);
		if($rvUnid < 0){
			print($DBI::errstr);
		}
		my @unid;
		my @existingEids;
		while(@unid = $sthUnid->fetchrow_array()) {
			if(("$ops{NAME}" eq "$unid[1]") || ("$ops{UDID}" eq "$unid[2]")) {
				$msg = "User $ops{NAME} (ID $ops{UDID}) already exist";
				print("\n" . $msg . "\n\n");
				return ($NOT_SUCCESS);
			}
			push(@existingEids, $unid[0]);
		}
		my $i;
		my @missingEids;
		foreach (@existingEids) {
			if ($_ != ++$i) {
				push(@missingEids, $i .. $_ - 1);
				$i = $_;
			}
		}
		if(defined($missingEids[0])) {
			$maxEid = $missingEids[0];
		} else {
			$maxEid = $maxEid + 1;
		}
		my $stmtAddUser = qq(
			INSERT INTO employee_info \(eid, username, uid, fullname\) 
			VALUES \($maxEid, \'$ops{NAME}\', $ops{UDID}, \'$ops{FNAME}\'\);
		);
		my $sthAddUser = $dbHandler->prepare($stmtAddUser);
		my $rvAddUser = $sthAddUser->execute() or die($DBI::errstr);
		if($rvAddUser < 0){
			print($DBI::errstr);
		}
		$msg="Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument(s) [DB_HANDLER] and [NEW_USER_STRUCTURE]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

AddUser - Add new user

=head1 SYNOPSIS

	use AddUser qw(addUser);

	...

	my $status = addUser($dbh, \%ops);

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

Add new user

=head2 EXPORT

addUser - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
