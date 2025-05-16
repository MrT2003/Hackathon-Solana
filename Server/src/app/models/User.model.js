import mongoose from "mongoose";
import { Schema } from "mongoose";

const wordListSchema = new Schema({
    word: String,
    part_of_speech: {
        type: Schema.Types.ObjectId,
        ref: "Content",
    },
    meaning: {
        type: String,
        required: true,
    },
    timestamp: {
        type: Date,
        default: Date.now,
    },
});

const notifySchema = new Schema({
    userId: {
        type: String,
        required: true,
        index: true,
    },
    title: String,
    message: String,
    isRead: {
        type: Boolean,
        default: false,
    },
    timestamp: {
        type: Date,
        default: Date.now,
    },
});

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
        wordList: [wordListSchema],
        notify: [notifySchema],
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
