import { Schema, model, Document } from 'mongoose';

export interface Todo extends Document {
  title: string;
  description: string;
  user: string; 
  completed: boolean;
}

const TodoSchema = new Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  completed: { type: Boolean, default: false },
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true } // Reference to User model
});

export default model<Todo>('Todo', TodoSchema);
