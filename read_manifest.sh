#!/bin/bash

echo "Reading file - $1"
echo "============================="

JSON_FILE="$1"
SAVE_PATH="$2"
index=0

if [ ! -d "$SAVE_PATH" ]; then
    mkdir -p "$SAVE_PATH"
    echo "Created save dir: $SAVE_PATH"
else
    echo "Directory $SAVE_PATH exist. Writing files..."
fi

echo "============================="

while IFS= read -r line; do
    if grep -q "\"projectID\"" <<< "$line" || grep -q "\"fileID\"" <<< "$line"; then
        case $index in
            0)
                projectID=$(cut -d ":" -f 2 <<< "$line" | tr -d '," ')
                ;;
            *)
                fileID=$(cut -d ":" -f 2 <<< "$line" | tr -d '," ')

                URL=$(sed 's/\r//g' <<< "https://www.curseforge.com/api/v1/mods/$projectID/files/$fileID/download")

                echo "Checking $URL"

                URL=$(curl -o /dev/null -Ls -w "%{url_effective}" "$URL")
                filename=$(basename "$URL")

                if [[ ! $filename == *.jar ]]; then
                    echo "File $filename is not .jar. Skipping."
                else
                    echo "Downloading ..."
                    curl -X GET "$URL" -o "$SAVE_PATH/$filename" --progress-bar -w "Downloaded: %{size_download} bytes\n"
                    echo "New file '$filename' created"
                fi

                echo "============================="
                index=0
                ;;
        esac
        index=$(($index + 1))
    fi
done < "$JSON_FILE"

echo "Files downloaded successfully!"
