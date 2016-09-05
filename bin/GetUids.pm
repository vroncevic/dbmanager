package GetUids;
#
# @brief    Get user ids from database/table
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
our @EXPORT = qw(getuids);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Get user ids from database/table
# @params  Values required argument structure, and uids [output]
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use GetUids qw(getuids);
#
# ...
#
# my $status = getuids(\%argStructure, \@uids);
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
sub getuids {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	my $uids = $_[1];
	if(%argStructure) {
		$msg = "Select from table [$argStructure{DBTE}]";
		if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
		}
		my $stmtGetUids = qq (
			SELECT $argStructure{DBTE}.uid 
			FROM $argStructure{DBTE};
		);
		my $sthGetUids = $argStructure{DBI}->prepare($stmtGetUids);
		my $rvGetUids = $sthGetUids->execute() or die($DBI::errstr);
		if($rvGetUids < 0) {
			print($DBI::errstr);
			return ($NOT_SUCCESS);
		}
		while(my @listUids = $sthGetUids->fetchrow_array()) {
			for(my $i = 0; $i < scalar(@listUids); $i++) {
				my $uid = $listUids[$i];
				push(@{$uids}, $uid);
			}
		}
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

GetUids - Get user ids from database/table

=head1 SYNOPSIS

	use GetUids qw(getuids);

	...

	my $status = getuids(\%argStructure, \@uids);

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

Get user ids from database/table

=head2 EXPORT

getuids - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
