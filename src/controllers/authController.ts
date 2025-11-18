import pool from '../db/db';
import bcrypt from 'bcryptjs';
import { generateToken } from '../utils/generateToken';
import { Request, Response } from 'express';

export const loginLeader = async (req: Request, res: Response) => {
    const { identifier, password } = req.body;

    try {
        // find leader by name or email
        const query = `SELECT * FROM leader WHERE name = $1 OR email = $1 LIMIT 1`;
        const result = await pool.query(query, [identifier]);

        if (result.rows.length === 0) {
            return res.status(404).json({ message: "Leader not found" });
        }

        const leader = result.rows[0];

        // verify password
        const isMatch = await bcrypt.compare(password, leader.password_hash);
        if (!isMatch) {
            return res.status(400).json({ message: "Invalid password" });
        }

        // create token
        const token = generateToken(leader.id);

        res.json({
            message: "Login successful",
            leader: {
                id: leader.id,
                name: leader.name,
                email: leader.email,
                designation: leader.designation
            },
            token
        });
    } catch (error) {
        console.error("Login error: ", error);
        res.status(500).json({ message: "Server error at Leader Login" });
    }
}

