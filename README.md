# TermiX-Pro - Advanced Development Environment

An all-in-one development environment for Android, featuring built-in Nginx, Docker support via PRoot, and 14+ programming languages.

## 🚀 Features

- **14+ Programming Languages**: Python 3.14, Java 25, C++ GCC 15, Node.js 22, PHP 8.5, Go 1.26, Rust 1.93, Ruby 3.3, Kotlin, Dart 3.5
- **Web Server**: Nginx 1.28.3 with CGI support
- **Databases**: MySQL 8.4, PostgreSQL 18
- **Containerization**: Docker 29.1.3
- **Web Dashboard**: Interactive browser-based interface
- **Environment**: Ubuntu Proot-Distro (x86_64)

## 📦 Installation

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/aashumalik784/TermiX-Pro.git
cd TermiX-Pro

# Run installation script
bash scripts/install-termix-pro.sh

# Start Ubuntu environment
proot-distro login ubuntu
```

### Manual Setup

1. Install Termux from F-Droid or GitHub
2. Run these commands:

```bash
pkg update -y
pkg install proot-distro -y
proot-distro install ubuntu
proot-distro login ubuntu
```

3. Inside Ubuntu, install tools:

```bash
apt update
apt install -y nginx fcgiwrap python3 openjdk-21-jdk g++ nodejs php
```

## 🌐 Web Dashboard

After installation, start the web interface:

```bash
# Inside Ubuntu
nginx
spawn-fcgi -s /run/fcgiwrap.socket -M 766 -- /usr/sbin/fcgiwrap
```

Then open browser: `http://localhost:8080`

## 🛠️ Available Tools

| Category | Tools |
|----------|-------|
| Languages | Python, Java, C++, Node.js, PHP, Go, Rust, Ruby, Kotlin, Dart |
| Web | Nginx, HTML/CSS, React (via npm) |
| Database | MySQL, PostgreSQL |
| DevOps | Docker, Git |

## 📱 Building APK

```bash
./gradlew assembleDebug
```

Or use GitHub Actions for cloud build.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines.

## 📄 License

MIT License - see LICENSE file for details

## 👨‍💻 Author

Aashu Malik (@aashumalik784)

## 🚀 TermiX-Pro Setup

After installing the APK, run this command once to set up the development environment:

```bash
pkg install proot-distro -y
proot-distro install ubuntu
proot-distro login ubuntu
```

Inside Ubuntu, run:

```bash
apt update && apt install -y python3 openjdk-21-jdk g++ nodejs npm php golang-go rustc cargo ruby nginx fcgiwrap spawn-fcgi mysql-client postgresql docker.io kotlin
```

For Dart:

```bash
wget -q https://storage.googleapis.com/dart-archive/channels/stable/release/3.5.4/sdk/dartsdk-linux-x64-release.zip
unzip -q dartsdk-linux-x64-release.zip -d /usr/lib/
ln -sf /usr/lib/dart-sdk/bin/dart /usr/local/bin/dart
rm -f dartsdk-linux-x64-release.zip
```

## 🌐 Web Dashboard

Start web dashboard:

```bash
# Inside Ubuntu
nginx
spawn-fcgi -s /run/fcgiwrap.socket -M 766 -- /usr/sbin/fcgiwrap
```

Then open browser: `http://localhost:8080`
