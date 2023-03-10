# embassyOS (PureOS based) Image Recipes

Code and `debos` recipes that are used to create the embassyOS live and
installer images.

If you want to build a local image in the exact same environment used to build
official embassyOS images, you can use the `run-local-build.sh` helper script:

```bash
# Prerequisites
sudo apt install debspawn
sudo mkdir -p /etc/debspawn/ && echo "AllowUnsafePermissions=true" | sudo tee /etc/debspawn/global.toml

wget https://repo.pureos.net/pureos/pool/main/d/debootstrap/debootstrap_1.0.125pureos1_all.deb
sudo apt install ./debootstrap_1.0.125pureos1_all.deb

wget https://repo.pureos.net/pureos/pool/main/p/pureos-archive-keyring/pureos-archive-keyring_2021.11.0_all.deb
sudo apt-get install -y ./pureos-archive-keyring_2021.11.0_all.deb

debspawn create byzantium

# Get dpkg
mkdir -p overlays/vendor/root
wget -O overlays/vendor/root/embassyos_0.3.x-1_amd64.deb <dpkg_url>

# Build byzantium-based image
./run-local-build.sh byzantium
```

In order for the build to work properly, you will need debspawn >= 0.5.1, the
build may fail with prior versions.
