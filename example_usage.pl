#!/usr/bin/perl

#use Satel::Ethm;
#use Satel::UDP;
use Satel::Mysql;
use Satel::Serial;

my $debug =1;
my $debug_mysql =0;

my $mysql = Satel::Mysql->new(Debug => $debug_mysql, DSN => "DBI:mysql:DATABASE:MYSQL_HOST", User => "MYSQL_USER", Password => "MYSQL_PASSWORD", Write=>0, Read=>1);

#my $a = Satel::Ethm->new( PeerAddr => "ETHM_HOST", Code=>SATEL_CODE_PASSWORD, Password=>'ETHM_PASSWORD', PeerPort=>9091, Debug=> $debug, DB => $mysql  );
#my $a = Satel::Ethm->new( PeerAddr => "ETHM_HOST", Code=>SATEL_CODE_PASSWORD, Password=>'ETHM_PASSWORD', PeerPort=>9091, Debug=> $debug, DB => $mysql );
#my $a = Satel::UDP->new( LocalAddr => "SERIAL2UDP_IP_FORWARDER", Code=>SATEL_CODE_PASSWORD, LocalPort=>5000, Debug=> $debug, DB => $mysql );
my $a = Satel::Serial->new( Code=>SATEL_CODE_PASSWORD, Port=> "/dev/ttyS3", Debug=> $debug, DB => $mysql,
			    Forwarders => Satel::Forwarders->new({PeerAddr   => 'FORWARDER_IP:5000'}));
$a->connect();
#$a->read();
$a->read_loop();

$a->disconnect();
exit;
