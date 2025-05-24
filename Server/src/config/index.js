import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

export default {
  PORT: parseInt(process.env.PORT || '8000', 10),
  MONGODB_URI: process.env.MONGODB_URI || 'mongodb://localhost:27017/solana-hackathon',
  SOLANA_NETWORK:process.env.SOLANA_NETWORK || 'devnet',
  TOKEN_MINT_ADDRESS:process.env.TOKEN_MINT_ADDRESS || 'YourTokenMintAddress',
  ADMIN_WALLET_SECRET_KEY:process.env.ADMIN_WALLET_SECRET_KEY || 'YourAdminWalletSecretKey',
  TOKEN_DECIMALS: process.env.TOKEN_DECIMALS || 2
};