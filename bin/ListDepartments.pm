package ListDepartments;
#
# @brief    List departments from database/table
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
our @EXPORT = qw(listdepartments);
our $VERSION = '1.0';
our $TOOL_DBG = "false";

#
# @brief   List departments from database/table
# @param   Value required argument structure 
# @retval  Success 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# 
# use ListDepartments qw(listdepartments);
#
# ...
#
# my $status = listdepartments(\%argStructure);
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
sub listdepartments {
	my $fCaller = (caller(0))[3];
	my $msg = "None";
	my %argStructure = %{$_[0]};
	if(%argStructure) {
		my $table = Text::Table->new(
			"Department ID",
			"Department name",
			"Group ID"
		);
		$msg = "Select from table [$argStructure{DBTD}]";
		if("$TOOL_DBG" eq "true") {
			print("[Info] " . $fCaller . " " . $msg . "\n");
		}
		my $stmtListDepartments = qq (
			SELECT $argStructure{DBTD}.did,
			$argStructure{DBTD}.department, 
			$argStructure{DBTD}.gid 
			FROM $argStructure{DBTD};
		);
		my $sthListDepartments = $argStructure{DBI}->prepare($stmtListDepartments);
		my $rvListDeartments = $sthListDepartments->execute() or 
			die($DBI::errstr);
		if($rvListDeartments < 0){
			print($DBI::errstr);
		}
		while(my @listDepartments = $sthListDepartments->fetchrow_array()) {
			$table->add(
				$listDepartments[0], 
				$listDepartments[1], 
				$listDepartments[2]
			);
		}
		$table->add(' ');
		print($table);
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

ListDepartments - List departments from database/table

=head1 SYNOPSIS

	use ListDepartments qw(listdepartments);

	...

	my $status = listdepartments(\%argStructure);

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

List departments from database/table

=head2 EXPORT

listdepartments - return 0 for success, else return 1

=head1 AUTHOR

Vladimir Roncevic, E<lt>vladimir.roncevic@frobas.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by www.frobas.com 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.

=cut
