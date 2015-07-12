#!/usr/bin/perl

# usage
#  curl -L ftp://ftp.apnic.net/pub/apnic/stats/apnic/delegated-apnic-latest | countryfilter.pl iptables KR,CN
# coutry code
#  http://www.iso.org/iso/prods-services/iso3166ma/02iso-3166-code-lists/country_names_and_code_elements
# apnic
#  ftp://ftp.apnic.net/pub/apnic/stats/apnic/delegated-apnic-latest
#  ftp://ftp.arin.net/pub/stats/arin/delegated-arin-latest

# Copyright (C) 2006-2007 Unregistered DNS
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

sub printrule {
	my $Address=$_[0];
	my $AddressCount=$_[1];
	my $FilterType=$_[2];

	my $SubnetMaskBin = sprintf "%b", scalar($AddressCount);
	my $SubnetMaskBinCnt = $SubnetMaskBin;
	$SubnetMaskBinCnt =~ s/1//g;
	my $SubnetBit = (32 - length($SubnetMaskBinCnt));

	# calc subnet mask
	my $SubnetMaskBit=(1 << 31);
	my $SubnetMaskVal=0;
	for($j=0;$j<$SubnetBit;$j++) {
		$SubnetMaskVal|=$SubnetMaskBit;
		$SubnetMaskBit>>=1;
	}
	my $SubnetMaskVal1=($SubnetMaskVal >> 24)&255;
	my $SubnetMaskVal2=($SubnetMaskVal >> 16)&255;
	my $SubnetMaskVal3=($SubnetMaskVal >> 8)&255;
	my $SubnetMaskVal4=$SubnetMaskVal&255;

	# write it
	if ($FilterType == 1) { # iptables
		print "\$IPTABLES -A \$FILTERNAME -s $Address/$SubnetBit -j \$TARGET\n";
	} elsif ($FilterType == 2) { # ipfw
		print "\$IPFW add \$RULENUM \$ACTION ip from $Address/$SubnetBit to any\n";
	} elsif ($FilterType == 3) { # windows
		print "routing ip add filter name=\"ローカル エリア接続\" filtertype=INPUT srcaddr=$Address srcmask=$SubnetMaskVal1.$SubnetMaskVal2.$SubnetMaskVal3.$SubnetMaskVal4 dstaddr=0.0.0.0 dstmask=0.0.0.0 proto=any\n";
	}
}

if ($#ARGV < 1) {
	print STDERR "Usage: countryfilter.pl (Filter Type) (Target Countries)\n";
	print STDERR "\n";
	print STDERR "(Filter Type): A filter name (\"iptables\" or \"ipfw\" or \"windows\").\n";
	print STDERR "(Target Countries): Target countries seperated with comma (ex. \"KR,CN,KP\").\n";
	exit;
}

$FilterTypeStr = lc(@ARGV[0]);
@TargetCountry = split(/\,/, @ARGV[1]);

if ($FilterTypeStr eq "iptables") {
	$FilterType=1;
} elsif ($FilterTypeStr eq "ipfw") {
	$FilterType=2;
} elsif ($FilterTypeStr eq "windows") {
	$FilterType=3;
} else {
	print STDERR "Error: Filter type must be either \"iptables\" or \"ipfw\" or \"windows\".\n";
	exit;
}

if ($FilterType != 3) { # not windows
	print "#!/bin/sh\n\n";
	$CommentChar = "#";
} else {
	$CommentChar = "#";
}

print "$CommentChar Country based filter from *NIC database.\n";
print "$CommentChar For APNIC, get from ftp://ftp.apnic.net/pub/apnic/stats/apnic/delegated-apnic-latest .\n";
print "$CommentChar Created: " . localtime(time) . "\n";
print "$CommentChar\n";
print "$CommentChar This filter detects access from contries;\n";
print "$CommentChar ";
for($i=0;$i<=$#TargetCountry;$i++) { print @TargetCountry[$i] . " "; }
print "\n\n";

print "$CommentChar variables. change these values before run.\n";
if ($FilterType == 1) { # iptables
	print "IPTABLES=/usr/sbin/iptables\n";
	print "FILTERNAME=CKFILTER\n";
	print "TARGET=CKFILTERED\n";
} elsif ($FilterType == 2) { # ipfw
	print "IPFW=/usr/bin/ipfw\n";
	print "RULENUM=10000\n";
	print "ACTION=deny\n";
} elsif ($FilterType == 3) { # windows
	print "$CommentChar Nothing. sorry...\n";
	print "\n";
	print "offline\n";
}

print "\n";

while (<STDIN>) {
	@TextArray = split(/\|/, $_);

	# parse only ipv4, ipv6
	if (lc(@TextArray[2]) eq "ipv4") {
		# check country
		$found=0;
		for($i=0;$i<=$#TargetCountry;$i++) {
			if (lc(@TextArray[1]) eq lc(@TargetCountry[$i])) {
				# check whether number of addresses is CIDR-ready or not.
				$SubnetMaskBin = sprintf "%b", scalar(@TextArray[4]);
				$SubnetMaskBinCnt = $SubnetMaskBin;
				$SubnetMaskBinCnt =~ s/0//g;

				if (length($SubnetMaskBinCnt) > 1) {
					print "$CommentChar Notice: @TextArray[3]/\#@TextArray[4] ($SubnetMaskBin) is not CIDR-ready number; splitted.\n";
				}

				@AddressArray = split(/\./, @TextArray[3]);
				if ($#AddressArray < 3) {
					print "$CommentChar Error: \"@TextArray[3]\" should have 4 fields.\n";
					last;
				}
				$AddressValue = scalar(@AddressArray[0]) << 24;
				$AddressValue |= scalar(@AddressArray[1]) << 16;
				$AddressValue |= scalar(@AddressArray[2]) << 8;
				$AddressValue |= scalar(@AddressArray[3]);

				for ($i=0;$i<length($SubnetMaskBin);$i++) {
					if (substr($SubnetMaskBin, $i, 1) eq "1") {
						$AddressCount = 2 ** (length($SubnetMaskBin) - $i - 1);

						if (($AddressValue & ($AddressCount - 1)) > 0) {
							$AddressStr = sprintf "%d.", ($AddressValue >> 24) & 255;
							$AddressStr .= sprintf "%d.", ($AddressValue >> 16) & 255;
							$AddressStr .= sprintf "%d.", ($AddressValue >> 8) & 255;
							$AddressStr .= sprintf "%d", $AddressValue & 255;

							print "$CommentChar Notice: $AddressStr/\#$AddressCount goes across the subnet boundary. splitted.\n";

							while ($AddressCount > 0) {
								$AddressCountSub = $AddressCount;

								while (($AddressValue & ($AddressCountSub - 1)) > 0) {
									$AddressCountSub /= 2;
								}

								$AddressStr = sprintf "%d.", ($AddressValue >> 24) & 255;
								$AddressStr .= sprintf "%d.", ($AddressValue >> 16) & 255;
								$AddressStr .= sprintf "%d.", ($AddressValue >> 8) & 255;
								$AddressStr .= sprintf "%d", $AddressValue & 255;

								printrule($AddressStr, $AddressCountSub, $FilterType);

								$AddressValue += $AddressCountSub;
								$AddressCount -= $AddressCountSub;
							}
						} else {
							$AddressStr = sprintf "%d.", ($AddressValue >> 24) & 255;
							$AddressStr .= sprintf "%d.", ($AddressValue >> 16) & 255;
							$AddressStr .= sprintf "%d.", ($AddressValue >> 8) & 255;
							$AddressStr .= sprintf "%d", $AddressValue & 255;
							$AddressCount = 2 ** (length($SubnetMaskBin) - $i - 1);

							printrule($AddressStr, $AddressCount, $FilterType);

							$AddressValue += $AddressCount;
						}
					}
				}

				last;
			}
		}
	} elsif (lc(@TextArray[3]) eq "ipv6") {
	} elsif (lc(@TextArray[0]) eq "2") {
		# database version
		print "$CommentChar Database version " . @TextArray[2] . "\n";
	}
}

if ($FilterType == 3) { # windows
	print "routing ip set filter name=\"ローカル エリア接続\" filtertype=INPUT action=FORWARD\n";
	print "commit\n";
}

