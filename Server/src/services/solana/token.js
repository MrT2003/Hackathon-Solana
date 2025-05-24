import { Token, TOKEN_PROGRAM_ID } from '@solana/spl-token';
import { PublicKey, Keypair } from '@solana/web3.js';
import { getSolanaConnection } from './solana.js';
import fs from 'fs';
import config from '../../config/index.js';

// Read the admin's secret key from environment variable
const loadAdminWallet = () => {
  const secretKeyString = process.env.ADMIN_WALLET_SECRET_KEY;
  const secretKey = Uint8Array.from(JSON.parse(secretKeyString));
  return Keypair.fromSecretKey(secretKey);
};

// Initialize the token object
const initializeToken = async (connection, adminWallet) => {
  const tokenMintAddress = process.env.TOKEN_MINT_ADDRESS;
  if (!tokenMintAddress) throw new Error('TOKEN_MINT_ADDRESS is not defined');
  
  return new Token(
    connection,
    new PublicKey(tokenMintAddress),
    TOKEN_PROGRAM_ID,
    adminWallet
  );
};

// Mint tokens to a recipient's associated token account
const mintToken = async (recipientPublicKey, amount) => {
  const connection = getSolanaConnection();
  const adminWallet = loadAdminWallet();
  
  try {
    // Validate that the recipient public key is valid
    if (!PublicKey.isOnCurve(new PublicKey(recipientPublicKey).toBuffer())) {
      throw new Error('Invalid recipientPublicKey');
    }
    if (!Number.isInteger(amount) || amount <= 0) {
      throw new Error('Amount must be a positive integer');
    }

    const token = await initializeToken(connection, adminWallet);
    const recipientTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      new PublicKey(recipientPublicKey)
    );

    // Mint tokens
    const decimals = parseInt(config.TOKEN_DECIMALS) || 2;
    const transaction = await token.mintTo(
      recipientTokenAccount.address,
      adminWallet,
      [],
      amount * Math.pow(10, decimals)
    );

    console.log(`Successfully minted ${amount} tokens: ${transaction}`);
    return transaction;
  } catch (error) {
    console.error('Error while minting tokens:', error);
    throw new Error(`Error while minting tokens: ${error.message}`);
  }
};

// Transfer tokens to a user when they exchange waste
const transferToken = async (recipientPublicKey, amount) => {
  const connection = getSolanaConnection();
  const adminWallet = loadAdminWallet();
  
  try {
    // Validate input
    if (!PublicKey.isOnCurve(new PublicKey(recipientPublicKey).toBuffer())) {
      throw new Error('Invalid recipientPublicKey');
    }
    if (!Number.isInteger(amount) || amount <= 0) {
      throw new Error('Amount must be a positive integer');
    }

    const token = await initializeToken(connection, adminWallet);
    const recipientTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      new PublicKey(recipientPublicKey)
    );
    const adminTokenAccount = await token.getOrCreateAssociatedAccountInfo(
      adminWallet.publicKey
    );

    // Check admin balance
    const adminBalance = await token.getAccountInfo(adminTokenAccount.address);
    const decimals = parseInt(process.env.TOKEN_DECIMALS) || 2;
    const adjustedAmount = amount * Math.pow(10, decimals);
    if (adminBalance.amount < adjustedAmount) {
      throw new Error('Admin does not have enough tokens to transfer');
    }

    // Perform the token transfer
    const transaction = await token.transfer(
      adminTokenAccount.address,
      recipientTokenAccount.address,
      adminWallet,
      [],
      adjustedAmount
    );

    console.log(`Successfully transferred ${amount} tokens: ${transaction}`);
    return transaction;
  } catch (error) {
    console.error('Error while transferring tokens:', error);
    throw new Error(`Error while transferring tokens: ${error.message}`);
  }
};

export {
  loadAdminWallet,
  mintToken,
  transferToken,
};