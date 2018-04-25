#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use POSIX qw(strftime);
use XML::Simple;
use Data::Dumper;

# Distro -------------------------------------------------------------------
open (my $issue, "<", "/etc/issue");
my $distro;
while (<$issue>) {
  if (/^[^\s]/) {
    $distro = (split / /, ((split /\\/)[0]))[0];
    last;
   }
}
close $issue;

# Host ---------------------------------------------------------------------
my $host = `uname -n`;
chomp $host;

# OS -----------------------------------------------------------------------
my $os = `uname -o`;
chomp $os;

# Machine ------------------------------------------------------------------
my $machine = `uname -m`;
$machine =~ s/_/-/;
chomp $machine;

# Kernel -------------------------------------------------------------------
my $kernel = `uname -r`;
chomp $kernel;

# CPU -------------------------------------------------------------------
my $cpu = `cat /proc/cpuinfo | grep 'model name' | cut -f 2 -d':' | uniq`;
chomp $cpu;

# Service Manager -------------------------------------------------------------------
my $servman = `cat /proc/1/comm`;
chomp $servman;

# Adapter -------------------------------------------------------------------
my $adapter = `acpi -a | grep "Adapter" | cut -f 2 -d':'`;
chomp $adapter;

# Battery -------------------------------------------------------------------
my $battery = `acpi -b | grep "Battery" | cut -f 2 -d':'`;
chomp $battery;

# Brightness -------------------------------------------------------------------
my $abrightness = `cat /sys/class/backlight/intel_backlight/actual_brightness`;
chomp $abrightness;

my $mbrightness = `cat /sys/class/backlight/intel_backlight/max_brightness`;
chomp $mbrightness;

my $brightness = int($abrightness/$mbrightness * 100);

#my $brightness = `cat /sys/class/backlight/nv_backlight/brightness`;
chomp $brightness;

# Load ---------------------------------------------------------------------
#my $load = (split ' ', (split ':', `uptime`)[4])[0];
#chomp $load;

# Memory -----------------------------------------------------------------------
my $memory = `free -m | sed -n '2,2p' | tr -s '[:blank:]''' | cut -f 7 -d' '`;
chomp $memory;

# Swap -----------------------------------------------------------------------
my $swap = `free -m | sed -n '3,3p' | tr -s '[:blank:]''' | cut -f 4 -d' '`;
chomp $swap;

# Swappiness --------------------------------------------------------------------
my $swappiness = `cat /proc/sys/vm/swappiness`;
chomp $swappiness;

# Memory (active) ------------------------------------------------------------
open (my $meminfo, "<", "/proc/meminfo");
my $mem_act;
while (<$meminfo>) {
  chomp;
  if (/^Active:/) {
    $mem_act = int(((split)[-2])/1024);
    last;
  }
}
close $meminfo;

# Openbox theme ------------------------------------------------------------
my $file = "$ENV{HOME}/.config/openbox/rc.xml";
my $xs1 = XML::Simple->new();
my $doc = $xs1->XMLin($file);
my $obtheme = $doc->{theme}->{'name'};

# Resolution-------------------------------------------------------------
my $resolution = `xrandr | grep "current" | cut -d ',' -f 2,3`;
chomp $resolution;

# Thermal -------------------------------------------------------------------
my $thermal = `acpi -t | grep "Thermal" | cut -d ' ' -f 3,4,9,10,15,16,21,22,27,28 | cut -d '.' -f 1,3,5,7,9`;
chop $thermal;

# Time ---------------------------------------------------------------------
my $time_date = strftime "%D, %R", localtime;

# Uptime -------------------------------------------------------------------
my $uptime = (split ' ', `uptime`)[0];

# WiFi Interface -------------------------------------------------------------------
my $wif = (split ' ', `nmcli device status | grep "wifi"`)[0];
chomp $wif;

# WiFi SSID -------------------------------------------------------------------
my $wssid = (split ' ', `nmcli device status | grep "wifi"`)[3];
chomp $wssid;

# WiFi Status -------------------------------------------------------------------
my $wstat = (split ' ', `nmcli device status | grep "wifi"`)[2];
chomp $wstat;

# WiFi Performance-------------------------------------------------------------------
my $wifiperf = `nmcli dev wifi | grep $wssid | grep "Mbit/s" | tr -s '[:blank:]''' | cut -d ' ' -f 3-9`;
chomp $wifiperf;

# WiFi Inet -------------------------------------------------------------------
my $inet = (split ' ', `ifconfig -a | grep "inet " | grep -v 127 | cut -d ' ' -f 1-14`)[2];
chomp $inet;

# WiFi Inet6 -------------------------------------------------------------------
my $inet6 = (split ' ', `ifconfig -a | grep "inet6" | grep -v "::1" | cut -d ' ' -f 1-14`)[2];
chomp $inet6;

# Wired Interface -------------------------------------------------------------------
my $wirif = (split ' ', `nmcli device status | grep "ethernet"`)[0];
chomp $wirif;

# Wired Status -------------------------------------------------------------------
my $wirstat = (split ' ', `nmcli device status | grep "ethernet"`)[2];
chomp $wirstat;

# Writing the pipemenu -----------------------------------------------------
#    . "<item label=\"+        $ENV{USER}\@$host        +\" />\n"
#    . "<separator />"
#    . "<separator />"
#    . "<item label=\"+        $time_date       +\" />\n"
#    . "<item label=\"Load: $load \" />\n"
 
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    . "<openbox_pipe_menu>\n"
    . "<item label=\"Host: $host \" />\n"
    . "<item label=\"OS: $distro $os $machine \" />\n"
    . "<item label=\"Kernel: $kernel \" />\n"
    . "<item label=\"CPU: $cpu \" />\n"
    . "<item label=\"Gernciador de Serviços: $servman \" />\n"
    . "<separator />"
    . "<item label=\"Adaptador: $adapter \" />\n"
    . "<item label=\"Bateria: $battery \" />\n"
    . "<item label=\"Brilho: $brightness% \" />\n"
    . "<item label=\"Memoria Usada: $mem_act MB\" />\n"
    . "<item label=\"Memoria Disp.: $memory MB\" />\n"
    . "<item label=\"Resolução: $resolution \" />\n"
    . "<item label=\"Swap Livre: $swap - $swappiness% \" />\n"
    . "<item label=\"Tema OB: $obtheme \" />\n"
    . "<item label=\"Temp.: $thermal \" />\n"
    . "<item label=\"Uptime: $uptime \" />\n"
    . "<item label=\"IPv4: $inet \" />\n"
    . "<item label=\"IPv6: $inet6 \" />\n"
    . "<item label=\"WiFi \" />\n"
    . "<item label=\"Interface: $wif \" />\n"
    . "<item label=\"SSID: $wssid \" />\n"
    . "<item label=\"Status: $wstat \" />\n"
    . "<item label=\"Perf.: $wifiperf \" />\n"
    . "<item label=\"Cabo \" />\n"
    . "<item label=\"Interface: $wirif \" />\n"
    . "<item label=\"Status: $wirstat \" />\n"
    . "</openbox_pipe_menu>\n";
