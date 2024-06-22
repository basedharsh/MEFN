// controllers/TodoController.ts

import { Request, Response } from 'express';
import Todo from '../models/Todo';


interface User {
  id: string; // Assuming id is of type string
  // Add other properties if needed
}

export const createTodo = async (req: Request, res: Response) => {
  try {
    const { title, description } = req.body;
    const newTodo = new Todo({ title, description, user: (req.user as User).id });
    await newTodo.save();
    res.status(201).json({ message: 'Todo created successfully', todo: newTodo });
  } catch (error) {
    res.status(400).json({ message: error });
  }
};

export const getTodos = async (req: Request, res: Response) => {
  try {
    const todos = await Todo.find({ user: (req.user as User).id });
    res.json(todos);
  } catch (error) {
    res.status(500).json({ message: error });
  }
};

export const getTodoById = async (req: Request, res: Response) => {
  try {
    const userId = (req.user as User).id;

    const todo = await Todo.findById(req.params.id);
    
    if (!todo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    if (todo.user.toString() !== userId) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    res.json(todo);
  } catch (error) {
    res.status(500).json({ message: error });
  }
};

export const updateTodo = async (req: Request, res: Response) => {
  try {
    const { title, description } = req.body;
    const updatedTodo = await Todo.findByIdAndUpdate(req.params.id, { title, description }, { new: true });

    if (!updatedTodo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    if (updatedTodo.user.toString() !== (req.user as User).id) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    res.json({ message: 'Todo updated successfully', todo: updatedTodo });
  } catch (error) {
    res.status(500).json({ message: error });
  }
};

export const deleteTodo = async (req: Request, res: Response) => {
  try {
    const deletedTodo = await Todo.findByIdAndDelete(req.params.id);

    if (!deletedTodo) {
      return res.status(404).json({ message: 'Todo not found' });
    }

    if (deletedTodo.user.toString() !== (req.user as User).id) {
      return res.status(403).json({ message: 'Unauthorized' });
    }

    res.json({ message: 'Todo deleted successfully', todo: deletedTodo });
  } catch (error) {
    res.status(500).json({ message: error });
  }
};
