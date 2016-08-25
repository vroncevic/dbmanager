package AddDepartment;
#
# @brief    Add new department
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
our @EXPORT = qw(addDepartment);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Add new department
# @params  Values required database handler and hash department structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use AddDepartment qw(addDepartment);
#
# ...
#
# my $status = addDepartment($dbh, \%ops);
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
sub addDepartment {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	my %ops = %{$_[1]};
	if((defined($dbHandler)) && (%ops)) {
		my $stmtMaxDid = qq(
			SELECT department_info.did
			FROM department_info 
			WHERE department_info.did = 
			\(SELECT MAX\(department_info.did\) FROM department_info\);
		);
		my $sthMaxDid = $dbHandler->prepare($stmtMaxDid);
		my $rvMaxDid = $sthMaxDid->execute() or die($DBI::errstr);
		if($rvMaxDid < 0){
			print($DBI::errstr);
		}
		my $maxDidRef = $sthMaxDid->fetchrow_hashref();
		my $maxDid = 0;
		$maxDid = $maxDidRef->{did};
		if($maxDid == 0) {
			print("\nFailed to get MAX ID of departments\n\n");
			$msg="Failed to get MAX ID form department_info table";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			return ($NOT_SUCCESS);
		}
		my $stmtGetDnid = qq(
			SELECT department_info.did, department_info.department,
			department_info.gid FROM department_info;
		);
		my $sthDnid = $dbHandler->prepare($stmtGetDnid);
		my $rvDnid = $sthDnid->execute() or die($DBI::errstr);
		if($rvDnid < 0){
			print($DBI::errstr);
		}
		my @dnid;
		my @existingDids;
		while(@dnid = $sthDnid->fetchrow_array()) {
			if(("$ops{NAME}" eq "$dnid[1]") || ("$ops{UDID}" eq "$dnid[2]")) {
				$msg = "Department $ops{NAME} (ID $ops{UDID}) already exist";
				print("\n" . $msg . "\n\n");
				return ($NOT_SUCCESS);
			}
			push(@existingDids, $dnid[0]);
		}
		my $i;
		my @missingDids;
		foreach (@existingDids) {
			if ($_ != ++$i) {
				push(@missingDids, $i .. $_ - 1);
				$i = $_;
			}
		}
		if(defined($missingDids[0])) {
			$maxDid = $missingDids[0];
		} else {
			$maxDid = $maxDid + 1;
		}
		my $stmtAddDepartment = qq(
			INSERT INTO department_info \(did, department, gid\)
			VALUES \($maxDid , \'$ops{NAME}\', $ops{UDID}\);
		);
		my $sthAddDepartment = $dbHandler->prepare($stmtAddDepartment);
		my $rvAddDepartment = $sthAddDepartment->execute() or 
			die($DBI::errstr);
		if($rvAddDepartment < 0){
			print($DBI::errstr);
		}
		$msg="Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument(s) [DB_HANDLER] and [NEW_DEPARTMENT_STRUCTURE]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

AddDepartment - Add new department

=head1 SYNOPSIS

	use AddDepartment qw(addDepartment);

	...

	my $status = addDepartment($dbh, \%ops);

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

Add new department

=head2 EXPORT

addDepartment - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
