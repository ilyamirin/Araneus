
my $body = $ARGV[ 0 ];

print $body =~ s/<noindex>.+<\/noindex>/ /g;

print "\n";

print $body =~ s/<!--[^(-->)]+-->/ /g;

print "\n";

