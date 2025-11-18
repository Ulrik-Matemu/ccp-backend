import { Router } from 'express';
import { loginLeader } from '../controllers/authController';

const router = Router();

// POST  /api/auth/leader/login
router.post('/leader/login', loginLeader);

export default router;