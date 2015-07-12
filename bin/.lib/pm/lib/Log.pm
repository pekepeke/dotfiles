package Log;

use warnings;
use strict;

sub new {
    my ($class, $filepath, $packagename ) = @_;
    my $self = {
		filepath     => $filepath,
		packagename  => $packagename,
		filehandle   => undef,
		first_line   => undef,
		current_line => undef,
		error        => undef,
		eof          => 0,
    };
    bless $self, $class;
	if( $self->open() ){
		$self->read_first_line();
	}
	return $self;
}

sub open {
	my $self = shift;
	if( !$self->{filepath} ){
		$self->{error} = 'File does not specified';
		return 0;
	}
	my $filehandle;
	if( !open( $filehandle, "<", $self->{filepath} ) ){
		$self->{error} = 'File cannot open';		
		return 0;
	}
	$self->{filehandle} = $filehandle;
	if( eof $self->{filehandle} ){
		$self->{eof} = 1;
		close( $self->{filehandle} );
		$self->{filehandle} = undef;
	}
	return 1;
}

sub parse_line {
	my $self = shift;
	my $line = shift;
	chomp($line);
	return {
		line  => $line,
	};
}

sub read_line {
	my $self = shift;
	if( $self->{filehandle} &&
		!$self->{eof} &&
		!eof $self->{filehandle} ){
		my $fh = $self->{filehandle};
		$/ = "\r\n";
		my $line = <$fh>;
		chomp($line);
		$self->{current_line} = $self->parse_line($line);
	}else{
		$self->{current_line} = undef;
	}
}

sub read_first_line {
	my $self = shift;
	$self->read_line();
	$self->{first_line} = $self->{current_line};
}

sub eof {
	my $self = shift;
	if( !$self->{filehandle} ||
		$self->{eof} ||
		eof($self->{filehandle}) ){
		return 1;
	}
	return 0;
}

sub close {
	my $self = shift;
	if( $self->{filehandle} ){
		close( $self->{filehandle} );
		$self->{filehandle} = undef;
	}
}

sub END {
}

1;
