module.exports = {
  apps: [{
    name: 'salary-backend',
    script: './server/index.js',
    cwd: '/var/www/salary',
    instances: 1,
    exec_mode: 'fork',
    autorestart: true,
    watch: false,
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production',
      PORT: 3011
    },
    error_file: '/root/.pm2/logs/salary-backend-error.log',
    out_file: '/root/.pm2/logs/salary-backend-out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss',
    merge_logs: true,
    time: true
  }]
};
