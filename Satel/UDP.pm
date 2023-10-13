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

package Satel::UDP;

use Satel::Integra;
#use Satel::Exception;

@ISA = ("Satel::Integra");

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my(%params) = @_;
    my($self) = Satel::Integra->new(@_);
    $params{Proto}= 'udp';
    %{$self->{params}} = %params;
    bless ($self,$class);
    return $self;
}

sub connect
{
    my $self = shift;
## tu tez exception
    $self->{handle} = IO::Socket::INET->new(%{$self->{params}}) || die "can't connect: $!";
    $self->{handle}->autoflush(1);
}

sub disconnect
{
# jezeli istnieje i auto w destruktorze?
    my $self = shift;
    $self->{handle}->close();    
}

sub read
{
    my $self = shift;
    my $r;

    $self->{handle}->recv($r,1024);
    if(length($r) > 0)
    {
	$self->{peer_address} = $self->{handle}->peerhost();
	$self->{peer_port} = $self->{handle}->peerport();
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
#    print STDOUT "UDP z read=1 nie jest jeszcze supportowane po stronie forwardera!\n";
#    exit;
    $self->{handle}->send($command);
}
		


1;
 