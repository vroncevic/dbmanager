package GetMaxEid;
#
# @brief    Get max employee id from database/table
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
our @EXPORT = qw(getmaxeid);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Get max employee id from database/table
# @params  Values required argument structure, and max eid [output]
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use GetMaxEid qw(getmaxeid);
#
# ...
#
# my $status = getmaxeid(\%argStructure, \$maxEid);
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
sub getmaxeid {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	my $finalMaxEid = $_[1];
	if(%argStructure) {
		$msg = "Select from table [$argStructure{DBTE}]";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		my $stmtMaxEid = qq (
			SELECT $argStructure{DBTE}.eid
			FROM $argStructure{DBTE} 
			WHERE $argStructure{DBTE}.eid = 
			\(SELECT MAX\($argStructure{DBTE}.eid\) 
			FROM $argStructure{DBTE}\);
		);
		my $sthMaxEid = $argStructure{DBI}->prepare($stmtMaxEid);
		my $rvMaxEid = $sthMaxEid->execute() or die($DBI::errstr);
		if($rvMaxEid < 0) {
			print($DBI::errstr);
		}
		my $maxEidRef = $sthMaxEid->fetchrow_hashref();
		my $maxEid = 0;
		$maxEid = $maxEidRef->{eid};
		if($maxEid == 0) {
			$msg="Failed to get max employee id from database/table";
			print("[Error] " . $fCaller . " " . $msg . "\n");
			return ($NOT_SUCCESS);
		}
		${$finalMaxEid} = $maxEid;
		$msg = "Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument [ARGUMENT_STRUCTURE]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

GetMaxEid - Get max employee id from database/table

=head1 SYNOPSIS

	use GetMaxEid qw(getmaxeid);

	...

	my $status = getmaxeid(\%argStructure, \$maxEid);

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

Get max employee id from database/table

=head2 EXPORT

getmaxeid - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
