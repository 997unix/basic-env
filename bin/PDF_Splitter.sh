#!/bin/bash

# Help text to show how to use the script
show_usage() {
    echo "How to use this script:"
    echo "------------------------"
    echo "./split_book.sh input.pdf \"12,28,39,49,60\""
    echo ""
    echo "This will split input.pdf into chapters starting at those pages"
    echo "Put the page numbers in quotes, separated by commas"
}

# Check if we got the right number of inputs
if [ $# -ne 2 ]; then
    show_usage
    exit 1
fi

# Give friendly names to our inputs
INPUT_BOOK=$1
PAGE_NUMBERS=$2

# Get the filename without extension for output naming
BOOK_NAME=$(basename "$INPUT_BOOK" .pdf)

# Check if the book file exists
if [ ! -f "$INPUT_BOOK" ]; then
    echo "Error: Can't find the book file: $INPUT_BOOK"
    exit 1
fi

# Create a folder for our chapters
CHAPTER_FOLDER="split_chapters"
mkdir -p "$CHAPTER_FOLDER"

# Convert the comma-separated list into an array
IFS=',' read -ra CHAPTER_PAGES <<< "$PAGE_NUMBERS"

# Function to extract one chapter
split_out_chapter() {
    local start_page=$1
    local end_page=$2
    local chapter_number=$3
    
    # Pad chapter number to 3 digits
    local padded_number=$(printf "%03d" $chapter_number)
    local output_name="${BOOK_NAME}_chapter_${padded_number}.pdf"
    
    echo "Creating Chapter $padded_number (pages $start_page to $end_page)"
    
    gs -sDEVICE=pdfwrite \
       -dNOPAUSE \
       -dBATCH \
       -dSAFER \
       -sOutputFile="$CHAPTER_FOLDER/$output_name" \
       -dFirstPage=$start_page \
       -dLastPage=$end_page \
       "$INPUT_BOOK"
}

# Go through each chapter and split it out
for index in "${!CHAPTER_PAGES[@]}"; do
    # Get the starting page for this chapter
    start_page=${CHAPTER_PAGES[$index]}
    
    # Calculate which chapter number we're on
    chapter_number=$((index + 1))
    
    # Figure out where this chapter ends
    if [ $((index + 1)) -lt ${#CHAPTER_PAGES[@]} ]; then
        # If not the last chapter, end one page before the next chapter
        end_page=$((${CHAPTER_PAGES[$index + 1]} - 1))
    else
        # If it's the last chapter, use ghostscript's special number for "until the end"
        end_page=999999
    fi
    
    # Split out this chapter
    split_out_chapter $start_page $end_page $chapter_number
done

echo ""
echo "All done! Your chapters are in the '$CHAPTER_FOLDER' folder"