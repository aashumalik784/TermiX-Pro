#!/system/bin/sh
# TermiX-Pro Ultimate Auto-Setup Script

SETUP_MARKER="$HOME/.termix-pro-initialized"
LOCAL_BACKUP="/sdcard/TermiX-Pro/ubuntu-rootfs.tar.zst"
ROOTFS_DIR="$PREFIX/var/lib/proot-distro/containers/ubuntu"

if [ -f "$SETUP_MARKER" ]; then
    echo "✅ TermiX-Pro already configured!"
    exit 0
fi

echo "🚀 Setting up TermiX-Pro Development Environment..."
mkdir -p /sdcard/TermiX-Pro

# --- FAST PATH: Local Backup Found ---
if [ -f "$LOCAL_BACKUP" ]; then
    echo "⚡ Found Local Backup! Fast Setup Starting..."
    pkg install -y zstd
    
    # Clean old container
    rm -rf "$ROOTFS_DIR"
    mkdir -p "$PREFIX/var/lib/proot-distro/containers"
    
    # Extract backup
    echo "⏳ Extracting 1.6GB backup (Wait 1-2 mins)..."
    tar --use-compress-program=unzstd -xf "$LOCAL_BACKUP" \
        -C "$PREFIX/var/lib/proot-distro/containers/" \
        --strip-components=9
        
    echo "✅ Local Restore Complete!"

# --- SLOW PATH: No Backup, Install from Scratch ---
else
    echo " No local backup. Installing from scratch (This will take 15-30 mins)..."
    pkg install -y proot-distro wget zstd
    proot-distro install ubuntu
    
    proot-distro login ubuntu -- bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt update -y
        apt install -y python3 openjdk-21-jdk g++ nodejs php golang-go rustc ruby kotlin nginx docker.io mariadb-client postgresql wget unzip curl
        
        # Install Dart
        cd /opt
        wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-arm64-release.zip
        unzip -q dartsdk-linux-arm64-release.zip
        rm -f dartsdk-linux-arm64-release.zip
        ln -sf /opt/dart-sdk/bin/dart /usr/local/bin/dart
    "
    
    # Create backup for next time
    echo " Creating local backup for future fast setup..."
    tar --use-compress-program=zstd -cf "$LOCAL_BACKUP" "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
    echo "✅ Backup created!"
fi

# Start Nginx
proot-distro login ubuntu -- bash -c "nginx"

# Create Marker
touch "$SETUP_MARKER"
echo "🎉 TermiX-Pro Setup Complete!"
echo "Run: proot-distro login ubuntu"
