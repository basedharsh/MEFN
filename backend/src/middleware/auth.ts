// auth.ts

import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';


declare global {
  namespace Express {
    interface Request {
      user?: { id: string }; 
    }
  }
}

export const verifyToken = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split(' ')[1]; 

  if (!token) {
    return res.status(401).json({ message: 'No token provided' });
  }

  try {
    const decoded = jwt.verify(token, 'your-secret-key') as { id: string }; 
    req.user = decoded; 
    next();
  } catch (error) {
    return res.status(403).json({ message: 'Unauthorized' });
  }
};
