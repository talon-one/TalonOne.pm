use File::Basename;
use lib dirname (__FILE__);
use Data::Dumper;
use Getopt::Long;

use TalonOne;

sub talonone_demo_integration() {
    my $subdomain = 'demo';
    my $appkey = 'fefecafedeadbeef';
    my $appid = 1;

    GetOptions ("appid=i" => \$appid,
                "subdomain=s"   => \$subdomain,
                "appkey=s"  => \$appkey);

    my $talon = new TalonOne($subdomain, $appid, $appkey);

    my %effect_handlers;
    
    $effect_handlers{rejectCoupon} = sub {
        my ($response, @args) = @_;
        my $coupon = $args[0];
        print "Invalid coupon: $coupon\n";
    };

    $effect_handlers{acceptCoupon} = sub {
        my ($response, @args) = @_;
        print "Valid coupon: @args\n";
    };

    $effect_handlers{setDiscount} = sub {
        my ($response, @args) = @_;
        
        # This is a good spot to update discount lines in the current cart
        print "Set discount: @args\n";
    };

    # Refer to http://developers.talon.one/data-model/attribute-library/ for additional attributes
    my ($ok, $response) = $talon->PUT("customer_profiles/testprofile1234", 
                                      {'attributes' => {'Email' => 'happycustomer@example.org'},
                                       'advocateId' => 'friendid2345'}, 
                                      \%effect_handlers);
    
    print "Profile updated, success: $ok\n";
    if (!$ok) {
        print Dumper($response);
    }
    
    my ($ok, $response) = $talon->PUT("customer_sessions/testsession1234", 
                                      {'attributes' => {},
                                       'coupon' => 'DEMO-AWAU-TAYA',
                                       # Set state to 'closed' when the order is completed
                                       'state' => 'open'}, 
                                      \%effect_handlers);

    print "Session updated, success: $ok\n";
    if (!$ok) {
        print Dumper($response);
    }
}

talonone_demo_integration();
