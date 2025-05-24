import { Keypair, PublicKey } from '@solana/web3.js';
import { db } from '../../config/firebaseConfig.js';
import { encryptSecretKey } from '../../utils/encrypt.js';
import config from '../../config/index.js';
import admin from 'firebase-admin';
import { getSolanaConnection } from './solana.js';

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

//* Get token balance (custom token) của wallet*
const getTokenBalance = async (publicKey, tokenMintAddress = null) => {
  try {
    const connection = getSolanaConnection();
    
    // Sử dụng token mint từ env nếu không truyền vào
    const mintAddress = tokenMintAddress || config.TOKEN_MINT_ADDRESS;
    if (!mintAddress) {
      throw new Error('Token mint address is required');
    }
    
    const tokenMintPublicKey = new PublicKey(mintAddress);
    publicKey = new PublicKey(publicKey);
    
    // Lấy token accounts của user cho token cụ thể này
    const tokenAccounts = await connection.getTokenAccountsByOwner(
      publicKey,
      { mint: tokenMintPublicKey }
    );
    
    if (tokenAccounts.value.length === 0) {
      return {
        success: true,
        balance: 0,
        tokenMintAddress: mintAddress,
        publicKey: publicKey,
        hasTokenAccount: false
      };
    }
    
    // Lấy balance của token account đầu tiên
    const tokenAccountInfo = await connection.getTokenAccountBalance(
      tokenAccounts.value[0].pubkey
    );
    
    return {
      success: true,
      balance: tokenAccountInfo.value.uiAmount || 0,
      balanceRaw: tokenAccountInfo.value.amount,
      decimals: tokenAccountInfo.value.decimals,
      tokenMintAddress: mintAddress,
      tokenAccountAddress: tokenAccounts.value[0].pubkey.toString(),
      publicKey: publicKey,
      hasTokenAccount: true
    };
    
  } catch (error) {
    console.error("Error getting token balance:", error);
    return {
      success: false,
      message: "Failed to get token balance",
      error: error.message
    };
  }
};

export {
  createWallet,
  getUserWallet,
  getTokenBalance
};