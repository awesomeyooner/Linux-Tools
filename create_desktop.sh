#!/bin/bash -e

prompt_nonempty()
{
    # Read input into $prompt_output
    read -r -p "$1" prompt_output
    
    # If it's empty then exit
    if [[ -z "$prompt_output" ]]; then
        echo "Input was invalid (empty)! Exiting..."
        exit 1
    fi
}

get_file()
{
    # Case insensitive
    # Empty matchihng
    # Extended globbing
    shopt -s extglob nocaseglob nullglob

    file_found=0

    for file in *.$1; do
        file_found=1
        break
    done

    # Turn them off to restore default behavior
    shopt -u extglob nocaseglob nullglob
}

prompt_nonempty "Enter the name for the desktop file >> "
DESKTOP_FILE=$prompt_output

echo "Your file will be $DESKTOP_FILE.desktop"

prompt_nonempty "Enter the display name of your application >> "
DISPLAY_NAME=$prompt_output

echo "Your app will show up as: $DISPLAY_NAME"

# Get icon file name
if get_file "png"; [[ "$file_found" -eq 1 ]]; then
    echo "Using image file: $file"
    ICON_NAME=$file

elif get_file "jpg"; [[ "$file_found" -eq 1 ]]; then
    echo "Using image file: $file"
    ICON_NAME=$file

elif get_file "jpeg"; [[ "$file_found" -eq 1 ]]; then
    echo "Using image file: $file"
    ICON_NAME=$file

else
    echo "No image files found! Using icon.png as placeholder..."
    ICON_NAME="icon.png"
fi

# Get exec file name
if get_file "appimage"; [[ "$file_found" -eq 1 ]]; then
    echo "Using executable: $file"
    EXEC_NAME=$file

elif get_file "sh"; [[ "$file_found" -eq 1 ]]; then
    echo "Using executable: $file"
    EXEC_NAME=$file

else
    echo "No executables found! Using run.sh as placeholder..."
    EXEC_NAME="run.sh"
fi

# Ask user if they want to keep the terminal alive
while true; do
    read -p "Do you want terminal? (y/N): " response
    case $response in
        [Yy]* ) USE_TERMINAL="true" ; break;;
        [Nn]* ) USE_TERMINAL="false"; break;;
        * ) USE_TERMINAL="false"; break;;
    esac
done

echo "Creating ${DESKTOP_FILE}.desktop"

touch ${DESKTOP_FILE}.desktop

# Populate the file contents
cat << EOF > ${DESKTOP_FILE}.desktop
[Desktop Entry]
Type=Application
Name=${DISPLAY_NAME}
GenericName=${DISPLAY_NAME}
Exec=$(pwd)/${EXEC_NAME}
Icon=$(pwd)/${ICON_NAME}
Terminal=${USE_TERMINAL}
Categories=Application;Network;
Encoding=UTF-8
EOF

echo "Creating symlink..."

# Only create the file if it does not exist
if [[ ! -f "$(pwd)/${DESKTOP_FILE}.copy.desktop" ]]; then
    ln -s $(pwd)/${DESKTOP_FILE}.desktop $(pwd)/${DESKTOP_FILE}.copy.desktop

else
    echo "Symlink already exists!"
fi

echo "Place this to ~/.local/share/applications using the following:"
echo ""
echo "mv $(pwd)/${DESKTOP_FILE}.copy.desktop ~/.local/share/applications && sudo update-desktop-database"
echo ""
