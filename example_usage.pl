#!/usr/bin/perl
#BSD 3-Clause License
#
#Copyright (c) 2012, defragmentator
# Author: Marcin Ochab marcin.ochab@gmail.com github.com/defragmentator
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#
#1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
#2. Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
#3. Neither the name of the copyright holder nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
#FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
#DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
#SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
#CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



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
