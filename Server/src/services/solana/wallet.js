// src/services/solana/wallet.js
const { Keypair } = require('@solana/web3.js');
const fs = require('fs');
const path = require('path');
const { db } = require('../../config/firebase');

// Tạo ví mới cho người dùng
const createWallet = async (userId) => {
  const newWallet = Keypair.generate();
  
  // Lưu khóa bí mật an toàn (trong thực tế nên sử dụng hệ thống quản lý khóa chuyên nghiệp)
     
  
  // Lưu thông tin ví vào Firebase
  await db.collection('wallets').doc(userId).set({
    publicKey: newWallet.publicKey.toString(),
    encryptedSecretKey: encryptedSecretKey,
    createdAt: firebase.firestore.FieldValue.serverTimestamp()
  });
  
  return {
    publicKey: newWallet.publicKey.toString()
  };
};

// Lấy thông tin ví của người dùng
const getUserWallet = async (userId) => {
  const walletDoc = await db.collection('wallets').doc(userId).get();
  
  if (!walletDoc.exists) {
    throw new Error('Ví không tồn tại');
  }
  
  return {
    publicKey: walletDoc.data().publicKey
  };
};

module.exports = {
  createWallet,
  getUserWallet
};