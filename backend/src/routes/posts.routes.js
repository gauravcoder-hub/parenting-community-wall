const express = require("express");
const router = express.Router();
const {
  createPost,
  getAllPosts,
  getSinglePost,
  likePost,
  addComment,
} = require("../controllers/posts.controller");

const { postValidation, commentValidation } = require("../middleware/validate");

// Routes
router.get("/", getAllPosts);                  
router.post("/", postValidation, createPost);
router.get("/:id", getSinglePost);           
router.post("/:id/like", likePost);          
router.post("/:id/comments", commentValidation, addComment);

module.exports = router;
