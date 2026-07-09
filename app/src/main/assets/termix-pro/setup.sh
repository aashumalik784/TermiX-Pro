#!/system/bin/sh
# TermiX-Pro Auto-Setup Script

SETUP_MARKER="/sdcard/.termix-pro-initialized"

if [ -f "$SETUP_MARKER" ]; then
    echo "TermiX-Pro already configured!"
    exit 0
fi

echo "🚀 Setting up TermiX-Pro Development Environment..."

# Install proot-distro
pkg install proot-distro -y

# Install Ubuntu
proot-distro install ubuntu

# Install all tools
proot-distro login ubuntu -- bash -c "
    apt update
    apt upgrade -y
    
    # Programming Languages
    apt install -y python3 openjdk-21-jdk g++ nodejs npm php golang-go rustc cargo ruby
    
    # Web & Server
    apt install -y nginx fcgiwrap spawn-fcgi
    
    # Databases
    apt install -y mysql-client postgresql postgresql-contrib
    
    # Container
    apt install -y docker.io
    
    # Kotlin & Dart
    apt install -y kotlin
    
    # Dart installation
    wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.4/sdk/dartsdk-linux-x64-release.zip
    apt install -y unzip
    unzip -q dartsdk-linux-x64-release.zip -d /usr/lib/
    ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
    rm -f dartsdk-linux-x64-release.zip
"

# Mark setup complete
touch "$SETUP_MARKER"

echo "✅ TermiX-Pro setup complete!"
echo "Run: proot-distro login ubuntu"
