import config from '../../config/index.js';
import { getSolanaConnection } from '../../services/solana/solana.js';
import { loadAdminWallet, mintToken, transferTokenFromAdminWallet } from '../../services/solana/token.js';
import { createWallet, getUserWallet, getTokenBalance, getWalletTransactionsHistory } from '../../services/solana/wallet.js';

export class SolanaController {
    createNewWallet = async (req, res) => {
        try {
            const userId = req.params?.userId?.trim();

            if (!userId) {
                return res.status(400).json({ success: false, message: "User ID is required" });
            }

            const wallet = await createWallet(userId);

            return res.status(201).json({
                success: true,
                message: "Wallet created successfully",
                wallet,
            });
        } catch (error) {
            console.error("Error when creating wallet:", error);
            return res.status(500).json({
                success: false,
                message: "Server error while creating wallet",
                error: error.message,
            });
        }
    }

    getTokenBalance = async (req, res) => {
        try {
            const publicKey = req.params?.publicKey?.trim();
            const tokenMintAddress = req.query.tokenMintAddress || null;

            if (!publicKey) {
                return res.status(400).json({ success: false, message: "Public key is required" });
            }

            const balance = await getTokenBalance(publicKey, tokenMintAddress);

            return res.status(200).json({
                success: true,
                message: "Get token balance successfully",
                balance,
            });
        } catch (error) {
            console.error("Error when getting token balance:", error);
            return res.status(500).json({
                success: false,
                message: "Server error while getting token balance",
                error: error.message,
            });
        }
    }

    getUserWallet = async (req, res) => {
        try {
            const userId = req.params?.userId?.trim();

            if (!userId) {
                return res.status(400).json({ success: false, message: "User ID is required" });
            }

            const wallet = await getUserWallet(userId);

            return res.status(200).json({
                success: true,
                message: "Get wallet successfully",
                wallet,
            });
        } catch (error) {
            console.error("Error when getting wallet:", error);
            return res.status(500).json({
                success: false,
                message: "Server error while getting wallet",
                error: error.message,
            });
        }
    }

    tokenTransferAdmin = async (req, res) => {
        try {
            const { recipientPublicKey, amount } = req.body;

            if (!recipientPublicKey || !amount) {
                return res.status(400).json({ success: false, message: "Recipient public key and amount are required" });
            }

            const transaction = await transferTokenFromAdminWallet(recipientPublicKey, amount);

            return res.status(200).json({
                success: true,
                message: "Tokens transferred successfully",
                transaction,
            });
        } catch (error) {
            console.error("Error when transferring tokens:", error);
            return res.status(500).json({
                success: false,
                message: "Server error while transferring tokens",
                error: error.message,
            });
        }
    }

    mintTokensToUser = async (req, res) => {
        try {
            const { publicKey, amount } = req.body;

            if (!publicKey || !amount) {
                return res.status(400).json({ success: false, message: "Missing publicKey or amount" });
            }

            const tx = await mintToken(publicKey, parseInt(amount));

            return res.status(200).json({ success: true, message: "Tokens minted", tx });
        } catch (error) {
            return res.status(500).json({ success: false, message: error.message });
        }
    }

    getTransactionHistory = async (req, res) => {
        try {
            const publicKey = req.params?.publicKey?.trim();

            if (!publicKey) {
                return res.status(400).json({ success: false, message: "Public key is required" });
            }

            const transactions = await getWalletTransactionsHistory(publicKey);

            return res.status(200).json({
                success: true,
                message: "Transaction history retrieved successfully",
                transactions,
            });
        } catch (error) {
            console.error("Error when getting transaction history:", error);
            return res.status(500).json({
                success: false,
                message: "Server error while getting transaction history",
                error: error.message,
            });
        }
    }


}


