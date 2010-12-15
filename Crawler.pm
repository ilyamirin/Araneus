package Araneus::Crawler;
use Moose;
use MooseX::NonMoose;
use utf8;

use Encode;

extends qw/ HTTP::Lite /;

sub load_page {
    my ( $self, $page ) = @_;
    
    my $req = $self->request( $page ) or die "Unable to get document: $page";

    my $body = $self->body;

    $body =~ /<meta\s.*content=.+charset=([^;\s>"]+)/i;

    $body = decode( $1, $body ) if $1;

    $body =~ s/<$_[\s\S]+?\/$_>/ /g for qw/ img noindex script form /;    

    $body =~ s/<!--[\s\S]+?-->/ /g;

    $body =~ s/&[^;]+;/ /gi;

    #TODO:: remove hidden elements
    
    #get links

    my ( @links );

    push @links, $1 while $body =~ /href="?([^">\s#]+)/ig;
    
    @links = grep { $_ if $_ =~ /^(http:\/\/)?[A-Za-zА-Яа-я0-9\.\/]+$/ig } @links;

    map { $_ = $page . $1 if $_ =~ /^\.?\/(.+)$/ } @links;
    map { $_ .= '/' if $_ =~ /.+(?<!\/)$/ } @links;

    print( $_ . "\n" ) foreach @links;

    #print $body;
    print "\n";
    
}

#__PACKAGE__->meta->make_immutable;

1;

