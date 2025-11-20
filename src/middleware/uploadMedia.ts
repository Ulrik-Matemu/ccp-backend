import multer from "multer";
import { CloudinaryStorage } from "multer-storage-cloudinary";
import cloudinary from "../config/cloudinary";

const storage = new CloudinaryStorage({
    cloudinary,
    params: {
        folder: "ccp_post",
        allowed_formats: ["jpg", "jpeg", "png", "gif", "avif", "webp"],
    } as any,
});

const upload = multer({ storage });

export default upload;