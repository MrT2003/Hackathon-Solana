const { Connection, clusterApiUrl, Keypair, PublicKey } = require("@solana/web3.js");
const { Token, TOKEN_PROGRAM_ID } = require("@solana/spl-token");
const fs = require("fs");

(async () => {
  // 1. Kết nối tới devnet
  const connection = new Connection(clusterApiUrl("devnet"), "confirmed");

  // 2. Load ví admin từ file
  const secretKey = Uint8Array.from(JSON.parse(fs.readFileSync("admin-keypair.json")));
  const adminWallet = Keypair.fromSecretKey(secretKey);

  // 3. Airdrop SOL để trả phí giao dịch (devnet thôi, miễn phí)
  const airdropSignature = await connection.requestAirdrop(adminWallet.publicKey, 2e9); // 2 SOL
  await connection.confirmTransaction(airdropSignature, "confirmed");

  // 4. Tạo token SPL mới
  const decimals = 2; // Ví dụ: 2 chữ số thập phân
  const mint = await Token.createMint(
    connection,
    adminWallet,
    adminWallet.publicKey,
    null,
    decimals,
    TOKEN_PROGRAM_ID
  );

  console.log("✅ Token created!");
  console.log("Token Mint Address:", mint.publicKey.toString());
})();
