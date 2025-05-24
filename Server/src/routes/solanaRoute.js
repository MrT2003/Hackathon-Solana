import { Router } from 'express';
import { SolanaController } from '../app/controllers/SolanaController.js';
import isAuthenticated from '../middlewares/auth.js';
const router = Router();

const solanaController = new SolanaController();

router.post('/createWallet/:userId', isAuthenticated, solanaController.createNewWallet);
// router.post('/createWallet/:userId', solanaController.createNewWallet);

export {router as solanaRoute};