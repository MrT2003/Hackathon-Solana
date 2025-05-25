import {registerNewUser} from "./DatabaseController.js";
export class UserController {
    getAllUser = async (req, res, next) => {
        try {
            
            return res.status(200).json({ success: true, message: "Get All User" });
        } catch (error) {
            console.error("Error in getAllUser:", error);
            return res
                .status(500)
                .json({ message: "Server error", error: error.message });
        }
    };

    signup = async (req, res) => {
        try{
            const user = req.body;
            const result = await registerNewUser(user);
            
            if(result.success){
                console.info("User registered successfully:", result.message);
                return res.status(200).json({ success: true, message: "Register succesfully" });
            }else{
                console.error("User registration failed:", result.message);
                return res.status(500).json({ success: false, message: "Can not register" });
            }
        }catch (error) {
            console.error("Error in register:", error);
        }
    };
}
