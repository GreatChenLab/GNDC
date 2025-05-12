#!/usr/bin/perl 
use strict;
#by Yicheng yang
#date 2021-3-16
die "perl $0 <kegg.xls> <pathway.xls> > <ko2id.txt> \n" unless @ARGV == 2;


print "seq_id\tK_num\tpathway\n";

open FA,"<$ARGV[0]"||die;
<FA>;
my %hash_accession;
while(<FA>){
	chomp;
	my @a = split("\t",$_);
	push @{$hash_accession{$a[0]}},$a[1];
}
close FA;

open BLAST,"<$ARGV[1]"||die;
my %hash_pathway;
<BLAST>;
while(<BLAST>){
	chomp;
	my @list =split("\t",$_);
	push @{$hash_pathway{$list[0]}},$list[-1];
}
close BLAST;

foreach my $id (sort keys %hash_accession){
	foreach my $i (@{$hash_accession{$id}}) {
		foreach my $j (@{$hash_pathway{$id}}) {
			print "$id\t$i\t$j\n";
		} 
	}
}

