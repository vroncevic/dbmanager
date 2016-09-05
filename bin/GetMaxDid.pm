package GetMaxDid;
#
# @brief    Get max department id from database/table
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
our @EXPORT = qw(getmaxdid);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Get max department id from database/table
# @params  Values required argument structure, and max did [output]
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use GetMaxDid qw(getmaxdid);
#
# ...
#
# my $status = getmaxdid(\%argStructure, \$maxDid);
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
sub getmaxdid {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	my $finalMaxDid = $_[1];
	if(%argStructure) {
		$msg = "Select from table [$argStructure{DBTD}]";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		my $stmtMaxDid = qq (
			SELECT $argStructure{DBTD}.did
			FROM $argStructure{DBTD} 
			WHERE $argStructure{DBTD}.did = 
			\(SELECT MAX\($argStructure{DBTD}.did\) 
			FROM $argStructure{DBTD}\);
		);
		my $sthMaxDid = $argStructure{DBI}->prepare($stmtMaxDid);
		my $rvMaxDid = $sthMaxDid->execute() or die($DBI::errstr);
		if($rvMaxDid < 0) {
			print($DBI::errstr);
		}
		my $maxDidRef = $sthMaxDid->fetchrow_hashref();
		my $maxDid = 0;
		$maxDid = $maxDidRef->{did};
		if($maxDid == 0) {
			$msg="Failed to get max department id from database/table";
			print("[Error] " . $fCaller . " " . $msg . "\n");
			return ($NOT_SUCCESS);
		}
		${$finalMaxDid} = $maxDid;
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

GetMaxDid - Get max department id from database/table

=head1 SYNOPSIS

	use GetMaxDid qw(getmaxdid);

	...

	my $status = getmaxdid(\%argStructure, \$maxDid);

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

Get max department id from database/table

=head2 EXPORT

getmaxdid - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
