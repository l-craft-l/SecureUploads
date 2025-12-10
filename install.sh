#!/bin/bash

green='\033[0;32m'
red='\033[0;31m'
cyan='\033[0;36m'
orange='\e[38;5;214m'
bold='\033[1m'
reset='\e[0m'

echo -e "${bold}SecureUploads Installer${reset}"

# --- CHECK ROOT ---
if [[ $EUID != 0 ]]; then
    echo -e "${red}[!] You must run this installer as root (use sudo).${reset}"
    exit 1
fi

# --- CHECK DISTRO ---
if ! command -v apt &>/dev/null; then
    echo -e "${red}[!] This installer only supports Debian/Ubuntu systems.${reset}"
    exit 1
fi

# --- INSTALL DEPENDENCIES ---
echo -e "${orange}[~] Installing required packages...${reset}"
apt install -y nginx apache2-utils openssl inotify-tools &>/dev/null

if [[ $? != 0 ]]; then
    echo -e "${red}[!] Failed installing dependencies.${reset}"
    exit 1
fi

# --- INSTALL SCRIPT ---
echo -e "${orange}[~] Installing SecureUploads script...${reset}"

wget https://raw.githubusercontent.com/l-craft-l/SecureUploads/refs/heads/main/secureuploads &>/dev/null

if [[ ! -f secureuploads ]]; then
    echo -e "${red}[!] secureuploads script not found in this folder.${reset}"
    echo -e "Place the script in the same directory as install.sh"
    exit 1
fi

chmod +x secureuploads
mv secureuploads /usr/bin

# --- SUCCESS MESSAGE ---
echo -e "\n${green}[+] SecureUploads installed successfully!${reset}"
echo -e "${green}[+] You can now run it using:${reset}"
echo -e "${red}sudo${reset} ${cyan}secureuploads${reset} ${green}--help${reset}"

echo -e "\n${bold}Done.${reset}"

rm ./install.sh
