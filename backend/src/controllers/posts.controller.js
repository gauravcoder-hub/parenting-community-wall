const Post = require("../models/Post");

exports.createPost = async (req, res, next) => {
  try {
  
    const { author, content } = req.body;

    const post = await Post.create({ author, content });

    return res.status(201).json({
      success: true,
      message: "Post created successfully",
      data: post,
    });
  } catch (error) {
    console.error("Create post error:", error);
    next(error); 
  }
};

exports.getAllPosts = async (req, res, next) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      data: posts,
    });
  } catch (error) {
    console.error("Get all posts error:", error);
    next(error);
  }
};

exports.getSinglePost = async (req, res, next) => {
  try {
    const { id } = req.params;

    const post = await Post.findById(id);

    if (!post) {
      return res.status(404).json({
        success: false,
        message: "Post not found",
      });
    }

    return res.status(200).json({
      success: true,
      data: post,
    });
  } catch (error) {
    console.error("Get single post error:", error);
    next(error);
  }
};

exports.likePost = async (req, res, next) => {
  try {
    const { id } = req.params;

    const post = await Post.findByIdAndUpdate(
      id,
      { $inc: { likes: 1 } },
      { new: true }
    );

    if (!post) {
      return res.status(404).json({
        success: false,
        message: "Post not found",
      });
    }

    return res.status(200).json({
      success: true,
      message: "Post liked successfully",
      data: post,
    });
  } catch (error) {
    console.error("Like post error:", error);
    next(error);
  }
};

exports.addComment = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { author, text } = req.body;

    const post = await Post.findById(id);

    if (!post) {
      return res.status(404).json({
        success: false,
        message: "Post not found",
      });
    }

    post.comments.push({ author, text });
    await post.save();

    return res.status(201).json({
      success: true,
      message: "Comment added successfully",
      data: post,
    });
  } catch (error) {
    console.error("Add comment error:", error);
    next(error);
  }
};
