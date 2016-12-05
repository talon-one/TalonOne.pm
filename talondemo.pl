use File::Basename;
use lib dirname (__FILE__);
use Data::Dumper;
use Getopt::Long;

use TalonOne;

my $subdomain = 'demo';
my $appkey = 'fefecafedeadbeef';
my $appid = 1;

GetOptions ("appid=i" => \$appid,
            "subdomain=s"   => \$subdomain,
            "appkey=s"  => \$appkey);

my $talon = new TalonOne($subdomain, $appid, $appkey);

sub handle_reject_coupon {
    my (@args) = @_;
    
    print "hello from handle_reject_coupon. args: @args\n";
}

my $r = $talon->PUT("customer_sessions/perlrulez1", 
                    {'coupon' => 'foobar!'},
                    {'rejectCoupon' => \&handle_reject_coupon});

