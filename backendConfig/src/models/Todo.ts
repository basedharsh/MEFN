import { Schema, model } from 'mongoose';

// schema for a ToDo item
const TodoSchema = new Schema({
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  completed: {
    type: Boolean,
    default: false,
  },
}, {
  timestamps: true,
});

// Create and export the model
const Todo = model('Todo', TodoSchema);

export default Todo;
