#!/system/bin/sh
# TermiX-Pro Auto-Setup Script

SETUP_MARKER="$HOME/.termix-pro-initialized"

if [ -f "$SETUP_MARKER" ]; then
    echo "TermiX-Pro already configured!"
    exit 0
fi

echo "Setting up TermiX-Pro Development Environment..."

pkg install proot-distro -y
proot-distro install ubuntu

proot-distro login ubuntu -- bash -c "
    apt update
    apt upgrade -y

    apt install -y python3 openjdk-21-jdk g++ nodejs npm php golang-go rustc cargo ruby kotlin

    apt install -y nginx fcgiwrap spawn-fcgi

    apt install -y mariadb-server
    service mariadb start

    apt install -y postgresql postgresql-contrib

    apt install -y docker.io

    wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.4/sdk/dartsdk-linux-x64-release.zip
    apt install -y unzip
    unzip -q dartsdk-linux-x64-release.zip -d /usr/lib/
    ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
    rm -f dartsdk-linux-x64-release.zip
"

touch "$SETUP_MARKER"

echo "TermiX-Pro setup complete!"
echo "Run: proot-distro login ubuntu"
