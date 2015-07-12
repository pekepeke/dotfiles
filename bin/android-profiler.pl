#!/usr/bin/env perl


use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
use FindBin;

use lib "$FindBin::Bin/.lib/pm";

use Log::Logcat;
use Log::Top;
use Log::Meminfo;
use Log::Shot;
use LogDate;
use Output;

use Data::Dumper;

$| = 1;

# my $exit_loop;

# $SIG{TERM} = sub { $exit_loop = 1 };

my $adb_command = "adb";
my $monkeyrunner_command = "monkeyrunner";
my $pybindir = "$FindBin::Bin/.lib/py/android-profiler";
my $package_name = "com.mobage.us";
my $opt_help;

GetOptions(
    'target|t=s' => \$package_name,
    'help|h' => \$opt_help,
);
pod2usage() if $opt_help;

sub make_directory_name {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year += 1900;
	$mon += 1;
	return sprintf("profile_%04d%02d%02d%02d%02d%02d", $year, $mon, $mday, $hour, $min, $sec );
}

sub read_logcat {
    $SIG{TERM} = sub { exit 0 };
	$SIG{KILL} = sub { exit 0 };

	my $dir = shift;
	my $data = `$adb_command logcat -v time > $dir/logcat.log`;
	while(1){
		sleep(1);
	}
}

sub read_meminfo {
    $SIG{TERM} = sub { exit 0 };
	$SIG{KILL} = sub { exit 0 };

	my $dir = shift;
	open( MEMINFO, ">", "$dir/meminfo.log" );
	while(1){
		my $result = `$adb_command shell dumpsys meminfo $package_name`;
		my( $pss_native, $pss_dalvik, $pss_other, $pss_total,
			$sd_native, $sd_dalvik, $sd_other, $sd_total,
			$pd_native, $pd_dalvik, $pd_other, $pd_total );
		if( $result =~ /[\r\n]\s+?\(Pss\)\:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/s ){
			$pss_native = $1;
			$pss_dalvik = $2;
			$pss_other  = $3;
			$pss_total  = $4;
		}else{
			return;
		}
		if( $result =~ /[\r\n]\s+?\(shared\sdirty\)\:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/s ){
			$sd_native = $1;
			$sd_dalvik = $2;
			$sd_other  = $3;
			$sd_total  = $4;
		}
		if( $result =~ /[\r\n]\s+?\(priv\sdirty\)\:\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/s ){
			$pd_native = $1;
			$pd_dalvik = $2;
			$pd_other  = $3;
			$pd_total  = $4;
		}
		my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
 		$mon = $mon + 1;
		$year = $year + 1900;
		my $time = sprintf("%02d-%02d %02d:%02d:%02d",$mon, $day, $hour, $min, $sec );
		my $log = sprintf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
						  $time,
						  $pss_native, $pss_dalvik, $pss_other, $pss_total,
						  $sd_native, $sd_dalvik, $sd_other, $sd_total,
						  $pd_native, $pd_dalvik, $pd_other, $pd_total );

		print MEMINFO $log."\r\n";
		sleep(1);
	}
	close( MEMINFO );
}

sub read_top {
    $SIG{TERM} = sub { exit 0 };
	$SIG{KILL} = sub { exit 0 };
	my $dir = shift;
	open( TOP, ">", "$dir/top.log" );
	while(1){
		my $result = `$adb_command shell top -n 1`;
		if( $result =~ /[\r\n]([^\r\n]+?$package_name)[\r\n]/s ){
			my $line = $1;
			if( $line =~ /\d+\s+(\d+)\%\s+\S+\s+(\d+)\s+(\d+)K\s+(\d+)K\s+\S+\s+\S+/i ){
				my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
				$mon = $mon + 1;
				$year = $year + 1900;
				my $time = sprintf("%02d-%02d %02d:%02d:%02d",$mon, $day, $hour, $min, $sec );
				my $log = "$time\t$1\t$3\t$4";
				if( $1 > 100 ){
					print $line."\n";
				}else{
#					print "----".$line."---\n";
					print TOP $log."\r\n";
				}
			}
		}
	}
}

sub take_screen_shot {
    $SIG{TERM} = sub { exit 0 };
	$SIG{KILL} = sub { exit 0 };
	my $dir = shift;
	open( SHOT, ">", "$dir/shot.log" );
	while(1){
		my ($sec, $min, $hour, $day, $mon, $year) = localtime(time);
		$mon = $mon + 1;
		$year = $year + 1900;
		my $time = sprintf("%02d-%02d %02d:%02d:%02d",$mon, $day, $hour, $min, $sec );
		my $filename = sprintf("$dir/shot_%02d%02d%02d.png",$hour, $min, $sec );
		my $result = `$monkeyrunner_command $pybindir/screenshot.py $filename`;
		print SHOT $time."\t".$filename.".png\r\n";
		sleep(30);
	}
}

sub detect_starttime {
	my ( $top, $mem, $log ) = @_;
	if( $top->{first_line}->{datetime} gt $mem->{first_line}->{datetime} ){
		if( $mem->{first_line}->{datetime} gt $log->{first_line}->{datetime} ){
			return $log->{first_line}->{datetime};
		}else{
			return $mem->{first_line}->{datetime};
		}
	}else{
		if( $top->{first_line}->{datetime} gt $log->{first_line}->{datetime} ){
			return $log->{first_line}->{datetime};
		}else{
			return $top->{first_line}->{datetime};
		}
	}
}

sub print_result_line {
	my $line = shift;
	if( !$line->{top} ){
		$line->{top}->{cpuusage} = "";
	}
	if( !$line->{meminfo} ){
		$line->{meminfo}->{pss} = {};
		$line->{meminfo}->{private} = {};
		$line->{meminfo}->{pss}->{native} = "";
		$line->{meminfo}->{pss}->{dalvik} = "";
		$line->{meminfo}->{pss}->{other} = "";
		$line->{meminfo}->{pss}->{total} = "";
		$line->{meminfo}->{private}->{native} = "";
		$line->{meminfo}->{private}->{dalvik} = "";
		$line->{meminfo}->{private}->{other} = "";
		$line->{meminfo}->{private}->{total} = "";
	}
	if( !$line->{fps} ){
		$line->{fps} = "";
	}
	if( !$line->{garbage} ){
		$line->{garbage} = "";
	}
	return $line->{datetime}."\t".
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

sub analyze {
	my $dir     = shift;
	my $top     = Log::Top->new("$dir/top.log", $\);
	my $meminfo = Log::Meminfo->new("$dir/meminfo.log");
	my $logcat  = Log::Logcat->new("$dir/logcat.log");
	my $shot    = Log::Shot->new("$dir/shot.log");
	my $startdatetime = $meminfo->{first_line}->{datetime};

	my $output = Output->new();

	my $currenttime = LogDate->new($startdatetime);
	open( RESULT, ">", "$dir/result.tsv" );
	print RESULT "time\tcpu usage\tpss native\tpss dalvik\tpss other\tpss total\tprivate native\tprivate dalvik\tprivate other\tprivate total\tfps\tgarbage\n";

	my $html = "<table id='result'>\n".
		"<tr><th>time</th><th>cpu usage</th><th>pss native</th><th>pss dalvik</th><th>pss other</th><th>pss total</th><th>private native</th><th>private dalvik</th><th>private other</th><th>private total</th><th>fps</th><th>garbage info</th></tr>\n";

	while( !$top->eof() || !$meminfo->eof() || !$logcat->eof() ){
		my $line = {
			datetime => $currenttime->{str}
		};
		if( !$top->eof() ){
			while( !$top->eof() && $top->{current_line}->{datetime} lt $currenttime->{str} ){
				$top->read_line();
			}
			if( !$top->eof() && $top->{current_line}->{datetime} eq $currenttime->{str} ){
				$line->{ top } = $top->{current_line};
				while( !$top->eof() && $top->{current_line}->{datetime} eq $currenttime->{str} ){
					$top->read_line();
				}
			}
		}
		if( !$meminfo->eof() ){
			while( !$meminfo->eof() && $meminfo->{current_line}->{datetime} lt $currenttime->{str} ){
				$meminfo->read_line();
			}
			if( !$meminfo->eof() && $meminfo->{current_line}->{datetime} eq $currenttime->{str} ){
				$line->{ meminfo } = $meminfo->{current_line};
				while( !$meminfo->eof() && $meminfo->{current_line}->{datetime} eq $currenttime->{str} ){
					$meminfo->read_line();
				}
			}
		}
		$line->{ shot } = "";
		if( !$shot->eof() ){
			warn $shot->{current_line}->{datetime};
			while( !$shot->eof() && $shot->{current_line}->{datetime} lt $currenttime->{str} ){
				$shot->read_line();
			}
			if( !$shot->eof() && $shot->{current_line}->{datetime} eq $currenttime->{str} ){
				$line->{ shot } = $shot->{filename};
				while( !$shot->eof() && $shot->{current_line}->{datetime} eq $currenttime->{str} ){
					$shot->read_line();
				}
			}
		}
		$line->{fps} = "";
		$line->{garbage} = "";
		if( !$logcat->eof() ){
			while( !$logcat->eof() && (
						!$logcat->{current_line}->{datetime} ||
						$logcat->{current_line}->{datetime} lt $currenttime->{str} ) ){
				$logcat->read_line();
			}
			if( !$logcat->eof() && $logcat->{current_line}->{datetime} eq $currenttime->{str} ){
				my @garbage = ();
				while( !$logcat->eof() && $logcat->{current_line}->{datetime} eq $currenttime->{str} ){
#					warn $logcat->{current_line};
					if( my $g =  $logcat->getgarbage_info() ){
						push(@garbage,$g);
					}
					if( my $fps = $logcat->get_fps() ){
						$line->{fps} = $fps;
					}
					$logcat->read_line();
				}
				if( $#garbage >= 0 ){
					$line->{garbage} = join(",", @garbage);
				}
			}
		}
		print RESULT $output->make_output($line);
		$html = $html . $output->make_output_html($line);
		$currenttime->next();
	}
	close( RESULT );
	$top->close();
	$meminfo->close();
	$logcat->close();
	return ( $startdatetime, $currenttime->{str}, $html );
}

sub analyze_exception_segv {
	my $dir       = shift;
	my $startdate = shift;
	my $logcat   = Log::Logcat->new("$dir/logcat.log");
	my $exception_count = 0;
	my $segv_count = 0;
	if( !$logcat->eof() ){
		while( !$logcat->eof() && (
					!$logcat->{current_line}->{datetime} ||
					$logcat->{current_line}->{datetime} lt $startdate ) ){
			$logcat->read_line();
		}
		while( !$logcat->eof() ){
			if( $logcat->{current_line}->{message} =~ /signal\s+11\s+\(SIGSEGV\)/ ){
				$segv_count++;
				open SG, ">", sprintf("$dir/sigsegv_%03d.txt",$segv_count);
				print SG $logcat->{current_line}->{line}."\n";
				$logcat->read_line();
				while( $logcat->{current_line}->{level} eq 'INFO' &&
					   $logcat->{current_line}->{tag} eq 'DEBUG' ) {
					print SG $logcat->{current_line}->{line}."\n";
					$logcat->read_line();
				}
				close(SG);
			}elsif( $logcat->{current_line}->{message} =~ /EXCEPTION\:/ ){
				$exception_count++;
				open EX,">", sprintf("$dir/exception_%03d.txt",$exception_count);
				print EX $logcat->{current_line}->{line}."\n";
				$logcat->read_line();
				while( $logcat->{current_line}->{message} =~ /property\:/ ||
					   $logcat->{current_line}->{message} =~ /at\s+/ ) {
					print EX $logcat->{current_line}->{line}."\n";
					$logcat->read_line();
				}
				close(EX);
			}
			$logcat->read_line();
		}
	}
	return ( $exception_count, $segv_count );
}


sub output_html {
	my ( $dir, $html, $start, $end, $exception, $segv ) = @_;
	open HTML, ">", $dir."/result.html";
	print HTML <<HEADER;
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
</head>
<body>
HEADER

	print HTML "<h1>".$start."-".$end."</h1>";
	print HTML $html;
	print HTML <<FOOTER;
</body>
</html>
FOOTER

 	close (HTML);
}

sub main {
	my $dir = make_directory_name();
	mkdir $dir or die "Cannot make directory :".$dir;
	my $logcat_pid = fork;
	if( !$logcat_pid ){
		exit(read_logcat($dir));
		return;
	}
	my $meminfo_pid = fork;
	if( !$meminfo_pid ){
		exit(read_meminfo($dir));
		return;
	}
	my $top_pid = fork;
	if( !$top_pid ){
		exit(read_top($dir));
		return;
	}
	my $shot_pid = fork;
	if( !$shot_pid ){
		exit(take_screen_shot($dir));
		return;
	}

 	print "Start logging. Please press \033[32mENTER\033[0m to stop...";
	my $key = <STDIN>;
	kill 'TERM', $logcat_pid;
	kill 'TERM', $meminfo_pid;
	kill 'TERM', $top_pid;
	kill 'TERM', $shot_pid;
	waitpid($logcat_pid,1);
	waitpid($meminfo_pid,1);
	waitpid($top_pid,1);
	waitpid($shot_pid,1);

	print "Analyzing CPU/Memory Usage...\n";
	sleep(2);
	my ( $startdate, $enddate, $html ) = analyze($dir);
	print "Analyzing Error Logs...\n";
	my ( $exception, $segv ) = analyze_exception_segv($dir, $startdate);
	print "\nCompleted\n";
	print "Analyzed $startdate - $enddate\n\n";
	if( $exception ){
		print "\033[31m$exception exception(s) found!\033[0m\n";
	}else{
		print "\033[32mNo exception found!\033[0m\n";
	}
	if( $segv ){
		print "\033[31m$segv sigsegv(s) found!\033[0m\n";
	}else{
		print "\033[32mNo sigsegv found!\033[0m\n";
	}

	output_html( $dir, $html, $startdate, $enddate, $exception, $segv );

	print "\nYou can check the result on ... \033[32m".$dir."/result.tsv\033[0m\n";
}

main();

__END__

=head1 NAME

android-profiler.pl - profiler for Android

=head1 SYNOPSIS

    android-profiler.pl [--help] [-t process]

=head1 DESCRIPTION

profiler for Android

=over 4

=item Analyze CPU & Memory Usage

run program, gathering perf infomations.
if you press enter, stop gathering perfs, and analyze gc event and memory usage report.

=item prints the output on error


=back

=head1 AUTHOR

L):O

=cut
