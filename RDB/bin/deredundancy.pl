#! /usr/bin/perl

die "perl $0 <raw.fa> <prefix> <out.fa>" unless @ARGV==3; 

my $f = shift;
my $prefix = shift;
my $outfile = shift;

if($f=~/gz$/){
	open IN, "gzip -dc $f|" || die "$!\n";
}else{
	open IN, $f || die "$!\n";
}

open OUT, ">$outfile" || die "$!\n";
 
my @seq;
while (<IN>)
{ chomp;
  next if ($_=~/^>/);
  push(@seq,$_);
}

my $hash;
foreach (@seq)
{  $hash{$_}+=1;}

my @keys = keys %hash;
my @value = values %hash;
my $len=scalar(@keys);

for (my $i=0;$i<$len;$i++)
{  my $num=$i+1;
   print OUT ">$prefix\_$num\_x$value[$i]\n$keys[$i]\n";}

close IN;
close OUT;

