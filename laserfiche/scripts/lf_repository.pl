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

# Documents Created/sec
$repository_dcps = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\Laserfiche Repository($ARGV[1])\\Documents Created \/sec"`; 
chomp $repository_dcps; 

# Entries Created/sec
$repository_ecps = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\Laserfiche Repository($ARGV[1])\\Entries Created \/sec"`; 
chomp $repository_ecps; 

# Pages Created/sec
$repository_pcps = `$CHKNTPATH/check_nt -H $ARGV[0] -p 12489 -v COUNTER -l "\\Laserfiche Repository($ARGV[1])\\Pages Created \/sec"`; 
chomp $repository_pcps; 

print "repository_dcps:"	. $repository_dcps . 
	" repository_ecps:"		. $repository_ecps . 
	" repository_pcps:"		. $repository_pcps . 
	"\n";
