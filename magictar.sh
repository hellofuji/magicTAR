#!/bin/bash 
set -euo pipefail

# ARCHIVE BACKUP SCRIPT
run_archive() {
    clear
    DATE=$(date +%F)
    
    echo "_______  ______ _______ _     _ _____ _    _ _______";
    echo "|_____| |_____/ |       |_____|   |    \  /  |______";
    echo "|     | |    \_ |_____  |     | __|__   \/   |______";
    echo "";
    echo "Follow the steps below to complete the archiving process."
    echo "----------------------------------------------------------"

    # 1. GET SOURCE PATH
    read -p "Step 1: Enter the directory to BACKUP [Press Enter for current directory]: " SOURCE_DIR < /dev/tty
    # If user pressed Enter, use current directory
    if [ -z "$SOURCE_DIR" ]; then
        SOURCE_DIR=$(pwd)
        echo "Using current directory: $SOURCE_DIR"
    fi

    # 2. GET DESTINATION PATH
        read -p "Step 2: Enter the directory to SAVE the archive [Press Enter to save in current directory]: " ARCHIVE_DIR < /dev/tty
    # If user pressed Enter, use current directory
    if [ -z "$ARCHIVE_DIR" ]; then
        ARCHIVE_DIR=$(pwd)
        echo "Using current directory: $ARCHIVE_DIR"
    fi

    # 3. HANDLE DESTINATION LOGIC
    if [ ! -d "$ARCHIVE_DIR" ]; then
        echo "Destination does not exist. Creating '$ARCHIVE_DIR'..."
        mkdir -p "$ARCHIVE_DIR" || { echo "Failed to create directory"; exit 1; }
    else
        echo "Destination folder found."
    fi

    # 4. PREPARE FILENAME
    FOLDER_NAME=$(basename "$SOURCE_DIR")
    ARCHIVE_PATH="${ARCHIVE_DIR}/${FOLDER_NAME}_${DATE}.tar"

    # 5. EXECUTE TAR (No compression for data integrity)
    echo "Archiving $SOURCE_DIR to $ARCHIVE_PATH..."

    if sudo tar --acls --xattrs --one-file-system -cpvf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
        echo "------------------------------------------"
        echo "SUCCESS: Archive created."
        du -sh "$ARCHIVE_PATH"
    else
        echo "ERROR: Archive failed."
        exit 1
    fi
}

run_restore() {
    clear 

    echo " ______ _______ _______ _______  _____   ______ _______";
    echo "|_____/ |______ |______    |    |     | |_____/ |______";
    echo "|    \_ |______ ______|    |    |_____| |    \_ |______";
    echo "";
    echo "Follow the steps below to complete the restoration process of existing tar arvhive."
    echo "-----------------------------------------------------------------------------------"

    # 1. ASK FOR THE ARCHIVE FILE
    read -p "Enter the full path of the .tar file: " ARCHIVE_FILE < /dev/tty

    # Validate that the file exists
    if [ ! -f "$ARCHIVE_FILE" ]; then
        echo "Error: Archive file '$ARCHIVE_FILE' not found."
        exit 1
    fi

    # 2. ASK FOR THE RESTORE DESTINATION
    read -p "Enter the directory to extract TO [Press Enter to extract to current directory]: " RESTORE_DIR < /dev/tty
    # If user pressed Enter, use current directory
    if [ -z "$RESTORE_DIR" ]; then
        RESTORE_DIR=$(pwd)
        echo "Using current directory: $RESTORE_DIR"
    fi

    # 3. PREPARE DESTINATION
    if [ ! -d "$RESTORE_DIR" ]; then
        echo "Destination doesn't exist. Creating '$RESTORE_DIR'..."
        mkdir -p "$RESTORE_DIR"
    fi

    # 4. EXECUTE RESTORE
    echo "Restoring $ARCHIVE_FILE to $RESTORE_DIR..."

    # -x: extract
    # -v: verbose (show files)
    # -p: preserve permissions
    # --acls/--xattrs: restore special metadata
    if sudo tar --acls --xattrs -xvpf "$ARCHIVE_FILE" -C "$RESTORE_DIR"; then
        echo "------------------------------------------"
        echo "SUCCESS: Recovery complete."
        du -sh "$RESTORE_DIR"
    else
        echo "ERROR: Restore failed."
        exit 1
    fi
}

# MAIN MENU
clear


echo "███╗   ███╗ █████╗  ██████╗ ██╗ ██████╗████████╗ █████╗ ██████╗ ";
echo "████╗ ████║██╔══██╗██╔════╝ ██║██╔════╝╚══██╔══╝██╔══██╗██╔══██╗";
echo "██╔████╔██║███████║██║  ███╗██║██║        ██║   ███████║██████╔╝";
echo "██║╚██╔╝██║██╔══██║██║   ██║██║██║        ██║   ██╔══██║██╔══██╗";
echo "██║ ╚═╝ ██║██║  ██║╚██████╔╝██║╚██████╗   ██║   ██║  ██║██║  ██║";
echo "╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝";
echo "██╗   ██╗████████╗██╗██╗     ██╗████████╗██╗   ██╗              ";
echo "██║   ██║╚══██╔══╝██║██║     ██║╚══██╔══╝╚██╗ ██╔╝              ";
echo "██║   ██║   ██║   ██║██║     ██║   ██║    ╚████╔╝               ";
echo "██║   ██║   ██║   ██║██║     ██║   ██║     ╚██╔╝                ";
echo "╚██████╔╝   ██║   ██║███████╗██║   ██║      ██║                 ";
echo " ╚═════╝    ╚═╝   ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝                 ";
echo "";
echo "Welcome to MagicTAR - Archive and Restore Utility"
echo "---------------------------------------------------"
echo "1) Archive a directory"
echo "2) Restore an Archive"
echo "3) Exit"
read -p "Select an option (1 or 2): " OPTION < /dev/tty

case $OPTION in
    1)
        run_archive
        ;;
    2)
        run_restore
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac
