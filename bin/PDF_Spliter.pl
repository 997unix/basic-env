#!/usr/bin/env perl
use strict;
use warnings;
use v5.10;
use File::Basename;

=head1 NAME

split_book.pl - Split PDF books into chapters based on page numbers

=head1 SYNOPSIS

    ./split_book.pl input.pdf "12,28,39,49,60"

=head1 DESCRIPTION

This script splits a PDF book into individual chapter files. It takes a PDF file
and a comma-separated list of page numbers where chapters begin.

=head1 ARGUMENTS

=over 4

=item * PDF file path

=item * Comma-separated list of chapter start pages (in quotes)

=back

=head1 OUTPUT

Creates a 'split_chapters' directory containing individual chapter PDFs named:
    original_name_chapter_001.pdf
    original_name_chapter_002.pdf
    etc.

=cut

# Show usage if wrong number of arguments
if (@ARGV != 2) {
    say "Usage: $0 input.pdf \"12,28,39,49,60\"";
    say "Please provide the PDF file and chapter page numbers in quotes.";
    exit 1;
}

# Get input arguments
my $input_book = $ARGV[0];
my $page_numbers = $ARGV[1];

# Check if PDF exists
unless (-f $input_book) {
    die "Error: Cannot find PDF file: $input_book\n";
}

# Get base filename without extension
my $book_name = basename($input_book, '.pdf');

# Create output directory
my $chapter_folder = "split_chapters";
mkdir $chapter_folder unless -d $chapter_folder;

# Convert comma-separated string to array
my @chapter_pages = split /,/, $page_numbers;

# Validate page numbers
validate_page_numbers(@chapter_pages);

# Process each chapter
for my $index (0 .. $#chapter_pages) {
    my $start_page = $chapter_pages[$index];
    my $chapter_num = $index + 1;
    
    # Calculate end page
    my $end_page = ($index < $#chapter_pages) 
        ? $chapter_pages[$index + 1] - 1 
        : 999999;
    
    extract_chapter($start_page, $end_page, $chapter_num);
}

say "\nAll done! Your chapters are in the '$chapter_folder' folder";

# Subroutine to validate page numbers
sub validate_page_numbers {
    my @pages = @_;
    
    # Check that all numbers are positive integers
    for my $page (@pages) {
        unless ($page =~ /^\d+$/ && $page > 0) {
            die "Error: Invalid page number found: $page\n";
        }
    }
    
    # Check ascending order
    for my $i (1 .. $#pages) {
        if ($pages[$i] <= $pages[$i-1]) {
            die "Error: Page numbers must be in ascending order: $pages[$i-1] >= $pages[$i]\n";
        }
    }
    
    # Check for suspiciously small gaps (less than 3 pages)
    for my $i (1 .. $#pages) {
        my $gap = $pages[$i] - $pages[$i-1];
        if ($gap < 3) {
            warn "Warning: Very small gap ($gap pages) between chapters at pages $pages[$i-1] and $pages[$i]\n";
        }
    }
    
    # Check for suspiciously large gaps (more than 50 pages)
    for my $i (1 .. $#pages) {
        my $gap = $pages[$i] - $pages[$i-1];
        if ($gap > 50) {
            warn "Warning: Large gap ($gap pages) between chapters at pages $pages[$i-1] and $pages[$i]\n";
        }
    }
}

# Subroutine to extract a single chapter
sub extract_chapter {
    my ($start_page, $end_page, $chapter_num) = @_;
    
    # Create padded chapter number
    my $padded_num = sprintf("%03d", $chapter_num);
    
    # Create output filename
    my $output_file = "${book_name}_chapter_${padded_num}.pdf";
    my $output_path = "$chapter_folder/$output_file";
    
    say "Creating Chapter $padded_num (pages $start_page to $end_page)";
    
    # Run ghostscript command
    my $gs_command = "gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER " .
                     "-sOutputFile=\"$output_path\" " .
                     "-dFirstPage=$start_page -dLastPage=$end_page " .
                     "\"$input_book\"";
    
    system($gs_command) == 0
        or die "Error: Ghostscript failed for chapter $chapter_num: $?\n";
}

=head1 AUTHOR

Created for PDF chapter extraction and audiobook preparation

=head1 LICENSE

This is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut