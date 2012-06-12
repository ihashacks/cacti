#!/usr/bin/perl
###########
# Sonicwall VPN Traffic Script
# Created by Ken Nerhood
# 
# based on the lan2lantraffic.pl script by Dan Brummer
#
# This script (index) will walk the IPSec VPN tunnels of a Sonicwall firewall
# and return the Decrypted (RX) / Encrypted (TX) Octets and tunnel name
# for all active tunnels.
#
# Usage:
#   query_sonicwall_vpn.pl host community index
#   query_sonicwall_vpn.pl host community query {peergateway, vpnname, decryptbytes, encryptbytes}
#   query_sonicwall_vpn.pl host community get {peergateway, vpnname, decryptbytes, encryptbytes} DEVICE
#
#    DEVICE is the IP address of the PeerGateway of the tunnel you want
###########

use Net::SNMP;

# Set variables based on input parameters
$host           = $ARGV[0];
$community 	= $ARGV[1];
$func		= $ARGV[2];

# Set OID variables
#$sonicSAStatPeerGateway		= "1.3.6.1.4.1.8741.1.3.2.1.1.1.2.";
#$sonicSAStatDecryptByteCount 	= "1.3.6.1.4.1.8741.1.3.2.1.1.1.11.";
#$sonicSAStatEncryptByteCount 	= "1.3.6.1.4.1.8741.1.3.2.1.1.1.9.";
#$sonicSAStatUserName		= "1.3.6.1.4.1.8741.1.3.2.1.1.1.14.";

$sonicSAStatPeerGateway = "1.3.6.1.4.1.8741.1.3.2.1.1.1.2";
$sonicSAStatDecryptByteCount = "1.3.6.1.4.1.8741.1.3.2.1.1.1.11";
$sonicSAStatEncryptByteCount = "1.3.6.1.4.1.8741.1.3.2.1.1.1.9";
$sonicSAStatUserName = "1.3.6.1.4.1.8741.1.3.2.1.1.1.14";


# Check variables to make sure data is there
if(!$community||!$host){
	print "Usage:\n\n";
	print "query_sonicwall_vpn.pl host community index\n";
        print "query_sonicwall_vpn.pl host community query {peergateway, vpnname, decryptbytes, encryptbytes}\n";
        print "query_sonicwall_vpn.pl host community get {peergateway, vpnname, decryptbytes, encryptbytes} DEVICE\n\n";
	print "   where DEVICE is the IP address of the PeerGateway of the tunnel you want\n";
	exit;
}

# Create SNMP Session

($session, $error) = Net::SNMP->session(-hostname=>$host,-community=>$community,-port=>161);
die "session error: $error" unless ($session);

# Walk sonicSAStatPeerGateway for list of active session OIDs

%result = $session->get_table($sonicSAStatPeerGateway);
die "request error: ".$session->error unless (defined %result);

# Grab the oids and stick it into an array (ghetto)
@indexoids = $session->var_bind_names;

# Loop through the oid array and make a seperate request to get the data (even more ghetto)
foreach $oid (@indexoids){

	# Split the full OID to get the index
	@splits = split($sonicSAStatPeerGateway,$oid);

	# Set index var
	$dataindex = @splits[1];

	# Grab a hash of the IP address from the OID
	$getdata = $session->get_request($oid);

	# Take the oid index and the returned value and create a hash
	# This is your datatable with index => ipaddress
	$datatable{$dataindex} = $getdata->{$oid};

}

# Search datatable for session ip parameter

if ($func eq "index") {
	foreach $key (sort keys (%datatable)){
		print "$datatable{$key}\n";
	}
} elsif ($func eq "test") {

	foreach $key (sort keys (%datatable)){
	#print "$key => $datatable{$key}\n";

		$recdata = $session->get_request($sonicSAStatDecryptByteCount.$key);
		$receive = $recdata->{$sonicSAStatDecryptByteCount.$key};
		$sentdata = $session->get_request($sonicSAStatEncryptByteCount.$key);
		$sent = $sentdata->{$sonicSAStatEncryptByteCount.$key};
		$namedata = $session->get_request($sonicSAStatUserName.$key);
		$name = $namedata->{$sonicSAStatUserName.$key};
		print "$datatable{$key}!$name!$receive!$sent\n";
	}
} elsif ($func eq "query") {
	foreach $key (sort keys (%datatable)){
                $recdata = $session->get_request($sonicSAStatDecryptByteCount.$key);
                $receive = $recdata->{$sonicSAStatDecryptByteCount.$key};
                $sentdata = $session->get_request($sonicSAStatEncryptByteCount.$key);
                $sent = $sentdata->{$sonicSAStatEncryptByteCount.$key};
                $namedata = $session->get_request($sonicSAStatUserName.$key);
                $name = $namedata->{$sonicSAStatUserName.$key};
		my %output = (
			peergateway => $datatable{$key},
			vpnname => $name,
			decryptbytes => $receive,
			encryptbytes => $sent
		);
		print "$output{peergateway}:$output{$ARGV[3]}\n";
	}
} elsif ($func eq "get") {
        foreach $key (sort keys (%datatable)){
		if ($datatable{$key} eq $ARGV[4]) {
			$recdata = $session->get_request($sonicSAStatDecryptByteCount.$key);
			$receive = $recdata->{$sonicSAStatDecryptByteCount.$key};
			$sentdata = $session->get_request($sonicSAStatEncryptByteCount.$key);
			$sent = $sentdata->{$sonicSAStatEncryptByteCount.$key};
			$namedata = $session->get_request($sonicSAStatUserName.$key);
			$name = $namedata->{$sonicSAStatUserName.$key};
			my %output = (
                        	peergateway => $datatable{$key},
                        	vpnname => $name,
                        	decryptbytes => $receive,
                        	encryptbytes => $sent
                	);
                print "$output{$ARGV[3]}";
		}

	}
}

# Close SNMP session

$session->close;

