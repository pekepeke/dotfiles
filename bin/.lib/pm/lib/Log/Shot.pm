package Log::Shot;

use base qw(Log);

use warnings;
use strict;

sub parse_line {
	my $self = shift;
	my $line = shift;
	chomp($line);
	if( $line =~ /(\S+)\s(\S+)\t(\S+)/ ){
		return {
			datetime => $1." ".$2,
			filename => $3,
		};
	}
	return undef;
}

1;
