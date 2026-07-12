#!/system/bin/sh
# TermiX-Pro Auto-Setup Script

SETUP_MARKER="$HOME/.termix-pro-initialized"
ROOTFS_URL="https://github.com/aashumalik784/TermiX-Pro/releases/download/rootfs-v1/termix-pro-rootfs-arm64.tar.zst"

if [ -f "$SETUP_MARKER" ]; then
    echo "TermiX-Pro already configured!"
    exit 0
fi

echo "Setting up TermiX-Pro Development Environment..."

pkg install proot-distro -y
proot-distro install ubuntu

FAST_SETUP_DONE=0

if command -v wget >/dev/null 2>&1 || pkg install -y wget; then
    ROOTFS_PATH="$PREFIX/var/lib/proot-distro/containers/ubuntu/rootfs"
    echo "Trying fast setup (downloading pre-built environment)..."
    wget -q -O /sdcard/termix-rootfs.tar.zst "$ROOTFS_URL"
    if [ -s /sdcard/termix-rootfs.tar.zst ]; then
        pkg install -y zstd
        tar --use-compress-program=unzstd -xf /sdcard/termix-rootfs.tar.zst -C "$ROOTFS_PATH" 2>/dev/null
        if [ $? -eq 0 ]; then
            FAST_SETUP_DONE=1
            rm -f /sdcard/termix-rootfs.tar.zst
            echo "Fast setup successful!"
        fi
    fi
fi

if [ "$FAST_SETUP_DONE" -eq 0 ]; then
    echo "Fast setup unavailable, falling back to manual install (this will take longer)..."
    proot-distro login ubuntu -- bash -c "
        apt update
        apt upgrade -y

        apt install -y wget unzip python3 openjdk-21-jdk g++ nodejs npm php golang-go rustc cargo ruby kotlin

        apt install -y nginx fcgiwrap spawn-fcgi

        apt install -y mariadb-server
        service mariadb start

        apt install -y postgresql postgresql-contrib

        apt install -y docker.io

        wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.4/sdk/dartsdk-linux-arm64-release.zip
        unzip -q dartsdk-linux-arm64-release.zip -d /usr/lib/
        ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
        rm -f dartsdk-linux-arm64-release.zip
    "
fi

touch "$SETUP_MARKER" 2>/dev/null

echo "TermiX-Pro setup complete!"
echo "Run: proot-distro login ubuntu"
