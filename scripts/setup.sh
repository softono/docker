#!/bin/bash

# Resolve repo root (parent of the scripts/ directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT" || exit 1

if [ -z "$1" ]; then
    echo "Usage: $0 <folder_name>"
    exit 1
fi

FOLDER="$1"

if [ ! -d "$FOLDER" ]; then
    echo "Error: Folder '$FOLDER' does not exist."
    exit 1
fi

cd "$REPO_ROOT/$FOLDER" || exit 1

if [ ! -f ".env.example" ]; then
    echo "Setup Completed Successfully."
    exit 1
fi

if [ -f ".env" ]; then
    echo "Notice: .env already exists in '$FOLDER'. Skipping to prevent overwriting."
    exit 0
fi

# Function to generate random key of a given type (alnum or base64) and length
generate_random_key() {
    local type=$1
    local length=$2
    case "$type" in
        alnum)
            LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$length"
            ;;
        base64)
            head -c "$length" /dev/urandom | base64 | tr -d '\r\n'
            ;;
        *)
            echo "Error: Unknown key type '$type' (expected 'alnum' or 'base64')" >&2
            return 1
            ;;
    esac
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
        
        # Generate key if inner_val matches generate_random_key:<type>|<length>
        if [[ "$inner_val" =~ ^generate_random_key:(alnum|base64)\|([0-9]+)$ ]]; then
            key_type="${BASH_REMATCH[1]}"
            key_length="${BASH_REMATCH[2]}"
            new_key=$(generate_random_key "$key_type" "$key_length")
            echo "${key}=${quote}${new_key}${quote}" >> .env
        else
            echo "$line" >> .env
        fi
    else
        echo "$line" >> .env
    fi
done < .env.example

echo "Setup Completed Successfully. created .env in '$FOLDER' with newly generated random keys."
