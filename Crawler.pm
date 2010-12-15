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

    $self->body =~ /<meta\s.*content=.+charset=([^;\s>"]+)/i;

    $body = decode( $1, $body ) if $1;

    #ignore comments and hidden

    #$body =~ s/<!--[^(-->)]+//ig;
    
    #get links

    my ( @links );

    push @links, $1 while $body =~ /href="?([^">\s#]+)/ig;
    
    @links = grep { $_ if $_ =~ /^(http:\/\/)?[A-Za-zА-Яа-я0-9\.\/]+$/ig } @links;

    map { $_ = $page . $1 if $_ =~ /^\.?\/(.+)$/i } @links;

    #print( $_ . "\n" ) foreach @links;

    #remove tags

    #/<\/?.+>/

    print $body . "\n";
    #return $body;    
    
}

#__PACKAGE__->meta->make_immutable;

1;

