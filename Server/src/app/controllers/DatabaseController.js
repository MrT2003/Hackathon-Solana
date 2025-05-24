import {db } from "../../config/firebaseConfig.js";
import { User } from "../models/User.model.js";
export const registerNewUser = async (user) => {
    try{
        const registerInformation = new User(user.uid, user.email, user.createdAt, user.isAdmin, user.name,user.updatedAt);
        const userData = registerInformation.toJSON();

        const userDoc = await db.collection("users").doc(user.uid).get();
        if (userDoc.exists) {
            console.log("User already exists in the database");
            return {success: false, message: "User already exists"};
        }
        //if the user does not exist, create a new document
        //and store the user information
        await db.collection("users").doc(user.uid).set(userData);
        console.log(`Stored ${registerInformation} to database !`);
        return {success: true, message: "User information stored successfully"};
    }catch (error) {
        console.error("Error storing user information:", error);
        return {success: false, message: "Error storing user information"};
    }

};
