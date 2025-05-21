import dotenv from 'dotenv';
import admin from 'firebase-admin';
dotenv.config({
  path: './.env'
});

if (!process.env.FIREBASE_CONFIG) {
  throw new Error('FIREBASE_CONFIG environment variable is not set. Please check your .env file.');
}

let serviceAccount;

try {
  // Parse first
  serviceAccount = JSON.parse(process.env.FIREBASE_CONFIG);

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

export { admin };
