import { Router } from 'express';
import { SolanaController } from '../app/controllers/SolanaController.js';
import isAuthenticated from '../middlewares/auth.js';
const router = Router();

const solanaController = new SolanaController();

router.post('/createWallet/:userId',solanaController.createNewWallet);
router.post('/getWallet/:userId', solanaController.getUserWallet);
router.get('/getTokenBalance/:publicKey', solanaController.getTokenBalance);
router.post('/transferTokenAdmin', solanaController.tokenTransferAdmin);
router.post('/mintToken', solanaController.mintTokensToUser);
// router.post('/createWallet/:userId', solanaController.createNewWallet);

export {router as solanaRoute};