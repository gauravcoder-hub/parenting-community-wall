const { body, validationResult } = require('express-validator');

const postValidation = [
  body('author').notEmpty().withMessage('Author is required'),
  body('content').notEmpty().withMessage('Content is required'),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }
    next();
  },
];

const commentValidation = [
  body('author').notEmpty().withMessage('Comment author is required'),
  body('text').notEmpty().withMessage('Comment text is required'),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }
    next();
  },
];

module.exports = { postValidation, commentValidation };
