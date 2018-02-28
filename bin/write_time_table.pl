#!/bin/perl
# Author: Tony Hansmann
#
$TB = 10**12;
$Tb = 8 * $TB;



$GB = 10**9;
$Gb = 8 * $GB;

$MB = 10**6;
$Mb = 8 * $MB;

$KB = 10**3;
$Kb = 8 * $KB;



sub time_to_write ($$){
   ( $data_size, $data_rate) =  @_;
    $time_to_write =  $data_size /  $data_rate ;
    
    print "Seconds: ", $time_to_write, " Min: ", $time_to_write/60, "Hours: ", $time_to_write / 3600, "\n";
}


for $j (3 , .480) {
    for $i (1..20) {
        print "\$i $i || \$j $j\n";
        $x = ($i * $Tb);
        $y = $j * $Mb;

#                print "\$i $i || \$j $j || \$x: $x || \$y: $y  \n";
        time_to_write( $x , $y  );
        
    }
}
