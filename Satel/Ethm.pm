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


package Satel::Ethm;

use Satel::Integra;
use Satel::EthmProxy;

#use Satel::Exception;

@ISA = ("Satel::Integra");

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my(%params) = @_;
    my($self) = Satel::Integra->new(@_);
    $self->{"Password"} = $params{"Password"};
    
    if($params{Proxy})
    {
        $self->{Proxy}=$params{Proxy};
    }
    else
    {
        $self->{Proxy} = Satel::EthmProxy->new();
    }
    $self->{Proxy}->{Password}=$self->{Password};
    
    %{$self->{params}} = @_;
    bless ($self,$class);
    return $self;
}

sub connect
{
    use Crypt::Rijndael;
    use Crypt::CBC;
    use IO::Socket;
    
    my $self = shift;
#    throw Satel::Exception::NoPassword unless $self->{Password};
#    throw Satel::Exception::NoPort unless $self->{Port};
    
    
    my $cipher0 = Crypt::Rijndael->new($self->{Password}.$self->{Password}, Crypt::Rijndael::MODE_CBC());
    my $empty = pack("C16", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00);
    my $iv = $cipher0->encrypt($empty);

    $self->{cipher}= Crypt::CBC->new( -key    => $self->{Password}.$self->{Password},
                               -cipher => 'Rijndael',
                               -header => 'none',
                               -iv => $iv,
                               -keysize => 24,
                               -literal_key => 1,
                            );
    my  $plaintext;
    my $nr;
    my $crypted;

## tu tez exception
    $self->{handle} = IO::Socket::INET->new(%{$self->{params}}) || die "can't connect: $!";
    $self->{handle}->autoflush(1);
    $self->{handle}->read($crypted, 16);

    $plaintext = $self->{cipher}->decrypt($crypted);
    $nr = substr($plaintext, 0, 1);

    if (! ( $plaintext =~ /[GD]_ETHM-1 v/))
    {	
	die "Zly pierwszy pakiet!!";
    }
    $ciphertext = $self->{cipher}->encrypt($nr.$self->ask_pkt());
    $self->{handle}->print(pack("L1",length($ciphertext)).$ciphertext);
    
    $self->{Proxy}->{header}=$plaintext;
    
    if($self->{Debug} == 1)
    {
	print STDOUT "conn OK\n";
    }
}

sub send_command
{
    my $self = shift;
    my $command = shift;

    my ($nr,$data) = $self->do_read();
    $self->send_ack($nr,$command);    
    $self->{Proxy}->send($nr.pack('H*',$data));
    $self->do_parse($data);
}

sub ask_pkt
{
    my $self = shift;
    my $ask_pkt = "475244ffffffffffffffffffffffff";
    return pack("H* ", $ask_pkt);
}

sub disconnect
{
# jezeli istnieje i auto w destruktorze?
    my $self = shift;
    $self->{handle}->close();
# czyscic tez cipher???    
}

sub send_ack
{
    my $self = shift;
    my $nr = shift;
    
    my $command = shift;
    my $ciphertext;

    if(length($command)>0)
    {
	my $komenda=pack("H*","475244");
	$komenda.=$command;
	while ( (length($komenda)+1) < 16 )
	{
	    $komenda.=chr(255);
	}
	
	if($self->{Debug} == 1)
	{
	    print "Sent command (nr ".ord($nr)."): ".unpack("H*",$nr.$komenda)."\n";
	}
    	$ciphertext = $self->{cipher}->encrypt($nr.$komenda);
    }
    elsif(length($self->{Proxy}->{to_send}) > 0)
    {
	my $komenda=pack("H*","475244").$self->{Proxy}->{to_send};
	print "wysylamy: ".unpack('H*',$nr.$komenda)."\n";
    	$ciphertext = $self->{cipher}->encrypt($nr.$komenda);    
	$self->{Proxy}->{to_send}="";
    }
    else
    {
	$ciphertext = $self->{cipher}->encrypt($nr.$self->ask_pkt());
    }
    $self->{handle}->print(pack("L1",length($ciphertext)).$ciphertext);
}

sub do_read
{
    my $self = shift;

    my $len;
    $self->{handle}->read($len, 4);
    $len = unpack("L1",$len);
    $self->{handle}->read($crypted, $len);

    my $plaintext  = $self->{cipher}->decrypt($crypted);
    my $nr = substr($plaintext, 0, 1);
    $data=unpack("H* ", substr($plaintext,1));
    
#    $self->{Proxy}->send($plaintext);
    
    return ($nr, $data,);
}

sub do_parse
{
    my $self = shift;
    my $data = shift;

    my $dzielnik = substr($data,0,2);
##print $data."\n\n";
## tutaj co trzeba zrobic jak ff jest w tresci albo ffff
## mozna by uzyc parse_string_new
    @packet= split(/$dzielnik$dzielnik/, substr($data,0,length($data)-2));
    foreach $item (@packet)
    {
        if(! ($item =~ /^$dzielnik/))
        {
	    $item=$dzielnik.$item;
	}
	$self->parse_packet(pack("H* ",$item));
    }

}

sub read
{
    my $self = shift;
    my ($nr,$data) = $self->do_read();
    $self->send_ack($nr);    
    $self->{Proxy}->send($nr.pack('H*',$data));
    $self->do_parse($data);
}

1;