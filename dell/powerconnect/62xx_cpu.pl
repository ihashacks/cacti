#!/usr/bin/perl
#
# 62xx_cpu.pl
#
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
# 21.07.2010 Version 1.0   Initial write
#
#

use SNMP;
use Net::SNMP;

my $hostname='';
my $community='public';
my $port=161;
my $version='1';
my $domain='';
my $seconds=30;
my $username='';    
my $authkey='';     
my $authpasswd='';  
my $authprotocol='';
my $privkey='';     
my $privpasswd='';  
my $privprotocol=''; 
my $snmpTestoid = '.1.3.6.1.2.1.1.3.0';
my $snmpoid='.1.3.6.1.4.1.674.10895.5000.2.6132.1.1.1.1.4.4.0';

#
# Process arguments
#
if ($#ARGV <= 0) 
{
	&help;
	exit(0);
}
else
{
	until ($#ARGV < 0)
	{
		if ($ARGV[0] eq '-host' || $ARGV[0] eq '-H') {
		    if (!($ARGV[1]=~ m/^-.*/)) {
	    	    	shift;
		    	$hostname=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-community' || $ARGV[0] eq '-C') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$community=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-port') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
			$port=$ARGV[0];
			}
		}
		elsif ($ARGV[0] eq '-version') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$version=$ARGV[0];
			}
		}
		elsif ($ARGV[0] eq '-domain') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$domain=$ARGV[0];
			}
		}
		elsif ($ARGV[0] eq '-user') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$username=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-pass') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$authpasswd=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-authkey') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$authkey=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-authprotocol') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$authprotocol=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-privatekey') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$privkey=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-privatepassword') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$privpasswd=$ARGV[0];
			}
		} 
		elsif ($ARGV[0] eq '-privateprotocol') {
		    if (!($ARGV[1]=~ m/^-/)) {
			shift;
		    	$privprotocol=$ARGV[0];
			}
		}
		elsif ($ARGV[0] eq '-timeout') {
		    if (!($ARGV[1]=~ m/^-/)) {	
			shift;
		    	$seconds=$ARGV[0]/1000;
		   	if ($seconds < 1) { $seconds = 1; }
		    	if ($seconds > 60) { $seconds = 60; }
			}
		}
		elsif ($ARGV[0] eq '-h') {
		    &help;
		    exit(0);
		}
	   shift;
	}
}

# Setup connection to SNMP
my $session;
my $error;

if ($version eq '1' || $version eq '2c' || $version eq '2') 
{
	($session, $error) = Net::SNMP->session(
                           -hostname      => $hostname,
                           -port          => $port,
                           -nonblocking   => 1,
                           -version       => $version,
                           -timeout       => $seconds,
                           -community     => $community,
                        );
	die "session error: $error" unless ($session);
} 
else {
	($session, $error) = Net::SNMP->session(
                           -hostname      => $hostname,
                           -port          => $port,
                           -nonblocking   => 1,
                           -version       => $version,
                           -domain        => $domain,
                           -timeout       => $seconds,
                           -community     => $community,
                           -username      => $username,
                           -authkey       => $authkey,
                           -authpassword  => $authpasswd,
                           -authprotocol  => $authproto,
                           -privkey       => $privkey,
                           -privpassword  => $privpasswd,
                           -privprotocol  => $privproto,
                        );
	die "session error: $error" unless ($session);
}

#test if device is up
my $sysTest = $session->get_request(
	-varbindlist => [ $snmpTestoid ],
);
	
#	If device is up query it.

if (! defined $sysTest) {
	print "0";
} else {
	# Get Stat
	my $result = $session->get_request(
	 		-varbindlist =>  [ $snmpoid ],
	 		-callback    =>  \&get_callback
	 		);
	 		
       if (!defined $result) {
		printf "ERROR: Get request failed for host '%s': %s.\n",
			$session->hostname(), $session->error();
       }
}	

snmp_dispatcher();
exit(0);

sub get_callback
{
	my ($session) = @_;
	my $result = $session->var_bind_list();

	if (!defined $result) {
		printf "ERROR: Get request failed for host '%s': %s.\n",
			$session->hostname(), $session->error();
		return;
	}

	$res=$result->{$snmpoid};
	$res=~ s/\s+//g;
	$res=~ s/\(/:/g;
	$res=~ s/%\)//g;
	$res=~ s/\,/ /g;
	$res=~ s/\s+$//;
	print $res;
}

sub help() {
print <<EOF;
Usage: $0 -H hostname -C community -version [version] -counter [counter] [OPTIONS]


where
    -host|-H			SNMP Hostname
    -community|-C		SNMP Community (Default: public)
    -version			SNMP Version (Default v1)
    -port			SNMP port number (Default: 161)
    -domain			SNMP domain (no default)
    -user			SNMP Username
    -pass			SNMP Password
    -authkey			SNMP Authenication Key
    -authprotocol		SNMP Auth Protocol (e.g MD5)
    -privatekey			SNMP Private Key
    -privatepassword		SNMP Private Key Pass Phrase
    -privateprotocol		SNMP Privacy Protocol (e.g DES)
    -timeout			Number of seconds until timeout
    -h				This help screen

EOF
}
