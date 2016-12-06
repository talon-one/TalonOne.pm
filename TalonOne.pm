package TalonOne;
=head1 NAME

TalonOne - Talon.One Integration API SDK for Perl 5.22

=head1 VERSION

version 0.1

=cut

# install: cpan install Digest::HMAC_MD5
    
use LWP::Simple;
use Digest::HMAC_MD5 qw(hmac_md5 hmac_md5_hex);
use JSON;
use Data::Dumper;

sub new {
    my ($class, $subdomain, $appid, $appkey) = @_;
    
    my $new = bless {
        subdomain => $subdomain,
        appid => $appid,
        appkey => $appkey
    }, $class;

    return $new;
}

sub api_request {
    my ($self, $method, $resource, $payload, $effect_handlers) = @_;
    
    my $base_url = "https://$self->{subdomain}.talon.one/v1";
    my $payload = encode_json($payload);
    
    my $appkey_bytes = pack "H*", $self->{appkey};
    my $signature = hmac_md5_hex($payload, $appkey_bytes);

    my $ua = new LWP::UserAgent;
    $ua->agent("LWP/1.0");
    my $request = new HTTP::Request($method, $base_url.'/'.$resource, 
                                    ['Content-Type' => 'application/json', 
                                     'Content-Signature' => "signer=$self->{appid}; signature=$signature"], 
                                    $payload);
    my $response = $ua->request($request);
    my $ok = 0;
    
    my $content = decode_json($response->content);
    if ($response->is_success) {
        $ok = $self->process_effects($content,$effect_handlers);
    } else {
        $ok = 0;
    }
    
    return ($ok, $response);
}

sub GET {
    $self = shift;
    return $self->api_request("GET", @_);
}

sub PUT {
    $self = shift;
    return $self->api_request("PUT", @_);
}

sub POST {
    $self = shift;
    return $self->api_request("POST", @_);
}

sub process_effects {
    my ($self, $response, $handlers) = @_;
    
    my $fxref = $$response{'event'}{'effects'};
    my @fx = @$fxref;

    foreach (@fx) {
        my ($campaignId, $rulesetId, $ruleIndex, $effect) = @$_;
        my ($action, @args) = @$effect;

        my $handler = $handlers->{$action};
        if ($handler) {
            &$handler($response, @args);
        }
    }
    return 1;
}

1;
