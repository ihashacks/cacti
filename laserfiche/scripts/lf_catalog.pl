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

$CHKNTPATH="/usr/lib/nagios/plugins";

# Concurrent searches
$catalog_cs = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Concurrent searches"`; 
chomp $catalog_cs; 

# Documents indexed per second
$catalog_dips = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Documents indexed per second"`; 
chomp $catalog_dips; 

# Words indexed per second
$catalog_wips = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Words indexed per second"`; 
chomp $catalog_wips; 

# Documents in the catalog
$catalog_ditc = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Documents in the catalog"`; 
chomp $catalog_ditc; 

# Terms in the catalog
$catalog_titc = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Terms in the catalog"`; 
chomp $catalog_titc; 

# Time since last searched
$catalog_tsls = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Time since last searched"`; 
chomp $catalog_tsls; 

# Time since last indexed
$catalog_tsli = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Time since last indexed"`; 
chomp $catalog_tsli; 

# Pages indexed per second
$catalog_pips = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\LFFTS Catalog(_Total)\\Pages indexed per second"`; 
chomp $catalog_pips; 

print "catalog_cs:"		. $catalog_cs . 
	" catalog_dips:"	. $catalog_dips . 
	" catalog_wips:"	. $catalog_wips . 
	" catalog_ditc:"	. $catalog_ditc . 
	" catalog_titc:"	. $catalog_titc . 
	" catalog_tsls:"	. $catalog_tsls . 
	" catalog_tsli:"	. $catalog_tsli . 
	" catalog_pips:"	. $catalog_pips . 
	"\n";
