#! /usr/bin/perl
#
die ("perl $0 <kobas.anno> <KOMAP> <PATHWAY_INFO> <kegg.txt> <pathway.txt>") unless $#ARGV==4;

open (KOMAP, $ARGV[1]);
open (KO, $ARGV[0]);
open (PATHINFO, $ARGV[2]);
open KEGG, ">$ARGV[3]";
open PATHWAY, ">$ARGV[4]";

my %map;
while (<KOMAP>){
        chomp;
        my @a=split(/\t/, $_);
        $map{$a[0]}{$a[1]}=1;
}
close KOMAP;

my %path;

while (<PATHINFO>){
	chomp;
	my @a=split(/\t/,$_);
	$path{$a[2]}="$a[0]\t$a[1]\t$a[3]";
}
close PATHINFO;

print KEGG "seq_id\taccession\tannotation\n";
print PATHWAY "seq_id\tA\tB\tC\tpathway_id\n";

while (<KO>){
        chomp;
        next if (/^#/);
        my @a=split(/\t/, $_);
        if ($a[1]=~ /^(K\d+)\|(.+?)\|/){
                my $knumber=$1;
                my %KO=%{$map{$knumber}};
				print KEGG "$a[0]\t$knumber\t$2\n";
                foreach (keys %KO){
			print PATHWAY "$a[0]\t$path{$_}\t$_\n";
        		}
        }

}

close KO; close KEGG; close PATHWAY;
