package Satel::Mysql;

@ISA = ("Satel::DB");
use DBI;

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my(%params) = @_;
    my($self) = Satel::DB->new(@_);
    $self->{DSN}= $params{DSN};
    $self->{User}= $params{User};
    $self->{Password}= $params{Password};
    $self->{Write}= $params{Write};
    $self->{Read}= $params{Read};
    bless ($self,$class);
    return $self;
# wspolne polacznie do bazy i laczenie ponowne jak padnie!
}

sub save_ins_part
{
## NIE UZYWANE !!!!
## w ten sposob nie m synchoronizacji kawalkow w mysql
    my $self = shift;
    my (%params) = @_;

    if($self->{Write}!=1) {return;}

## tu errory obsluzyc
    if ($dbh= DBI->connect($self->{DSN},$self->{User},$self->{Password}) ) {} else { print "Can't connect $DBI::errstr\n";};
    if ( $dane = $dbh->prepare("INSERT INTO ins".$params{in}." (ins".$params{in}.", typ".$params{in}.") VALUES(b'".unpack("b32*",$params{bin_ins})."','".$params{typ}."')")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    $dbh->disconnect();
}

sub save_ins
{
    my $self = shift;
    my $typ= shift;

    if($self->{Write}!=1) {return;}

    my @ins;
    push(@ins,substr(join('',@{$self->{Parent}->{$typ}},(0)x128),1,32));
    push(@ins,substr(join('',@{$self->{Parent}->{$typ}},(0)x128),33,32));
    push(@ins,substr(join('',@{$self->{Parent}->{$typ}},(0)x128),65,32));
    push(@ins,substr(join('',@{$self->{Parent}->{$typ}},(0)x128),97,32));
    
## tu errory obsluzyc
    if ($dbh= DBI->connect($self->{DSN},$self->{User},$self->{Password}) ) {} else { print "Can't connect $DBI::errstr\n";};    
    for($i=1;$i<5;$i++)
    {
	if( $ins[$i-1] ne "????????????????????????????????")
	{
	    if ( $dane = $dbh->prepare("INSERT INTO ins".$i." (ins".$i.", typ".$i.") VALUES(b'".$ins[$i-1]."','".$typ."')")) {} else { print "Can't connect $DBI::errstr\n";};    
	    $dane->execute();
	}
    }
    $dbh->disconnect();
}


sub load_outs
{
    my $self = shift;
    if($self->{Read}!=1) {return;}

    if ($dbh= DBI->connect($self->{DSN},$self->{User},$self->{Password}) ) {} else { print "Can't connect $DBI::errstr\n";};
    if ( $dane = $dbh->prepare("DELETE FROM ins1 WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    if ( $dane = $dbh->prepare("DELETE FROM ins2 WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    if ( $dane = $dbh->prepare("DELETE FROM ins3 WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    if ( $dane = $dbh->prepare("DELETE FROM ins4 WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    if ( $dane = $dbh->prepare("DELETE FROM outs WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    if ( $dane = $dbh->prepare("DELETE FROM outs_on WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    if ( $dane = $dbh->prepare("DELETE FROM outs_off WHERE DATE_ADD(data,INTERVAL 1 MINUTE) < now()")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();

    if ( $dane = $dbh->prepare("
		    SELECT CONCAT(REPEAT('0', 64-length(bin(outs1+0))),bin(outs1+0)  
			    , REPEAT('0', 64-length(bin(outs2+0))),bin(outs2+0)  ) as outs  FROM outs_on
			")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    $a=0;
    $b="";
    while ($wyn=$dane->fetchrow_arrayref)
    {
        $a=1;
        $b = $b|$wyn->[0];
    }
    if($a==1)
    {
        if ( $dane = $dbh->prepare("DELETE FROM outs_on")) {} else { print "Can't connect $DBI::errstr\n";};
        $dane->execute();

	print "on bity: $b ".length($b)."\n";
	@b = split('',$b);
	unshift(@b,'0');
	@b = grep {$b[$_] == 1} 0..$#b;
	
	if($self->{Debug}) {print "@b\n"; }
	
	$self->{Parent}->outs_on(@b);
    }

    if ( $dane = $dbh->prepare("
    		SELECT CONCAT(REPEAT('0', 64-length(bin(outs1+0))),bin(outs1+0)  
			    , REPEAT('0', 64-length(bin(outs2+0))),bin(outs2+0)  ) as outs  FROM outs_off
			")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();
    $a=0;
    $b="";
    while ($wyn=$dane->fetchrow_arrayref)
    {
        $a=1;
        $b = $b|$wyn->[0];
    }
    if($a==1)
    {
        if ( $dane = $dbh->prepare("DELETE FROM outs_off")) {} else { print "Can't connect $DBI::errstr\n";};
        $dane->execute();

	print "off bity: $b ".length($b)."\n";
	@b = split('',$b);
	unshift(@b,'0');
	@b = grep {$b[$_] == 1} 0..$#b;
	
	if($self->{Debug}) {print "@b\n"; }
	
	$self->{Parent}->outs_off(@b);
    }
    $dbh->disconnect();
}

sub save_outs
{
    my $self = shift;
    
    if($self->{Write}!=1) {return;}

    my $pierwsza=substr(join('',@{$self->{Parent}->{outs}},(0)x128),1,64);
    my $druga=substr(join('',@{$self->{Parent}->{outs}},(0)x128),65,64);

## tu errory obsluzyc
    if ($dbh= DBI->connect($self->{DSN},$self->{User},$self->{Password}) ) {} else { print "Can't connect $DBI::errstr\n";};
    if ( $dane = $dbh->prepare("INSERT INTO outs (outs1,outs2) VALUES(b'".$pierwsza."',b'".$druga."')")) {} else { print "Can't connect $DBI::errstr\n";};
    $dane->execute();

    $dbh->disconnect();
}

1;