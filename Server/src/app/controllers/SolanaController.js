import config from '../../config/index.js';
import { getSolanaConnection } from '../../services/solana/solana.js';
import { loadAdminWallet, mintToken, transferToken } from '../../services/solana/token.js';
import { createWallet, getUserWallet} from '../../services/solana/wallet.js';

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
}


