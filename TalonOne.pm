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

sub new {
    my ($class, $subdomain, $appid, $appkey) = @_;
    
    my $new = bless {
        subdomain => $subdomain,
        appid => $appid,
        appkey => $appkey,

        api_request => api_request
    }, $class;

    return $new;
}

sub api_request {
    my ($self, $method, $resource, $payload) = @_;
    
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
    return $response;
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

1;
