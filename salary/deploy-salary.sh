#!/bin/bash

# ============================================
# Salary Backend Deploy Script
# Maqsad: Port conflict xatosini hal qilish va backend ni ishga tushirish
# ============================================

set -e  # Xato bo'lsa to'xtatish

echo "🚀 Salary Backend Deploy Boshlandi..."
echo ""

# ============================================
# 1. O'ZGARUVCHILAR
# ============================================
PROJECT_DIR="/var/www/salary"
PROCESS_NAME="salary-backend"
DESIRED_PORT=3001
BACKUP_PORT=3002

echo "📁 Loyiha papkasi: $PROJECT_DIR"
echo "🔧 Process nomi: $PROCESS_NAME"
echo "🔌 Asosiy port: $DESIRED_PORT"
echo ""

# ============================================
# 2. ESKI PROCESSLARNI TOZALASH
# ============================================
echo "🧹 Eski processlarni tozalash..."

# PM2 dan o'chirish
if pm2 list | grep -q "$PROCESS_NAME"; then
    echo "  ➜ PM2 dan $PROCESS_NAME ni o'chirish..."
    pm2 delete "$PROCESS_NAME" 2>/dev/null || true
    sleep 2
fi

# Port 3010 ni bo'shatish (eski port)
if lsof -i :3010 >/dev/null 2>&1; then
    echo "  ➜ Port 3010 ni bo'shatish..."
    fuser -k 3010/tcp 2>/dev/null || true
    sleep 1
fi

# Port 3001 ni bo'shatish (yangi port)
if lsof -i :$DESIRED_PORT >/dev/null 2>&1; then
    echo "  ➜ Port $DESIRED_PORT ni bo'shatish..."
    fuser -k $DESIRED_PORT/tcp 2>/dev/null || true
    sleep 1
fi

echo "✅ Eski processlar tozalandi"
echo ""

# ============================================
# 3. LOYIHA PAPKASINI TEKSHIRISH
# ============================================
echo "📂 Loyiha papkasini tekshirish..."

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Xato: $PROJECT_DIR papkasi topilmadi!"
    exit 1
fi

cd "$PROJECT_DIR"
echo "✅ Hozirgi papka: $(pwd)"
echo ""

# ============================================
# 4. .ENV FAYLINI SOZLASH
# ============================================
echo "⚙️  .env faylini sozlash..."

if [ ! -f ".env" ]; then
    echo "  ➜ .env fayl topilmadi, yangi yaratilmoqda..."
    cat > .env << EOF
MONGODB_URI=mongodb+srv://lmurodjon556_db_user:fPv2JMKt2IbBVNt7@cluster0.e5ikopt.mongodb.net/salary-management?retryWrites=true&w=majority
PORT=$DESIRED_PORT

# Regos API
REGOS_API_URL=https://api.regos.uz/v1
REGOS_API_KEY=your_regos_api_key_here
REGOS_COMPANY_ID=your_company_id_here

# Admin Login
ADMIN_LOGIN=Nurik1111
ADMIN_PASSWORD=Nurik3335

# Manager Login (Faqat ko'rish rejimi)
MANAGER_LOGIN=Menjer1111
MANAGER_PASSWORD=Menejer1111

# G'ijduvon Manager Login (Faqat G'ijduvon filiali)
GIJDUVON_MANAGER_LOGIN=Mamat0406
GIJDUVON_MANAGER_PASSWORD=Mamat0406

# Navoiy Manager Login (Faqat Navoiy filiali)
NAVOI_MANAGER_LOGIN=Zikrillo7596
NAVOI_MANAGER_PASSWORD=Zikrillo7596
EOF
else
    # PORT ni yangilash
    if grep -q "^PORT=" .env; then
        sed -i "s/^PORT=.*/PORT=$DESIRED_PORT/" .env
        echo "  ➜ PORT yangilandi: $DESIRED_PORT"
    else
        echo "PORT=$DESIRED_PORT" >> .env
        echo "  ➜ PORT qo'shildi: $DESIRED_PORT"
    fi
fi

echo "✅ .env fayl sozlandi"
echo ""

# ============================================
# 5. DEPENDENCIES NI TEKSHIRISH
# ============================================
echo "📦 Dependencies ni tekshirish..."

if [ ! -d "node_modules" ]; then
    echo "  ➜ node_modules topilmadi, o'rnatilmoqda..."
    npm install
else
    echo "  ➜ node_modules mavjud"
fi

echo "✅ Dependencies tayyor"
echo ""

# ============================================
# 6. PM2 ECOSYSTEM FAYLINI YARATISH
# ============================================
echo "📝 PM2 ecosystem faylini yaratish..."

cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: '$PROCESS_NAME',
    script: './server/index.js',
    instances: 1,
    exec_mode: 'fork',
    watch: false,
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production',
      PORT: $DESIRED_PORT
    },
    error_file: './logs/error.log',
    out_file: './logs/out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    autorestart: true,
    max_restarts: 10,
    min_uptime: '10s',
    listen_timeout: 3000,
    kill_timeout: 5000
  }]
};
EOF

# Logs papkasini yaratish
mkdir -p logs

echo "✅ Ecosystem fayl yaratildi"
echo ""

# ============================================
# 7. PORTNI TEKSHIRISH
# ============================================
echo "🔍 Port $DESIRED_PORT ni tekshirish..."

if lsof -i :$DESIRED_PORT >/dev/null 2>&1; then
    echo "⚠️  Port $DESIRED_PORT hali ham band!"
    echo "  ➜ Backup port $BACKUP_PORT ga o'tkazilmoqda..."
    
    # .env ni yangilash
    sed -i "s/^PORT=.*/PORT=$BACKUP_PORT/" .env
    
    # ecosystem.config.js ni yangilash
    sed -i "s/PORT: $DESIRED_PORT/PORT: $BACKUP_PORT/" ecosystem.config.js
    
    FINAL_PORT=$BACKUP_PORT
else
    echo "✅ Port $DESIRED_PORT bo'sh"
    FINAL_PORT=$DESIRED_PORT
fi

echo ""

# ============================================
# 8. BACKEND NI ISHGA TUSHIRISH
# ============================================
echo "🚀 Backend ni ishga tushirish..."

pm2 start ecosystem.config.js
sleep 3

echo "✅ Backend ishga tushirildi"
echo ""

# ============================================
# 9. PM2 NI SAQLASH
# ============================================
echo "💾 PM2 konfiguratsiyasini saqlash..."

pm2 save
pm2 startup | tail -1 | bash 2>/dev/null || true

echo "✅ PM2 saqlandi"
echo ""

# ============================================
# 10. STATUSNI TEKSHIRISH
# ============================================
echo "📊 Backend statusini tekshirish..."
echo ""

pm2 list | grep "$PROCESS_NAME" || echo "⚠️  Process topilmadi"
echo ""

# ============================================
# 11. LOGLARNI KO'RSATISH
# ============================================
echo "📝 Oxirgi loglar:"
echo ""

pm2 logs "$PROCESS_NAME" --lines 15 --nostream

echo ""
echo "============================================"
echo "🎉 Deploy Tugadi!"
echo "============================================"
echo ""
echo "📊 Foydali komandalar:"
echo "  - Status: pm2 list"
echo "  - Loglar: pm2 logs $PROCESS_NAME"
echo "  - Restart: pm2 restart $PROCESS_NAME"
echo "  - Stop: pm2 stop $PROCESS_NAME"
echo "  - Delete: pm2 delete $PROCESS_NAME"
echo ""
echo "🌐 Backend manzili: http://localhost:$FINAL_PORT"
echo "🔗 API test: curl http://localhost:$FINAL_PORT/api/branches"
echo ""
