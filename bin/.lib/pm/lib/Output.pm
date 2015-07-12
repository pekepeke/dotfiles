package Output;

use warnings;
use strict;

sub new {
    my ($class) = @_;
	my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
	$year = $year + 1900;
    my $self = {
		year => $year,
		memo => {
			top => {
				cpuusage => "",
			},
			meminfo => {
				pss => {
					native => "",
					dalvik => "",
					other  => "",
					total  => "",
				},
				private => {
					native => "",
					dalvik => "",
					other  => "",
					total  => "",
				},
			},
			fps => "",
		}
    };
    bless $self, $class;
	return $self;
}

sub make_output {
	my $self = shift;
	my $line = shift;
	if( !$line->{top} ){
		$line->{top} = $self->{memo}->{top};
	}
	if( !$line->{meminfo} ){
		$line->{meminfo} = $self->{memo}->{meminfo};
	}
	if( !$line->{fps} ){
		$line->{fps} = $self->{memo}->{fps};
	}
	if( !$line->{garbage} ){
		$line->{garbage} = "";
	}

	$self->{memo}->{top} = $line->{top};
	$self->{memo}->{meminfo} = $line->{meminfo};
	$self->{memo}->{fps} = $line->{fps};
	
	return $self->{year}."-".$line->{datetime}."\t".
		$line->{top}->{cpuusage}."\t".
		$line->{meminfo}->{pss}->{native}."\t".
		$line->{meminfo}->{pss}->{dalvik}."\t".
		$line->{meminfo}->{pss}->{other}."\t".
		$line->{meminfo}->{pss}->{total}."\t".
		$line->{meminfo}->{private}->{native}."\t".
		$line->{meminfo}->{private}->{dalvik}."\t".
		$line->{meminfo}->{private}->{other}."\t".
		$line->{meminfo}->{private}->{total}."\t".
		$line->{fps}."\t".
		$line->{garbage}."\r\n";
	
}

sub make_output_html {
	my $self = shift;
	my $line = shift;
	if( !$line->{top} ){
		$line->{top} = $self->{memo}->{top};
	}
	if( !$line->{meminfo} ){
		$line->{meminfo} = $self->{memo}->{meminfo};
	}
	if( !$line->{fps} ){
		$line->{fps} = $self->{memo}->{fps};
	}
	if( !$line->{garbage} ){
		$line->{garbage} = "";
	}

	$self->{memo}->{top} = $line->{top};
	$self->{memo}->{meminfo} = $line->{meminfo};
	$self->{memo}->{fps} = $line->{fps};
	
	my $html = "<tr><th>";
	if( $line->{shot} ){
		$html .= "<a href='".$line->{shot}."'>".$self->{year}."-".$line->{datetime};
	}else{
		$html .= $self->{year}."-".$line->{datetime};
	}
	return $html . "</th><td>".
		$line->{top}->{cpuusage}."</td><td>".
		$line->{meminfo}->{pss}->{native}."</td><td>".
		$line->{meminfo}->{pss}->{dalvik}."</td><td>".
		$line->{meminfo}->{pss}->{other}."</td><td>".
		$line->{meminfo}->{pss}->{total}."</td><td>".
		$line->{meminfo}->{private}->{native}."</td><td>".
		$line->{meminfo}->{private}->{dalvik}."</td><td>".
		$line->{meminfo}->{private}->{other}."</td><td>".
		$line->{meminfo}->{private}->{total}."</td><td>".
		$line->{fps}."</td><td>".
		$line->{garbage}."</td></tr>\r\n";
	
}

1;

