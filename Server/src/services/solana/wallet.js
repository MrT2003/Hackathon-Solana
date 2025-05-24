import { Keypair } from '@solana/web3.js';
import { db } from '../../config/firebaseConfig.js';
import { encryptSecretKey } from '../../utils/encrypt.js';
import config from '../../config/index.js';
import admin from 'firebase-admin';

const createWallet = async (userId) => {
  // Kiểm tra user có tồn tại không
  const userDoc = await db.collection("users").doc(userId).get();
  if (!userDoc.exists) {
    console.log("User does not exist in the database");
    return { success: false, message: "User does not exist" };
  }

  try {
    // Tạo ví mới
    const newWallet = Keypair.generate();

    // Mã hóa secretKey
    const encryptedSecretKey = encryptSecretKey(
      newWallet.secretKey,
      config.ENCRYPTIONKEY
    );

    // Lưu vào Firestore
    await db.collection("wallets").doc(userId).set({
      publicKey: newWallet.publicKey.toString(),
      encryptedSecretKey,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      publicKey: newWallet.publicKey.toString(),
    };
  } catch (error) {
    console.error("Error creating wallet:", error);
    return {
      success: false,
      message: "Failed to create wallet",
      error: error.message,
    };
  }
};

// Get wallet information of a user
const getUserWallet = async (userId) => {
  const walletDoc = await db.collection('wallets').doc(userId).get();

  if (!walletDoc.exists) {
    throw new Error('Wallet does not exist');
  }

  return {
    publicKey: walletDoc.data().publicKey
  };
};

export {
  createWallet,
  getUserWallet
};
