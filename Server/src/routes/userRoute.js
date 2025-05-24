import { Router } from "express";
import { UserController } from "../app/controllers/UserController.js";
import isAuthenticated from "../middlewares/auth.js";
import { getQRCodeData } from "../app/controllers/QRController.js";
const route = Router();
const userController = new UserController();

route.get("/", userController.getAllUser);
route.get("/data", getQRCodeData);
export {route as userRoute}