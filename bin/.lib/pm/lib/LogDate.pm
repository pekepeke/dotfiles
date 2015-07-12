package LogDate;

use warnings;
use strict;

sub new {
    my ($class, $date ) = @_;
    my $self = {
		daynum => [ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
	};
	my ($sec,$min,$hour,$mday,$mon,$year) = localtime(time);
	$year += 1900;
	if( $year % 4 == 0 ){
		if( $year % 100 == 0 ){
			if( $year % 400 == 0 ){
				$self->{daynum}->[2] = 29;
			}
		}else{
			$self->{daynum}->[2] = 29;
		}
	}
    bless $self, $class;
	$self->parse($date);
	$self->{str} = $date;
	return $self;
}

sub parse {
	my $self = shift;
	my $date = shift;
	if( $date =~ /(\d\d)-(\d\d)\s(\d\d):(\d\d):(\d\d)/ ){
		$self->{month}  = $1;
		$self->{day}    = $2;
		$self->{hour}   = $3;
		$self->{minute} = $4;
		$self->{second} = $5;
	}
}

sub next {
	my $self = shift;
	$self->{second} += 1;
	if( $self->{second} >= 60 ){
		$self->{second} = 0;
		$self->{minute} += 1;
		if( $self->{minute} >= 60 ){
			$self->{minute} = 0;
			$self->{hour}++;
			if( $self->{hour} >= 24 ){
				$self->{hour} = 0;
				$self->{day}++;
				if( $self->{day} >= $self->{daynum}->[$self->{month}] ){
					$self->{day} = 0;
					$self->{month} += 1;
					if( $self->{month} >= 13 ){
						$self->{month} = 1;
					}
				}
			}
		}
	}
	$self->{str} = sprintf("%02d-%02d %02d:%02d:%02d",
						   $self->{month},
						   $self->{day},
						   $self->{hour},
						   $self->{minute},
						   $self->{second});
}


1;
