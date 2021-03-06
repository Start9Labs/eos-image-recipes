# PureOS Image Recipes

Code and `debos` recipes that are used to create the PureOS live and installer
images.

If you want to build a local image in the exact same environment used to build
official PureOS images, you can use the `run-local-build.sh` helper script:
```bash
# Prerequisites
sudo apt install debspawn
sudo mkdir -p /etc/debspawn/ && echo "AllowUnsafePermissions=true" | sudo tee /etc/debspawn/global.toml

# Build byzantium-gnome-live image (the default)
./run-local-build.sh byzantium
```
