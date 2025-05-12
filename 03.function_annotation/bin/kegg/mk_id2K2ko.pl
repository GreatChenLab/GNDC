#!/usr/bin/perl 
use strict;
#by Yicheng yang
#date 2021-4-8
die "perl $0 <kegg.xls> /home/user/fanpengyu/03.data/database/kegg/KoPathways.txt > <id2K2ko.txt> \n" unless @ARGV == 2;


print "SeqID\tK_num\tko_num\n";

open KOPATH,"<$ARGV[1]"||die;

my %hash_kopath;
while(<KOPATH>){
	chomp;
	my @a = split("\t",$_);
	if(exists $hash_kopath{$a[0]}){$hash_kopath{$a[0]}="$hash_kopath{$a[0]}\t$a[1]";}else{$hash_kopath{$a[0]}=$a[1];}
}
close KOPATH;

open FA,"<$ARGV[0]"||die;
<FA>;
my %hash_accession;
while(<FA>){
	chomp;
	my @a = split("\t",$_);
	if(exists $hash_accession{$a[0]}){$hash_accession{$a[0]}="$hash_accession{$a[0]}\t$a[1]";}else{$hash_accession{$a[0]}=$a[1];}
}
close FA;

foreach my $id (sort keys %hash_accession){
	my @a = split("\t",$hash_accession{$id});
	foreach my $i (@a) {
		my @b = split("\t",$hash_kopath{$i});
		foreach my $j (@b) {
			print "$id\t$i\t$j\n";
		} 
	}
}

