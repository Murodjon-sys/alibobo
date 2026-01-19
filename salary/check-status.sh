#!/bin/bash

# ============================================
# Salary Backend Status Checker
# Maqsad: Backend va Nginx holatini tekshirish
# ============================================

echo "============================================"
echo "🔍 Salary Backend Status Checker"
echo "============================================"
echo ""

# ============================================
# 1. PM2 STATUS
# ============================================
echo "📊 PM2 Status:"
echo "----------------------------------------"
pm2 list | grep -E "salary-backend|id.*name" || echo "❌ salary-backend topilmadi"
echo ""

# ============================================
# 2. PORT HOLATI
# ============================================
echo "🔌 Port Holati:"
echo "----------------------------------------"

for PORT in 3001 3002 3010; do
    if lsof -i :$PORT >/dev/null 2>&1; then
        echo "  ✅ Port $PORT: BAND"
        lsof -i :$PORT | grep LISTEN
    else
        echo "  ⚪ Port $PORT: BO'SH"
    fi
done
echo ""

# ============================================
# 3. PROCESS HOLATI
# ============================================
echo "⚙️  Node.js Processlar:"
echo "----------------------------------------"
ps aux | grep "server/index.js" | grep -v grep || echo "❌ server/index.js process topilmadi"
echo ""

# ============================================
# 4. PM2 LOGS (OXIRGI 10 QATOR)
# ============================================
echo "📝 Oxirgi Loglar:"
echo "----------------------------------------"
pm2 logs salary-backend --lines 10 --nostream 2>/dev/null || echo "❌ Loglar topilmadi"
echo ""

# ============================================
# 5. NGINX STATUS
# ============================================
echo "🌐 Nginx Holati:"
echo "----------------------------------------"
systemctl status nginx --no-pager | grep "Active:" || echo "❌ Nginx holati aniqlanmadi"
echo ""

# ============================================
# 6. API TEST
# ============================================
echo "🧪 API Test (GET /api/branches):"
echo "----------------------------------------"

for PORT in 3001 3010; do
    echo "  Testing port $PORT..."
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$PORT/api/branches 2>/dev/null)
    
    if [ "$RESPONSE" = "200" ]; then
        echo "  ✅ Port $PORT: API ishlayapti (HTTP $RESPONSE)"
    elif [ -n "$RESPONSE" ]; then
        echo "  ⚠️  Port $PORT: API javob berdi (HTTP $RESPONSE)"
    else
        echo "  ❌ Port $PORT: API javob bermadi"
    fi
done
echo ""

# ============================================
# 7. .ENV FAYL
# ============================================
echo "⚙️  .env Fayl:"
echo "----------------------------------------"
if [ -f "/var/www/salary/.env" ]; then
    echo "  ✅ .env fayl mavjud"
    grep "^PORT=" /var/www/salary/.env || echo "  ⚠️  PORT o'zgaruvchisi topilmadi"
else
    echo "  ❌ .env fayl topilmadi"
fi
echo ""

# ============================================
# 8. DISK VA MEMORY
# ============================================
echo "💾 Disk va Memory:"
echo "----------------------------------------"
df -h /var/www/salary | tail -1
free -h | grep -E "Mem:|Swap:"
echo ""

echo "============================================"
echo "✅ Tekshirish Tugadi!"
echo "============================================"
