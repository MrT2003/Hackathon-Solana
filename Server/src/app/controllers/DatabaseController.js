import {db } from "../../config/firebaseConfig.js";
import { User } from "../models/User.model.js";
import { createWallet } from "../../services/solana/wallet.js";

export const registerNewUser = async (user) => {
    try {
        const registerInformation = new User(
            user.uid,
            user.email,
            user.createdAt,
            user.isAdmin,
            user.name,
            user.updatedAt
        );
        const userData = registerInformation.toJSON();

        const userDoc = await db.collection("users").doc(user.uid).get();
        if (userDoc.exists) {
            console.log("User already exists in the database");
            return { success: false, message: "User already exists" };
        }

        // Lưu user ban đầu
        await db.collection("users").doc(user.uid).set(userData);

        // Tạo ví và lấy public key
        const walletPublicKey = await createWallet(user.uid);

        // Cập nhật Firestore với trường mới
        await db.collection("users").doc(user.uid).update({
            walletPublicKey: walletPublicKey
        });

        // Thêm vào response
        userData.walletPublicKey = walletPublicKey;

        console.log(`Stored ${registerInformation} and wallet to database!`);

        return {
            success: true,
            message: "User information stored successfully",
            user: userData
        };
    } catch (error) {
        console.error("Error storing user information:", error);
        return {
            success: false,
            message: "Error storing user information"
        };
    }
};

