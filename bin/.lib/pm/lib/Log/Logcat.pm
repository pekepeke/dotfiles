package Log::Logcat;

use base qw(Log);

use warnings;
use strict;

sub parse_line {
	my $self = shift;
	my $line = shift;
	if( $line =~ /(\S+)\s+(\d+:\d+:\d+)\.(\d+)\s+(\w+)\/([^(]+)\(([^)]+)\)\:\s*(.+)$/ ){
#		warn $1." ".$2;
		return {
			datetime => $1." ".$2,
			level    => $4,
			tag      => $5,
			pid      => $6,
			message  => $7,
			line     => $line,
		};
	}
	return undef;
}

sub read_first_line {
	my $self = shift;
	$self->read_line();
	while( !$self->{current_line} && !$self->eof ){
		$self->read_line();
	}
	$self->{first_line} = $self->{current_line};
}

sub getgarbage_info {
	my $self = shift;
	if( !$self->{current_line} ){
		return undef;
	}
#	warn $self->{current_line}->{message};
	if( $self->{current_line}->{message} =~ /(GC_\w+).+?(\d+)ms$/ ){
		return $1." ".$2."ms";
	}
	return undef;
}

sub get_fps {
	my $self = shift;
	if( !$self->{current_line} ){
		return undef;
	}
	if( $self->{current_line}->{message} =~ /FPSWatcher\:\s+FPS\:\s(\d+)/ ){
		return $1;
	}
	return undef;
}

1;
