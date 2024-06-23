// routes.ts

import { Router } from 'express';
import { createTodo, getTodos, getTodoById, updateTodo, deleteTodo } from '../controllers/TodoController';
import { registerUser, loginUser } from '../controllers/UserController';
import { verifyToken } from '../middleware/auth'; 

const router = Router();


router.post('/todos', verifyToken, createTodo); // Protected route
router.get('/todos', verifyToken, getTodos);
router.get('/todos/:id', verifyToken, getTodoById);
router.put('/todos/:id', verifyToken, updateTodo);
router.delete('/todos/:id', verifyToken, deleteTodo);

// User routes
router.post('/register', registerUser);
router.post('/login', loginUser);

export default router;
