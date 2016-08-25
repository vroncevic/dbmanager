package ListDepartments;
#
# @brief    List departments
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
our @EXPORT = qw(listDepartments);
our $VERSION = '1.0';
our $TOOL_DBG="false";

#
# @brief   List departments
# @param   Value required database handler
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use ListDepartments qw(listDepartments);
#
# ...
#
# my $status = listDepartments($dbh);
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
sub listDepartments {
	my $fCaller = (caller(0))[3];
	my $msg="None";
	my $dbHandler = $_[0];
	if(defined($dbHandler)) {
		my $tbl = Text::Table->new(
			"Department ID",
			"Department name",
			"Group ID"
		);
		my $stmtListDepartments = qq(
			SELECT department_info.did,
			department_info.department, 
			department_info.gid FROM department_info;
		);
		my $sthListDepartments = $dbHandler->prepare($stmtListDepartments);
		my $rvListDeartments = $sthListDepartments->execute() or 
			die($DBI::errstr);
		if($rvListDeartments < 0){
			print($DBI::errstr);
		}
		while(my @ListDepartments = $sthListDepartments->fetchrow_array()) {
			$tbl->add(
				$ListDepartments[0], 
				$ListDepartments[1], 
				$ListDepartments[2]
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

ListDepartments - List departments 

=head1 SYNOPSIS

	use ListDepartments qw(listDepartments);

	...

	my $status = listDepartments($dbh);

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

List departments 

=head2 EXPORT

ListDepartments - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
