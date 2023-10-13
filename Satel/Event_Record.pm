package Satel::Event_Record;


my  %EVENTS = (
'1.0' =>  ['6', 'Voice messaging aborted '],
'2.0' =>  ['3', 'Change of user access code '],
'2.1' =>  ['3', 'Change of user access code '],
'3.0' =>  ['6', 'Change of user access code '],
'4.0' =>  ['6', 'Zones bypasses '],
'5.0' =>  ['6', 'Zones reset '],
'6.0' =>  ['6', 'Change of options '],
'7.0' =>  ['6', 'Permission for service access '],
'7.1' =>  ['6', 'Permission for service access removed '],
'8.0' =>  ['6', 'Addition of user '],
'9.0' =>  ['6', 'New user '],
'10.0' =>  ['6', 'Edition of user '],
'11.0' =>  ['6', 'User changed '],
'12.0' =>  ['6', 'Removal of user '],
'13.0' =>  ['6', 'User removed '],
'14.0' =>  ['6', 'Recognition of user access code '],
'15.0' =>  ['6', 'User access code recognized '],
'16.0' =>  ['6', 'Addition of master '],
'17.0' =>  ['6', 'Edition of master '],
'18.0' =>  ['6', 'Removal of master '],
'19.0' =>  ['4', 'RS-downloading started '],
'19.1' =>  ['4', 'RS-downloading finished '],
'20.0' =>  ['6', 'TEL-downloading started '],
'21.0' =>  ['6', 'Monitoring station 1A test '],
'22.0' =>  ['6', 'Monitoring station 1B test '],
'23.0' =>  ['6', 'Monitoring station 2A test '],
'24.0' =>  ['6', 'Monitoring station 2B test '],
'25.0' =>  ['4', 'Service mode taken over '],
'26.0' =>  ['2', 'Access to cash machine granted '],
'27.0' =>  ['3', 'Recognition of user access code '],
'27.1' =>  ['3', 'Recognition of user access code '],
'28.0' =>  ['3', 'User access code recognized '],
'28.1' =>  ['3', 'User access code recognized '],
'29.0' =>  ['7', 'Automatically removed temporal user '],
'30.0' =>  ['0', 'Service access automatically blocked '],
'31.0' =>  ['0', 'Main panel software updated '],
'32.0' =>  ['4', 'System settings stored in FLASH memory '],
'33.0' =>  ['0', 'Starter started '],
'34.0' =>  ['0', 'Starter started from RESET jumper '],
'35.0' =>  ['6', 'Zones test function started '],
'36.0' =>  ['7', 'Removal of single user '],
'37.0' =>  ['2', 'First access code entered '],
'38.0' =>  ['3', 'Voice messaging aborted '],
'38.1' =>  ['3', 'Voice messaging aborted '],
'39.0' =>  ['1', 'Vibration sensors test ok '],
'40.0' =>  ['6', 'Change of prefix '],
'41.0' =>  ['0', 'Change of winter time to summer time '],
'42.0' =>  ['0', 'Change of summer time to winter time '],
'43.0' =>  ['6', 'Guard round '],
'44.0' =>  ['5', 'First access code expired '],
'45.0' =>  ['2', 'First access code cancelled '],
'46.0' =>  ['7', 'Remote (telephone) control started '],
'46.1' =>  ['7', 'Remote (telephone) control finished '],
'47.0' =>  ['10', 'Remote switch turned on '],
'47.1' =>  ['10', 'Remote switch turned off '],
'48.0' =>  ['30', 'TCP/IP connection started (Internet) '],
'48.1' =>  ['30', 'TCP/IP connection finished (Internet) '],
'49.0' =>  ['30', 'TCP/IP connection failed (Internet) '],
'50.0' =>  ['31', 'IP address '],
'51.0' =>  ['4', 'Invalidation of system settings in FLASH '],
'52.0' =>  ['6', 'Service note cleared '],
'53.0' =>  ['1', 'Vibration sensors test interrupted '],
'54.0' =>  ['30', 'TCP/IP connection started (DloadX) '],
'54.1' =>  ['30', 'TCP/IP connection finished (DloadX) '],
'55.0' =>  ['30', 'TCP/IP connection failed (DloadX) '],
'56.0' =>  ['30', 'TCP/IP connection started (GuardX) '],
'56.1' =>  ['30', 'TCP/IP connection finished (GuardX) '],
'57.0' =>  ['30', 'TCP/IP connection failed (GuardX) '],
'58.0' =>  ['30', 'TCP/IP connection started (GSM socket) '],
'58.1' =>  ['30', 'TCP/IP connection finished (GSM socket) '],
'59.0' =>  ['30', 'TCP/IP connection failed (GSM socket) '],
'60.0' =>  ['30', 'TCP/IP connection started (GSM http) '],
'60.1' =>  ['30', 'TCP/IP connection finished (GSM http) '],
'61.0' =>  ['30', 'TCP/IP connection failed (GSM http) '],
'62.0' =>  ['6', 'User access '],
'63.0' =>  ['6', 'User exit '],
'64.0' =>  ['4', 'Keypad temporary blocked '],
'65.0' =>  ['4', 'Reader temporary blocked '],
'66.0' =>  ['1', 'Arming in "Stay" mode '],
'67.0' =>  ['1', 'Armin in "Stay, delay=0" mode '],
'68.0' =>  ['0', 'System real-time clock set '],
'69.0' =>  ['6', 'Troubles memory cleared '],
'70.0' =>  ['6', 'User logged in '],
'71.0' =>  ['6', 'User logged out '],
'72.0' =>  ['6', 'Door opened from LCD keypad '],
'73.0' =>  ['13', 'Door opened '],
'74.0' =>  ['6', 'System restored '],
'75.0' =>  ['0', 'ETHM/GPRS key changed '],
'76.0' =>  ['6', 'Messaging test started '],
'77.0' =>  ['1', 'Alarm monitoring delay '],
'78.0' =>  ['1', 'Network cable unplugged '],
'78.1' =>  ['1', 'Network cable ok '],
'79.0' =>  ['9', 'Messaging trouble '],
'80.0' =>  ['9', 'Messaging doubtful '],
'81.0' =>  ['9', 'Messaging ok '],
'82.0' =>  ['9', 'Messaging confirmed '],
'83.0' =>  ['1', '3 wrong access codes '],
'84.0' =>  ['1', 'Alarm - proximity card reader tamper '],
'84.1' =>  ['1', 'Proximity card reader restore '],
'85.0' =>  ['4', 'Unauthorised door opening '],
'86.0' =>  ['3', 'User exit '],
'86.1' =>  ['3', 'User exit '],
'87.0' =>  ['2', 'Partition temporary blocked '],
'88.0' =>  ['0', 'GSM module trouble '],
'88.1' =>  ['0', 'GSM module ok '],
'89.0' =>  ['4', 'Long opened door '],
'89.1' =>  ['4', 'Long opened door closed '],
'90.0' =>  ['0', 'Download suspended '],
'91.0' =>  ['0', 'Download started '],
'92.0' =>  ['1', 'Alarm - module tamper (verification error) '],
'92.1' =>  ['1', 'Module tamper restore (verification ok) '],
'93.0' =>  ['1', 'Alarm - module tamper (lack of presence) '],
'93.1' =>  ['1', 'Module tamper restore (presence ok) '],
'94.0' =>  ['1', 'Alarm - module tamper (TMP input) '],
'94.1' =>  ['1', 'Module tamper restore (TMP input) '],
'95.0' =>  ['12', 'Output overload '],
'95.1' =>  ['12', 'Output overload restore '],
'96.0' =>  ['12', 'No output load '],
'96.1' =>  ['12', 'Output load present '],
'97.0' =>  ['1', 'Long zone violation '],
'97.1' =>  ['1', 'Long zone violation restore '],
'98.0' =>  ['1', 'No zone violation '],
'98.1' =>  ['1', 'No zone violation restore '],
'99.0' =>  ['1', 'Zone violation '],
'99.1' =>  ['1', 'Zone restore '],
'100.0' =>  ['1', 'Medical request (button) '],
'100.1' =>  ['1', 'Release of medical request button '],
'101.0' =>  ['1', 'Medical request (remote) '],
'101.1' =>  ['1', 'Remote medical request restore '],
'110.0' =>  ['1', 'Fire alarm '],
'110.1' =>  ['1', 'Fire alarm zone restore '],
'111.0' =>  ['1', 'Fire alarm (smoke detector) '],
'111.1' =>  ['1', 'Smoke detector zone restore '],
'112.0' =>  ['1', 'Fire alarm (combustion) '],
'112.1' =>  ['1', 'Combustion zone restore '],
'113.0' =>  ['1', 'Fire alarm (water flow) '],
'113.1' =>  ['1', 'Water flow detection restore '],
'114.0' =>  ['1', 'Fire alarm (temperature sensor) '],
'114.1' =>  ['1', 'Temperature sensor zone restore '],
'115.0' =>  ['1', 'Fire alarm (button) '],
'115.1' =>  ['1', 'Release of fire alarm button '],
'116.0' =>  ['1', 'Fire alarm (duct) '],
'116.1' =>  ['1', 'Duct zone restore '],
'117.0' =>  ['1', 'Fire alarm (flames detected) '],
'117.1' =>  ['1', 'Flames detection zone restore '],
'120.0' =>  ['1', 'PANIC alarm (keypad) '],
'121.0' =>  ['2', 'DURESS alarm '],
'122.0' =>  ['1', 'Silent PANIC alarm '],
'122.1' =>  ['1', 'Silent panic alarm zone restore '],
'123.0' =>  ['1', 'Audible PANIC alarm '],
'123.1' =>  ['1', 'Audible panic alarm zone restore '],
'126.0' =>  ['5', 'Alarm - no guard '],
'130.0' =>  ['1', 'Burglary alarm '],
'130.1' =>  ['1', 'Zone restore '],
'131.0' =>  ['1', 'Alarm (perimeter zone) '],
'131.1' =>  ['1', 'Perimeter zone restore '],
'132.0' =>  ['1', 'Alarm (interior zone) '],
'132.1' =>  ['1', 'Interior zone restore '],
'133.0' =>  ['1', 'Alarm (24h burglary zone) '],
'133.1' =>  ['1', '24h burglary zone restore '],
'134.0' =>  ['1', 'Alarm (entry/exit zone) '],
'134.1' =>  ['1', 'Entry/exit zone restore '],
'135.0' =>  ['1', 'Alarm (day/night zone) '],
'135.1' =>  ['1', 'Day/night zone restore '],
'136.0' =>  ['1', 'Alarm (exterior zone) '],
'136.1' =>  ['1', 'Exterior zone restore '],
'137.0' =>  ['1', 'Alarm (tamper perimeter) '],
'137.1' =>  ['1', 'Tamper perimeter zone restore '],
'139.0' =>  ['1', 'Verified alarm '],
'143.0' =>  ['11', 'Alarm - communication bus trouble '],
'143.1' =>  ['11', 'Communication bus ok '],
'144.0' =>  ['1', 'Alarm (zone tamper) '],
'144.1' =>  ['1', 'Zone tamper restore '],
'145.0' =>  ['1', 'Alarm (module tamper) '],
'145.1' =>  ['1', 'Module tamper restore '],
'150.0' =>  ['1', 'Alarm (24h no burglary zone) '],
'150.1' =>  ['1', '24h no burglary zone restore '],
'151.0' =>  ['1', 'Alarm (gas detector) '],
'151.1' =>  ['1', 'Gas detection zone restore '],
'152.0' =>  ['1', 'Alarm (refrigeration) '],
'152.1' =>  ['1', 'Refrigeration zone restore '],
'153.0' =>  ['1', 'Alarm (heat loss) '],
'153.1' =>  ['1', 'Heat loss zone restore '],
'154.0' =>  ['1', 'Alarm (water leak) '],
'154.1' =>  ['1', 'Water leak zone restore '],
'155.0' =>  ['1', 'Alarm (protection loop break) '],
'155.1' =>  ['1', 'Protection loop break zone restore '],
'156.0' =>  ['1', 'Alarm (day/night zone tamper) '],
'156.1' =>  ['1', 'Day/night zone tamper restore '],
'157.0' =>  ['1', 'Alarm (low gas level) '],
'157.1' =>  ['1', 'Low gas level zone restore '],
'158.0' =>  ['1', 'Alarm (high temperature) '],
'158.1' =>  ['1', 'High temperature zone restore '],
'159.0' =>  ['1', 'Alarm (low temperature) '],
'159.1' =>  ['1', 'Low temperature zone restore '],
'161.0' =>  ['1', 'Alarm (no air flow) '],
'161.1' =>  ['1', 'No air flow zone restore '],
'162.0' =>  ['1', 'Alarm (carbon monoxide detected) '],
'162.1' =>  ['1', 'Restore of carbon monoxide (CO) detection '],
'163.0' =>  ['1', 'Alarm (tank level) '],
'163.1' =>  ['1', 'Restore of tank level '],
'200.0' =>  ['1', 'Alarm (fire protection loop) '],
'200.1' =>  ['1', 'Fire protection loop zone restore '],
'201.0' =>  ['1', 'Alarm (low water pressure) '],
'201.1' =>  ['1', 'Low water pressure zone restore '],
'202.0' =>  ['1', 'Alarm (low CO2 pressure) '],
'202.1' =>  ['1', 'Low CO2 pressure zone restore '],
'203.0' =>  ['1', 'Alarm (valve sensor) '],
'203.1' =>  ['1', 'Valve sensor zone restore '],
'204.0' =>  ['1', 'Alarm (low water level) '],
'204.1' =>  ['1', 'Low water level zone restore '],
'205.0' =>  ['1', 'Alarm (pump activated) '],
'205.1' =>  ['1', 'Pump stopped '],
'206.0' =>  ['1', 'Alarm (pump trouble) '],
'206.1' =>  ['1', 'Pump ok '],
'220.0' =>  ['1', 'Keybox open '],
'220.1' =>  ['1', 'Keybox restore '],
'301.0' =>  ['4', 'AC supply trouble '],
'301.1' =>  ['4', 'AC supply ok '],
'302.0' =>  ['4', 'Low battery voltage '],
'302.1' =>  ['4', 'Battery ok '],
'303.0' =>  ['0', 'RAM memory error '],
'305.0' =>  ['4', 'Main panel restart '],
'306.0' =>  ['0', 'Main panel settings reset '],
'306.1' =>  ['0', 'System settings restored from FLASH memory '],
'312.0' =>  ['12', 'Supply output overload '],
'312.1' =>  ['12', 'Supply output overload restore '],
'330.0' =>  ['8', 'Proximity card reader trouble '],
'330.1' =>  ['8', 'Proximity card reader ok '],
'333.0' =>  ['11', 'Communication bus trouble '],
'333.1' =>  ['11', 'Communication bus ok '],
'339.0' =>  ['4', 'Module restart '],
'344.0' =>  ['1', 'Receiver jam detected '],
'344.1' =>  ['1', 'Receiver jam ended '],
'350.0' =>  ['0', 'Transmission to monitoring station trouble '],
'350.1' =>  ['0', 'Transmission to monitoring station ok '],
'351.0' =>  ['0', 'Telephone line troubles '],
'351.1' =>  ['0', 'Telephone line ok '],
'370.0' =>  ['1', 'Alarm (auxiliary zone perimeter tamper) '],
'370.1' =>  ['1', 'Auxiliary zone perimeter tamper restore '],
'373.0' =>  ['1', 'Alarm (fire sensor tamper) '],
'373.1' =>  ['1', 'Fire sensor tamper restore '],
'380.0' =>  ['1', 'Zone trouble (masking) '],
'380.1' =>  ['1', 'Zone ok (masking) '],
'381.0' =>  ['32', 'Radio connection troubles '],
'381.1' =>  ['32', 'Radio connection ok '],
'383.0' =>  ['1', 'Alarm (zone tamper) '],
'383.1' =>  ['1', 'Zone tamper restore '],
'384.0' =>  ['32', 'Low voltage on radio zone battery '],
'384.1' =>  ['32', 'Voltage on radio zone battery ok '],
'400.0' =>  ['2', 'Disarm '],
'400.1' =>  ['2', 'Arm '],
'401.0' =>  ['2', 'Disarm by user '],
'401.1' =>  ['2', 'Arm by user '],
'402.0' =>  ['2', 'Group disarm '],
'402.1' =>  ['2', 'Group arm '],
'403.0' =>  ['15', 'Auto-disarm '],
'403.1' =>  ['15', 'Auto-arm '],
'404.0' =>  ['2', 'Late disarm by user '],
'404.1' =>  ['2', 'Late arm by user '],
'405.0' =>  ['2', 'Deferred disarm by user '],
'405.1' =>  ['2', 'Deferred arm by user '],
'406.0' =>  ['2', 'Alarm cleared '],
'407.0' =>  ['2', 'Remote disarm '],
'407.1' =>  ['2', 'Remote arm '],
'408.1' =>  ['1', 'Quick arm '],
'409.0' =>  ['1', 'Disarm by zone '],
'409.1' =>  ['1', 'Arm by zone '],
'411.0' =>  ['0', 'Callback made '],
'412.0' =>  ['0', 'Download successfully finished '],
'413.0' =>  ['0', 'Unsuccessful remote download attempt '],
'421.0' =>  ['3', 'Access denied '],
'421.1' =>  ['3', 'Access denied '],
'422.0' =>  ['3', 'User access '],
'422.1' =>  ['3', 'User access '],
'423.0' =>  ['1', 'Alarm - armed partition door opened '],
'441.1' =>  ['2', 'Arm (STAY mode) '],
'442.1' =>  ['1', 'Arm by zone (STAY mode) '],
'454.0' =>  ['2', 'Arming failed '],
'458.0' =>  ['2', 'Delay activation time started '],
'461.0' =>  ['1', 'Alarm (3 wrong access codes) '],
'462.0' =>  ['3', 'Guard round '],
'462.1' =>  ['3', 'Guard round '],
'570.0' =>  ['1', 'Zone bypass '],
'570.1' =>  ['1', 'Zone unbypass '],
'571.0' =>  ['1', 'Fire zone bypass '],
'571.1' =>  ['1', 'Fire zone unbypass '],
'572.0' =>  ['1', '24h zone bypass '],
'572.1' =>  ['1', '24h zone unbypass '],
'573.0' =>  ['1', 'Burglary zone bypass '],
'573.1' =>  ['1', 'Burglary zone unbypass '],
'574.0' =>  ['1', 'Group zone bypass '],
'574.1' =>  ['1', 'Group zone unbypass '],
'575.0' =>  ['1', 'Zone auto-bypassed (violations) '],
'575.1' =>  ['1', 'Zone auto-unbypassed (violations) '],
'601.0' =>  ['6', 'Manual transmission test '],
'602.0' =>  ['0', 'Transmission test '],
'604.0' =>  ['2', 'Fire/technical zones test '],
'604.1' =>  ['5', 'End of fire/technical zones test '],
'607.0' =>  ['2', 'Burglary zones test '],
'607.1' =>  ['5', 'End of burglary zones test '],
'611.0' =>  ['1', 'Zone test ok '],
'612.0' =>  ['1', 'Zone not tested '],
'613.0' =>  ['1', 'Burglary zone test ok '],
'614.0' =>  ['1', 'Fire zone test ok '],
'615.0' =>  ['1', 'Panic zone test ok '],
'621.0' =>  ['0', 'Reset of event log '],
'622.0' =>  ['0', 'Event log 50% full '],
'623.0' =>  ['0', 'Event log 90% full '],
'625.0' =>  ['6', 'Setting system real-time clock '],
'625.1' =>  ['0', 'System real-time clock trouble '],
'627.0' =>  ['4', 'Service mode started '],
'628.0' =>  ['4', 'Service mode finished '],
'985.0' =>  ['15', 'Exit time started '],
'986.0' =>  ['1', 'Warning alarm '],
'987.0' =>  ['2', 'Warning alarm cleared '],
'988.0' =>  ['1', 'Arming aborted '],
'989.0' =>  ['7', 'User logged in (INT-VG) '],
'989.1' =>  ['7', 'User logged out (INT-VG) '],
'990.0' =>  ['4', 'No connection with KNX system '],
'990.1' =>  ['4', 'Connection with KNX system ok '],
'991.0' =>  ['1', 'Zone auto-bypassed (tamper violations) '],
'991.1' =>  ['1', 'Zone auto-unbypassed (tamper violations) '],
'992.0' =>  ['6', 'Confirmed troubles '],
'993.0' =>  ['6', 'Confirmed use of RX key fob with low battery '],
'994.0' =>  ['6', 'Confirmed use of ABAX key fob with low battery'],
'995.0' =>  ['3', 'Remote RX key fob with low battery used '],
'995.1' =>  ['3', 'Remote RX key fob with low battery used '],
'996.0' =>  ['3', 'Remote ABAX key fob with low battery used '],
'996.1' =>  ['3', 'Remote ABAX key fob with low battery used '],
'997.0' =>  ['4', 'Long transmitter busy state '],
'997.1' =>  ['4', 'Restore of long transmitter busy state '],
'998.0' =>  ['0', 'Transmission test (station 1) '],
'999.0' =>  ['0', 'Transmission test (station 2) '],
'1000.0' =>  ['1', 'Trouble (zone) '],
'1000.1' =>  ['1', 'Trouble restore (zone) '],
'1001.0' =>  ['2', 'Forced arming '],
'1002.0' =>  ['4', 'No network (PING test) '],
'1002.1' =>  ['4', 'Network ok (PING test) '],
'1003.0' =>  ['2', 'Arming aborted '],
'1005.0' =>  ['6', 'ETHM-1-downloading started '],
'1006.0' =>  ['4', 'Current battery test - absent/low voltage '],
'1006.1' =>  ['4', 'Current battery test - ok '],
'1007.0' =>  ['1', 'Exit time started '],
'1008.0' =>  ['2', 'Exit time started '],
'1009.0' =>  ['14', 'SMS control - begin '],
'1009.1' =>  ['14', 'SMS control - end '],
'1010.0' =>  ['14', 'SMS with no control received '],
'1011.0' =>  ['14', 'SMS from unauthorized telephone received '],
'1012.0' =>  ['6', 'CSD-downloading started '],
'1013.0' =>  ['6', 'GPRS-downloading started '],
'1014.0' =>  ['4', 'No signal on DSR input '],
'1014.1' =>  ['4', 'Signal on DSR input ok '],
'1015.0' =>  ['4', 'Time server error '],
'1015.1' =>  ['4', 'Time server ok '],
'1016.0' =>  ['6', 'Time synchronization started '],
'1017.0' =>  ['9', 'SMS messaging ok '],
'1018.0' =>  ['9', 'SMS messaging failed '],
'1019.0' =>  ['3', 'Remote key fob used '],
'1019.1' =>  ['3', 'Remote key fob used '],
'1020.0' =>  ['1', 'LCD/PTSA/ETHM-1 initiation error '],
'1021.0' =>  ['1', 'LCD/PTSA/ETHM-1 initiation ok '],
'1022.0' =>  ['0', 'DOWNLOAD request from ETHM-1 module '],
'1023.0' =>  ['6', 'Tamper info cleared '],
);


sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};
    my $data = shift;
    if(length($data)==16)
    {
	#HEX
	$data=pack("H* ",$data)
    }
    if(length($data)==8)
    {
	#BIN
	@{ $self->{BITY} }    =  split(//,$data);
    }
    else
    {
        $self->{BITY}    = [];
    }
## to ustalac!!!    
    $self->{integra_ver}=128;
    bless ($self, $class);
    return $self;
}

sub parse_record()
{
    my $self = shift;
    
    $a = $self->data()." ".$self->czas()." : ".($self->rekord_istnieje()?'OK':'!!!')." : ".$self->monitoring().
	" : ".$self->event_class()."->".$self->event_code().".".$self->source().".".$self->object().".".
	$self->user_cn()." : Part:".$self->partycja()." ".$self->restore()."\n";
    $a.= $self->event_name()." ".$self->event_param()." ".$self->event_description()."\n";
    return $a;
}

sub czas()
{
    my $self = shift;
    my $czas = (ord(@{ $self->{BITY} }[2])&15)*256+ord(@{ $self->{BITY} }[3]);
    my $min = $czas%60;
    my $godz = ($czas-$min)/60;
    return sprintf("%02d:%02d",$godz,$min);
}

sub data()
{
    my $self = shift;
    return sprintf("%d-%02d-%02d",$self->rok(),$self->miesiac(),$self->dzien());
}

sub event_class()
{
    use Switch;
    my $self = shift;
    switch (ord(@{ $self->{BITY} }[1])>>5)
    {
        case 0   { return "zone and tamper alarms"; }
	case 1   { return "partition and expander alarms";  }
	case 2   { return "arming, disarming, alarm clearing"; }
	case 3   { return "zone bypasses and unbypasses"; }
	case 4   { return "access control"; }
	case 5   { return "troubles"; }
	case 6   { return "user functions"; }
	case 7   { return "system events";  }
    }
}

sub monitoring()
{
    use Switch;
    my $self = shift;
    switch ((ord(@{ $self->{BITY} }[0])&6)>>1) 
    {
	case 0  { return "new event, not processed by monitoring service"; }
	case 1  { return "event sent"; }
	case 2  { return "should not occur"; }
        case 3  { return "event not monitored"; }
    }
}



sub rekord_istnieje()
{
    my $self = shift;
    if ( ((ord(@{ $self->{BITY} }[0])<<2)>>6)== 3)
    {
	return 1;
    }
    elsif ( ((ord(@{ $self->{BITY} }[0])<<2)>>6) == 0)
    {
	return 0;
    }
    else
    {
	return -1;
    }
}

sub dzien()
{
    my $self = shift;
    my $dzien = ((ord(@{ $self->{BITY} }[1])&31));
    return $dzien;
}

sub miesiac()
{
    my $self = shift;
    my $miesiac = ((ord(@{ $self->{BITY} }[2])>>4));
    return $miesiac;
}


sub rok()
{
    use POSIX qw(strftime);
    my $self = shift;
    my $bit=ord(@{ $self->{BITY} }[0])>>6;    
    my $cur_year = strftime "%Y", localtime;
    my $year=$cur_year-$cur_year%4+$bit;
    if($year > $cur_year)
    {
	$year-=4;
    }
    return $year;
}


sub event_name()
{
    my $self = shift;
    return $EVENTS{$self->event_code().".".$self->restore()}[1];
}

sub event_description()
{
    use Switch;
    my $self = shift;
    my $id = ($EVENTS{$self->event_code().".".$self->restore()}[0]);
    switch ($id)
    {
        case 0 { return " no addictional description"; }
        case 1 { return " partition/zone|expander|keypad"; }
        case 2 { return " partition/user"; }
        case 3 { return " partition keypad/user (partition keypad address in PPPPPR) (not LCD keypad, but LED partition keypad, e.g. INT-S)"; }
        case 4 { return " zone|expander|keypad"; }
        case 5 { return " partition"; }
        case 6 { return " keypad/user"; }
        case 7 { return " user"; }
        case 8 { return " expander reader head"; }
        case 9 { return " telephone"; }
        case 10 { return " output of telephone relay type"; }
        case 11 { return " partition/data bus"; }
        case 12 { return " partition/output|expander (partition not important for main panel outputs)"; }
	case 13 { return " partition/output|expander (partition not important for outputs)"; }
        case 14 { return " telephone in PPPPP/user (telephone: 0 - unknown, 1.. - phone number)"; }
        case 15 { return " partition/timer"; }
    	case 30 { return " beginning of TCP/IP address (keypad address in PPPPP)"; }
	case 31 { return " 3rd and 4th bytes of TCP/IP address"; }
        case 32 { return " partition/zone or ABAX output"; }
    }
}

sub event_param()
{
    use Switch;
    my $self = shift;
    my $id = ($EVENTS{$self->event_code().".".$self->restore()}[0]);
    switch ($id)
    {
        case 0 { return "";  } #no addictional description
        case 1
	{
	    #partition/zone|expander|keypad";
	    if($self->source() < 129)
	    {
		return "input line ".$self->source();
	    }
	    elsif($self->source() > 128 && $self->source() < 193)
	    {
		return "expander at address ".($self->source()-129);
	    }
	    else
	    {
		if($self->{integra_ver} == 24 || $self->{integra_ver} == 32)
		{
		    if($self->source() > 192 && $self->source() < 197)
		    {
			return "real LCD keypads or INT-RS modules at address ".($self->source()-193);
		    }
		    elsif($self->source() > 196 && $self->source() < 201)
		    {
			return "keypad in GuardX connected to LCD keypad or www keypad connected to ETHM-1 at address ".($self->source()-197);
		    }
		    elsif($self->source() == 201)
		    {
			return "keypad in DloadX connected to INTEGRA via RS cable";
		    }
		    elsif($self->source() == 202)
		    {
			return "keypad in DloadX connected to INTEGRA via TEL link (modem)";
		    }
		}
		else
		{
		    if($self->source() > 192 && $self->source() < 201)
		    {
			return "real LCD keypads or INT-RS modules at address ".($self->source()-193);
		    }
		    elsif($self->source() > 200 && $self->source() < 209)
		    {
			return "keypad in GuardX connected to LCD keypad or www keypad connected to ETHM-1 at address ".($self->source()-201);
		    }
		    elsif($self->source() == 209)
		    {
			return "keypad in DloadX connected to INTEGRA via RS cable";
		    }
		    elsif($self->source() == 210)
		    {
			return "keypad in DloadX connected to INTEGRA via TEL link (modem)";
		    }		
		}
	    }
	}
        case 2
	{
	    #partition/user
	    if($self->source() < 241)
	    {
		return "user nr ".$self->source();
	    }
	    elsif($self->source() > 240 && $self->source() < 249)
	    {	    
		return "master user nr ".$self->source();
	    }
	    elsif($self->source() == 249)
	    {	    
		return "INT-AV";
	    }
	    elsif($self->source() == 251)
	    {	    
		return "SMS";
	    }
	    elsif($self->source() == 252)
	    {	    
		return "timer";
	    }
	    elsif($self->source() == 253)
	    {	    
		return "function zone";
	    }
	    elsif($self->source() == 254)
	    {	    
		return "Quick arm";
	    }
	    elsif($self->source() == 255)
	    {	    
		return "service";
	    }
	}
        case 3 { return " partition keypad/user (partition keypad address in PPPPPR) (not LCD keypad, but LED partition keypad, e.g. INT-S)"; }
        case 4 { return " zone|expander|keypad"; }
        case 5 { return " partition"; }
        case 6 { return " keypad/user"; }
        case 7 { return " user"; }
        case 8 { return " expander reader head"; }
        case 9 { return " telephone"; }
        case 10 { return " output of telephone relay type"; }
        case 11 { return " partition/data bus"; }
        case 12 { return " partition/output|expander (partition not important for main panel outputs)"; }
	case 13 { return " partition/output|expander (partition not important for outputs)"; }
        case 14 { return " telephone in PPPPP/user (telephone: 0 - unknown, 1.. - phone number)"; }
        case 15 { return " partition/timer"; }
    	case 30 { return ord(@{ $self->{BITY} }[6]).".".ord(@{ $self->{BITY} }[7])." keypad nr ".$self->partycja(); }
	case 31 { return ord(@{ $self->{BITY} }[6]).".".ord(@{ $self->{BITY} }[7]); }
        case 32 { return " partition/zone or ABAX output"; }
    }
}

sub event_code()
{
    my $self = shift;
    my $code = (ord(@{ $self->{BITY} }[4])&3)*256+ord(@{ $self->{BITY} }[5]);
    return $code;
}

sub object()
{
    my $self = shift;
    my $object= (ord(@{ $self->{BITY} }[7])>>5);
    return $object;
}

sub user_cn()
{
    my $self = shift;
    my $user_cn= (ord(@{ $self->{BITY} }[7])&31);
    return $user_cn;
}


sub source()
{
    my $self = shift;
    my $source= ord(@{ $self->{BITY} }[6]);
    return $source;
}


sub partycja()
{
    my $self = shift;
    my $partycja = (ord(@{ $self->{BITY} }[4])>>3);
    return $partycja;
}

sub restore()
{
    my $self = shift;
    my $restore = (ord(@{ $self->{BITY} }[4]) & 7 )>>2;
    return $restore;
}



1;