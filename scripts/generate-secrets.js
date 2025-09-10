#!/usr/bin/env node

const crypto = require('crypto');

/**
 * Script pour générer des secrets sécurisés pour Strapi
 * Usage: node scripts/generate-secrets.js
 */

function generateSecret(length = 32) {
  return crypto.randomBytes(length).toString('hex');
}

function generateAppKeys(count = 4) {
  const keys = [];
  for (let i = 0; i < count; i++) {
    keys.push(generateSecret(32));
  }
  return keys.join(',');
}

console.log('🔐 Génération des secrets Strapi...\n');

const secrets = {
  ADMIN_JWT_SECRET: generateSecret(32),
  ENCRYPTION_KEY: generateSecret(32), 
  API_TOKEN_SALT: generateSecret(16),
  APP_KEYS: generateAppKeys(4),
  TRANSFER_TOKEN_SALT: generateSecret(16)
};

console.log('# Copiez ces valeurs dans votre fichier .env:');
console.log('# =============================================\n');

Object.entries(secrets).forEach(([key, value]) => {
  console.log(`${key}=${value}`);
});

console.log('\n# =============================================');
console.log('# ⚠️  IMPORTANT: Gardez ces secrets confidentiels !');
console.log('# ⚠️  Utilisez des valeurs différentes pour la production !');
