#!/usr/bin/perl -w

#use lib 'c:/cygwin/lib/perl5/5.26';
use strict;
use warnings;

#my $bdir="c:/users/mark/videos/astro/meteorcam";
my $bdir="/mnt/c/Users/Mark/Videos/Astro/MeteorCam";
my $outdir="$bdir"."/csv";

sub ltrim { my $s = shift; $s =~ s/^\s+//;       return $s };
sub rtrim { my $s = shift; $s =~ s/\s+$//;       return $s };
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

# function to strip out the value-fields only from each row
sub mungerow {
   my $inprow = $_[0];
   my $oprow='';
   my $a=1;
   my $b=0;
   while ($a>0) {
   	$a = index($inprow, '"', $b+1);
   	$b = index($inprow, '"', $a+1);
   	if ($a<0) {
   	   $oprow = $oprow.'""';
   	   goto DONE;
   	}
   	$oprow = $oprow.','.substr($inprow,$a+1, $b-$a-1);
   }  
   DONE:
   return $oprow;
}

# function to read the TCA file and extract the parameters

sub doafile {
    my $dir=$_[0];
    my $doneone=$_[2];
    my $ofname="$outdir/$_[1].csv";
    my @files=glob($dir . '/*TCA.XML');
    foreach (@files) {
	my $want=0;
	my $filename = $_;
	my $dname="";
	my $dname2="";
	my $frow="";
	my $fh2;
	my $objno=1;
	
	open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open file '$filename' $!";
	while (my $row = <$fh>) {
	   chomp $row;
	   $row=trim($row);
	   if (substr($row,0,9) eq 'clip_name') {
	   	$dname2=substr($row,11,16);
	   }
	   if (substr($row, 0,12) eq '<ua2_objpath' ){
	   	$want=0;
	   	if ($doneone==0) {
	   	  open ($fh2,'>',$ofname);
	   	  $doneone=1;
	   	}else{
	   	  open ($fh2,'>>',$ofname);
	   	}
	   	$dname=$dname2."_".$objno;
	   	$objno++;
#	   	print "$dname"."$frow\n";
		my $nrow = mungerow($frow);
	   	print $fh2 "$dname$nrow\n";
	   	close $fh2;
	   	$frow="";
	   }
	   if (substr($row, 0,11) eq '<ua2_object' ){
	   	$want=2;
	   }
	   if ($want==1) {
	   	$row =~ s/\" /\",/g;
	   	$row=trim($row);
	   	$row =~ s/\>/\n/g;
	   	$row =~ s/\n//g;
		$frow=$frow . $row . ",";
	   }
	   if ($want==2){
	      $want=1;
	   }
	}
	close $fh;
    }
    return $doneone;
}

#function to read the TC.txt file and extract the std dev of the AV

sub dotxtfile {
    my $dir=$_[0];
    my $doneone=$_[2];
    my $ofname="$outdir/$_[1]_av.csv";
    my @files=glob($dir . '/*TC.txt');
    foreach (@files) {
	my $want=0;
	my $filename = $_;
	my $dname="";
	my $dname2="";
	my $frow="object=\"";
	my $fh2;
	my $sdval=-1;
	my $objno=1;
	
	open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open file '$filename' $!";
	while (my $row = <$fh>) {
	   chomp $row;
	   $row=trim($row);
	   if (substr($row,0,3) eq '[ M') {
	   	$dname2=substr($row,2,16);
	   	$dname=$dname2."_".$objno;
	   	$objno++;
	   }
	   if (substr($row,0,3) eq '[ V') {
	   	$dname=$dname2."_".$objno;
	   	$objno++;
	   }
	   
	   if (substr($row, 0,4) eq '====' ){
	   	$want=0;
	   	if ($doneone==0) {
	   	  open ($fh2,'>',$ofname);
	   	  $doneone=1;
	   	}else{
	   	  open ($fh2,'>>',$ofname);
	   	}
#	   	print "$dname,$sdval\n";
	   	print $fh2 "$dname,$sdval\n";
	   	close $fh2;
	   }
	   if ($row eq 'Angular Velocity (Minmum square Method)') {
	   	$want=2;
	   }
	   if ($want==1) {
	   	my $lv= index $row, 'sd=';
	   	$lv=$lv+3;
	   	my $rv= index $row, ')';
	   	$sdval=substr($row, $lv, $rv-$lv);
		$want=0;
	   }
	   if ($want==2){
	      $want=1;
	   }
	}
	close $fh;
    }
    return $doneone;
}

# start of main routine
my $min=0; my $mon=0; my $year=0;

my $yyyymm='201712';
if($#ARGV>=0){
   $yyyymm=$ARGV[0];
} 

$year=substr($yyyymm, 0,4);
$mon=substr($yyyymm,4,2);

print("Processing $yyyymm\n");
my $doneone=0;
my $dd=1;
for ($dd=1; $dd< 32 ; $dd++){
   my $ds=sprintf("%02d", $dd);
   my $dir=$bdir . "/$year/$year$mon/$year$mon$ds";
   my $ofn=sprintf("%04d%02d", $year, $mon);
   $doneone=doafile($dir, $ofn, $doneone);
}
$dd=1;
$doneone=0;
for ($dd=1; $dd< 32 ; $dd++){
   my $ds=sprintf("%02d", $dd);
   my $dir=$bdir . "/$year/$year$mon/$year$mon$ds";
   my $ofn=sprintf("%04d%02d", $year, $mon);
   $doneone=dotxtfile($dir, $ofn, $doneone);
}
