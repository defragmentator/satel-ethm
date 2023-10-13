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

package Satel::Serial;

use Satel::Integra;
#use Satel::Exception;
use Device::SerialPort;

@ISA = ("Satel::Integra");

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my(%params) = @_;
    my($self) = Satel::Integra->new(@_);
    $self->{"Port"} = $params{"Port"};
     %{$self->{params}} = @_;
    bless ($self,$class);
    return $self;
}

## to wlasciwie w RS i send
sub parse_packet
{
    my $self = shift;
    my $packet = shift;
    ##np wyslanie do UDP
    $self->Satel::Integra::parse_packet($packet);
}
		

sub connect
{
    my $self = shift;
    
## tu tez exception
    $self->{serial} = Device::SerialPort->new ($self->{"Port"}) || die;
    $self->{serial}->baudrate(4800);
    $self->{serial}->parity("none");
    $self->{serial}->databits(8);
    $self->{serial}->stopbits(1);
    $self->{serial}->handshake('none');
    $self->{serial}->read_const_time(10);
    $self->{serial}->read_char_time(0);

    if($self->{Debug} == 1)
    {
	print "B = ".$self->{serial}->baudrate.", D = ".$self->{serial}->databits.", S = ".
	    $self->{serial}->stopbits.", P = ".$self->{serial}->parity.", H = ".$self->{serial}->handshake."\n";
    }
	    
#	    $self->{handle}  = new IO::Socket::INET (
#	    PeerAddr   => 'IP:5000',
#	    #PeerAddr   => 'IP:5000',
#	    Proto        => 'udp'
#	    ) or die "ERROR in Socket Creation : $!\n";
}

sub disconnect
{
# jezeli istnieje i auto w destruktorze?
    my $self = shift;
    $self->{serial}->close();
}

sub read
{
    my $self = shift;
    my ($count, $r) = $self->{serial}->read(255);
    if($count > 0)
    {
	$self->parse_string_new($r);
    }
}

sub send_command
{
    my $self = shift;
    my $command = shift;
    if($self->{Debug} == 1)
    {
        print "Sent command: ".unpack("H*",$command)."\n";
    }
    $self->{serial}->write($command);
    while(! $self->{serial}->write_drain){};

## to zeby jak kilka pod rzad po sobie wywolan
    sleep(1);
}

1;
