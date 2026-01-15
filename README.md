```markdown
# Parenting Community Wall

A full-stack community wall app where parents can share short posts, like posts, and comment on others' posts. Built with a modern **Node.js + Express + MongoDB backend** and **Flutter frontend**.

---

# Table of Contents

- [Demo]
- [Tech Stack] 
- [Project Structure] 
- [Setup Instructions]
  - [Backend](#backend)  
  - [Frontend](#frontend)  
- [API Documentation]
- [Likes and Comments]
- [Optional Deployment]
- [Screenshots & Workflow]

---

# Demo

*(Optional: Add deployed demo link here)*

---

# Tech Stack

- **Backend:** Node.js, Express.js, MongoDB (Atlas)  
- **Frontend:** Flutter (Mobile-friendly UI)  
- **State Management:** setState  
- **HTTP Client:** `http` package  
- **Time Formatting:** `timeago` package  
- **Validation:** Basic validation on backend and frontend

---

## Project Structure

```

/parenting-community-wall/
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   │   └── posts.controller.js
│   │   ├── models/
│   │   │   └── Post.js
│   │   ├── routes/
│   │   │   └── post.route.js
│   │   └── server.js
│   ├── .env
│   └── package.json
├── frontend/
│   ├── lib/
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   ├── widgets/
│   │   │   ├── post_card.dart
│   │   │   └── comment_modal.dart
│   │   └── services/
│   │       └── api_service.dart
│   └── pubspec.yaml
└── README.md


## Setup Instructions

### Backend

1. Navigate to backend folder:  
```bash
cd src/parenting-community-wall/backend
````

2. Install dependencies:

```bash
npm install
```

3. Create a `.env` file:

```
PORT=5050
MONGO_URI=your_mongodb_connection_string
```

4. Start the server:

```bash
npm run dev
```

Server runs on: `http://localhost:5050`

---

### Frontend

1. Navigate to frontend folder:

```bash
cd src/parenting-community-wall/frontend
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

* Ensure a simulator/emulator or device is connected.

---

## API Documentation

Base URL: `http://localhost:5050/api/posts`

| Endpoint        | Method | Body / Params                                | Description                                 |
| --------------- | ------ | -------------------------------------------- | ------------------------------------------- |
| `/`             | GET    | -                                            | Get all posts (sorted newest → oldest)      |
| `/`             | POST   | `{ "author": "Name", "content": "Message" }` | Create a new post                           |
| `/:id`          | GET    | Post ID                                      | Get a single post by ID, including comments |
| `/:id/like`     | POST   | Post ID                                      | Increment like count for a post             |
| `/:id/comments` | POST   | `{ "author": "Name", "text": "Comment" }`    | Add a comment to a post                     |

**Response Example:**

```json
{
  "success": true,
  "message": "Post created successfully",
  "data": {
    "_id": "69688057006c18ef0e176786",
    "author": "Ritika",
    "content": "How do you manage nap time for twins?",
    "likes": 0,
    "comments": [
      { "author": "Raj", "text": "Try banana pancakes!" }
    ],
    "createdAt": "2026-01-15T05:51:19.570Z",
    "updatedAt": "2026-01-15T05:51:19.570Z"
  }
}
```

---

## Likes and Comments

* **Likes:**

  * Incremented via `/api/posts/:id/like`.
  * Frontend updates likes instantly on success.

* **Comments:**

  * Added via `/api/posts/:id/comments`.
  * Posts maintain a `comments` array.
  * Frontend updates comments immediately.

* Sorting by "Most Liked" is implemented on the frontend.

---

## Optional Deployment

* Backend: Render / Railway
* Frontend: Vercel / Netlify
* Set environment variables for API URL and MongoDB connection.

---

## Screenshots & Workflow

<img width="496" height="728" alt="Screenshot 2026-01-15 at 12 58 14" src="https://github.com/user-attachments/assets/d7bd73c8-71f2-4714-a9b1-d822914ea65a" />



1. **Post Composer:** Enter name and message, click "Post".
2. **Community Feed:** Shows posts sorted by newest or most liked.
3. **Comments:** Tap "Comment" to open modal, add comment, reflected instantly.

---

**Author:** Gaurav Kumar
**Assignment:** Parenting Community Wall
**Date:** January 2026
