package ListAll;
#
# @brief    List all details
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
use Text::Table;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(dirname(abs_path($0))) . '/../../lib/perl5';
use Status;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ('all' => [qw()]);
our @EXPORT_OK = (@{$EXPORT_TAGS{'all'}});
our @EXPORT = qw(listAll);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   List all details
# @param   Value required database handler
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use ListAll qw(listAll);
#
# ...
#
# my $status = listAll($dbh);
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
sub listAll {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	if(defined($dbHandler)) {
		my $tbl = Text::Table->new(
			"Employee ID",
			"Full name",
			"User name",
			"Department",
			"User ID",
			"Group ID"
		);
		my $stmtListAll = qq(
			SELECT employee_info.eid, 
			employee_info.fullname, 
			employee_info.username, 
			department_info.department, 
			employee_info.uid, 
			department_info.gid FROM employee_info
			INNER JOIN company ON (employee_info.eid = company.eid)
			INNER JOIN department_info ON (department_info.did = company.did);
		);
		my $sthListAll = $dbHandler->prepare($stmtListAll);
		my $rvListAll = $sthListAll->execute() or die($DBI::errstr);
		if($rvListAll < 0){
			print($DBI::errstr);
		}
		while(my @listAll = $sthListAll->fetchrow_array()) {
			$tbl->add(
				$listAll[0], 
				$listAll[1], 
				$listAll[2], 
				$listAll[3], 
				$listAll[4], 
				$listAll[5]
			);
		}
		$tbl->add(' ');
		print($tbl);
		$msg="Done";
        if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
        }
		return ($SUCCESS);
	}
	$msg = "Check argument [DB_HANDLER]";
    print("[Error] " . $fCaller . " " . $msg . "\n");
	return ($NOT_SUCCESS);
} 

1;
__END__

=head1 NAME

ListAll - List all details 

=head1 SYNOPSIS

	use ListAll qw(listAll);

	...

	my $status = listAll($dbh);

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

List all details 

=head2 EXPORT

listAll - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
