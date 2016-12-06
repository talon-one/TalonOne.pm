# Set up with current perl (5.24.1)

    cpan install LWP

# Set up with Perl 5.8.8

    cpan GAAS/URI-1.40.tar.gz
    cpan GAAS/libwww-perl-5.837.tar.gz
    cpan MAKAMAKA/JSON-2.23.tar.gz
    cpan install IO::Socket::SSL

# Test it

To test the integration, you need to create an application in CAMA and find out its ID and application key. Pass your unique subdomain name, application ID and key to the demo script:

    perl talondemo.pl --subdomain master --appid 9 --appkey <yourappkey> 
