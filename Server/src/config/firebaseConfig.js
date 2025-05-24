import dotenv from 'dotenv';
import admin from 'firebase-admin';
import config from '../config/index.js';

let serviceAccount;

try {
  // Parse first
  // serviceAccount = JSON.parse(process.env.FIREBASE_CONFIG);
  serviceAccount = JSON.parse(config.FIREBASE_CONFIG);

  // Then fix the private_key field only
  if (serviceAccount.private_key) {
    serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');
  }
} catch (error) {
  throw new Error('Failed to parse FIREBASE_CONFIG. Make sure it contains valid JSON: ' + error.message);
}

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

export { admin , db };