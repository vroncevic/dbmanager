package DelDepartment;
#
# @brief    Delete department by department name
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
our @EXPORT = qw(delDepartment);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   Delete department by department name
# @params  Values required database handler and department name
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use DelDepartment qw(delDepartment);
#
# ...
# 
# my $status = delDepartment($dbh, $department);
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
sub delDepartment {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	my $department = $_[1];
	if((defined($dbHandler)) && (defined($department))) {
		my $stmtDid = qq(
			SELECT department_info.did FROM department_info 
			WHERE department_info.department=\'$department\';
		);
		my $sthDid = $dbHandler->prepare($stmtDid);
		my $rvDid = $sthDid->execute() or die($DBI::errstr);
		if($rvDid < 0){
			print($DBI::errstr);
		}
		my $didRef = $sthDid->fetchrow_hashref();
		my $did = 0;
		$did = $didRef->{did};
		if($did == 0) {
			$msg="Failed to get department ID";
			if("$TOOL_DBG" eq "true") {
				print("[Info] " . $fCaller . " " . $msg . "\n");
			}
			return ($NOT_SUCCESS);
		}
		my $stmtDelCompany = qq(
			DELETE FROM company WHERE company.did=$did;
		);
		my $sthCompany = $dbHandler->prepare($stmtDelCompany);
		my $rvCompany = $sthCompany->execute() or die($DBI::errstr);
		if($rvCompany < 0) {
			print($DBI::errstr);
		}
		my $stmtDelDepartment = qq(
			DELETE FROM department_info WHERE department_info.did=$did;
		);
		my $sthDelDepartment = $dbHandler->prepare($stmtDelDepartment);
		my $rvDepartment = $sthDelDepartment->execute() or die($DBI::errstr);
		if($rvDepartment < 0) {
			print($DBI::errstr);
		}
		$msg="Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument(s) [DB_HANDLER] and [DB_DEPARTMENT_NAME]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
}

1;
__END__

=head1 NAME

DelDepartment - Delete department by department name

=head1 SYNOPSIS

	use DelDepartment qw(delDepartment);

	...

	my $status = delDepartment($dbh, $department);

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

Delete department by department name

=head2 EXPORT

delDepartment - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
