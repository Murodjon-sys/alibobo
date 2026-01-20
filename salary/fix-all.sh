#!/bin/bash

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Salary Backend - Complete Fix (Production Ready)     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

cd /var/www/salary

# 1. Backend restart
echo "STEP 1: Restarting Backend..."
chmod +x restart-backend.sh
./restart-backend.sh

echo ""
echo "─────────────────────────────────────────────────────────"
echo ""

# 2. Nginx update
echo "STEP 2: Updating Nginx..."
chmod +x update-nginx.sh
./update-nginx.sh

echo ""
echo "─────────────────────────────────────────────────────────"
echo ""

# 3. Final test
echo "STEP 3: Final Testing..."
sleep 3

echo "Testing localhost:3011..."
if curl -s http://localhost:3011/api/branches > /dev/null 2>&1; then
    echo "✓ Backend: OK"
else
    echo "✗ Backend: FAILED"
fi

echo ""
echo "Testing via domain..."
if curl -s https://oylik.aliboboqurilish.uz/api/branches > /dev/null 2>&1; then
    echo "✓ Domain: OK"
else
    echo "✗ Domain: FAILED (check SSL/DNS)"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  ✓ COMPLETE                                            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Monitor logs: pm2 logs salary-backend"
echo "Check status: pm2 status"
echo "Nginx logs: sudo tail -f /var/log/nginx/salary-error.log"
