package AddUser;
#
# @brief    Add new user to database/table
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
use GetMaxEid qw(getmaxeid);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(adduser);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Add new user to database/table
# @params  Values required argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use AddUser qw(adduser);
#
# ...
#
# my $status = adduser(\%argStructure);
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
sub adduser {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	if(%argStructure) {
		my $maxEid;
		if(getmaxeid(\%argStructure, \$maxEid) == $SUCCESS) {
			$msg = "Select from table [$argStructure{DBTE}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtGetUnid = qq (
				SELECT $argStructure{DBTE}.eid, 
				$argStructure{DBTE}.username, 
				$argStructure{DBTE}.uid 
				FROM $argStructure{DBTE};
			);
			my $sthUnid = $argStructure{DBI}->prepare($stmtGetUnid);
			my $rvUnid = $sthUnid->execute() or die($DBI::errstr);
			if($rvUnid < 0) {
				print($DBI::errstr);
			}
			my @unid;
			my @existingEids;
			my $name = "$argStructure{OPT}->{NAME}";
			my $udid = "$argStructure{OPT}->{UDID}";
			my $fname = "$argStructure{OPT}->{FNAME}";
			while(@unid = $sthUnid->fetchrow_array()) {
				if(("$name" eq "$unid[1]") || ("$udid" eq "$unid[2]")) {
					$msg = "User $name (ID $udid) already exist";
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
			$msg = "Insert to table [$argStructure{DBTE}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtAddUser = qq (
				INSERT INTO $argStructure{DBTE} \(eid, username, uid, fullname\) 
				VALUES \($maxEid, \'$name\', $udid, \'$fname\'\);
			);
			my $sthAddUser = $argStructure{DBI}->prepare($stmtAddUser);
			my $rvAddUser = $sthAddUser->execute() or die($DBI::errstr);
			if($rvAddUser < 0) {
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

AddUser - Add new user to database/table

=head1 SYNOPSIS

	use AddUser qw(adduser);

	...

	my $status = adduser(\%argStructure);

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

Add new user to database/table

=head2 EXPORT

adduser - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
