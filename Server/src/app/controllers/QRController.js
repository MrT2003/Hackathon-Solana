import {getSolanaPublicKey} from "./DatabaseController.js";

export const getQRCodeData = async (req, res) => {
        try {
            // const user = req.user; // req.user is set by the isAuthenticated middleware
            const mockUser = req.body
            // if (!user) {
            //     return res.status(401).json({ message: "Unauthorized: Missing user information" });
            // }
            const uid = user.uid;
            const UID = mockUser.uid;
            const publicKey = await getSolanaPublicKey(UID);
            if (!publicKey.success) {
                return res.status(404).json({ success:false, message: "No Solana public key found for user" });
            }
            return res.status(200).json({ success: true, user: { uid:uid, publicKey:publicKey } , message:"Get user data successfully!" });
        } catch (error) {
            console.error("Error in getUserData:", error);
            return res.status(500).json({ message: "Server error", error: error.message });
        }
};