package Araneus::Crawler;
use Moose;
use MooseX::NonMoose;
use utf8;

use Encode;

#TODO:: добавить логирование
#TODO:: добавить конфигу
#TODO:: добавить схему
#TODO:: обрабатывать robots.txt
#TODO:: обрабатывать метатеги

extends qw/ HTTP::Lite /;

has config => ( is => 'rw' , isa => 'HashRef', default => sub {
    {
        coefficients => {
            'h1'         => 3,
            'h2'         => 2,
            'h3'         => 1,
            'h4'         => 1.5,
            'h5'         => 1.3,
            'h6'         => 1.1,            
            'a'          => 3,
            'i'          => 1.2,
            'b'          => 2,
            'strong'     => 2,
            'code'       => 3,
            'blockquote' => 3,            
        },#coefficients
    }
} );

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

    #parse

    while ( $body =~ s/<(h[1-6])[^>]*>([\s\S]+?)<\1>/ /i ) {
        #print $1 . ': ' . $2 . "\n";
    }#while

    while ( $body =~ s/<(a|i|b(?<=>)|strong|code|blockquote)[^>]*>([\s\S]*?)<\/\1>/ /i ) {
        print '------------' .$1 .'------------' . "\n";
        print $2 . "\n";
    }#while    
    
    #get links

    my ( @links );

    push @links, $1 while $body =~ /href="?([^">\s#]+)/ig;
    
    @links = grep { $_ if $_ =~ /^(http:\/\/)?[A-Za-zА-Яа-я0-9\.\/]+$/ig } @links;

    map { $_ = $page . $1 if $_ =~ /^\.?\/(.+)$/ } @links;
    map { $_ .= '/' if $_ =~ /.+(?<!\/)$/ } @links;

    #print( $_ . "\n" ) foreach @links;

    #print $body;
    print "\n";
    
}

#__PACKAGE__->meta->make_immutable;

1;

