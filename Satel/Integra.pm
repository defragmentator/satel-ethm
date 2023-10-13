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


package Satel::Integra;

use Satel::DB;
use Satel::Forwarders;
$|=1;

#dl pakietu len +3 bajty (ff|fe + pocz_id + crc)
my @pakiety = ( ["\x00",4,'fun','violation 1..32'],
		["\x00",5,'fun','violation 65..96'],
		["\x01",4,'fun','violation 33..64'],
		["\x01",5,'fun','violation 97..128'],
		["\x02",4,'fun','tamper 1..32'],
		["\x02",5,'fun','tamper 65..96'],
		["\x03",4,'fun','tamper 33..64'],
		["\x03",5,'fun','tamper 97..128'],
		["\x04",4,'fun','alarm 1..32'],
		["\x04",5,'fun','alarm 65..96'],
		["\x05",4,'fun','alarm 33..64'],
		["\x05",5,'fun','alarm 97..128'],
		["\x06",4,'fun','tamper alarm 1..32'],
		["\x06",5,'fun','tamper alarm 65..96'],
		["\x07",4,'fun','tamper alarm 33..64'],
		["\x07",5,'fun','tamper alarm 97..128'],
		["\x08",4,'fun','alarm memory 1..32'],
		["\x08",5,'fun','alarm memory 65..96'],
		["\x09",4,'fun','alarm memory 33..64'],
		["\x09",5,'fun','alarm memory 97..128'],
		["\x0A",4,'fun','tamper alarm memory 1..32'],
		["\x0A",5,'fun','tamper alarm memory 65..96'],
		["\x0B",4,'fun','tamper alarm memory 33..64'],
		["\x0B",5,'fun','tamper alarm memory 97..128'],
		["\x0C",4,'fun','bypasses 1..32'],
		["\x0C",5,'fun','bypasses 65..96'],
		["\x0D",4,'fun','bypasses 33..64'],
		["\x0D",5,'fun','bypasses 97..128'],
		["\x0E",4,'fun','no violation trouble 1..32'],
		["\x0E",5,'fun','no violation trouble 65..96'],
		["\x0F",4,'fun','no violation trouble 33..64'],
		["\x0F",5,'fun','no violation trouble 97..128'],
		["\x10",4,'fun','long violation trouble 1..32'],
		["\x10",5,'fun','long violation trouble 65..96'],
		["\x11",4,'fun','long violation trouble 33..64'],
		["\x11",5,'fun','long violation trouble 97..128'],
		["\x12",4,'fun','armed partitions (with suppressed status)'],
		["\x12",5,'fun','really armed partitions (without suppressed status)'],
		["\x13",4,'fun','partitions with entry time'],
		["\x13",5,'fun','partitions temporary blocked'],
		["\x14",4,'fun','partitions with exit time >10sec.'],
		["\x14",5,'fun','partitions blocked for guard round'],
		["\x15",4,'fun','partitions with exit time <10sec.'],
		["\x15",5,'fun','partitions with arming mode 2'],
		["\x16",4,'fun','partitions with alarm'],
		["\x16",5,'fun','partitions with arming mode 3'],
		["\x17",4,'fun','partitions with fire alarm'],
		["\x18",4,'fun','partitions with alarm memory'],
		["\x18",5,'fun','partitions with verified alarm memory'],
		["\x19",4,'fun','partitions with fire alarm memory'],
		["\x1A",4,'fun','partitions with 1st code entered'],
		["\x1A",7,'fun','date and time'],
		["\x1C",4,'fun','outputs state in INTEGRA 24'],
		["\x1C",5,'fun','outputs state in INTEGRA 32'],
		["\x1C",9,'fun','outputs state in INTEGRA 64 / opened and long opened doors - INTEGRA 24, 32 and 128-WRL'],
		["\x1C",17,'fun','outputs state in INTEGRA 128 and 128-WRL / opened and long opened doors - INTEGRA 64 and 128'],		
		["\x54",48,'fun','troubles'],
		["\x55",17,'fun','output state (old Integra)'],
## brak dlugosci!!
		["\x56",36,'fun','event record'],
		["\x57",27,'fun','troubles'],
		["\x58",57,'fun','troubles (old Integra)'],
		["\x58",61,'fun','troubles'],
		["\x59",30,'fun','troubles'],
		["\x5A",48,'fun','troubles'],
		["\x5B",27,'fun','troubles (old Integra)'],
		["\x5B",40,'fun','troubles'],
		["\x5C",57,'fun','troubles (old Integra)'],
		["\x5C",61,'fun','troubles'],
		["\x5D",30,'fun','troubles'],
		["\x5E",49,'fun','troubles'],
		["\x5F",32,'fun','troubles'],
## brak dlugosci!!
		["\xFD",21,'fun','system names'],
		);

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
    $self->{Forwarders}->{Parent}=$self;
    for($i=0; $i < scalar(@typy);$i+=2)
    {
	@{$self->{$typy[$i]}}=('?') x 129;
    }
    @{$self->{outs}}=('?') x 129;
    
    @{$self->{pakiety}}= sort {@{$b}[1] <=> @{$a}[1] }@pakiety;
    
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
	    print "$a - BAD CRC powinno byc ".unpack("H*",$self->crc(substr($pakiet,0,length($pakiet)-1)))."\n";
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
    $komenda=$self->ff_encode($komenda);
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

sub code2
{
    my $self = shift;
    my $code2 = "";
    foreach $byte (split //, $self->{Code})
    {
	$code2.=sprintf("%x",15-$byte);
    }
    $code2.="00000000";
    $code2=substr($code2,0,8);
    $code2 =~ s/([a-fA-F0-9][a-fA-F0-9])/chr(hex($1))/eg;
    return $code2;
}

sub ff_encode
{
    my $self = shift;
    my $command = shift;
    my $command2 = "";
    foreach $byte (split //, $command)
    {
	$command2.=$byte;
	if(ord($byte) == 0xff){	$command2.=chr(0);}
    }
    return $command2;
}

sub get_event_begin
{
    my $self = shift;
    $self->get_event(0x7ee0,0);
}

sub get_event
{
    my $self = shift;
    my $adres = shift;
    my $offset = shift;
    $command= chr(hex(55));
    $command.=$self->code2();
    $command.=pack("v*",$adres);
    $command.= chr(hex($offset));
    $command.=$self->crc($command);
    $command.=$self->crc($command);
    $command=$self->ff_encode($command);
    $command=chr(0xff).chr(0xff).$command.chr(0xff).chr(0xaa);    
    $self->send_command($command);
    
#    print unpack("H*",$command)."\n";
}

sub get_event_nr
{
#dla 2 pytac o  8000+adr (4000-8000) , dla 3 pytac adr (8000-ffff).
# dla 4 pytac adr-8000 (10000-17fff)
    my $self = shift;
    my $id = shift;
    if($id < 0x4000)
    {
	print "Blad - nie ma wpisow ponizej 4000!\n";
	exit;
    }
    elsif($id > 0x3fff && $id < 0x8000)
    {
	return $self->get_event(0x8000+$id,2);
    }
    elsif($id > 0x7fff && $id < 0x10000)
    {
	return $self->get_event($id,3);
    }
    elsif($id > 0xffff && $id < 0x18000)
    {
	return $self->get_event($id-0x8000,4);
    }
    elsif($id > 0x17fff && $id < 0x20000)
    {
	return $self->get_event($id-0x10000,5);
    }						
}

sub event_id
{
    my $self = shift;
    my $offset = shift;
    my $addr = shift;

    if($offset == 2)
    {
	return $addr-0x8000;
    }
    elsif($offset == 3)
    {
	return $addr;
    }
    elsif($offset == 4)
    {
	return $addr+0x8000;
    }
    elsif($offset == 5)
    {
	return $addr+0x10000;
    }
    else
    {
	print "Bledny adress: $addr i offset $offset\n";
    exit;
    }
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
##    print "pakiet:".unpack("H*",$pakiet)."\n";

    
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
    elsif(substr($pakiet,1,1) =~ /\x56/)
    {
#	print "pakiet:".unpack("H*",$pakiet)."\n";
        use Satel::Event_Record;
	if(unpack("H*",substr($pakiet,2,3)) eq "e07e00")
	{
	    ## do zapytania pierwszego -0x20
	    my $id=$self->event_id(ord(substr($pakiet,18,1)),ord(substr($pakiet,19,1))+ord(substr($pakiet,20,1))*256); 
	    printf "0x%X pierwszy wpis!!\n",$id;
	    $self->get_event_nr($id-0x20);
	}
	
        if(ord(substr($pakiet,4,1)) > 1 && ord(substr($pakiet,4,1)) < 6)
	{
	    my $id;
	    for($i=3;$i>-1;$i--)
    	    {
		$id=$self->event_id(ord(substr($pakiet,4,1)),256*ord(substr($pakiet,3,1))+ord(substr($pakiet,2,1)))+$i*8;
    		printf STDERR "event: 0x%X\n",$id;
		$a = new Satel::Event_Record(substr($pakiet,5+$i*8,8));
    		print STDERR $a->parse_record();
	    }
	    $self->get_event_nr($id-0x20);
	  #exit;
	}
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
    elsif(substr($pakiet,1,3) =~ /\xfd\x16\x05/)
    {
	$in = ord(substr($pakiet,5,1));
	$name = substr($pakiet,8,16);
	print STDOUT "wejscie$in: $name\n";
    }
    elsif(substr($pakiet,1,1) =~ /\xfd/)
    {
	$name = substr($pakiet,8,16);
	print STDOUT "fd15: $name\n";
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

sub parse_string_new
{
    my $self = shift;
    my $r = shift;
    my $s = $self->{string}.$r;

    #zeby nie przychodzilo po pol pakietu
    if(length($s) < 128 ) { $self->{string}=$s; return; }
 
    #po dlugosci - do konstruktora poszlo
    #my @pakiety = sort {@{$b}[1] <=> @{$a}[1] }@pakiety;
    my @pakiety =  @{$self->{pakiety}};

    while ($s =~ /([\xff\xfe][^\xff\xfe]+.*)/m)
    {
	my $pakiet = $1;
	my $chr = substr($pakiet,1,1);

#	print unpack("H*",$pakiet)."\n";

	foreach (@pakiety)
	{
	    if(@{$_}[0] eq $chr)
	    {
#		print STDOUT "proba dl: (@{$_}[1]+3):\n";
		if(length($pakiet) >= @{$_}[1]+3  &&   $self->crc_check(substr($pakiet,0,@{$_}[1]+3)))
		{
		    if($self->{Debug} == 1)
		    {
			print STDOUT "@{$_}[3]\n";
		    }
		    $self->parse_packet(substr($pakiet,0,@{$_}[1]+3));
		    #obcinamy s
		    $s=substr($pakiet,@{$_}[1]+3);
		    last;
		}
	    }
	
	}
	#jezeli nadal nic to obcinamy 1 zn z przodu (ale jezeli nadal nic to wypadaloby to dac do s->{string}) 
	$s=substr($pakiet,1);
    }
    $self->{string}=$s;
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