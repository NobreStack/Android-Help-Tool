#!/bin/bash

#Mac Installer
mac() {
    dependencie="brew"

    # Verify if brew is installed
    if ! command -v $dependencie &> /dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install adb and fastboot
    if ! brew list android-platform-tools &> /dev/null; then
        echo "fastboot and/or adb not found. Installing..."
        brew install android-platform-tools
    fi

    # Verify if main.sh exists
    if [ -f "main.sh" ]; then
        chmod +x main.sh
        echo "Installation complete, executing main.sh"
        ./main.sh
    else
        echo "main.sh not found, leaving..."
        exit 1
    fi
}

#Linux installer
linux() {
    echo "Warning, this script will need administrator privileges to run."
    read -p "Press Enter to continue..."
    
    # Verify if installer is executed on Debian/Ubuntu based systems
    if ! command -v apt &> /dev/null; then
        echo "This installer is only for Debian/Ubuntu based systems."
        return 1
    fi

    sudo apt update

    # Install adb and fastboot
    if ! command -v fastboot &> /dev/null || ! command -v adb &> /dev/null; then
        echo "Installing fastboot and adb..."
        sudo apt install -y android-tools-adb android-tools-fastboot
    fi

    # Adding adb and fastboot to PATH
    ADB_PATH=$(command -v adb)
    FASTBOOT_PATH=$(command -v fastboot)

    if [[ ":$PATH:" != *":$(dirname $ADB_PATH):"* ]]; then
        echo "Adding adb to PATH..."
        echo "export PATH=\$PATH:$(dirname $ADB_PATH)" >> ~/.bashrc
        export PATH=$PATH:$(dirname $ADB_PATH)
    fi

    if [[ ":$PATH:" != *":$(dirname $FASTBOOT_PATH):"* ]]; then
        echo "Adding fastboot to PATH..."
        echo "export PATH=\$PATH:$(dirname $FASTBOOT_PATH)" >> ~/.bashrc
        export PATH=$PATH:$(dirname $FASTBOOT_PATH)
    fi

    # Verify if the main script exists and make it executable
    if [ -f "main.sh" ]; then
        chmod +x main.sh
        echo "Installation complete, executing main.sh"
        ./main.sh
    else
        echo "main.sh not found, leaving..."
        exit 1
    fi
}

#OS check
oscheck() {
    os_name=$(uname)

    if [[ "$os_name" == "Linux" ]]; then
        return 1  # Linux
    elif [[ "$os_name" == "Darwin" ]]; then
        return 0  # macOS
    else
        echo "Unsupported operating system."
        exit 1
    fi
}

#Check the OS
oscheck

# Runs the installation
case $? in
    0) 
        mac 
    ;;
    1) 
        linux 
    ;;
esac
