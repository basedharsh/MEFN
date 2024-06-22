import { Request, Response } from 'express';
import Todo from '../models/Todo';

// Create a new ToDo item
export const createTodo = async (req: Request, res: Response) => {
  try {
    const todo = new Todo(req.body);
    await todo.save();
    res.status(201).json(todo);
  } catch (error) {
    res.status(400).json({ message: error  });
  }
};

// Get all ToDo items
export const getTodos = async (req: Request, res: Response) => {
  try {
    const todos = await Todo.find();
    res.status(200).json(todos);
  } catch (error) {
    res.status(500).json({ message: error});
  }
};

// Get a ToDo item by ID
export const getTodoById = async (req: Request, res: Response) => {
  try {
    const todo = await Todo.findById(req.params.id);
    if (!todo) {
      return res.status(404).json({ message: 'ToDo item not found' });
    }
    res.status(200).json(todo);
  } catch (error) {
    res.status(500).json({ message: error });
  }
};

// Update a ToDo item by ID
export const updateTodo = async (req: Request, res: Response) => {
  try {
    const todo = await Todo.findByIdAndUpdate(req.params.id, req.body, { new: true, runValidators: true });
    if (!todo) {
      return res.status(404).json({ message: 'ToDo item not found' });
    }
    res.status(200).json(todo);
  } catch (error) {
    res.status(400).json({ message: error});
  }
};

// Delete a ToDo item by ID
export const deleteTodo = async (req: Request, res: Response) => {
  try {
    const todo = await Todo.findByIdAndDelete(req.params.id);
    if (!todo) {
      return res.status(404).json({ message: 'ToDo item not found' });
    }
    res.status(200).json({ message: 'ToDo item deleted' });
  } catch (error) {
    res.status(500).json({ message: error });
  }
};
