import mongoose from "mongoose";
import { Schema } from "mongoose";

const UserSchema = new Schema(
    {
        email: {
            type: String,
            required: true,
            lowercase: true,
            unique: true,
            match: [
                /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
                "Please fill a valid email address",
            ],
        },
        password: {
            type: String,
            required: true,
        },
        userName: String,
        avatarURL: String,
        gender: {
            type: String,
            enum: ["male", "female", "other"],
        },
        dob: {
            type: Date,
            validate: {
                validator: function (v) {
                    return v && v.getTime() < Date.now();
                },
                message: "Date of birth must be in the past",
            },
        },
        target: {
            type: String,
        },
        historyWorking: {
            type: Schema.Types.ObjectId,
            ref: "History",
        },
    },
    {
        timestamps: true,
    }
);

const User = mongoose.model("User", UserSchema);
export default User;
