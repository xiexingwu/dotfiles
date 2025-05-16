#
```sh
sudo cp ./LaunchDaemons/com.xiexingwu.*.plist /Library/LaunchDaemons/
```
```sh
sudo launchctl bootstrap system /Library/LaunchDaemons/com.xiexingwu.kanata.plist
sudo launchctl enable system/com.xiexingwu.kanata.plist

sudo launchctl bootstrap system /Library/LaunchDaemons/com.xiexingwu.karabiner-vhiddaemon.plist
sudo launchctl enable system/com.xiexingwu.karabiner-vhiddaemon.plist

sudo launchctl bootstrap system /Library/LaunchDaemons/com.xiexingwu.karabiner-vhidmanager.plist
sudo launchctl enable system/com.xiexingwu.karabiner-vhidmanager.plist
```
