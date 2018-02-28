#!/usr/bin/perl
use Data::Dumper;

## TODO: echo $(echo "foo1" ; range.pl  foo-[00100-00110])|rangify.pl
#### this is broken

$DEBUG = 0;
# regexp to test for leading zero

my $grab_leading_zeros_regexp = qr{ \A (0+) }xos;

# steming, get 3 values: all non-digits, then all digits, then the tail
my $stem_and_number_regexp = qr{(\D+)(\d+)? (.*)? }xso;
for (<>) {
    chomp;
    my $zero_pad;
    my ($stem, $number, $tail) = m{$stem_and_number_regexp};

    # skip blank lines
    next if m{^$}xms;
    # take values like foo-93-prod and make the hash key 'foo-&-prod'
    my $key = "$stem" . q{&} . "$tail";
    $DEBUG && print "key: $key :: number [ $number ]\n";
    if ($number) {
        if ($number =~ m{$grab_leading_zeros_regexp}xso) {
            push @{ $h{$key}{'zero_padded_range'}{length $number} }, $number;
        } else {
            push @{ $h{$key}{'range'}{length $number} }, $number;
        }
    } else {
        # line with no number in it.
        $h{$key}{'no_number'}++;
    }
}                               # end of for (<>)

$DEBUG && print "The entire hash: ", Dumper(\%h);


for my $key (keys %h) {
    my($stem,$tail) = split q{&}, $key;
    my $range_output_string;
    my @range_string;
    my $leading_zero_hashref = \$h{$key}{'zero_padded_range'};
    my $non_leading_zero_hashref = \$h{$key}{'range'};
    
    my %zz;
    # make %zz and unique key'd list of digit ranges 
    map {  $zz{$_}++ }  keys  %{ $$leading_zero_hashref }, keys  %{ $$non_leading_zero_hashref };
    my @all_widths = sort { $a <=> $b } keys %zz;
    
    # # cation double deref here -T Sun Sep 20 17:17:05 2009
    for my $width (@all_widths) {
        push @range_string, join(q{,} , scalar  Range_Simple::number_rangify(
            @{$$leading_zero_hashref->{$width}},
            @{$$non_leading_zero_hashref->{$width}}
        )
                              );
    }    

    if ($h{$key}{'no_number'}) {
        print "$stem" . "$tail" . "\n";
    }

    if (@range_string) {
        print "${stem}"
            . "["
                . join(q{,} , @range_string)
                    . "]"
                        . "$tail"
                            . "\n";
    }
}



=pod

Complex data structure to represent the type of things you see
in human generated lists.

I'm trying to solve cases where an org start a naming scheme like
foo-1, foo-2...foo-36 and then decides to move to foo-00037.... Which
is what my org did.

This will allow you to represent any stem and tail combo with any
wonky numbering system between and can cope with it when someone
changes it on the fly.

bar-[1-3,01-03,001-003]-baz
foo-[9-11]
The %h hash: {
   'bar-&-baz' => {
        'zero_padded_range' => {
                     '3' => [
                              '001',
                              '002',
                              '003'
                            ],
                     '2' => [
                              '01',
                              '02',
                              '03'
                            ]
                   },
        'range' => {
                     '1' => [
                              '1',
                              '2',
                              '3'
                            ]
                   }
      },
   'foo-&' => {
           'range' => {
                   '1' => [
                            '9'
                          ],
                   '2' => [
                            '10',
                            '11'
                          ]
                      }
         }
      };



Also covers the case like "uru, uru2..."
The entire hash: $VAR1 = {
          'uru&' => {
                      'no_number' => 1,
                      'range' => {
                                   '1' => [
                                            '2'
                                          ]
                                 }
                    }
        };




=cut

#!/usr/bin/perl
# Author: Tony Hansmann

$VERSION = '0.95'; $UPDATED = "Sat Oct 30 13:47:36 2010" ;

#package String::Range;
package Range_Simple;
use base qw(Exporter);
use Data::Dumper;
use Exporter 'import'; # gives you Exporter's import() method directly

my @EXPORT_OK = qw(
    number_rangify
    number_rangify2
    sort_and_uniquify
    list_cook_down
    split_comma_outside_square_braces
    get_name_range
    expand_char_range
    expand_nodes_with_regions
    $VERSION
    $UPDATED
    ) ;

our @EXPORT = qw(
    number_rangify
    number_rangify2
    sort_and_uniquify
    list_cook_down
    split_comma_outside_square_braces
    get_name_range
    expand_char_range
    expand_nodes_with_regions
    $VERSION
    $UPDATED
    ) ;

#our @EXPORT = qw(number_rangify number_rangify2 sort_and_uniquify list_cook_down);


use strict;
use Carp;

my $DEBUG_DUMPER;
my $DEBUG;
my $paired_sqr_braces = qr{\[ .* \] }xms;
my $open_sqr_brace = qr{\]}xms;
my $close_sqr_brace = qr{\]}xms;



###### make this the main worker function -T Sat May  8 11:01:09 2010

##### b Range_Simple::list_cook_down
sub list_cook_down {

    # regexp to test for leading zero
    my $grab_leading_zeros_regexp = qr{ \A (0+) }xos;

    # steming, get 3 values: all non-digits, then all digits, then the tail



    my $stem_and_number_regexp = qr{(\D+)(\d+)? (\D+)? }xso;
    my $DEBUG = 0;

    my @return_arr;
    my @unprocessed_return_array ;
    my $list_aref = shift @_;
    my %h;

    for (@{$list_aref}) {
        chomp;
        # skip blank lines
        next if m{^$}xms;
        my $digit_group_count = count_digit_groups($_) ;
        # check here for strings we can't rangify -T Tue Oct 19 13:30:23 2010
        if ( $digit_group_count != 1 ) { # we can only do one right now. -T Tue Oct 19 13:43:12 2010
            push @unprocessed_return_array, $_;
            next;
        }
        else {
            my $zero_pad;
            # make sure these get a value 
            my ($stem, $number, $tail) = ('', '', '');
            ($stem, $number, $tail) = m{$stem_and_number_regexp};


            # take values like foo-93-prod and make the hash key 'foo-&-prod'

            my $key = $stem
                . q{&}
                    . ($tail ? $tail : ''); # ugly test to quite strict -T
            $DEBUG && print "key: $key :: number [ $number ]\n";
            if ($number) {
                if ($number =~ m{$grab_leading_zeros_regexp}xso) {
                    push @{ $h{$key}{'zero_padded_range'}{length $number} }, $number;
                } else {
                    push @{ $h{$key}{'range'}{length $number} }, $number;
                }
            } else {
                # line with no number in it.
                $h{$key}{'no_number'}++;
            }
        } # end else
    }                       # end of for (@{$list_aref})

    

        $DEBUG && print "The entire hash: ", Dumper(\%h);


        for my $key (sort keys %h) {
            my($stem,$tail) = split q{&}, $key;
            my $range_output_string;
            my @range_string;
            my $leading_zero_hashref = \$h{$key}{'zero_padded_range'};
            my $non_leading_zero_hashref = \$h{$key}{'range'};
    
            my %zz;
            # make %zz and unique key'd list of digit ranges 
            map {  $zz{$_}++ }  keys  %{ $$leading_zero_hashref }, keys  %{ $$non_leading_zero_hashref };
            my @all_widths = sort { $a <=> $b } keys %zz;
    
            # # cation double deref here -T Sun Sep 20 17:17:05 2009
            for my $width (@all_widths) {
                push @range_string, join(q{,}
                                             , scalar number_rangify(
                                                 @{$$leading_zero_hashref->{$width}},
                                                 @{$$non_leading_zero_hashref->{$width}}
                                             )
                                         ); # end join
            }    

            if ($h{$key}{'no_number'}) {
                push @return_arr, , $stem . $tail;
                # print "$stem" . "$tail" . "\n";
            }

            if (@range_string) {
                push @return_arr, "${stem}"
                    . "["
                        . join(q{,} , @range_string)
                            . "]"
                                . "$tail";


            }
        } # end for my $key(sort keys %h)


    if (@unprocessed_return_array) {
        push @return_arr, sort @unprocessed_return_array;
    }
    return wantarray ? @return_arr : join(' ', @return_arr);
}                       # end list_cook down sub
## not cleaned up yet Sat May  8 10:59:24 2010
###### 




sub test_rangify {
    # sorted right now - will have to do that in the future
    # will need to uniquifed too
    my @a = qw(777 22 666 0 1 2 23 555 9993 5 888 7 8 10 24 444 14 15 16 20 21 889 890 44 77 88 99 111 222 33 25 333 );

    print "raw range:\n", join(' ', @a), "\n";
    my @b = sort_and_uniquify(@a);
    print "sorted uniqrange:\n", join(' ', @b), "\n";
    my @cooked_ranges = number_rangify(@b);
    print scalar number_rangify(@b), "\n";
}


##############################
##########
# doing some cleanup Sat Oct 30 18:52:49 2010 -T
#
sub sort_and_uniquify {
    if (! grep { m{\d|\w} } @_) {
        return '';
    }
    my @messy_numbers = @_;
    my %unique_key;
    my @sorted_uniquified_numbers;
    #my @AA;
    for (@messy_numbers) {
        $unique_key{$_}++;
    }
    @sorted_uniquified_numbers = sort { $a <=> $b} keys %unique_key;

#    map { push @{$AA[length $_]}, $_ } @sorted_uniquified_numbers;

    wantarray ? @sorted_uniquified_numbers : join(',',  @sorted_uniquified_numbers);
}



##############################
##########
# Sun Sep 20 10:01:16 2009
# reduce a list of numbers to a single range string
#
sub number_rangify {
    # needed this to exit so i was not getting garbage 
    if (! grep {m{\d}} @_) {
        return '';
    }

    my @sorted_uniquified_numbers = sort_and_uniquify(@_);
    my @cooked_ranges;
    # set default value - ranges coming in are all positive integers
    my ($last, $run) = (-1,-1);
    my %range_struct;
    for my $current (@sorted_uniquified_numbers) {
        # the list has to be sorted lowest-to-highest - error out if not;
        croak if $last > $current;

        # if $last is not defined its our first time thru, set everything
        if (! $last) {
            push @{ $range_struct{$current} }, $current;
            $last = $run = $current;
            next;
        }

        # if next in the sequence add it to our run
        if ($current == ( 1 + $last) ) {
            push @{ $range_struct{$run} }, $current;
            $last = $current;
        }
        # else start a new run
        else {
            push @{ $range_struct{$current} }, $current;
            $last = $run = $current;
            next;
        }
    }

    for my $r ( sort {$a <=> $b } keys %range_struct) {
        if ($r == $range_struct{$r}->[-1]) {
            push @cooked_ranges,  "$r" ;
        } else {
            push @cooked_ranges,  "$r" . "-" . "$range_struct{$r}->[-1]";
        }

    }
    wantarray ? @cooked_ranges : join(',', @cooked_ranges);
} # end sub number_rangify



## TODO fix this so 
sub count_digit_groups {
    my @incoming_list = @_;
    my %unique_sigs;
    my @numbers;
    for my $string ( @incoming_list) {

        chomp;
        # ## dont use this --> my @on_boundry_split = split qr{\b} , $string;
        # hack to get the split to work right - it puts in null
        # values, the grep strips them out
        my @on_boundry_split = grep { m{.}xms } split qr{(\b|_)} , $string;
        # spliting on \b boundaries will  leave a string with a number
        # handle the case like: p1-09-a
        if ($on_boundry_split[0] =~ m{\d} ) {
            my $first = shift @on_boundry_split;
            # get the alpha chars split from the digits
            my @j = $first =~ m{\A (\D+)? (\d+)}xms;
            # put it back together so the array is correct
            unshift @on_boundry_split, @j;
        }

        # this array gets push on the record so we can go down the list
        # and match them up again to rebuild the list
        # it looks weird on a dump, but works because we always match
        # strings with the same stem, digit group count, and seperators.
        @numbers = $string =~ m{ (\d+) }xmsg;


        # NOTE - this block must have been an test - i don't use its results anywhere.-T
        # go through the string and create a signiture
        # my $sig_accumulator;
        # my @R;
        # for (0..$#on_boundry_split) {
        #     # if we have non-digit data
        #     if ($on_boundry_split[$_] =~ m{\D}xms ) {
        #         #acculmate the sig
        #         $sig_accumulator .= $on_boundry_split[$_]
        #     }
        #     else {
        #         $sig_accumulator and push @R, $sig_accumulator; undef $sig_accumulator;
        #     }
        # }
        # #     print "a line like [$string] can be broken down to the stem and seperator chars\n";
        # #     print join( " :: ", @R), "\n";

        my $line_to_checksum;
    
        my @copy_of_split = @on_boundry_split;
        # replace any digitgroups with zero as a place holder for the signature
        for my $i (0..$#copy_of_split) {
            if ($copy_of_split[$i] =~ m{\A \d+ \z}xms) {
                $copy_of_split[$i] = 0;
            }
        }

        ##############################
        ##########
        # Sun Feb 21 12:13:37 2010
        # why did i use freeze here?
        #    my $froze = freeze(\@copy_of_split);
        my $this_sig = join '', @copy_of_split; 

        ## todo - instead of all of this i can just rip this apart here with col_struct_helper
    
        exists $unique_sigs{$this_sig}{sig}
            || do { $unique_sigs{$this_sig}{sig} = $this_sig; };

        push @{$unique_sigs{$this_sig}{numbers} }, [ @numbers ];
        exists $unique_sigs{$this_sig}{digit_group_count}
            || do { $unique_sigs{$this_sig}{digit_group_count} = scalar @numbers; };
        push @{$unique_sigs{$this_sig}{strings} }, $string;

        #capture the break format
        exists $unique_sigs{$this_sig}{sig_elements}
            || do { push @{$unique_sigs{$this_sig}{sig_elements}}, @on_boundry_split ; };

    }                           # the loop over input.

    return scalar @numbers;
}                               # end sub make_sig_hash





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

                # while string-wise lessthan-or-equal to each other
                while ( $range_element[0] le $range_element[-1] ) {
                    # collect the elements and increment to the next one.
                    push @expanded_elements, $range_element[0]++;
                }
            } else {
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




#vv##############################################vv
# Call like:
#  map_2d_array(
#       {
#          unique_sigs_href=><value>,
#       }
#   );
# Returns: <coder, Fill me in>
sub map_2d_array {

    # get the params that were passed in
    my $param_href = shift @_ ;

    # get and sort the keys so we can make sure we got what we expected
    my @passed_in_param = sort keys %{$param_href} ;

    # check that arg lists match
    # set the parameters for the sub
    my @param_required = qw(unique_sigs_href) ;

    # and sort them
    @param_required = sort @param_required ;

    # make local vars for them
    my ($unique_sigs_href) ;

    if ( @param_required == @passed_in_param ) {
        $unique_sigs_href = $param_href->{unique_sigs_href} ;
    }    # end if
    else {
        croak "ERROR: Missing arguments to sub: ",
            join( " ", @param_required ) ;
    }    # end else

    # ======= put local sub vars below here =======
    my $href;

    while ( my ( $sig, $data ) = each %{$unique_sigs_href} ) {
        my $col_count = $data->{digit_group_count} - 1;
        # this goes back to 0 based counting for this.

        $DEBUG && carp "for sig: [${sig}]:\n" ;
        my %h ;
        for my $line_arrary ( @{ $data->{numbers} } ) {

            push @{ $h{"$line_arrary->[0]"}},  "$line_arrary->[1]";
  

        }
        $DEBUG && warn "Dumper: ", Dumper( \%h ) ;

        # add the hash we just made to
        $data->{full_mapped} = \%h ;

    }    # while end
}    #end sub map_2d_array



#vv##############################################vv
# Call like:
#  glue_2d_together(
#       {
#          unique_sigs_href=><value>,
#       }
#   );
# Returns: <coder, Fill me in>
sub glue_2d_together {

    # get the params that were passed in
    my $param_href = shift @_ ;

    # get and sort the keys so we can make sure we got what we expected
    my @passed_in_param = sort keys %{$param_href} ;

    # check that arg lists match
    # set the parameters for the sub
    my @param_required = qw(unique_sigs_href) ;

    # and sort them
    @param_required = sort @param_required ;

    # make local vars for them
    my ($unique_sigs_href) ;

    if ( @param_required == @passed_in_param ) {
        $unique_sigs_href = $param_href->{unique_sigs_href} ;
    }    # end if
    else {
        croak "ERROR: Missing arguments to sub: ",
            join( " ", @param_required ) ;
    }    # end else
         # ======= put local sub vars below here =======

    my %forward_hash ;
    my %reverse_hash ;
    my $second_range ;

    # #1 sig needs be built before we get here.
    my $sig = $unique_sigs_href->{sig} ;
    my ( $front_sig, $middle_sig, $back_sig ) = split /0/, $sig ;

    ######### picture of what fully_mapped looks like for range pv-[01-03]-08 pv-[01-03]-09
    #   DB<2> x %{$unique_sigs_href->{full_mapped}}
    # 0  01 # << first digitgroups pv-01-??
    # 1  ARRAY(0x98a7708)
    #    0  08 # << pv-01-08
    #    1  09 # << pv-01-09
    # 2  03
    # 3  ARRAY(0x98a7a2c)
    #    0  08 # << pv-02-08
    #    1  09 # << pv-02-09
    # 4  02
    # 5  ARRAY(0x9857e7c)
    #    0  08 # << pv-03-08
    #    1  09 # << pv-03-09

    while ( my ( $first_digits, $second_digits_aref )
        = each %{ $unique_sigs_href->{full_mapped} } )
    {
        map { push @{ $reverse_hash{$_} }, $first_digits }
            @{$second_digits_aref} ;
    }

    ####### What %reverse_hash looks like for range pv-[01-03]-08 pv-[01-03]-09
    #       DB<3> x %reverse_hash
    # 0  08 # << last element (group 2)
    # 1  ARRAY(0x98a76a8)
    #    0  01 # << first group that has 08 as it's last element
    #    1  03
    #    2  02
    # 2  09
    # 3  ARRAY(0x98857a0)
    #    0  01
    #    1  03
    #    2  02
    while ( my ( $last_num, $first_digit_group_aref ) = each %reverse_hash ) {
        my $leading_range = number_rangify( @{$first_digit_group_aref} ) ;
        push @{ $forward_hash{$leading_range} }, $last_num ;
    }

    # what %forward_hash looks like for range pv-[01-03]-08 pv-[01-03]-09
    #   DB<4> x %forward_hash
    # 0  '01-03' # << range
    # 1  ARRAY(0x98a7cd8)
    #    0  08
    #    1  09

    while ( my ( $first_range, $second_range_aref ) = each %forward_hash ) {
        my $sec_range = number_rangify( @{$second_range_aref} ) ;

        print $front_sig . "["
            . $first_range . "]"
            . $middle_sig . "["
            . $sec_range . "]"
            . $back_sig
            . "\n" ;
    }

}    #end sub 2d_glue_together




#vv##############################################vv
# Call like:
#  parse_2d_range(
#       {
#          string=><value>,
#          main_href=><value>,
#       }
#   );
# Returns: <coder, Fill me in>
sub parse_2d_range {

    # get the params that were passed in
    my $param_href = shift @_ ;

    # get and sort the keys so we can make sure we got what we expected
    my @passed_in_param = sort keys %{$param_href} ;

    # check that arg lists match
    # set the paramete rs for the sub
    my @param_required = qw(string main_href) ;

    # and sort them
    @param_required = sort @param_required ;

    # make local vars for them
    my ( $string, $main_href ) ;

    if ( @param_required == @passed_in_param ) {
        $string    = $param_href->{string} ;
        $main_href = $param_href->{main_href} ;
    }    # end if
    else {
        croak "ERROR: Missing arguments to sub: ",
            join( " ", @param_required ) ;
    }    # end else

    # ======= put local sub vars below here =======

    my ($this_sig, $numbers_aref, $on_boundry_split_aref) = gen_2d_sig(
        {
            string=>$string
          
        }
    );


    ## todo - instead of all of this i can just rip this apart here with col_struct_helper
    
    exists $main_href->{$this_sig}{sig}
        || do { $main_href->{$this_sig}{sig} = $this_sig; };

    push @{$main_href->{$this_sig}{numbers} }, [ @{$numbers_aref} ];
    exists $main_href->{$this_sig}{digit_group_count}
        || do { $main_href->{$this_sig}{digit_group_count} = scalar @{$numbers_aref}; };
    push @{$main_href->{$this_sig}{strings} }, $string;

    #capture the break format
    exists $main_href->{$this_sig}{sig_elements}
        || do { push @{$main_href->{$this_sig}{sig_elements}}, @{$on_boundry_split_aref} ; };

    
}    #end sub parse_2d_range
#^^##############################################^^




#vv##############################################vv
# Call like:
#  gen_2d_sig(
#       {
#          string=><value>,
#       }
#   );
# Returns: <coder, Fill me in>
sub gen_2d_sig {

    # get the params that were passed in
    my $param_href = shift @_ ;

    # get and sort the keys so we can make sure we got what we expected
    my @passed_in_param = sort keys %{$param_href} ;

    # check that arg lists match
    # set the parameters for the sub
    my @param_required = qw(string) ;

    # and sort them
    @param_required = sort @param_required ;

    # make local vars for them
    my ($string) ;

    if ( @param_required == @passed_in_param ) {
        $string = $param_href->{string} ;
    }    # end if
    else {
        croak "ERROR: Missing arguments to sub: ",
            join( " ", @param_required ) ;
    }    # end else

    # ======= put local sub vars below here =======
    my @numbers;
    my @non_digits;
    my $this_sig;

    # ## dont use this --> my @on_boundry_split = split qr{\b} , $string;
    # hack to get the split to work right - it puts in null values, the grep strips them out
    my @on_boundry_split = grep { m{.}xms } split qr{(\b|_)} , $string;

    # spliting on \b boundaries will  leave a string with a number
    # handle the case like: p1-09-a
    if ($on_boundry_split[0] =~ m{\d} ) {
        my $first = shift @on_boundry_split;
        # get the alpha chars split from the digits
        @non_digits = $first =~ m{\A (\D+)? (\d+)}xms;
        # put it back together so the array is correct
        unshift @on_boundry_split, @non_digits;
    }

    # this array gets push on the record so we can go down the list
    # and match them up again to rebuild the list
    # it looks weird on a dump, but works because we always match
    # strings with the same stem, digit group count, and seperators.
    @numbers = $string =~ m{ (\d+) }xmsg;

    # go through the string and create a signiture
    my $p;
    my @R;
    for (0..$#on_boundry_split)    {
        # if we have non-digit data
        if($on_boundry_split[$_] =~ m{\D}xms ){
            #acculmate the sig
            $p .= $on_boundry_split[$_]
        }
        else {
            $p and push @R, $p; undef $p }
    }

    if ($DEBUG) {
        print "a line like [$string] can be broken down to the stem and seperator chars\n";
        print join( " :: ", @R), "\n";
    
    }

    my @copy_of_split = @on_boundry_split;
    # replace any digitgroups with zero as a place holder for the signature
    for my $i (0..$#copy_of_split) {
        if ($copy_of_split[$i] =~ m{\A \d+ \z}xms){
            $copy_of_split[$i] = 0;
        }
    }

    return wantarray ? (join("",@copy_of_split),\@numbers,\@copy_of_split) : join("",@copy_of_split);

}    #end sub gen_2d_sig



1;


__END__

# $Header: /home/thansmann/src/jsh_work/RCS/rangify.pl,v 1.5 2011/11/30 20:22:40 thansmann Exp thansmann $
# $Author: thansmann $
# $Date: 2011/11/30 20:22:40 $
#
# $Log: rangify.pl,v $
# Revision 1.5  2011/11/30 20:22:40  thansmann
# -checking in before doing: auto_ci auto_ci auto-checkin
#
# Revision 1.5  2011/04/30 19:00:10  thansmann
# -checking in before doing: auto_ci auto_ci auto-checkin
#
# Revision 1.4  2010/10/31 01:47:17  thansmann
# -checking in before doing: auto_ci auto_ci auto-checkin
#
# Revision 1.1  2010/10/17 23:01:23  thansmann
# Initial revision
#
# Revision 1.1  2010/05/09 20:29:04  thansmann
# Initial revision
# $cc$






=pod

Complex data structure to represent the type of things you see
in human generated lists.

I'm trying to solve cases where an org start a naming scheme like
foo-1, foo-2...foo-36 and then decides to move to foo-00037.... Which
is what my org did.

This will allow you to represent any stem and tail combo with any
wonky numbering system between and can cope with it when someone
changes it on the fly.

bar-[1-3,01-03,001-003]-baz
foo-[9-11]
The %h hash: {
   'bar-&-baz' => {
        'zero_padded_range' => {
                     '3' => [
                              '001',
                              '002',
                              '003'
                            ],
                     '2' => [
                              '01',
                              '02',
                              '03'
                            ]
                   },
        'range' => {
                     '1' => [
                              '1',
                              '2',
                              '3'
                            ]
                   }
      },
   'foo-&' => {
           'range' => {
                   '1' => [
                            '9'
                          ],
                   '2' => [
                            '10',
                            '11'
                          ]
                      }
         }
      };



Also covers the case like "uru, uru2..."
The entire hash: $VAR1 = {
          'uru&' => {
                      'no_number' => 1,
                      'range' => {
                                   '1' => [
                                            '2'
                                          ]
                                 }
                    }
        };




=cut


# =pod

# =head1 NAME

# =head1 SYNOPSIS 

# =head1 DESCRIPTION

# =head1 OPTIONS  

# =head1 RETURN VALUE

# =head1 ERRORS

# =head1 EXAMPLES  

# =head1 ENVIRONMENT

# =head1 FILES     

# =head1 SEE ALSO  

# =head1 NOTES     

# =head1 CAVEATS   

# =head1 DIAGNOSTICS

# =head1 BUGS

# =head1 RESTRICTIONS

# =head1 AUTHOR 

# =head1 HISTORY 

# =cut

