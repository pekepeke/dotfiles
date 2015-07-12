package Log::Top;

use base qw(Log);

use warnings;
use strict;

sub parse_line {
	my $self = shift;
	my $line = shift;
	chomp($line);
	if( $line =~ /(\S+)\s(\S+)\t(\d+)\t(\d+)\t(\d+)/ ){
		return {
			datetime => $1." ".$2,
			cpuusage => $3,
			vss      => $4,
			rss      => $5,
		};
	}else{
		warn $line;
	}
	return undef;
}

1;
