use Test::Harness;
use Data::Dumper;
opendir(my $dh, 't') || die "can't opendir $some_dir: $!";
@dots = readdir($dh);
closedir $dh;
(@files) = (@ARGV);
if(scalar @files == 0) {
  foreach (@dots) {
    next if $_ =~ /run\.pl/;
    next if $_ =~ /^\./;
    push @files, 't/'.$_;
  }
}
$Test::Harness::verbose = 1;
runtests(@files);
