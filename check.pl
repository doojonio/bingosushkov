#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

my %tickets;
open my $fh, '<', 'tickets';
my $curtname;
while (my $string = <$fh>) {
    if ($string =~ /^ticket#\d+/i) {
        $curtname = $&;
        $tickets{$curtname} = [];
        next;
    }
    my @numbers = split /[,\n]/, $string;
    push @{$tickets{$curtname}}, @numbers;
}
close $fh;

open $fh, '<', 'numbers';
my @numbers;
while (my $string = <$fh>) {
    my @strnumb = split /[,\n]/, $string;
    push @numbers, @strnumb;
}
close $fh;

while (my ($ticket, $tnum) = each %tickets) {
    my @remaining;
    for my $num (@$tnum) {
        push @remaining, $num if !scalar(grep { $_ == $num } @numbers);
    }
    my $n_rem = @remaining;
    my $n_all = @$tnum;
    say '---' x 10;
    say "$ticket: $n_rem of $n_all";
    say join ',', @remaining;
}
