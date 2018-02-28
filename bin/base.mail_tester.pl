#!/usr/bin/env perl


BEGIN {
  use Env;


}

use Shell(date);
use Getopt::Std; # MUST use getopts() with this!

use Env;
use Expect;
use Time::HiRes qw(usleep ualarm gettimeofday tv_interval time);



##############################
##########
# Tue Oct 19 11:16:10 2004
#
$DEFAULT_TO = "precept\@gmail.com";
$DEFAULT_ORIGIN =  "pivotal.io";
$DEFAULT_FROM =  "thansmann" . "\@" . "$SMTP_ORIGIN";
$DEFAULT_SMTP_SERVER = "aspmx.l.google.com";
$DEFAULT_PORT = 25;

# setsome vars in our package.

$pound="#";


$ID = "thansmann";
$host="saucer";

# get the date to show in the email body.
$date = localtime();

# get the start date in seconds format
$second_since_1970 = time;

getopts('ht:o:f:s:p:c:');

if ($opt_h) {
usage();
exit 1;
}

# need to get this from the commandline: -t
$MAIL_TO = $opt_t || "precept\@gmail.com";

# need to get this from the commandline: -o
$SMTP_ORIGIN = $opt_o || "pivotal.io";

# need to get this from the commandline: -f
$MAIL_FROM = "$opt_f\@$SMTP_ORIGIN" || "thansmann\@$SMTP_ORIGIN";

# need to get this from the commandline: -s
$SMTP_SERVER = $opt_s || "aspmx.l.google.com";

# need to get this from the commandline: -p
$SMTP_PORT = $opt_p || "25";

if ($opt_c) {
  $commnandline_comment = "Commandline comment:\r[\r$opt_c\r]";
}


##############################
##########
# Tue Oct 12 15:25:19 2004
#
$E=Expect->spawn("/usr/bin/telnet $SMTP_SERVER $SMTP_PORT");


$E->expect(140,"220 ") || die "no mail prompt at $SMTP_SERVER port $SMTP_PORT\n";

$E->send_slow(.00009,"HELO $SMTP_ORIGIN\r");
$E->expect(10,"250 ") || die "no 250 prompt\n";
$E->send_slow(.00009,"MAIL From:<$MAIL_FROM>\r");
$E->expect(10,"250 ") || die "no 250 ok prompt\n";
$E->send_slow(.00009,"RCPT To:<$MAIL_TO>\r");
$E->expect(10,"250 ") || die "no 250 ok prompt\n";
$E->send_slow(.00009,"DATA\r");
$E->expect(10,"354 ") || die "no 354 go ahead prompt\n";
$E->send_slow(.000009,
	      "From: $MAIL_FROM\r",
	      "To: $MAIL_TO\r",
	      "X-perl-expect-mail-debugger:\r",
	      "Subject: $SMTP_SERVER testing at $date\r",
	      "Date: $date -0800\r",
	      "Mime-Version: 1.0\r",
	      "Content-Type: text/plain; charset=US-ASCII\r",
	      "Content-Transfer-Encoding: 7bit\r",
	      "\r"
);


$E->send_slow(.000009,"Mail testing\r$date\r
This mail is:\rto: $MAIL_TO\r
from: $MAIL_FROM\r
mail server originally delivered to: $SMTP_SERVER on port: $SMTP_PORT\r
$commnandline_comment
.\r");




# measure elapsed time
# (could also do by subtracting 2 gettimeofday return values)
$t0 = [gettimeofday];

$E->expect(17,-re,"250 |451 ") || warn "no 250 ok prompt\n";

$t1 = time();

$E->hard_close();

$t0_t1 = tv_interval ($t0, [$t1]);

print "time in seconds from sending smtp daemon dot to getting the 250 ok:\n",
"\t", "$t0_t1\n";
# next host



sub usage  {

print qq/$0 valid options are:
   -t "user@domain.com" who to send mail to (default $DEFAULT_TO)
   -o "origin_domain.com" the domain this mail should appear to be from.
 	(default $DEFAULT_ORIGIN)
   -f "sending_userid" account mail is coming from - please don't include the 
      "\@domain.com" part (default $DEFAULT_FROM)
   -s "mx.host.domain.com" connect to this SMTP host and deliver mail
	(default $DEFAULT_SMTP_SERVER)
   -p "2025" port where MTA is running on SMTP host. Usually does not need to be set 
	(default $DEFAULT_PORT)
   -c "put a comment that will appear in the message body here."
/;

} # end usage

