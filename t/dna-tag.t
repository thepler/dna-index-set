
use strict;
use warnings;
use Test::More;

use DNATag;

my $t;

$t = DNATag->new('ACGTCC');
isa_ok($t, 'DNATag');
is("$t", 'ACGTCC', 'stringifies');
ok($t->is_single, 'single');
ok(!$t->is_dual, 'not dual');

$t = DNATag->new('AACAAAAC-AACAAAAC');
isa_ok($t, 'DNATag');
is("$t", 'AACAAAAC-AACAAAAC', 'stringifies');
ok(!$t->is_single, 'not single');
ok($t->is_dual, 'dual');
is(substr("$t", 0, 6), 'AACAAA', 'substr works');

my $ts;

$ts = DNATag::Set->new(qw(
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
isa_ok($ts, 'DNATag::Set');

ok($ts->all_dual, 'all dual');
ok(!$ts->all_single, 'not all single');
is($ts->min_length, 16, 'min_length');
is($ts->max_length, 16, 'max_length');

$ts = DNATag::Set->new(qw(
    AACAAAAC-AACAAAAC
    GTACTT
));
isa_ok($ts, 'DNATag::Set');

ok(!$ts->all_dual, 'not all dual');
ok(!$ts->all_single, 'not all single');
is($ts->min_length, 6, 'min_length');
is($ts->max_length, 16, 'max_length');

$ts = DNATag::Set->new(qw(
    AACAAA
    GTACTT
));
isa_ok($ts, 'DNATag::Set');

ok(!$ts->all_dual, 'not all dual');
ok($ts->all_single, 'all single');
is($ts->min_length, 6, 'min_length');
is($ts->max_length, 6, 'max_length');



done_testing();

