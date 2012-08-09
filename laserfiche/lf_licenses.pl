#!/usr/bin/perl 

###############################################################################
#   License
################################################################################
#
#   Copyright (c) 2012 Brandon Pierce <brandon@ihashacks.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

$CHKNTPATH="/usr/lib/nagios/plugins";

# Full Licenses LaserFiche sessions
$license_full = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\Laserfiche Server\\Full Licenses"`; 
chomp $license_full; 

# Retrieval Licenses LaserFiche sessions
$license_retreival = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\Laserfiche Server\\Retrieval Licenses"`; 
chomp $license_retreival; 

print "license_full:"		. $license_full . 
	" license_retreival:"	. $license_retreival . 
	"\n";
