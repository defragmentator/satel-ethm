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
 