// src/services/solana/token.js
const { Token, TOKEN_PROGRAM_ID } = require('@solana/spl-token');
const { PublicKey, Keypair } = require('@solana/web3.js');
const { getSolanaConnection } = require('./connection');
const fs = require('fs');

// Đọc khóa bí mật của admin từ file bảo mật
const loadAdminWallet = () => {
  const secretKeyString = process.env.ADMIN_WALLET_SECRET_KEY;
  const secretKey = Uint8Array.from(JSON.parse(secretKeyString));
  return Keypair.fromSecretKey(secretKey);
};

// Chuyển token cho người dùng khi đổi rác
const transferTokenForRecycling = async (recipientPublicKey, amount) => {
  const connection = getSolanaConnection();
  const adminWallet = loadAdminWallet();
  
  try {
    // Khởi tạo token object
    const token = new Token(
      connection,
      new PublicKey(process.env.TOKEN_MINT_ADDRESS),
      TOKEN_PROGRAM_ID,
      adminWallet
    );
    
    // Lấy hoặc tạo tài khoản token của người nhận
    const recipientTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      new PublicKey(recipientPublicKey)
    );
    
    // Thực hiện chuyển token
    const transaction = await token.mintTo(
      recipientTokenAccount.address,
      adminWallet,
      [],
      amount * Math.pow(10, process.env.TOKEN_DECIMALS)
    );
    
    console.log('Token chuyển thành công:', transaction);
    return transaction;
  } catch (error) {
    console.error('Lỗi khi chuyển token:', error);
    throw error;
  }
};

module.exports = {
  transferTokenForRecycling
};