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


package Satel::Forwarders;

use IO::Socket::INET;

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    @{$self->{conns_param}} = @_;

#    print "polaczen:".scalar(@{$self->{conns_param}})."\n";

    for(my $i=0; $i<scalar(@{$self->{conns_param}});$i++)
    {
#	foreach $key (keys %{@{$self->{conns_param}}[$i]})
#	{
#	    print "\t$i $key = ".${@{$self->{conns_param}}[$i]}{$key}."\n";
#	}    
#	print "\n\n";
	
	${@{$self->{conns_param}}[$i]}{Proto}='udp';
	@{$self->{conns}}[$i] = IO::Socket::INET->new(%{@{$self->{conns_param}}[$i]}) || die "can't connect forwarder$i : $!";
	@{$self->{conns}}[$i]->autoflush(1);
    }
    bless ($self,$class);
    return $self;
}

sub send
{
    my $self = shift;
    my $packet = shift;
    my $command = "";
    
    for(my $i=0; $i<scalar(@{$self->{conns_param}});$i++)
    {
	#write
	@{$self->{conns}}[$i]->send($packet);

	#read
	my $r="";
	@{$self->{conns}}[$i]->recv($r,1024);
	if(length($r) > 0)
	{
	    #$self->{peer_address} = @{$self->{conns}}[$i]->peerhost();
	    #$self->{peer_port} = @{$self->{conns}}[$i]->peerport();
	    $command.=$r;
	}

    }
    $self->{Parent}->send_command($command);
}
						

sub add
{
    my $self = shift;
    my %params = @_;
## nie skonczone
}

1; 