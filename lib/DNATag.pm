
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
sub seq { "$_[0]" }
sub is_dual { (${$_[0]} =~ /-/) ? 1 : ''; }
sub is_single { not $_[0]->is_dual }
sub length {
    my $seq = ${$_[0]};
    $seq =~ s/-//g;
    CORE::length($seq);
}
sub length_i1 { CORE::length $_[0]->seq_i1 }
sub length_i2 { CORE::length $_[0]->seq_i2 }
sub seq_i1 {
    my $self = shift;
    return ${$self} if $self->is_single;
    return [split('-', ${$self})]->[0];
}
sub seq_i2 {
    my $self = shift;
    return '' if $self->is_single;
    return [split('-', ${$self})]->[1];
}

package DNATag::Set;

use strict;
use warnings;
use List::AllUtils ();

use overload (
    '@{}'      => sub { [ @{$_[0]->{'seq'}} ]; },
    'bool'     => sub {1},
    'fallback' => 1,
);

sub new {
    my $class = shift;
    (@_ > 0) or die 'need some seqs';
    bless {seq => [map { DNATag->new("$_") } @_]}, ref $class || $class;
}

sub all_dual   { List::AllUtils::all { $_->is_dual }    @{$_[0]}  }
sub all_single { List::AllUtils::all { $_->is_single }  @{$_[0]}  }
sub min_length { List::AllUtils::min(map { $_->length } @{$_[0]}) }
sub max_length { List::AllUtils::max(map { $_->length } @{$_[0]}) }
sub min_length_i1 { List::AllUtils::min(map { $_->length_i1 } @{$_[0]}) }
sub min_length_i2 { List::AllUtils::min(map { $_->length_i2 } @{$_[0]}) }

sub for_cycles {
    my $self = shift;
    if (@_ == 2) { return $self->_for_cycles_dual(@_) }
    if (@_ == 1) { return $self->_for_cycles_single(@_) }
    die "expecting 1 or 2 arguments";
}
sub _for_cycles_single {
    my $self = shift;
    my $len1 = List::AllUtils::min( $self->min_length_i1, shift );
    return $self->new( map { substr($_->seq_i1, 0, $len1) } @$self );
}
sub _for_cycles_dual {
    my $self = shift;
    my $len1 = List::AllUtils::min( $self->min_length_i1, shift );
    my $len2 = List::AllUtils::min( $self->min_length_i2, shift );
    return $self->new( map { substr($_->seq_i1, 0, $len1) . '-' . substr($_->seq_i2, 0, $len2) } @$self );
}

1;
__END__

