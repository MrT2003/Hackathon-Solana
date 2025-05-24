const { Connection, clusterApiUrl } = require('@solana/web3.js');

const getSolanaConnection = () => {
  const networkUrl = process.env.SOLANA_NETWORK === 'mainnet' 
    ? clusterApiUrl('mainnet-beta') 
    : clusterApiUrl('devnet');
  
  return new Connection(networkUrl, 'confirmed');
};

module.exports = { getSolanaConnection };