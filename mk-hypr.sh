#!/bin/bash

#================================================================================
# Script for installing Hyprland and Mk's configs
#================================================================================

# --- Color Codes ---
# Using tput for wider compatibility
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NC=$(tput sgr0) # No Color

# --- Functions ---

# Function to print colored log messages
# Usage: log "This is a message" "$GREEN"
log() {
    echo -e "${2}${1}${NC}"
}

# Function to check the exit status of the last command
# Usage: check_status "Error message if failed"
check_status() {
    if [ $? -ne 0 ]; then
        log "Error: $1" "$RED"
        exit 1
    else
        log "Success!" "$GREEN"
    fi
}

# --- Sudo Keep-Alive ---
# Ask for the administrator password upfront and run a loop in the background to
# keep the session active.

log "Requesting administrator privileges for the duration of the script..." "$YELLOW"
sudo -v
if [ $? -ne 0 ]; then
    log "Failed to obtain sudo privileges. Exiting." "$RED"
    exit 1
fi

# Keep-alive loop
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &
SUDO_LOOP_PID=$!
trap 'kill "$SUDO_LOOP_PID" &> /dev/null' EXIT

# --- Main Script ---

# 1. Display Header
clear
echo -e "${GREEN}"
cat << "EOF"

   _____   __               ___ ___                       
  /     \ |  | __          /   |   \ ___.__._____________ 
 /  \ /  \|  |/ /  ______ /    ~    <   |  |\____ \_  __ \
/    Y    \    <  /_____/ \    Y    /\___  ||  |_> >  | \/
\____|__  /__|_ \          \___|_  / / ____||   __/|__|   
        \/     \/                \/  \/     |__|          

EOF
echo -e "${NC}"

# 2. Confirmation Prompt
log "This program will install a full Hyprland desktop. Do you want to continue?" "$YELLOW"
read -p "Do you want to continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    log "Installation cancelled." "$RED"
    exit 0
fi

# 3. Prerequisite Installation (git and yay)
cd ~
check_status "Could not navigate to home directory."

log "Installing required packages: base-devel and git..." "$YELLOW"
sudo pacman -S --needed --noconfirm base-devel git
check_status "Failed to install required packages."

if command -v yay &> /dev/null; then
    log "yay is already installed. Skipping installation." "$GREEN"
else
    log "Cloning yay repository from AUR..." "$YELLOW"
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    check_status "Failed to clone yay repository."

    cd yay
    check_status "Could not navigate into yay directory."

    log "Building and installing yay..." "$YELLOW"
    makepkg -si --noconfirm
    check_status "Failed to build or install yay."

    cd ..
    check_status "Could not navigate out of yay directory."

    log "Cleaning up cloned repository..." "$YELLOW"
    rm -rf yay
    check_status "Failed to clean up."
fi

# 4. Define Package Lists
log "\nPreparing package lists for installation..." "$YELLOW"

prep_stage=(
    qt5-wayland qt5ct qt6-wayland qt6ct qt5-svg qt5-quickcontrols2
    qt5-graphicaleffects gtk3 polkit-gnome pipewire wireplumber
    jq wl-clipboard cliphist python-requests pacman-contrib udiskie
    libgtop upower aylurs-gtk-shell-git dart-sass gtksourceview3
    libsoup3
)

nvidia_stage=(
    linux-headers nvidia-dkms nvidia-settings libva libva-nvidia-driver-git
)

install_stage=(
    hyprland kitty mako waybar swaync hyprshot swaylock-effects wofi wlogout
    xdg-desktop-portal-hyprland swappy grim slurp thunar btop firefox
    thunderbird mpv pamixer pavucontrol brightnessctl bluez bluez-utils
    blueman network-manager-applet gvfs thunar-archive-plugin file-roller
    starship papirus-icon-theme ttf-jetbrains-mono-nerd noto-fonts-emoji
    lxappearance xfce4-settings nwg-look-bin sddm neovim tmux fzf
    hyprlock matugen unzip zsh hyprshot hyprpaper ghostty fastfetch
    qt5-quickcontrols zip discord flatpak linux-headers displaylink
    ags-hyprpanel-git python python-gpustat brightnessctl pacman-contrib
    power-profiles-daemon grimblast wf-recorder hyprpicker hyprsunset
    swww python-pywalfox tree ripgrep dotnet-sdk aspnet-runtime
)

# 5. Nvidia Prompt and Final Package List Construction
log "\nChecking for Nvidia GPU..." "$YELLOW"
read -p "Are you using an Nvidia GPU? (y/N) " -n 1 -r
echo

packages_to_install=("${prep_stage[@]}" "${install_stage[@]}")

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Nvidia GPU detected. Adding Nvidia packages." "$GREEN"
    packages_to_install+=("${nvidia_stage[@]}")
else
    log "Skipping Nvidia-specific packages." "$YELLOW"
fi

# 6. Main Installation
log "\nStarting main installation process. This may take a while..." "$YELLOW"
yay -S --needed --noconfirm "${packages_to_install[@]}"
check_status "Failed to install one or more packages."

# 7. Install Flatpak and Spotify via Flatpak
log "\nInstalling Spotify via Flatpak..." "$YELLOW"
# Install Spotify
flatpak install -y flathub com.spotify.Client
check_status "Failed to install Spotify via Flatpak."
log "Spotify installed via Flatpak successfully." "$GREEN"

# 8. Copy Configuration Files
log "\nPreparing to set up configuration files..." "$YELLOW"
read -p "Do you want to install the recommended configurations for Hyprland, Kitty, Waybar, etc.? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Ask if user wants to back up existing configs
    read -p "Would you like to back up your current ~/.config directory? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BACKUP_DIR="$HOME/config.orig"
        log "Backing up entire ~/.config to $BACKUP_DIR..." "$YELLOW"
        if [ -d "$HOME/.config" ]; then
            mkdir -p "$BACKUP_DIR"
            find "$HOME/.config" -mindepth 1 -maxdepth 1 ! -type l -exec cp -r {} "$BACKUP_DIR" \;
            check_status "Backup failed"
            log "Backup completed successfully." "$GREEN"
        else
            log "~/.config does not exist. Skipping backup." "$YELLOW"
        fi
    else
        log "Skipping backup of ~/.config." "$YELLOW"
    fi

    # Define the actual source and destination
    SOURCE_DIR="$HOME/mk-hypr/config"
    DEST_DIR="$HOME/.config"

    # Check if source directory exists
    if [ ! -d "$SOURCE_DIR" ]; then
        log "Source directory not found at '${SOURCE_DIR}'." "$RED"
        log "Please ensure ~/mk-hypr/config exists and contains the config files you want to use." "$YELLOW"
        exit 1
    fi

    mkdir -p "$DEST_DIR"
    echo "Destination directory is '${DEST_DIR}'."
    echo "---"

    # Loop through each item in mk-hypr/config and link it into ~/.config
    find "${SOURCE_DIR}" -maxdepth 1 -mindepth 1 | while read -r ITEM_PATH; do
        ITEM_NAME=$(basename "$ITEM_PATH")
        DEST_PATH="${DEST_DIR}/${ITEM_NAME}"

        echo "Processing: '${ITEM_NAME}'"

        # If a file/dir/link already exists at destination, delete it
        if [ -e "$DEST_PATH" ] || [ -L "$DEST_PATH" ]; then
            echo " -> Found existing item at '${DEST_PATH}', removing..."
            rm -rf "$DEST_PATH"
            check_status "Failed to remove existing ${DEST_PATH}"
        fi

        # Create symlink
        ln -s "$ITEM_PATH" "$DEST_PATH"
        echo " -> Success: Created symlink at '${DEST_PATH}'"
    done
fi


# 9. Copying SDDM config and theme
log "\nCopying SDDM configuration and theme..." "$YELLOW"
# Ensure SDDM config directory exists
sudo mkdir -p /usr/lib/sddm/sddm.conf.d
# Copy default.conf
if [ -f "extras/sddm/default.conf" ]; then
    sudo cp "extras/sddm/default.conf" /usr/lib/sddm/sddm.conf.d/
    check_status "Failed to copy default.conf to /usr/lib/sddm/sddm.conf.d/"
    log "Copied SDDM default.conf successfully." "$GREEN"
else
    log "Warning: extras/sddm/default.conf not found; skipping SDDM config copy." "$YELLOW"
fi
# Copy sddm theme
if [ -d "extras/sddm/chili" ]; then
    sudo mkdir -p /usr/share/sddm/themes
    sudo cp -r "extras/sddm/chili" /usr/share/sddm/themes/
    check_status "Failed to copy sddm theme to /usr/share/sddm/themes/"
    log "Copied sddm themes successfully." "$GREEN"
else
    log "Warning: extras/sddm/ directory not found; skipping SDDM theme copy." "$YELLOW"
fi

# 10. Enable System Services
log "\nEnabling essential services..." "$YELLOW"
sudo systemctl enable sddm.service
check_status "Failed to enable SDDM."
sudo systemctl enable NetworkManager.service
check_status "Failed to enable NetworkManager."
sudo systemctl enable bluetooth.service
check_status "Failed to enable Bluetooth."
sudo systemctl enable displaylink.service
check_status "Failed to enable Displaylink."

# 11. Reboot Prompt
log "\nInstallation and configuration complete!" "$GREEN"
read -p "Would you like to reboot now to apply all changes? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "Rebooting now..." "$GREEN"
    sudo reboot
else
    log "Please reboot manually to complete the setup." "$YELLOW"
fi

exit 0
