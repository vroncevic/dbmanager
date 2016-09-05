package DelUser;
#
# @brief    Delete user from database/table by username
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
use GetEid qw(geteid);
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(deluser);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   Delete user from database/table by username
# @param   Value required argument structure
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use DelUser qw(deluser);
#
# ...
# 
# my $status = deluser(\%argStructure);
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
sub deluser {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	if(%argStructure) {
		my $eid;
		if(geteid(\%argStructure, \$eid) == $SUCCESS) {
			$msg = "Delete from table [$argStructure{DBTC}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtDelEid = qq (
				DELETE FROM $argStructure{DBTC} 
				WHERE $argStructure{DBTC}.eid = $eid;
			);
			my $sthDelEid = $argStructure{DBI}->prepare($stmtDelEid);
			my $rvDelEid = $sthDelEid->execute() or die($DBI::errstr);
			if($rvDelEid < 0){
				print($DBI::errstr);
			}
			$msg = "Delete from table [$argStructure{DBTE}]";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			my $stmtDelEmployee = qq (
				DELETE FROM $argStructure{DBTE} 
				WHERE $argStructure{DBTE}.eid = $eid;
			);
			my $sthDelEmployee = $argStructure{DBI}->prepare($stmtDelEmployee);
			my $rvDelEmployee = $sthDelEmployee->execute() or die($DBI::errstr);
			if($rvDelEmployee < 0){
				print($DBI::errstr);
			}
			$msg="Done";
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

DelUser - Delete user from database/table by username

=head1 SYNOPSIS

	use DelUser qw(deluser);

	...

	my $status = deluser(\%argStructure);

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

Delete user from database/table by username

=head2 EXPORT

deluser - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
