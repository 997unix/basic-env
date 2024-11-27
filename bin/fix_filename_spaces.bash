#!/bin/bash

# Check if a filename is provided as an argument
if [ -z "$1" ]; then
    echo "Error: No filename provided."
    exit 1
fi

filename="$1"

# Check if the file exists
if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    exit 1
fi

# Check if the filename contains spaces
if [[ "$filename" == *" "* ]]; then
    echo "Warning: Filename '$filename' contains spaces."
fi

# ... Rest of your file processing logic ...


# take spaces out of filenames in one step
cp -v "$filename" $(echo "$filename" |tr ' ' '_') && { 
   rm -Iv "$filename" 
}
