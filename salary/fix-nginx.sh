#!/bin/bash

# ============================================
# Nginx Konfiguratsiyasini Tuzatish
# Maqsad: Duplicate server_name warning'larini hal qilish
# ============================================

set -e

echo "🔧 Nginx konfiguratsiyasini tuzatish..."
echo ""

# ============================================
# 1. NGINX KONFIGURATSIYALARINI TEKSHIRISH
# ============================================
echo "🔍 Nginx konfiguratsiyalarini tekshirish..."

# Barcha enabled sites'larni ko'rish
echo "  ➜ Enabled sites:"
ls -la /etc/nginx/sites-enabled/ 2>/dev/null || echo "    Hech narsa topilmadi"
echo ""

# Duplicate server_name'larni topish
echo "  ➜ Duplicate server_name'larni qidirish..."
DUPLICATES=$(grep -r "server_name" /etc/nginx/sites-enabled/ 2>/dev/null | grep -v "#" | awk '{print $2}' | sort | uniq -d)

if [ -n "$DUPLICATES" ]; then
    echo "⚠️  Duplicate server_name'lar topildi:"
    echo "$DUPLICATES"
    echo ""
else
    echo "✅ Duplicate server_name'lar yo'q"
    echo ""
fi

# ============================================
# 2. SALARY NGINX KONFIGURATSIYASINI YARATISH
# ============================================
echo "📝 Salary uchun Nginx konfiguratsiyasini yaratish..."

cat > /etc/nginx/sites-available/salary << 'EOF'
# Salary Management - Nginx Configuration
# Domain: oylik.aliboboqurilish.uz
# Backend Port: 3001 (PM2)
# Frontend: Static files in /var/www/salary/dist

# Backend API Server
upstream salary_backend {
    server 127.0.0.1:3001;
    keepalive 64;
}

# Main Server Block
server {
    listen 80;
    listen [::]:80;
    
    # Server name - UNIQUE!
    server_name oylik.aliboboqurilish.uz;
    
    # Logs
    access_log /var/log/nginx/salary-access.log;
    error_log /var/log/nginx/salary-error.log;
    
    # Client body size limit
    client_max_body_size 50M;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types text/plain text/css text/xml text/javascript 
               application/x-javascript application/xml+rss 
               application/json application/javascript;
    
    # Frontend static files root
    root /var/www/salary/dist;
    index index.html;
    
    # Backend API - /api bilan boshlanadigan barcha so'rovlar
    location /api/ {
        proxy_pass http://salary_backend;
        proxy_http_version 1.1;
        
        # Headers
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
        
        # Cache bypass
        proxy_cache_bypass $http_upgrade;
        
        # Disable buffering
        proxy_buffering off;
    }
    
    # Frontend - Root va boshqa barcha so'rovlar
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Static files caching
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Health check endpoint
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
EOF

echo "✅ Nginx konfiguratsiya yaratildi"
echo ""

# ============================================
# 3. SYMBOLIC LINK YARATISH
# ============================================
echo "🔗 Symbolic link yaratish..."

# Eski linkni o'chirish
rm -f /etc/nginx/sites-enabled/salary

# Yangi link yaratish
ln -sf /etc/nginx/sites-available/salary /etc/nginx/sites-enabled/salary

echo "✅ Symbolic link yaratildi"
echo ""

# ============================================
# 4. NGINX TESTINI O'TKAZISH
# ============================================
echo "✅ Nginx konfiguratsiyasini test qilish..."

if nginx -t; then
    echo "✅ Nginx konfiguratsiyasi to'g'ri"
    echo ""
    
    # ============================================
    # 5. NGINX NI RESTART QILISH
    # ============================================
    echo "🔄 Nginx ni restart qilish..."
    systemctl restart nginx
    echo "✅ Nginx restart qilindi"
    echo ""
else
    echo "❌ Nginx konfiguratsiyasida xato bor!"
    echo "Iltimos, xatolarni tuzating va qayta urinib ko'ring."
    exit 1
fi

# ============================================
# 6. NGINX STATUSINI TEKSHIRISH
# ============================================
echo "📊 Nginx statusini tekshirish..."
systemctl status nginx --no-pager | head -10
echo ""

echo "============================================"
echo "🎉 Nginx Konfiguratsiyasi Tugadi!"
echo "============================================"
echo ""
echo "📝 Foydali komandalar:"
echo "  - Status: systemctl status nginx"
echo "  - Restart: systemctl restart nginx"
echo "  - Reload: systemctl reload nginx"
echo "  - Test: nginx -t"
echo "  - Loglar: tail -f /var/log/nginx/salary-error.log"
echo ""
