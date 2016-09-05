package AddDepartment;
#
# @brief    Add new department to database/table
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
use GetMaxDid qw(getmaxdid);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(adddepartment);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Add new department to database/table
# @param   Value required argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use AddDepartment qw(adddepartment);
#
# ...
#
# my $status = adddepartment(\%argStructure);
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
sub adddepartment {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	if(%argStructure) {
		my $maxDid;
		if(getmaxdid(\%argStructure, \$maxDid) == $SUCCESS) {
			$msg = "Select from table [$argStructure{DBTD}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtGetDnid = qq (
				SELECT $argStructure{DBTD}.did, 
				$argStructure{DBTD}.department,
				$argStructure{DBTD}.gid 
				FROM $argStructure{DBTD};
			);
			my $sthDnid = $argStructure{DBI}->prepare($stmtGetDnid);
			my $rvDnid = $sthDnid->execute() or die($DBI::errstr);
			if($rvDnid < 0){
				print($DBI::errstr);
			}
			my @dnid;
			my @existingDids;
			my $dname = "$argStructure{NAME}";
			my $udid = "$argStructure{UDID}";
			while(@dnid = $sthDnid->fetchrow_array()) {
				if(("$dname" eq "$dnid[1]") || ("$udid" eq "$dnid[2]")) {
					$msg = "Department $dname (ID $udid) already exist";
					print("[Info] " . $fCaller . " " . $msg . "\n");
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
			$msg = "Insert to table [$argStructure{DBTD}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtAddDepartment = qq (
				INSERT INTO $argStructure{DBTD} \(did, department, gid\)
				VALUES \($maxDid , \'$dname\', $udid\);
			);
			my $sthAddDepartment = $argStructure{DBI}->prepare($stmtAddDepartment);
			my $rvAddDepartment = $sthAddDepartment->execute() or 
				die($DBI::errstr);
			if($rvAddDepartment < 0){
				print($DBI::errstr);
			}
			$msg = "Done";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			return ($SUCCESS);
		}
		return ($NOT_SUCCESS);
	}
	$msg = "Check argument [ARGUMENT_STRUCTURE]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

AddDepartment - Add new department to database/table

=head1 SYNOPSIS

	use AddDepartment qw(adddepartment);

	...

	my $status = adddepartment(\%argStructure);

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

Add new department to database/table

=head2 EXPORT

adddepartment - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
