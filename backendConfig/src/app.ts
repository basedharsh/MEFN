import express from 'express';
import mongoose from 'mongoose';
import bodyParser from 'body-parser';
import routes from './routes';

const app = express();

// Middleware yeh use hota for  request handleing
app.use(bodyParser.json());

// MongoDB connection
const mongoUri = 'mongodb://localhost:27017/todos';
mongoose.connect(mongoUri).then(() => {
  console.log('MongoDB connected');
  console.log('Server Link: http://localhost:3000');
}).catch(err => console.log(err));

// Routes
app.use('/api', routes);

export default app;
