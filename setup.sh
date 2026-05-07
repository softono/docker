#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <folder_name>"
    exit 1
fi

FOLDER="$1"

if [ ! -d "$FOLDER" ]; then
    echo "Error: Folder '$FOLDER' does not exist."
    exit 1
fi

cd "$FOLDER" || exit 1

if [ ! -f ".env.example" ]; then
    echo "Error: .env.example not found in '$FOLDER'."
    exit 1
fi

if [ -f ".env" ]; then
    echo "Notice: .env already exists in '$FOLDER'. Skipping to prevent overwriting."
    exit 0
fi

# Function to generate random alphanumeric string of a given length
generate_random_key() {
    local length=$1
    # Using /dev/urandom and tr to generate random string
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$length"
}

rm -f .env

while IFS= read -r raw_line || [ -n "$raw_line" ]; do
    # Remove carriage return if present (Windows line endings)
    line="${raw_line%$'\r'}"
    
    # Check if line is a valid key=value pair and not a comment
    if [[ "$line" =~ ^[A-Za-z0-9_]+=(.*)$ ]] && [[ ! "$line" =~ ^# ]]; then
        key="${line%%=*}"
        val="${line#*=}"
        
        quote=""
        inner_val="$val"
        
        # Check for quotes
        if [[ "$val" =~ ^\"(.*)\"$ ]]; then
            quote="\""
            inner_val="${BASH_REMATCH[1]}"
        elif [[ "$val" =~ ^\'(.*)\'$ ]]; then
            quote="'"
            inner_val="${BASH_REMATCH[1]}"
        fi
        
        # Determine if inner_val looks like a random key (alphanumeric and length >= 10)
        if [[ "$inner_val" =~ ^[A-Za-z0-9]+$ ]] && [ ${#inner_val} -ge 10 ]; then
            new_key=$(generate_random_key ${#inner_val})
            echo "${key}=${quote}${new_key}${quote}" >> .env
        else
            echo "$line" >> .env
        fi
    else
        echo "$line" >> .env
    fi
done < .env.example

echo "Successfully created .env in '$FOLDER' with newly generated random keys."
