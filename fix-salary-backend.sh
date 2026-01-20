#!/bin/bash

echo "=== Fixing Salary Backend - Switching to Port 3011 ==="

# Step 1: Stop PM2 process
echo "Step 1: Stopping PM2 salary-backend..."
pm2 stop salary-backend 2>/dev/null || echo "Process not running in PM2"
pm2 delete salary-backend 2>/dev/null || echo "Process not in PM2"

# Step 2: Check if port 3011 is free
echo "Step 2: Checking if port 3011 is free..."
PORT_PID=$(lsof -ti:3011)
if [ ! -z "$PORT_PID" ]; then
    echo "Port 3011 is in use by process $PORT_PID, killing it..."
    kill -9 $PORT_PID
    sleep 2
else
    echo "Port 3011 is free"
fi

# Step 3: Verify port is free
echo "Step 3: Verifying port 3011 is free..."
if lsof -i:3011 > /dev/null 2>&1; then
    echo "ERROR: Port 3011 is still in use!"
    lsof -i:3011
    exit 1
else
    echo "Port 3011 is now free"
fi

# Step 4: Start the backend with PM2
echo "Step 4: Starting salary backend..."
cd /var/www/salary
pm2 start server/index.js --name salary-backend --time
pm2 save

# Step 5: Wait and check status
echo "Step 5: Checking backend status..."
sleep 3
pm2 status salary-backend

# Step 6: Check if backend is responding
echo "Step 6: Testing backend connection..."
sleep 2
curl -s http://localhost:3011/api/branches > /dev/null
if [ $? -eq 0 ]; then
    echo "✓ Backend is responding on port 3011"
else
    echo "✗ Backend is not responding, checking logs..."
    pm2 logs salary-backend --lines 20 --nostream
fi

echo ""
echo "=== Done! ==="
echo "Check status: pm2 status"
echo "View logs: pm2 logs salary-backend"
