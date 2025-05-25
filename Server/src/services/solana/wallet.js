import { Keypair, PublicKey } from '@solana/web3.js';
import { db } from '../../config/firebaseConfig.js';
import { encryptSecretKey } from '../../utils/encrypt.js';
import config from '../../config/index.js';
import admin from 'firebase-admin';
import { getSolanaConnection } from './solana.js';
import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const { getAssociatedTokenAddress } = require('@solana/spl-token');

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

// const getWalletTransactionsHistory = async (publicKey) => {
//   const connection = getSolanaConnection();

//   try {
//     const tokenAccount = await getAssociatedTokenAddress(
//       new PublicKey(config.TOKEN_MINT_ADDRESS),
//       new PublicKey(publicKey)
//     );

//     const signatures = await connection.getSignaturesForAddress(tokenAccount);

//     const transactions = [];
//     for (const sig of signatures.slice(0, 10)) { // Giới hạn 10 giao dịch gần nhất
//       const tx = await connection.getParsedTransaction(sig.signature);
//       if (tx) {
//         transactions.push({
//           signature: sig.signature,
//           blockTime: tx.blockTime,
//           slot: tx.slot,
//           instructions: tx.transaction.message.instructions
//         });
//       }
//     }

//     return transactions;
//   } catch (error) {
//     console.error("Error getting transaction history:", error);
//     return {
//       success: false,
//       message: "Failed to get transaction history",
//       error: error.message
//     };
//   }
// }


async function getWalletTransactionsHistory(walletAddress, tokenMintAddress = null) {
  const connection = getSolanaConnection();
  const mintAddress = tokenMintAddress || config.TOKEN_MINT_ADDRESS;
  
  try {
    // Thay vì dùng getAssociatedTokenAddress, dùng getTokenAccountsByOwner
    const tokenAccounts = await connection.getTokenAccountsByOwner(
      new PublicKey(walletAddress),
      { mint: new PublicKey(mintAddress) }
    );
    
    if (tokenAccounts.value.length === 0) {
      return [];
    }
    
    // Lấy signatures cho tất cả token accounts
    let allSignatures = [];
    for (const account of tokenAccounts.value) {
      const signatures = await connection.getSignaturesForAddress(account.pubkey);
      allSignatures.push(...signatures);
    }
    
    // Loại bỏ duplicates
    const uniqueSignatures = allSignatures.filter((sig, index, self) => 
      index === self.findIndex(s => s.signature === sig.signature)
    );
    
    // Lấy chi tiết giao dịch
    const transactions = [];
for (const sig of uniqueSignatures.slice(0, 10)) {
  const tx = await connection.getParsedTransaction(sig.signature);
  if (tx) {
    // Lọc và thêm metadata hữu ích
    tx.transaction.message.instructions.forEach(instruction => {
      if (instruction.parsed && instruction.parsed.info) {
        transactions.push({
          ...instruction.parsed.info,
          transactionType: instruction.parsed.type,
          signature: sig.signature,
          blockTime: tx.blockTime,
          program: instruction.program
        });
      }
    });
  }
}
    
    return transactions;
  } catch (error) {
    console.error('Error:', error);
    return [];
  }
}

export {
  createWallet,
  getUserWallet,
  getTokenBalance,
  getWalletTransactionsHistory
};