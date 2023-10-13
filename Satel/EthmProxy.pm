package Satel::EthmProxy;

use IO::Socket::INET;

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    
    my(%params) = @_;
    
    print STDOUT "Wlaczanie proxy!!\n\n";
    $self->{header} = "AG_ETHM-1 v1.05B";
    $self->{to_send} = "";
    
    $self->{handle} = IO::Socket::INET->new(%params) || die "can't connect: $!";
    $self->{handle}->autoflush(1);
    $self->{handle}->blocking(0);
    
    bless ($self,$class);
    return $self;
}


sub cipher
{
    use Crypt::Rijndael;
    use Crypt::CBC;
    use IO::Socket;
    
    my $self = shift;
    
    my $cipher0 = Crypt::Rijndael->new($self->{Password}.$self->{Password}, Crypt::Rijndael::MODE_CBC());
    my $empty = pack("C16", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00);
    my $iv = $cipher0->encrypt($empty);

    return Crypt::CBC->new( -key    => $self->{Password}.$self->{Password},
                               -cipher => 'Rijndael',
                               -header => 'none',
                               -iv => $iv,
                               -keysize => 24,
                               -literal_key => 1,
                            );

#    $plaintext = $self->{cipher}->decrypt($crypted);
#    $ciphertext = $self->{cipher}->encrypt($nr.$self->ask_pkt());
#    $self->{handle}->print(pack("L1",length($ciphertext)).$ciphertext);    
}
sub send
{
    my $self = shift;
    my $packet = shift;

    my $ciphertext;
    my $plaintext;
    my $len;

    my $sock = $self->{handle}->accept();
    if(defined $sock)
    {
	push(@{$self->{conns}},$sock);
	my $cipher = $self->cipher();
	push(@{$self->{ciphers}},$cipher);
	
	$ciphertext = $cipher->encrypt($self->{header});
        $sock->print($ciphertext);    
	print "Podlaczyl sie ".@{$self->{conns}}[$i]->peerhost().":".@{$self->{conns}}[$i]->peerport()."\n";
    }
    
    for(my $i=0; $i<scalar(@{$self->{conns}});$i++)
    {
	if(defined @{$self->{conns}}[$i] && @{$self->{conns}}[$i]->connected())
	{
##	    print STDOUT "wysylanie do:".@{$self->{conns}}[$i]->peerhost().":".@{$self->{conns}}[$i]->peerport()."\n";
	    $ciphertext = @{$self->{ciphers}}[$i]->encrypt($packet);
	    @{$self->{conns}}[$i]->print(pack("L1",length($ciphertext)).$ciphertext);    

##	    print STDOUT "czytanie od:".@{$self->{conns}}[$i]->peerhost().":".@{$self->{conns}}[$i]->peerport()."\n";
## tu nie zawsze musi sie udac odczytac - co wtedy?	    
	    @{$self->{conns}}[$i]->read($len, 4);
    	    $len = unpack("L1",$len);
	    @{$self->{conns}}[$i]->read($crypted, $len);
	    $plaintext = @{$self->{ciphers}}[$i]->decrypt($crypted);
	    
	    if( unpack('H*',$plaintext) =~ /..475244ffffffffffffffffffffffff/) 
	    {
##		print STDOUT "Normlany ping\n";
	    }
	    else
	    {
##		print STDOUT  unpack('H*',$plaintext)."\n";
		unpack('H*',$plaintext) =~ /..475244(.*)$/;
		$self->{to_send} = pack('H*',$1);
##		print STDOUT unpack('H*',$self->{to_send})."\n";
	    }
	}
	else
	{
	    print STDOUT "Rozlaczono ";
	    if (defined @{$self->{conns}}[$i])
	    {
		print STDOUT @{$self->{conns}}[$i]->peerhost().":".@{$self->{conns}}[$i]->peerport()."\n";
	    }
	    else
	    {
		print STDOUT "\n";
	    }
	    delete @{$self->{conns}}[$i];
	    delete @{$self->{ciphers}}[$i];
	}
    }
}

sub add
{
    my $self = shift;
    my %params = @_;
## nie skonczone


}

sub nic
{
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

}

1;