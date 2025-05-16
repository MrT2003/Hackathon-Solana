import { Router } from 'express';
import { UserController } from '../app/controllers/UserController.js';

const router = Router();

const userController = new UserController();

router.post('/register', async(req, res, next)=> {
    res.send('Register');
});

router.post('/login', async (req, res, next) => {
    res.send('Login');
});

router.post('/refresh-token', async (req, res, next) => {
    res.send('Refresh-token');
});

router.delete('/logout', async (req, res, next) => {
    res.send('Logout');
});

export { router as authRoute };
