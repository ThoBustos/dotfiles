#!/bin/bash
# macOS system defaults - runs once on new machine setup
# Managed by Chezmoi

echo "Applying macOS defaults..."

# ----------------------------
# Dock
# ----------------------------
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

dockutil --remove all --no-restart
dockutil --add ~/Downloads --view fan --display folder --sort dateadded --no-restart
# Finder (leftmost) and Trash (rightmost) are managed by macOS and restored automatically

# ----------------------------
# Keyboard
# ----------------------------
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# ----------------------------
# Finder
# ----------------------------
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # Search current folder

# ----------------------------
# Screenshots
# ----------------------------
mkdir -p ~/Desktop/Screenshots
defaults write com.apple.screencapture location ~/Desktop/Screenshots
defaults write com.apple.screencapture type -string "png"

# ----------------------------
# Trackpad
# ----------------------------
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1  # Tap to click

# ----------------------------
# Misc
# ----------------------------
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Apply changes
killall Dock Finder 2>/dev/null || true

echo "macOS defaults applied."
