package Log::Meminfo;

use base qw(Log);

use warnings;
use strict;

sub parse_line {
	my $self = shift;
	my $line = shift;
	chomp($line);
	if( $line =~ /(\S+)\s(\S+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)/ ){
		return {
			datetime => $1." ".$2,
			pss => {
				native => $3,
				dalvik => $4,
				other  => $5,
				total  => $6,
			},
			shard => {
				native => $7,
				dalvik => $8,
				other  => $9,
				total  => $10,
			},
			private => {
				native => $11,
				dalvik => $12,
				other  => $13,
				total  => $14,
			},
		};
	}
	return undef;
}

1;
