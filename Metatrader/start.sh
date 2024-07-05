#!/bin/bash


# original : https://github.com/gmag11/MetaTrader5-Docker-Image/blob/main/Metatrader/start.sh

# Not required. Just for Fun
xterm &
echo "--###############################################################################"
whoami
# Configuration variables
mt5file='/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe'
WINEPREFIX='/root/.wine'
wine_executable="wine"
#metatrader_version="5.0.36"
#mt5server_port="8001"
mono_url="https://dl.winehq.org/wine/wine-mono/9.2.0/wine-mono-9.2.0-x86.msi"
#python_url="https://www.python.org/ftp/python/3.9.0/python-3.9.0.exe"
mt5setup_url="https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"

# Function to display a graphical message
show_message() {
    echo $1
}

# Function to check if a dependency is installed
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed. Please install it to continue."
        exit 1
    fi
}

# Function to check if a Python package is installed
is_python_package_installed() {
    python3 -c "import pkg_resources; exit(not pkg_resources.require('$1'))" 2>/dev/null
    return $?
}

# Function to check if a Python package is installed in Wine
is_wine_python_package_installed() {
    $wine_executable python -c "import pkg_resources; exit(not pkg_resources.require('$1'))" 2>/dev/null
    return $?
}

# Check for necessary dependencies
check_dependency "curl"
check_dependency "$wine_executable"

# Install Mono if not present
if [ ! -e "/root/.wine/drive_c/windows/mono" ]; then
    show_message "[1/7] Downloading and installing Mono..."
    #curl -o /root/.wine/drive_c/mono.msi $mono_url
    WINEDLLOVERRIDES=mscoree=d $wine_executable msiexec /i /root/.wine/drive_c/mono.msi /qn
    rm /root/.wine/drive_c/mono.msi
    show_message "[1/7] Mono installed."
else
    show_message "[1/7] Mono is already installed."
fi

# Check if MetaTrader 5 is already installed
if [ -e "$mt5file" ]; then
    show_message "[2/7] File $mt5file already exists."
else
    show_message "[2/7] File $mt5file is not installed. Installing..."

    # Set Windows 10 mode in Wine and download and install MT5
    $wine_executable reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f
    show_message "[3/7] Downloading MT5 installer..."
    curl -o /root/.wine/drive_c/mt5setup.exe $mt5setup_url
    show_message "[3/7] Installing MetaTrader 5..."
    $wine_executable "/root/.wine/drive_c/mt5setup.exe" "/auto"
    # wait
    rm -f /root/.wine/drive_c/mt5setup.exe
fi
sudo abc
# Recheck if MetaTrader 5 is installed
if [ -e "$mt5file" ]; then
    show_message "[4/7] File $mt5file is installed. Running MT5..."
    $wine_executable "$mt5file"
else
    show_message "[4/7] File $mt5file is not installed. MT5 cannot be run."
fi



