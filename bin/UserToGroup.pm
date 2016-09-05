package UserToGroup;
#
# @brief    Add user to group in database/table
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
use GetDid qw(getdid);
use GetEid qw(geteid);
use GetMaxEid qw(getmaxeid);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(usertogroup);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Add user to group in database/table
# @param   Value required argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use UserToGroup qw(usertogroup);
#
# ...
#
# my $status = usertogroup(\%argStructure);
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
sub usertogroup {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	if(%argStructure) {
		my $eid;
		my $did;
		if((geteid(\%argStructure, \$eid) == $SUCCESS) && 
		   (getdid(\%argStructure, \$did) == $SUCCESS)) {
			$msg = "Select from table [$argStructure{DBTC}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtGetEdid = qq (
				SELECT $argStructure{DBTC}.eid, 
				$argStructure{DBTC}.did 
				FROM $argStructure{DBTC};
			);
			my $sthGetEdid = $argStructure{DBI}->prepare($stmtGetEdid);
			my $rvGetEdid = $sthGetEdid->execute() or die($DBI::errstr);
			if($rvGetEdid < 0){
				print($DBI::errstr);
			}
			my $name = "$argStructure{NAME}";
			my $fname = "$argStructure{FNAME}";
			while(my @edid = $sthGetEdid->fetchrow_array()) {
				if(("$edid[0]" eq "$eid") || ("$edid[1]" eq "$did")) {
					$msg = "User $name already in $fname department";
					print("[Info] " . $fCaller . " " . $msg . "\n");
					return ($NOT_SUCCESS);
				}
			}
			$msg = "Insert to table [$argStructure{DBTC}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtUser2Group = qq (
				INSERT INTO $argStructure{DBTC} \(eid, did\) 
				VALUES \($eid, $did\);
			);
			my $sthUser2Group = $argStructure{DBI}->prepare($stmtUser2Group);
			my $rvUser2Group = $sthUser2Group->execute() or 
				die($DBI::errstr);
			if($rvUser2Group < 0) {
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

UserToGroup - Add user to group in database/table

=head1 SYNOPSIS

	use UserToGroup qw(usertogroup);

	...

	my $status = usertogroup(\%argStructure);

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

Add user to group in database/table

=head2 EXPORT

usertogroup - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
