
package DNATag;

use strict;
use warnings;

use overload (
    q[""]      => sub { ${$_[0]} },
    'bool'     => sub {1},
    'fallback' => 1,
);

sub new {
    my $class = shift;
    my $seq = shift or die 'need tag';
    (@_ == 0) or die 'too many';
    bless \$seq, $class;
}

sub is_dual { (${$_[0]} =~ /-/) ? 1 : ''; }
sub is_single { not $_[0]->is_dual }
sub length {
    my $seq = ${$_[0]};
    $seq =~ s/-//g;
    length($seq);
}

package DNATag::Set;

use strict;
use warnings;
use List::AllUtils ();

use overload (
    '@{}'      => sub { [ map {"$_"} @{$_[0]->{'seq'}} ]; },
    'bool'     => sub {1},
    'fallback' => 1,
);

sub new {
    my $class = shift;
    (@_ > 0) or die 'need some seqs';
    bless {seq => [map { DNATag->new($_) } @_]}, $class;
}

sub all_dual   { List::AllUtils::all { $_->is_dual }    @{$_[0]->{'seq'}}  }
sub all_single { List::AllUtils::all { $_->is_single }  @{$_[0]->{'seq'}}  }
sub min_length { List::AllUtils::min(map { $_->length } @{$_[0]->{'seq'}}) }
sub max_length { List::AllUtils::max(map { $_->length } @{$_[0]->{'seq'}}) }

1;
__END__

