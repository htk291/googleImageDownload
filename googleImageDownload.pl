#!usr/bin/perl
use strict;
use warnings;
use WebService::Simple;
use Path::Class qw/dir file/;
use File::Basename;
use LWP::UserAgent;
use utf8;

my $arg = shift || '寺川愛美';
my $ua = LWP::UserAgent->new;
my $dir = dir('./data');

my $page_count = 0;
my $download_count = 0;

while (1) {
    my $offset = $page_count * 8;
    my $google = WebService::Simple->new(
        base_url        => "http://ajax.googleapis.com/ajax/services/search/images",
        response_parser => "JSON",
        params          => {v => "1.0", rsz => "large", hl=> "ja"}
    );

    my $response = $google->get({ q => $arg, start => $offset});
    for my $array (@{$response->parse_response->{responseData}{results}}) {
        $download_count++;
        my $imageUrl = $array->{'url'};
        print "Downloading$download_count...  $imageUrl\n";
        my $res = $ua->get($imageUrl, ':content_file'=> $dir->file(basename($imageUrl))->stringify);
        #die "error: $!\n" if $res->is_error;
    }
    $page_count++;
}

print "fin...\n";
