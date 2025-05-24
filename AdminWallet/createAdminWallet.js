const fs = require("fs");
const { Keypair } = require("@solana/web3.js");

// Tạo ví mới
const keypair = Keypair.generate();

// Lưu secretKey ra file
fs.writeFileSync("admin-keypair.json", JSON.stringify(Array.from(keypair.secretKey)));

console.log("✅ Admin wallet created!");
console.log("Public Key:", keypair.publicKey.toString());

