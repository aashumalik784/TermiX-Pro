#!/system/bin/sh
# TermiX-Pro Magic Auto-Setup Script

GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[1;31m'
CYAN=$'\033[1;36m'
RESET=$'\033[0m'
SETUP_MARKER="$HOME/.termix-pro-initialized"
LOCAL_BACKUP="/sdcard/TermiX-Pro/ubuntu-rootfs.tar.zst"
ROOTFS_DIR="$PREFIX/var/lib/proot-distro/containers/ubuntu"

if [ -f "$SETUP_MARKER" ]; then
    echo "${GREEN}TermiX-Pro already configured!${RESET}"
    exit 0
fi

echo "${CYAN}Setting up TermiX-Pro Development Environment...${RESET}"

echo "${YELLOW}Requesting storage permission...${RESET}"
yes | termux-setup-storage
sleep 3

if [ ! -d "/sdcard" ]; then
    echo "${RED}Storage permission nahi mili! Please Allow dabao.${RESET}"
    exit 1
fi

mkdir -p /sdcard/TermiX-Pro

echo "${YELLOW}Installing required packages...${RESET}"
pkg install -y proot-distro zstd wget git unzip

echo "${YELLOW}Configuring Git automatically...${RESET}"
git config --global user.email "aashumalik784@users.noreply.github.com"
git config --global user.name "Aashumalik784"

if [ -f "$LOCAL_BACKUP" ]; then
    echo "${GREEN}Found Local Backup! Fast Setup Starting...${RESET}"
    rm -rf "$ROOTFS_DIR"
    mkdir -p "$PREFIX/var/lib/proot-distro/containers"
    echo "${YELLOW}Extracting backup (Wait 2-3 mins)...${RESET}"
    tar --use-compress-program=unzstd -xf "$LOCAL_BACKUP" -C "$PREFIX/var/lib/proot-distro/containers/"
    if [ $? -eq 0 ]; then
        echo "${GREEN}Local Restore Complete!${RESET}"
    else
        echo "${RED}Extraction failed!${RESET}"
        exit 1
    fi
else
    echo "${YELLOW}No local backup. Installing from scratch...${RESET}"
    proot-distro install ubuntu
    proot-distro login ubuntu -- bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt update -y
        apt install -y python3 openjdk-21-jdk g++ nodejs npm php golang-go rustc cargo ruby kotlin nginx fcgiwrap spawn-fcgi docker.io mariadb-server postgresql postgresql-contrib wget unzip curl
        service mariadb start
        wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.4/sdk/dartsdk-linux-arm64-release.zip
        unzip -q dartsdk-linux-arm64-release.zip -d /usr/lib/
        ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
        rm -f dartsdk-linux-arm64-release.zip
    "
    echo "${YELLOW}Creating backup for next time...${RESET}"
    tar --use-compress-program="zstd -19 -T0" -cf "$LOCAL_BACKUP" -C "$PREFIX/var/lib/proot-distro/containers" ubuntu
    echo "${GREEN}Backup created!${RESET}"
fi

echo "${YELLOW}Configuring Nginx dashboard...${RESET}"
proot-distro login ubuntu -- bash -c '
cat > /etc/nginx/sites-enabled/default << "EOF"
server {
    listen 8080 default_server;
    listen [::]:8080 default_server;
    root /var/www/html;
    index index.html;
    server_name _;
    location / {
        try_files $uri $uri/ =404;
    }
}
EOF
mkdir -p /var/www/html
echo "<h1>TermiX-Pro Dashboard</h1>" > /var/www/html/index.html
'

echo "${YELLOW}Starting MariaDB and Nginx...${RESET}"
proot-distro login ubuntu -- bash -c "service mariadb start"
pkill -f "nginx -g" 2>/dev/null
nohup proot-distro login ubuntu -- nginx -g "daemon off;" > /dev/null 2>&1 &
disown
sleep 2

touch "$SETUP_MARKER"
echo "${GREEN}TermiX-Pro Setup Complete!${RESET}"
