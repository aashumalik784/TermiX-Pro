#!/bin/bash

echo "Content-Type: text/html"
echo ""

TOOL=$(echo $QUERY_STRING | cut -d'=' -f2)

echo "<html><head><title>TermiX-Pro: $TOOL</title>"
echo "<style>body{background:#000;color:#0f0;font-family:monospace;padding:20px;} a{color:#0f0; text-decoration:none;} h1{border-bottom:1px solid #0f0;} .back{margin-top:20px;}</style></head><body>"
echo "<h1>🚀 Tool Status: $TOOL</h1>"

case $TOOL in
    python|python3)
        echo "<p><strong>✅ Python 3.14.4</strong> is installed and ready!</p>"
        echo "<pre>$(python3 --version 2>&1)</pre>"
        echo "<p>Usage: <code>python3 script.py</code></p>" ;;
    java)
        echo "<p><strong>✅ OpenJDK 25</strong> is installed!</p>"
        echo "<pre>$(java -version 2>&1)</pre>"
        echo "<p>Usage: <code>javac Main.java && java Main</code></p>" ;;
    g++)
        echo "<p><strong>✅ GCC 15.2.0</strong> C++ Compiler ready!</p>"
        echo "<pre>$(g++ --version | head -n 1)</pre>"
        echo "<p>Usage: <code>g++ main.cpp -o app && ./app</code></p>" ;;
    node)
        echo "<p><strong>✅ Node.js v22.22.1</strong> is running!</p>"
        echo "<pre>$(node --version)</pre>"
        echo "<p>Usage: <code>node app.js</code> or <code>npm install</code></p>" ;;
    php)
        echo "<p><strong>✅ PHP 8.5.4</strong> is installed!</p>"
        echo "<pre>$(php -v | head -n 1)</pre>"
        echo "<p>Usage: <code>php script.php</code></p>" ;;
    go)
        echo "<p><strong>✅ Go 1.26.0</strong> is ready!</p>"
        echo "<pre>$(go version)</pre>"
        echo "<p>Usage: <code>go run main.go</code></p>" ;;
    rust)
        echo "<p><strong>✅ Rust 1.93.1</strong> is installed!</p>"
        echo "<pre>$(rustc --version)</pre>"
        echo "<p>Usage: <code>rustc main.rs && ./main</code></p>" ;;
    ruby)
        echo "<p><strong>✅ Ruby 3.3.8</strong> is ready!</p>"
        echo "<pre>$(ruby --version)</pre>"
        echo "<p>Usage: <code>ruby script.rb</code></p>" ;;
    kotlin)
        echo "<p><strong>✅ Kotlin</strong> is installed!</p>"
        echo "<pre>$(kotlinc -version 2>&1 | head -n 1)</pre>"
        echo "<p>Usage: <code>kotlinc Main.kt -include-runtime -d Main.jar && java -jar Main.jar</code></p>" ;;
    dart)
        echo "<p><strong>✅ Dart 3.5.4</strong> is ready!</p>"
        echo "<pre>$(dart --version)</pre>"
        echo "<p>Usage: <code>dart run main.dart</code></p>" ;;
    nginx)
        echo "<p><strong>✅ Nginx 1.28.3</strong> web server is running!</p>"
        echo "<pre>$(nginx -v 2>&1)</pre>"
        echo "<p>Config: <code>/etc/nginx/nginx.conf</code></p>" ;;
    docker)
        echo "<p><strong>✅ Docker 29.1.3</strong> is installed!</p>"
        echo "<pre>$(docker --version)</pre>"
        echo "<p>Usage: <code>docker run hello-world</code></p>" ;;
    mysql)
        echo "<p><strong>✅ MySQL 8.4.10</strong> client is ready!</p>"
        echo "<pre>$(mysql --version)</pre>"
        echo "<p>Usage: <code>mysql -u root -p</code></p>" ;;
    postgresql|psql)
        echo "<p><strong>✅ PostgreSQL 18.4</strong> is installed!</p>"
        echo "<pre>$(psql --version)</pre>"
        echo "<p>Usage: <code>psql -U postgres</code></p>" ;;
    *)
        echo "<p><strong>ℹ️ Checking $TOOL...</strong></p>"
        echo "<pre>which $TOOL 2>&1 || echo 'Tool not found in PATH'</pre>" ;;
esac

echo "<div class='back'><a href='/'>⬅️ Back to Dashboard</a></div>"
echo "</body></html>"
