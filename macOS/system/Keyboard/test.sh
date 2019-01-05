#!/bin/bash

# # show input menu in menu bar
# # see in ../SysMenuExtras
# currentDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# prefDIR=~/Library/Preferences
# domain=com.apple.HIToolbox
# plist=$prefDIR/$domain.plist

# plutil -replace "AppleGlobalTextInputProperties.TextInputGlobalPropertyPerContextInput" -xml "<true/>" "$plist"
# # defaults write $domain -dict \
# # '{
# #   "AppleGlobalTextInputProperties" = {
# #     "TextInputGlobalPropertyPerContextInput" = 1;
# #   };
# # }'
