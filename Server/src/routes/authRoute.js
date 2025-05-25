import { Router } from 'express';
import { UserController } from '../app/controllers/UserController.js';
import isAuthenticated from '../middlewares/auth.js'; 
const router = Router();

const userController = new UserController();

// router.post('/register' , isAuthenticated, userController.signup);
router.post('/register' , userController.signup);
export { router as authRoute };
