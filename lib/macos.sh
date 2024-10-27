#!/bin/bash

# https://mths.be/macos

set_default_general () {
  sudo nvram SystemAudioVolume=" "
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  defaults write com.apple.CrashReporter DialogType -string "none"
  defaults write com.apple.helpviewer DevMode -bool true
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
}

set_default_dev () {
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
  defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
  defaults write NSGlobalDomain KeyRepeat -int 1
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
}

set_default_screen () {
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture location -string "${HOME}/Pictures"
  defaults write com.apple.screencapture type -string "png"
}

set_default_finder () {
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  defaults write com.apple.finder QuitMenuItem -bool true
  defaults write com.apple.finder DisableAllAnimations -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  # defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # defaults write com.apple.finder _FXSortFoldersFirst -bool true
  defaults write com.apple.frameworks.diskimages skip-verify -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  defaults write com.apple.frameworks.diskimages auto-open-ro-root-bool true
  defaults write com.apple.frameworks.diskimages auto-open-rw-root-bool true
  defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
  chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library
  sudo chflags nohidden /Volumes
}

set_default_dock () {
  defaults write com.apple.dock minimize-to-application -bool true
  defaults write com.apple.dock show-process-indicators  -bool true
  defaults write com.apple.dock expose-animation-duration -float 0.1
  defaults write com.apple.dock expose-group-by-app -bool false
  defaults write com.apple.dock mru-spaces  -bool false
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock show-recents  -bool false
}

set_default_safari () {
  defaults write com.apple.Safari HomePage -string "https://www.google.com"
  defaults write com.apple.Safari ProxiesInBookmarksBar "()"
  defaults write com.apple.Safari UniversalSearchEnabled -bool false
  defaults write com.apple.Safari SuppressSearchSuggestions  -bool true
  defaults write com.apple.Safari AutoOpenSafeDownloads  -bool false
  defaults write com.apple.Safari ShowFavoritesBar -bool false
  defaults write com.apple.Safari ShowSidebarInTopSites  -bool false
  defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
  defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
  defaults write com.apple.Safari IncludeDevelopMenu -bool true
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
  defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false
  defaults write com.apple.Safari AutoFillFromAddressBook -bool false
  defaults write com.apple.Safari AutoFillPasswords  -bool false
  defaults write com.apple.Safari AutoFillCreditCardData -bool false
  defaults write com.apple.Safari AutoFillMiscellaneousForms  -bool false
  defaults write com.apple.Safari WarnAboutFraudulentWebsites  -bool true
  defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
  defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
  defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
  # defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
  defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
}

set_default_timemachine () {
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
  hash tmutil &> /dev/null && sudo tmutil disablelocal
}

set_default_appstore () {
  defaults write com.apple.appstore WebKitDeveloperExtras -bool true
  defaults write com.apple.appstore ShowDebugMenu -bool true
  defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
  defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
  defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
  defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
  defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
  defaults write com.apple.commerce AutoUpdate -bool true
  defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
}

set_default_photo () {
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
}

delocalize () {
  for f in $HOME/* \
    "/Applications" \
    "/Library" \
    "/Users" \
    "/Users/Guest" \
    "/Users/Guest/Public" \
    "/Users/Shared"; do
    sudo rm -d "$f/.localized"
  done
}

set_macos_defaults () {
  sudo -v
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

  set_default_general
  set_default_dev
  set_default_screen
  set_default_finder
  set_default_dock
  set_default_safari
  set_default_timemachine
  set_default_appstore
  set_default_photo
  delocalize

  killall Dock
  killall Finder
}
