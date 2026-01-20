#!/bin/bash

echo "=== Updating Nginx Configuration ==="

# 1. Backup
echo "1. Creating backup..."
sudo cp /etc/nginx/sites-available/salary /etc/nginx/sites-available/salary.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null || echo "No existing config"

# 2. Update port
echo "2. Updating to port 3011..."
sudo sed -i 's/server 127\.0\.0\.1:301[0-9];/server 127.0.0.1:3011;/g' /etc/nginx/sites-available/salary

# 3. Verify
echo "3. Verifying configuration..."
cat /etc/nginx/sites-available/salary | grep -A3 "upstream salary_backend"

# 4. Test nginx
echo "4. Testing nginx configuration..."
sudo nginx -t

# 5. Reload
if [ $? -eq 0 ]; then
    echo "5. Reloading nginx..."
    sudo systemctl reload nginx
    echo "✓ Nginx reloaded successfully"
else
    echo "✗ Nginx configuration error!"
    exit 1
fi

echo ""
echo "=== Done ==="
