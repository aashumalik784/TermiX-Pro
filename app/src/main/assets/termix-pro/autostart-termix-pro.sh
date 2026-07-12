#!/system/bin/sh
# TermiX-Pro Magic Auto-Setup Script

SETUP_MARKER="$HOME/.termix-pro-initialized"
LOCAL_BACKUP="/sdcard/TermiX-Pro/ubuntu-rootfs.tar.zst"
ROOTFS_DIR="$PREFIX/var/lib/proot-distro/containers/ubuntu"

if [ -f "$SETUP_MARKER" ]; then
    echo "✅ TermiX-Pro already configured!"
    exit 0
fi

echo "🚀 Setting up TermiX-Pro Development Environment..."

# --- Step 1: Automatic Storage Permission ---
echo "📂 Requesting storage permission..."
termux-setup-storage
sleep 3

if [ ! -d "/sdcard" ]; then
    echo "❌ Storage permission nahi mili! Please 'Allow' dabao."
    exit 1
fi

mkdir -p /sdcard/TermiX-Pro

# --- Step 2: Install Required Packages ---
echo " Installing required packages..."
pkg install -y proot-distro zstd wget git

# --- Step 3: Git Auto-Config ---
echo "⚙️ Configuring Git automatically..."
git config --global user.email "aashumalik784@users.noreply.github.com"
git config --global user.name "Aashumalik784"

# --- FAST PATH: Local Backup Found ---
if [ -f "$LOCAL_BACKUP" ]; then
    echo " Found Local Backup! Fast Setup Starting..."
    rm -rf "$ROOTFS_DIR"
    mkdir -p "$PREFIX/var/lib/proot-distro/containers"
    echo "⏳ Extracting 1.6GB backup (Wait 2-3 mins)..."
    tar --use-compress-program=unzstd -xf "$LOCAL_BACKUP" \
        -C "$PREFIX/var/lib/proot-distro/containers/" \
        --strip-components=9
    if [ $? -eq 0 ]; then
        echo "✅ Local Restore Complete!"
    else
        echo "❌ Extraction failed!"
        exit 1
    fi
else
    echo "⏳ No local backup. Installing from scratch..."
    proot-distro install ubuntu
    proot-distro login ubuntu -- bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt update -y
        apt install -y python3 openjdk-21-jdk g++ nodejs php golang-go rustc ruby kotlin nginx docker.io mariadb-client postgresql wget unzip curl
        cd /opt
        wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-arm64-release.zip
        unzip -q dartsdk-linux-arm64-release.zip
        rm -f dartsdk-linux-arm64-release.zip
        ln -sf /opt/dart-sdk/bin/dart /usr/local/bin/dart
    "
    echo "📦 Creating backup..."
    tar --use-compress-program=zstd -cf "$LOCAL_BACKUP" "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu"
    echo "✅ Backup created!"
fi

echo "🌐 Starting Nginx..."
proot-distro login ubuntu -- bash -c "nginx"

touch "$SETUP_MARKER"
echo " TermiX-Pro Setup Complete!"
