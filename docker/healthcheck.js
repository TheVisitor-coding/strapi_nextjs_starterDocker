#!/usr/bin/env node

/**
 * Generic Health Check Script for Node.js Applications
 * This script checks if the application is running and responding
 */

const http = require('http');
const url = require('url');

const port = process.env.PORT || 3000;
const healthPath = process.env.HEALTH_PATH || '/api/health';

const options = {
  hostname: 'localhost',
  port: port,
  path: healthPath,
  method: 'GET',
  timeout: 5000
};

const req = http.request(options, (res) => {
  if (res.statusCode >= 200 && res.statusCode < 300) {
    console.log('Health check passed');
    process.exit(0);
  } else {
    console.log(`Health check failed with status: ${res.statusCode}`);
    process.exit(1);
  }
});

req.on('error', (err) => {
  console.log(`Health check error: ${err.message}`);
  process.exit(1);
});

req.on('timeout', () => {
  console.log('Health check timeout');
  req.destroy();
  process.exit(1);
});

req.end(); 