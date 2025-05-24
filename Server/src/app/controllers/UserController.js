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
            const user = req.body;
            const authenticatedUser = req.user;
            if (req.user && req.user.uid !== undefined){
                return res.status(500).json({ message: "Server error", error: error.message });
            }
            res.status(202).json({ message: "User is authenticated" , success: true } );
            const result = registerNewUser(user);
            if (result.success) {
                console.info("User registered successfully !");
            }else{
                console.error("User registered failed !");
            }
        } catch (error) {
            console.error("Error in register:", error);
            
        }
    };

}
