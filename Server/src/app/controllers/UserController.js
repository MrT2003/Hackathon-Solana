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
            // After passing the authentication middleware, we can assume that the user is authenticated
            // and we can access their information from req.user

            const user = req.body;

            // Run registerNewUser in the background
            registerNewUser(user).then((result) => {
                if (result.success) {
                    console.info("User registered successfully:", result.message);
                } else {
                    console.error("User registration failed:", result.message);
                }
            }).catch((error) => {
                console.error("Error in registerNewUser:", error);
            });

            // Immediately return the response
            if (req.user.uid !== undefined) {
                return res.status(200).json({ success: true, message: "User finished signup!" });
            }
        } catch (error) {
            console.error("Error in register:", error);
            return res.status(500).json({ message: "Server error", error: error.message });
        }
    };
}
