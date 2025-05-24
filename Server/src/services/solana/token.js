const { Token, TOKEN_PROGRAM_ID } = require('@solana/spl-token');
const { PublicKey, Keypair } = require('@solana/web3.js');
const { getSolanaConnection } = require('./connection');
const fs = require('fs');
import config from '../../config';

// Đọc khóa bí mật của admin từ file bảo mật
const loadAdminWallet = () => {
  const secretKeyString = process.env.ADMIN_WALLET_SECRET_KEY;
  const secretKey = Uint8Array.from(JSON.parse(secretKeyString));
  return Keypair.fromSecretKey(secretKey);
};

// Khởi tạo token object
const initializeToken = async (connection, adminWallet) => {
  const tokenMintAddress = process.env.TOKEN_MINT_ADDRESS;
  if (!tokenMintAddress) throw new Error('TOKEN_MINT_ADDRESS không được định nghĩa');
  
  return new Token(
    connection,
    new PublicKey(tokenMintAddress),
    TOKEN_PROGRAM_ID,
    adminWallet
  );
};

const mintToken = async (recipientPublicKey, amount) => {
  const connection = getSolanaConnection();
  const adminWallet = loadAdminWallet();
  
  try {
    // Validation the public key is valid or not 
    if (!PublicKey.isOnCurve(new PublicKey(recipientPublicKey).toBuffer())) {
      throw new Error('recipientPublicKey không hợp lệ');
    }
    if (!Number.isInteger(amount) || amount <= 0) {
      throw new Error('Số lượng token phải là số nguyên dương');
    }

    const token = await initializeToken(connection, adminWallet);
    const recipientTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      new PublicKey(recipientPublicKey)
    );

    // Mint token
    const decimals = parseInt(config.TOKEN_DECIMALS) || 2;
    const transaction = await token.mintTo(
      recipientTokenAccount.address,
      adminWallet,
      [],
      amount * Math.pow(10, decimals)
    );

    console.log(`Mint ${amount} token thành công: ${transaction}`);
    return transaction;
  } catch (error) {
    console.error('Lỗi khi mint token:', error);
    throw new Error(`Lỗi khi mint token: ${error.message}`);
  }
};

// Chuyển token cho người dùng khi đổi rác
const transferToken = async (recipientPublicKey, amount) => {
  const connection = getSolanaConnection();
  const adminWallet = loadAdminWallet();
  
  try {
    // Validation
    if (!PublicKey.isOnCurve(new PublicKey(recipientPublicKey).toBuffer())) {
      throw new Error('recipientPublicKey không hợp lệ');
    }
    if (!Number.isInteger(amount) || amount <= 0) {
      throw new Error('Số lượng token phải là số nguyên dương');
    }

    const token = await initializeToken(connection, adminWallet);
    const recipientTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      new PublicKey(recipientPublicKey)
    );
    const adminTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      adminWallet.publicKey
    );

    // Kiểm tra số dư admin
    const adminBalance = await token.getAccountInfo(adminTokenAccount.address);
    const decimals = parseInt(process.env.TOKEN_DECIMALS) || 2;
    const adjustedAmount = amount * Math.pow(10, decimals);
    if (adminBalance.amount < adjustedAmount) {
      throw new Error('Số dư admin không đủ để chuyển token');
    }

    // Thực hiện chuyển token
    const transaction = await token.transfer(
      adminTokenAccount.address,
      recipientTokenAccount.address,
      adminWallet,
      [],
      adjustedAmount
    );

    console.log(`Chuyển ${amount} token thành công: ${transaction}`);
    return transaction;
  } catch (error) {
    console.error('Lỗi khi chuyển token:', error);
    throw new Error(`Lỗi khi chuyển token: ${error.message}`);
  }
};

module.exports = {
  transferTokenForRecycling
};