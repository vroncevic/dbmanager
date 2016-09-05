package GetEid;
#
# @brief    Get employee id from database/table by username
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
our @EXPORT = qw(geteid);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Get employee id from database/table by username
# @params  Values required argument structure, and eid [output]
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use GetEid qw(geteid);
#
# ...
#
# my $status = geteid(\%argStructure, \$eid);
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
sub geteid {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	my $finalEid = $_[1];
	if(%argStructure) {
		$msg = "Select from table [$argStructure{DBTE}]";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		my $stmtEid = qq (
			SELECT $argStructure{DBTE}.eid 
			FROM $argStructure{DBTE} 
			WHERE $argStructure{DBTE}.username = \'$argStructure{OPT}->{NAME}\';
		);
		my $sthEid = $argStructure{DBI}->prepare($stmtEid);
		my $rvEid = $sthEid->execute() or die($DBI::errstr);
		if($rvEid < 0){
			print($DBI::errstr);
		}
		my $eidRef = $sthEid->fetchrow_hashref();
		my $eid = 0;
		$eid = $eidRef->{eid};
		if($eid == 0) {
			$msg="Failed to get employee id from database/table";
			print("[Error] " . $fCaller . " " . $msg . "\n");
			return ($NOT_SUCCESS);
		}
		${$finalEid} = $eid;
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

GetEid - Get employee id from database/table by username

=head1 SYNOPSIS

	use GetEid qw(geteid);

	...

	my $status = geteid(\%argStructure, \$eid);

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

Get employee id from database/table by username

=head2 EXPORT

geteid - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
