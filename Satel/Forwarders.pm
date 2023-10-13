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