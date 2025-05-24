import { Connection, clusterApiUrl } from '@solana/web3.js';

// Create a Solana connection based on environment variable
const getSolanaConnection = () => {
  const networkUrl = process.env.SOLANA_NETWORK === 'mainnet' 
    ? clusterApiUrl('mainnet-beta') 
    : clusterApiUrl('devnet');
  
  return new Connection(networkUrl, 'confirmed');
};

export { getSolanaConnection };
