import {Router} from 'express';
import {
    createTodo,
    getTodos,
    getTodoById,
    updateTodo,
    deleteTodo
} from '../controllers/controllers';

const router = Router();

//routes define
router.post('/todos', createTodo);
router.get('/todos', getTodos);
router.get('/todos/:id', getTodoById);
router.put('/todos/:id', updateTodo);
router.delete('/todos/:id', deleteTodo);


export default router;

