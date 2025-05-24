import e from 'express';
import {admin} from '../config/firebaseConfig.js';
export default async function isAuthenticated  (req , res , next){
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer')){
        return res.status(401).json({message: "Unauthorized: Missing or invalid token !"})
    }

    const token = authHeader.split(' ')[1];
    if (!token ){
        return res.status(401).json({message: "Missing token"});
    }
    try{
        // Verify ID token 
        const decoded = await admin.auth().verifyIdToken(token);
        console.log('Decoded token: ', decoded);
        req.user = decoded;
        next();
    }catch(error){
        console.log("Token: ",token)
        console.error('Token verification failed: ', error.message);
        return res.status(403).json({message: "Invalid token"});
    }
}