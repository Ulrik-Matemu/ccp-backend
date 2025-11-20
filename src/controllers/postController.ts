import { Request, Response } from "express";
import pool from "../db/db";


export const createPost = async (req: Request, res: Response) => {
    try {
        const { body } = req.body;
        const leaderId = req.leaderId;

        if (!body) {
            return res.status(400).json({ message: "Post body is required" });
        }

        // Insert post
        const postResult = await pool.query(
            `INSERT INTO posts (body, leader_id) VALUES ($1, $2) RETURNING *`,
            [body, leaderId]
        );

        const post = postResult.rows[0];

        // If media was uploaded
        let media: any[] = [];

        if (Array.isArray(req.files) && req.files.length > 0) {
            media = await Promise.all(
                req.files.map(async (file: any) => {
                    const result = await pool.query(
                        `INSERT INTO post_media (post_id, media_url, media_type)
                        VALUES ($1, $2, $3)
                        RETURNING *`,
                        [post.id, file.path, "image"]
                    );
                    return result.rows[0];
                })
            );
        }

        return res.status(201).json({
            message: "Post created successfully",
            post,
            media
        });

    } catch (error) {
        console.error("Create post error: ", error);
        return res.status(500).json({ message: "Server error" })
    }
};

export const getPosts = async (req: Request, res: Response) => {
    try {
        const postsResult = await pool.query(
            // 1. SELECT: Fetching post body and leader details
            `
            SELECT
                p.id AS post_id,
                p.leader_id,
                p.body,
                p.created_at,
                l.name AS leader_name,
                l.profile_image_url,  -- 💡 Added leader profile image URL
                
                -- 2. Subqueries for Counts: Efficiently fetch the total number of interactions
                (
                    SELECT COUNT(*)
                    FROM post_likes pl
                    WHERE pl.post_id = p.id
                ) AS likes_count,
                (
                    SELECT COUNT(*)
                    FROM comments c
                    WHERE c.post_id = p.id
                ) AS comments_count,
                (
                    SELECT COUNT(*)
                    FROM post_shares ps
                    WHERE ps.post_id = p.id
                ) AS shares_count
            FROM posts p
            JOIN leader l ON l.id = p.leader_id
            ORDER BY p.created_at DESC
            `
        );
        
        const posts = postsResult.rows;
        
        if (posts.length === 0) {
            return res.json([]);
        }
        
        const postsIds = posts.map(p => p.post_id);
        
        // Get all media for these posts
        const mediaResult = await pool.query(
            `
            SELECT post_id, media_url, media_type
            FROM post_media
            WHERE post_id = ANY($1)
            `,
            [postsIds]
        );
        
        const mediaMap: Record<string, any[]> = {};
        mediaResult.rows.forEach((m) => {
            if (!mediaMap[m.post_id]) mediaMap[m.post_id] = [];
            mediaMap[m.post_id].push({
                media_url: m.media_url,
                media_type: m.media_type,
            });
        });
        
        // Attach media and format the final output object
        const formatted = posts.map((post) => ({
            id: post.post_id,
            leader_id: post.leader_id,
            leader_name: post.leader_name,
            // 💡 Added profile image URL
            leader_profile_pic: post.profile_image_url, 
            body: post.body,
            created_at: post.created_at,
            // 💡 Added count fields (returned as strings by Postgres COUNT)
            likes_count: parseInt(post.likes_count, 10),
            comments_count: parseInt(post.comments_count, 10),
            shares_count: parseInt(post.shares_count, 10),
            media: mediaMap[post.post_id] || [],
        }));
        
        return res.json(formatted);
    } catch (error) {
        console.error("Fetch feed error:", error);
        return res.status(500).json({ message: "Server error" });
    }
}