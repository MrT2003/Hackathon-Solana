import { Router } from 'express';
import { UserController } from '../app/controllers/UserController.js';
import isAuthenticated from '../middlewares/auth.js'; 
const router = Router();

const userController = new UserController();

router.post('/register', isAuthenticated, userController.signup);
router.post('/login', isAuthenticated, userController.Login);
router.post('/refresh-token', isAuthenticated, userController.RefreshToken);

router.delete('/logout', async (req, res, next) => {
    res.send('Logout');
});

export { router as authRoute };
