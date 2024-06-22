import { Schema, model, Document } from 'mongoose';

export interface Todo extends Document {
  title: string;
  description: string;
  user: string; // Assuming user ID reference
}

const TodoSchema = new Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true } // Reference to User model
});

export default model<Todo>('Todo', TodoSchema);
