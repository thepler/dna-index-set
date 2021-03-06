
use strict;
use warnings;
use Test::More;

use Bio::NGS::DNAIndexSet;

sub new_set { Bio::NGS::DNAIndexSet->new(@_) }

my ($ts, $fc);

$ts = new_set(qw(AAAAAAAA-CCCCCCCC GGGGGGGG-TTTTTTTT));
isa_ok($ts, 'Bio::NGS::DNAIndexSet');
ok($ts->all_dual, 'all dual');
$fc = $ts->for_cycles(6);
is($fc->[0], 'AAAAAA', 'for_cycles single recipe, dual indexes');
is($fc->[1], 'GGGGGG', 'for_cycles single recipe, dual indexes');
$fc = $ts->for_cycles(8,8);
is($fc->[0], $ts->[0], 'for_cycles dual recipe, dual indexes');
is($fc->[1], $ts->[1], 'for_cycles dual recipe, dual indexes');
$fc = $ts->for_cycles(2,5);
is($fc->[0], 'AA-CCCCC', 'for_cycles dual recipe, dual indexes shortened');
is($fc->[1], 'GG-TTTTT', 'for_cycles dual recipe, dual indexes shortened');

$ts = new_set(qw(AACAAAAC-AACAAAAC GTACTT));
isa_ok($ts, 'Bio::NGS::DNAIndexSet');
ok(!$ts->all_dual, 'not all dual');
ok(!$ts->all_single, 'not all single');
is($ts->min_length, 6, 'min_length');
is($ts->max_length, 16, 'max_length');
$fc = $ts->for_cycles(6);
is($fc->[0], 'AACAAA', 'for_cycles single recipe, mixed indexes');
is($fc->[1], 'GTACTT', 'for_cycles single recipe, mixed indexes');
$fc = $ts->for_cycles(8);
is($fc->[0], 'AACAAA', 'for_cycles single recipe, mixed indexes');
is($fc->[1], 'GTACTT', 'for_cycles single recipe, mixed indexes');
$fc = $ts->for_cycles(8,8);
is($fc->[0], 'AACAAA', 'for_cycles single recipe, mixed indexes');
is($fc->[1], 'GTACTT', 'for_cycles single recipe, mixed indexes');


# beyond here is more speculative
# may not need to be part of the public API

my $t;

$t = Bio::NGS::DNAIndex->new('ACGTCC');
isa_ok($t, 'Bio::NGS::DNAIndex');
is("$t", 'ACGTCC', 'stringifies');
ok($t->is_single, 'single');
ok(!$t->is_dual, 'not dual');

$t = Bio::NGS::DNAIndex->new('AACAAAAC-AACAAAAC');
isa_ok($t, 'Bio::NGS::DNAIndex');
is("$t", 'AACAAAAC-AACAAAAC', 'stringifies');
ok(!$t->is_single, 'not single');
ok($t->is_dual, 'dual');
# TODO: make this work without ""?
is(substr("$t", 0, 6), 'AACAAA', 'substr works');

$ts = new_set(qw(
    AACAAAAC-AACAAAAC
    AGATAGTT-AGATAGTT
    CTATACTT-CTATACTT
    ACATCTGT-ACATCTGT
    CCTTAGGT-CCTTAGGT
    TACAGCAC-TACAGCAC
    ACAAACCG-ACAAACCG
    CGCTCATT-CGCTCATT
    GCCTTAGA-GCCTTAGA
    CGTACGTA-CGTACGTA
    CTAGCTAC-CTAGCTAC
    ACGATATT-ACGATATT
    ATTCCTTT-ATTCCTTT
    ATAATTGA-ATAATTGA
    TATAGCCT-TATAGCCT
    CAACTACA-CAACTACA
    AACTTGAT-AACTTGAT
    GTACTGAC-GTACTGAC
    ATTCAGAA-ATTCAGAA
    AACCCCTT-AACCCCTT
));
isa_ok($ts, 'Bio::NGS::DNAIndexSet');

ok($ts->all_dual, 'all dual');
ok(!$ts->all_single, 'not all single');
is($ts->min_length, 16, 'min_length');
is($ts->max_length, 16, 'max_length');

$ts = new_set(qw(AACAAA GTACTT));
isa_ok($ts, 'Bio::NGS::DNAIndexSet');

ok(!$ts->all_dual, 'not all dual');
ok($ts->all_single, 'all single');
is($ts->min_length, 6, 'min_length');
is($ts->max_length, 6, 'max_length');

done_testing();

