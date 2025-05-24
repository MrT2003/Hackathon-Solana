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
        try {
            res.status(200).json({ success: true, message: "User has signed up !" });
            const user = req.body;
            const result = registerNewUser(user);
            if (result.success) {
                console.info("User registered successfully !");
            } else {
                console.error("User registration failed !");
            }
            return res.status(200).json({ success: true, message: "User has signed up !" });
        } catch (error) {
            console.error("Error in register:", error);
            
        }
    };

}
