#!/usr/bin/perl

use Data::Dumper;

# Regexps used through out the code.
my $paired_sqr_braces = qr{\[ .* \] }xms;
my $open_sqr_brace = qr{\]}xms;
my $close_sqr_brace = qr{\]}xms;

# capture a digit pattern like '009..088'
my $leading_zero_range_capture_regex = qr{\A (0+\d+) \.\. (\d+) \z }xms;
my $NO_leading_zero_range_capture_regex = qr{\A ([1-9] \d+) \.\. ([1-9] \d+) \z }xms;


my $DEBUG_DUMPER = 0;

for (@ARGV) {
    print join "\n",  get_name_range($_);
    print "\n";
}


#my $paired_sqr_braces = qr{\[ .* \] }xms;

##############################
##########
# Sun Jun 14 20:41:51 2009
# Was written to handle the case where you have a string like:
# "foo[1,45-49],bar8,baz[19-30]" and split on commas iff it's not between sqr braces.
sub split_comma_outside_square_braces {
    my ($word,
        $in_braces,
        $line_with_range,
        @hold,
        @char_array,
    );
    $line_with_range  = shift @_;

    # split down to one char per element so we can work on it.
    @char_array = split //, $line_with_range;

    # iff we are between braces, add the comma to the word, else it is an element sperator
  COMMA: for my $char (@char_array) {
        if ($char =~ m{ \[ }xms) {
            $in_braces = 1;
        }

        if ($char =~ m{ \] }xms) {
            $in_braces = 0;
        }
        ;

        if ( $char =~ m{ \, }xms && not $in_braces) {
            push @hold, $word;
            undef $word;
            next COMMA;
        } else {
            $word .= $char;
        }


    }

    push @hold, $word;
    undef $word;
    return @hold;
}                               # end sub





##############################
##########
# Sun Jun 14 09:01:27 2009

# takes a range string "foo[23,89]" or "bar[34-50]" or "baz[1..7]" or
# "flurgle[1-5,9,15]" or any combo.
#
# errors out with a useful error message if there are illegal chars in the range.

# example: get_name_range("foo[45-55,13,17,1-5,20..22]");
# returns: foo45 foo46 foo47 foo48 foo49 foo50 foo51 foo52 foo53 foo54 foo55 foo13 foo17 foo1 foo2 foo3 foo4 foo5 foo20 foo21 foo22

# bugs & quirks:
# ] an arguement like "foo[45-90][12-44]" ignores
# everything after the first set of sqr braces.
# ] the is uniquified and sorted.

sub get_name_range {
    my $name_and_range = shift @_;
    my ($name, $range,$tail);
    my @expanded_name_range;
    my @bad_chars;
    my %seen;
    my $junk; 
    #############
    # the intention is to check the range stuff and make sure only
    # these chars can get through: digit, dot or comma.
    my $illegal_chars_regexp = qr{
                                  [^\d \. \, \w ]
                              }sxo; # if you add 'm' if fails -Tony Sun Jun 21 14:12:55 2009

    ############
    # clean up the name and range stuff
    $name_and_range =~ s{\s+}{}g;
    #strip the name from the range
    ($name, $range) = split q{\[}, $name_and_range;
#    ($name, $range,$tail) =  $name_and_range =~ m{\A (\D*) \[ (.*) \] (.*) \z}xms;
    ($junk, $tail) =  split q{\]}, $name_and_range;
    # clear off the trailing sqr brace
    $range =~ s{\].* \z}{}xms;
    # covert any dashs laying around to two dots.
    $range =~ s{\-}{\.\.}xmsg;

    # must not have any chars except the ones defined in the regexp
    # if we match any illegal chars we cant go on.
    if (@bad_chars = $range =~ m{($illegal_chars_regexp)}g ) {

        warn "The range regex $illegal_chars_regexp matched illegal char(s)"
            , " in range $name_and_range \n"
                , "\toffending chars are: [ ", join " ", @bad_chars, "]\n";
        
    }
    else {

        # push the name and number together into a string
        push @expanded_name_range,
            map {
                "$name" . $_ . "$tail" # put the name and range element back together ie the first foo[2..6] is foo2
            }
                #if $range has leading zeros, expand the char range, else
            expand_char_range($range) ;

        # do a unique option to clean up overlap
        my @uniqed = grep !$seen{$_}++, @expanded_name_range;
        #return sort @uniqed;
    }

}



##############################
##########
# Sat Jun 20 17:41:48 2009
# handles the case where its foo[003-008] # leading zeros usually break things.
# "a..c,009-011,1,099-100,67-69" will get
# fooa                    foob                    fooc
# foo009                  foo010                  foo011
# foo1                    foo099                  foo100
# foo67                   foo68                   foo69
sub expand_char_range {
    my $range_string;

    $range_string = shift @_;
    my @expanded_elements;

    my $first_char_is_zero_or_atoz_re = qr{ \A [0] }xso;

    # in case we have a commas just handle it normally
    my @char_ranges = split /,/, $range_string;
   $DEBUG_DUMPER and  warn "range_string: $range_string : \@char_ranges: ", Dumper (\@char_ranges);


    # need to know if it numeric or char
    # need to know if its '0' or '0\d+'

    

    
  CHAR_RANGE: for my $char_range (@char_ranges) {
        ## if this is a singelton, push onto array and next
        $char_range !~ m{\.\.} and do { push @expanded_elements, $char_range; next CHAR_RANGE;};
        my @range_element =  $char_range =~ m{ \A    # beginning of the line
                                               (\w+) # capture a alphanumeric
                                               (?:   # start a non-element returing group
                                                   \.\. # two literal dots
                                                   (\w+) # another alphanumeric
                                               )?       # make the second part optional
                                         }xms ; ##TODO fixing this up for

    # to handle all reasonalbe combos of range operators we have to do some checking.
    # if the leading char of range is 0 (zero) or a letter - they have to be expanded
    # differently. -T Sun Jun 21 14:39:08 2009

        # has a zero then at least 1 other digit
        my $has_leading_zero = $range_element[0] =~ m{\A 0\d+}xs;
        # has one or more chars
        my $is_char = $range_element[0] =~ m{\A \D+}xs;
        # a..f and 00..99 have to be handled as strings.
        if ( $has_leading_zero || $is_char ) {

            # make sure the ranges are padding the same length. ie 003..4567 is illegal.
             if (length $range_element[0] == length $range_element[-1]) {
                $DEBUG_DUMPER and warn "GOOD: this is a valid range: $char_range\n";
                # CORRECT way, below is a very bad way.
                push @expanded_elements, ("$range_element[0]".."$range_element[-1]");
                # found this bad thing after 2 years! really dumb way
                # to do this. -T Wed May  4 21:46:18 2011

                #while string-wise lessthan-or-equal to
                # each other while ( $range_element[0] le
                # $range_element[-1] ) {
                #     # collect the elements and increment to the next one.
                #     push @expanded_elements, $range_element[0]++;
                # }
            }
             else {
                warn "WARN: char range [ $char_range ] dont have equal fields\n";
            }
        }
        else {
            # if this is normal range of numbers just eval them norallmy
            $DEBUG_DUMPER and warn "evalling char range $char_range: ", Dumper (eval $char_range);
            # for some reason, its not expanding for "a..b" -T Sun Jun 21 18:10:15 2009 
            
            push @expanded_elements, eval $char_range;
        }

    }
    $DEBUG_DUMPER and warn "\@expanded_elements: ", Dumper (\@expanded_elements);

    return @expanded_elements;
}

#end sub



#############
# expand @NODES and @EXCLUDE with args like " -w moz[90-91] -w bar[34-45,1],baz"
# so they come out like:
# moz90   moz91   bar1    bar34   bar35   bar36
# bar37   bar38   bar39   bar40   bar41   bar42
# bar43   bar44   bar45   baz
sub expand_nodes_with_regions {
    
for my $arref (@_) {
    my @tmp; # just an area to run string thru
    my @hold_list; # gets assigned to array ref when were done
    for (@$arref) {

        if ( m{ $paired_sqr_braces }xms) {
            push @tmp, split_comma_outside_square_braces("$_");
            for (@tmp) {
                if (  m{ $paired_sqr_braces }xms  ) {
                    # has sqr braces, needs special handeling
                    push @hold_list, get_name_range($_);
                } else {
                    # plain no brace name.
                    push @hold_list, $_;
                }
            }
        }
        else {
            # if no paired braces treat normally.
            push @hold_list, split( /,/,  $_ )  ;
        }
    }
    # assign the expanded @hold_list to the original array
    @$arref = @hold_list;
}

} # end sub expand_nodes_with_regions
######## end of file range_subs.pm ############
