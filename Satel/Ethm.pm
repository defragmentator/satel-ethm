package Satel::Ethm;

use Satel::Integra;
#use Satel::Exception;

@ISA = ("Satel::Integra");

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my(%params) = @_;
    my($self) = Satel::Integra->new(@_);
    $self->{"Password"} = $params{"Password"};
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
    
    return ($nr, $data);
}

sub do_parse
{
    my $self = shift;
    my $data = shift;

    my $dzielnik = substr($data,0,2);

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
    $self->do_parse($data);
}

1;