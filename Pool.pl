package Pool;
use Moose;

use Crawler;

BEGIN{

    my $crawler = Araneus::Crawler->new();

    $crawler->load_page( $ARGV[ 0 ] );
}


1;
