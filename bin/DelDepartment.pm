package DelDepartment;
#
# @brief    Delete department from database/table by department name
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
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(deldepartment);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Delete department from database/table by department name
# @param   Value required argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use DelDepartment qw(deldepartment);
#
# ...
# 
# my $status = deldepartment(\%argStructure);
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
sub deldepartment {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	if(%argStructure) {
		my $did;
		if(getdid(\%argStructure, \$did) == $SUCCESS) {
			$msg = "Delete from table [$argStructure{DBTC}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtDelDid = qq (
				DELETE FROM $argStructure{DBTC} 
				WHERE $argStructure{DBTC}.did=$did;
			);
			my $sthDelDid = $argStructure{DBI}->prepare($stmtDelDid);
			my $rvDelDid = $sthDelDid->execute() or die($DBI::errstr);
			if($rvDelDid < 0) {
				print($DBI::errstr);
			}
			$msg = "Delete from table [$argStructure{DBTD}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtDelDepartment = qq (
				DELETE FROM $argStructure{DBTD} 
				WHERE $argStructure{DBTD}.did=$did;
			);
			my $sthDelDepartment = $argStructure{DBI}->prepare($stmtDelDepartment);
			my $rvDepartment = $sthDelDepartment->execute() or die($DBI::errstr);
			if($rvDepartment < 0) {
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

DelDepartment - Delete department from database/table by department name

=head1 SYNOPSIS

	use DelDepartment qw(deldepartment);

	...

	my $status = deldepartment(\%argStructure);

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

Delete department from database/table by department name

=head2 EXPORT

deldepartment - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
