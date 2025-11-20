import { Router } from "express";
import { createPost, getPosts } from "../controllers/postController";
import upload from "../middleware/uploadMedia";
import { getLeaderFromToken } from "../middleware/getLeaderFromToken";

const router = Router();

router.post("/", getLeaderFromToken, upload.array("media", 5), createPost);
router.get("/", getPosts);

export default router;