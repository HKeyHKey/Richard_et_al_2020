#!/usr/bin/perl

open(IN,$ARGV[0]);
while (<IN>)
{
    chomp;
    push(@orphan,$_);
}
close(IN);

foreach $gene_name (@orphan)
{
    $code=`wget -O dwnld http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=gene\\&term="$gene_name"[gene]Homo+sapiens[orgn];grep '^<Id>' dwnld | sed -e 's|^<Id>||' -e 's|</Id>||';sleep 0.5`;
    chomp $code;
    $ID{$gene_name}=$code;
    push(@{$name_for_ID{$code}},$gene_name);
}


foreach $gene_name (@orphan)
{
    print $gene_name;
    foreach $synonym (@{$name_for_ID{$ID{$gene_name}}})
    {
	if ($synonym ne $gene_name)
	{
	    print " $synonym";
	}
    }
    print "\n";
}
