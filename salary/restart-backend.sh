#!/bin/bash

echo "=== Salary Backend Restart (Production Ready) ==="

# 1. To'xtatish
echo "1. Stopping salary-backend..."
pm2 stop salary-backend 2>/dev/null || echo "Not running"
pm2 delete salary-backend 2>/dev/null || echo "Not in PM2"

# 2. Portni tozalash
echo "2. Cleaning up ports..."
lsof -ti:3010 | xargs kill -9 2>/dev/null || echo "Port 3010 free"
lsof -ti:3011 | xargs kill -9 2>/dev/null || echo "Port 3011 free"

# 3. .env tekshirish
echo "3. Checking .env configuration..."
cd /var/www/salary
if grep -q "^PORT=3011" .env; then
    echo "✓ PORT=3011 configured"
else
    echo "⚠ PORT not set to 3011, fixing..."
    sed -i '/^PORT=/d' .env
    echo "PORT=3011" >> .env
fi

# 4. Ecosystem bilan ishga tushirish
echo "4. Starting with PM2 ecosystem..."
pm2 start ecosystem.config.cjs
pm2 save

# 5. Status
echo "5. Checking status..."
sleep 3
pm2 status salary-backend

# 6. Logs
echo "6. Recent logs:"
pm2 logs salary-backend --lines 10 --nostream

# 7. Test
echo "7. Testing backend..."
sleep 2
if curl -s http://localhost:3011/api/branches > /dev/null 2>&1; then
    echo "✓ Backend responding on port 3011"
else
    echo "✗ Backend not responding"
    pm2 logs salary-backend --lines 20 --nostream
fi

echo ""
echo "=== Done ==="
echo "Monitor: pm2 logs salary-backend"
