export const QRCodeData = async (req, res) =>{
        try{
            const user = req.user;
            if(!user){
                return res.status(401).json({message: "Unauthorized: Missing user information"});
            }
            const uid = user.uid;
            // Here you would typically fetch the QR code data from your database   
            const SolanaPublicKey = await getSolanaPublicKey(uid);
            if (!SolanaPublicKey.success) {
                return res.status(404).json({ message: "No Solana public key found for user" });
            }   
        }
        catch (error) {
            console.error("Error in QRCodeData:", error);
            return res.status(500).json({ message: "Server error", error: error.message });
        }
}