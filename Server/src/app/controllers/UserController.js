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
            res.status(200).json({success: true , message:"Sign up successfully !"})
            const user = req.body;
            const result =  registerNewUser(user);
            if(result.success){
                console.info("User successfully stored !")
            }else{
                console.error("Fail to store user !")
            }
        }catch (error) {
            res.status(500).json({success: false , message:"Fail to sign up !"})
            console.error("Server error while store user:", error);
        }

    };
}
