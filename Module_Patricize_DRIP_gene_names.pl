#!/usr/bin/perl
use List::MoreUtils qw(uniq);

open(IN,'synchronization');
while (<IN>)
{
    chomp;
    if (/ /)
    {
	@array=split(' ',$_);
	$gene1=$array[0];
	foreach $gene2 (@array)
	{
	    if ($gene2 ne $gene1)
	    {
		push(@{$synonym{$gene1}},$gene2);
	    }
	}
    }
}
close(IN);

open(PATOU,'Comparison_array_seq.dat');
while(<PATOU>)
{
    chomp;
    if ($_ !~ /^#/)
    {
	s/\t.*//;
	s/\/.*//; #To keep just one gene name from Patricia's data
	push(@Patou_names,$_);
    }
}
close(PATOU);

foreach $file ('Higher_in_KD','Lower_in_KD')
{
    open(OUT,">Patricized_DRIP_$file".".tsv");
    open(OTHER,'Annotated_'.$file.'.tsv');
    while (<OTHER>)
    {
	chomp;
	if ($_ ne 'Gene name	Refseq Name (hg19)	Log2 Fold')
	{
	    @array=split('\t',$_);
	    $names=$array[0];
	    $downstream=join("\t",$array[1],$array[2]);
	    @name_array=split(' ',$names);
	    $replacements='';
	    foreach $name (@name_array)
	    {
		$replacement=$name.'_UNMATCHED';
		if (grep {$_ eq $name} @Patou_names)
		{
		    $replacement=$name;
		}
		else
		{
		    foreach $gene (@Patou_names)
		    {
			if (grep {$_ eq $name} @{$synonym{$gene}})
			{
			    $replacement=$gene;
			}
		    }
		}
		$replacements=$replacements.' '.$replacement;
	    }
	    $replacements=~s/^ *//;
	    print OUT "$replacements\t$downstream\n";
	}
	else
	{
	    print OUT "$_\n";
	}
    }
    close(OTHER);
    close(OUT);
}
