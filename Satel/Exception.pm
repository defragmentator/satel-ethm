package Satel::Exception;

use Exception::Class
( 
    'Satel::Exception',
    'Satel::Exception::NoPort' =>   { description => 'brak portu!', error => "kupa!", name => "nazwa" },
    'Satel::Exception::NoPassword' =>   { description => 'brak portu!', error => "kupa!" }
);
			       
1;