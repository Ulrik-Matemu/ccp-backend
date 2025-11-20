import { Request, Response, NextFunction }  from 'express';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
dotenv.config();

export const getLeaderFromToken = (req: Request, res: Response, next: NextFunction) => {
    try {
        const token = req.headers.authorization?.split(" ")[1];
        if (!token) return res.status(401).json({ message: "No token provided" });

        const decoded = jwt.verify(token, process.env.JWT_SECRET!);
        req.leaderId = (decoded as any).id;

        next();
    } catch(error) {
        return res.status(401).json({ message: "Invalid token" });
    }
}


declare global {
    namespace Express {
        interface Request {
            leaderId?: number;
        }
    }
}