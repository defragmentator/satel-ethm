package Satel::DB;

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = {};
    my(%params) = @_;
    $self->{Debug} = $params{Debug};

    if($self->{Debug})
    {
	print "Konstruktor DB\n";
    }

    bless ($self,$class);
    return $self;				
}

sub DESTROY
{
}

sub AUTOLOAD
{
    my $self = shift;
    my $type = ref($self);
    
    if($self->{Debug})
    {
	print "nie ma takiej funkcji: $AUTOLOAD !\n";
    }
}			       
1;