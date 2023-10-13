package Satel::Integra;

use Satel::DB;
use Satel::Forwarders;
$|=1;

my @typy = [];
$typy[0]="violation";
$typy[1]="violation";
$typy[2]="tamper";
$typy[3]="tamper";
$typy[4]="alarm";
$typy[5]="alarm";
$typy[6]="tamper_alarm";
$typy[7]="tamper_alarm";
$typy[8]="alarm_memory";
$typy[9]="alarm_memory";
$typy[10]="tamper_alarm_memory";
$typy[11]="tamper_alarm_memory";
$typy[12]="bypasses";
$typy[13]="bypasses";
$typy[14]="no_violation";
$typy[15]="no_violation";
$typy[16]="long_violation";
$typy[17]="long_violation";


sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my(%params) = @_;
    my $self  = {};
    $self->{Code} = $params{Code};
    $self->{Debug} = $params{Debug};
    if($params{DB})
    {
	$self->{DB}=$params{DB};
    }
    else
    {
	$self->{DB} = Satel::DB->new();
    }

    if($params{Forwarders})
    {
	$self->{Forwarders}=$params{Forwarders};
    }
    else
    {
	$self->{Forwarders} = Satel::Forwarders->new();
    }

    $self->{DB}->{Parent}=$self;
    for($i=0; $i < scalar(@typy);$i+=2)
    {
	@{$self->{$typy[$i]}}=('?') x 129;
    }
    @{$self->{outs}}=('?') x 129;
    # typ integry z automatu     
    bless ($self, $class);
    return $self;
}

sub crc_check()
{
    my $self = shift;
    my $pakiet = shift;

    if($self->crc(substr($pakiet,0,length($pakiet)-1)) ne  substr($pakiet,length($pakiet)-1,1) )
    {
	if($self->{Debug} == 1)
	{
	    $a=unpack("H*",$pakiet);
	    print "$a - BAD CRC\n";
	}
            return 0;
    }
    else
    {
        return 1;
    }
}

sub outs_do
{
    my $self = shift;
    my $cmd = shift;
    my @to_od = @_;
    my @outs = ('0') x 128;
    foreach $nr (@to_od)
    {
	$outs[$nr-1]=1;	
    }
    $outs=join('',@outs);

#sprawdzic czy to na pewno ok
    $outs=pack("b128",$outs);

    my $komenda = $cmd.$self->code1().$outs;
    $komenda.=$self->pack_xor($komenda);
    $komenda.=$self->crc($komenda);
    $komenda=chr(hex("FF")).chr(hex("FF")).$komenda.chr(hex("FF")).chr(hex("AA"));								

#print unpack("H*",$cmd)." ".unpack("H16",$outs)." - ".length($outs)."\n".unpack("H*",$komenda)."\n";

    $self->send_command($komenda);
}

sub code1
{
    my $self = shift;
    $code=substr($self->{Code}."AAAAAAAAAAAAAAAA",0,16);
    $code =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;
    return $code;
}

sub outs_on
{
    my $self = shift;
    my @to_on = @_;
    $self->outs_do("\x75",@to_on);
    
}

sub outs_off
{
    my $self = shift;
    my @to_on = @_;
    $self->outs_do("\x76",@to_on);
    
}


sub pack_xor()
{
    my $self = shift;

    my $xor=0;
    for($i=0;$i<(length($_[0]));$i++)
    {
        $xor^=ord(substr($_[0],$i,1));
    }
    return chr($xor);
}

sub crc()
{
    my $self = shift;

    my $suma=0;
    for($i=0;$i<(length($_[0]));$i++)
    {
        $suma= ($suma+ord(substr($_[0],$i,1)))%256;
    }
    return chr($suma);
}

sub parse_packet()
{
    my $self = shift;
    my $pakiet= shift;

    if(! $self->crc_check($pakiet))  { return; }
    $self->{Forwarders}->send($pakiet);
    
    if(substr($pakiet,1,1) =~ /\x1a/ && length($pakiet)==10)
    {
	$pak=unpack("H*",$pakiet);
	if($self->{Debug} == 1)
	{
	    print STDOUT  "czas: ".substr($pak,8,2).":".substr($pak,6,2).":".substr($pak,4,2)." ".substr($pak,10,2).".".
		substr($pak,12,2).".20".substr($pak,14,2)."\n";
	}
	$self->{time} = substr($pak,8,2).":".substr($pak,6,2).":".substr($pak,4,2)." ".substr($pak,10,2).".".
		substr($pak,12,2).".20".substr($pak,14,2);
    }    
    elsif(substr($pakiet,1,1) =~ /\x55/)
    {
	if($self->{Debug} == 1)	{$self->debug_outs_old($pakiet)}

	@{$self->{outs}} = split(//,"0".unpack("b128*",substr($pakiet,2,length(substr($pakiet,2))-1)));
	$self->outs_updated();	
    }
    elsif(substr($pakiet,1,1) =~ /\x1c/)
    {
        if(ord(substr($pakiet,2,1)) ==1)
        {
	    ## tu brakuje
	    if($self->{Debug} == 1)
	    {
        	print STDOUT  "drzwi\n";
	    }
            return;
        }

	if($self->{Debug} == 1)  {$self->debug_outs_new($pakiet)}
	
	@{$self->{outs}} = split(//,"0".unpack("b128*",substr($pakiet,3,length(substr($pakiet,3))-1)));
	$self->outs_updated();
    }    
    elsif(substr($pakiet,1,1) =~ /[\x00-\x11]/)
    {
	$ins=ord(substr($pakiet,1,1))%2+1;
	if(length($pakiet)==8){ $ins=$ins+2; }
        $typ=$typy[ord(substr($pakiet,1,1))];

	if($self->{Debug} == 1)  {$self->debug_ins($pakiet)}

	### teraz zapisuje sie calosc dla synchronizacji przez ins_updated
	###$self->{DB}->save_ins_part( in => $ins, typ => $typ, bin_ins => substr($pakiet,2,4));
	splice (@{$self->{$typ}},1+32*($ins-1),32,split(//,unpack("b32*",substr($pakiet,2,4))));
	$self->ins_updated($typ);
    }
    elsif(substr($pakiet,1,1) =~ /[\x12-\x15]/)
    {
    	if($self->{Debug} == 1)
	{
    	    print "armed \n";
    	    print "hex:".unpack("H*",substr($pakiet,1,length($pakiet)-2))."\n";
	}
    }
    else
    {
# nieznany ty pakietu    
#	print unpack("H*",substr($pakiet,1,1))."  len:".(length($pakiet)-3)."\n";
    }

}

sub outs_updated
{
    my $self = shift;
    $self->{DB}->save_outs();
    $self->{DB}->load_outs();
}

sub ins_updated
{
    my $self = shift;
    my $typ = shift;
    $self->{DB}->save_ins($typ);
}


sub debug_outs_old
{
    my $self = shift;
    my $pakiet = shift;
# nie czyta tu ponad 64 i nie sprawdza dlugosci pakietu

    print "wyjscia starej integry\n";
    print unpack("H*",substr($pakiet,2,8))."\n";	
    
    for($i=0;$i<65;$i++)
    {
	print (($i%100-$i%10)/10);
    }
    print "\n";
    for($i=0;$i<65;$i++)
    {
	print $i%10;
    }
    print "\n";
    print "0".unpack("b128*",substr($pakiet,2,length(substr($pakiet,2))-1))."\n";
}

sub debug_outs_new
{
    my $self = shift;
    my $pakiet = shift;

# nie czyta tu ponad 64 i nie sprawdza dlugosci pakietu
    print STDOUT  "wyjscia nowe integry\n";

    print unpack("H*",substr($pakiet,3,8))."\n";
	
    for($i=0;$i<65;$i++)
    {
	print (($i%100-$i%10)/10);
    }
    print "\n";
    for($i=0;$i<65;$i++)
    {
    	print $i%10;
    }
    print "\n";
    print "0".unpack("b128*",substr($pakiet,3,8))."\n";
}


sub debug_ins
{
    my $self = shift;
    my $pakiet = shift;
    
    print STDOUT "dlugosc:".length($pakiet)." \n";
    print "wejscia $typ cz.$ins\n";
    print "hex:".unpack("H*",substr($pakiet,2,4))."\n";	

    for($i=($ins==1?0:32);$i<($ins==1?33:65);$i++)
    {
	print (($i%100-$i%10)/10);
    }
    print "\n";
    for($i=($ins==1?0:32);$i<($ins==1?33:65);$i++)
    {
	print $i%10;
    }
    print "\n";
    print "0".unpack("b32*",substr($pakiet,2,4))."\n";	
}

sub parse_string
{
    my $self = shift;
####
#### no nie jest chyba dobre - filtruje pakiety i nie wiadomo czy to dobrze dziala
####
#### czy to dziala jak przyjdzie pol pakietu??? - $self->{pakiet} i inne stanu w klase wpisac

    my $pakiet="";
    my $r1="\xff";
    my $r2="\xff";
    my $r = shift;
    my $ile=-1;
    my $ile2=-1;
    my $ff=0;

#print "odebrano:".length($r)."\n";
    for(my $i=0;$i<length($r);$i++)
    {
#	print "i: $i\n";
	$r1=substr($r,$i,1);
    
	if($r1 =~ /[\xff\xfe]/ && $ile==-1)
	{
	    $ff=1;
	    $pakiet=$r1;
	}
	elsif($ff==1 &&  ord($r1) < ord("\x1a") )
	{
	    $ile=4;
	    $ile2=5;
	    $ff=0;
	    $pakiet.=$r1;
	}
	elsif($ff==1 &&  ord($r1) == ord("\x1a") )
	{
	    $ile=4;
	    $ile2=7;
	    $ff=0;
	    $pakiet.=$r1;
	}
	elsif($ff==1 &&  ord($r1) == ord("\x55") )
	{
	    $ile=17;
	    $ile2=17;
	    $ff=0;
	    $pakiet.=$r1;
	}
	elsif($ff==1 &&  ord($r1) == ord("\x1c") )
	{
	    $ile=4;
	    $ile2=17;
	    $ff=0;
	    $pakiet.=$r1;
	}
	elsif($ile >= 0)
	{
	    $pakiet.=$r1;
	    if($ile == 0)
	    {
		#print_pack($pakiet);
		$ile=-1;
		if($self->crc_check($pakiet))
		{
		    $self->parse_packet($pakiet);
		}
		else
		{
		    if($ile2 > 0)
		    {
			$ile=$ile2-1;
			$ile2=0;
		    }
		    else
		    {
			$r=substr($pakiet,1).substr($r,$i+1);
			$i=0;
		    }
		}
	    }
	    else
	    {
		$ile--;
		$ile2--;
	    }
	}
	

    }
}

sub read_loop
{
    my $self = shift;
    my $limit = shift;
    my $i=0;
    
    while(!$limit ||  $i < $limit)
    {
        $self->read();
        $i++;
    }
}
					

1; 