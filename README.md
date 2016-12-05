
# Set up with current perl (5.24.1)

cpan install LWP

# Set up with Perl 5.8.8

1. install perlbrew
2. perlbrew install 5.8.8
3. perlbrew use 5.8.8

cpan GAAS/URI-1.40.tar.gz
cpan GAAS/libwww-perl-5.837.tar.gz
cpan MAKAMAKA/JSON-2.23.tar.gz
cpan install IO::Socket::SSL

# Test it

perl talondemo.pl --subdomain master --appid 9 --appkey <yourappkey>
