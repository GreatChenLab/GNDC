#!/usr/bin/perl -w
use strict;
die "perl $0 <mirdeep2.csv> >miRNA.table\n" unless @ARGV==1;
my $in = shift;

my $flag = 0;
open IN, $in || die ;
print "#id\tmature-5p\tmature-3p\tprecursor\tArm_domination\tLocation\tmiRDeep2_score\n";
while(<IN>){
    chomp;
    next if (/^\s*$/);
    if (/^provisional id/){
        $flag = 1;
        next ;
    }
    if($flag == 1){
        my @t = split /\t/,$_;
        my $id   = $t[0];
        my $mat  = $t[13];
        my $sta  = $t[14];
        my $pre  = $t[15];
        my $pos  = $t[16];
        my $score = $t[1];
        my ($p, $p5, $p3);
        if($pre =~ /^$mat/){
            $p  = "5p";
            $p5 = $mat;
            $p3 = $sta;
        }
        elsif($pre =~ /$mat$/){
            $p  = "3p";
            $p5 = $sta;
            $p3 = $mat;
        }
        print "$id\t$p5\t$p3\t$pre\t$p\t$pos\t$score\n";
    }
}
close IN;

