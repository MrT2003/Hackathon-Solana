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
            let user = res.body;
            registerNewUser(user);
            return res.status(200).json({ success: true, message: "User registered successfully" });
        }catch (error) {
            console.error("Error in register:", error);
            return res
                .status(500)
                .json({ message: "Server error", error: error.message });
        }

    };
}
