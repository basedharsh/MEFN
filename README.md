
# MEFN (MongoDB, Express.js, Flutter, Node.js) Project

This repository contains a full-stack project template using MongoDB, Express.js for the backend, and Flutter for the frontend.

## Backend Setup

### Prerequisites
- Node.js (with npm)
- MongoDB

### Getting Started with Backend

1. **Clone the repository:**
   ```bash
   git clone https://github.com/basedharsh/MEFN.git
   cd MEFN
   ```

2. **Install backend dependencies:**
   ```bash
   cd backend
   npm install
   ```

3. **Set up MongoDB:**

   Make sure MongoDB is installed and running. If not installed, download and install it from [MongoDB Download Center](https://www.mongodb.com/try/download/community).

4. **Configure MongoDB connection:**

   Inside your backend code (in `backend/src/server.ts`), ensure you have your MongoDB connection configured. Example:
   
   ```javascript
   const mongoose = require('mongoose');

   // Connect to MongoDB
   mongoose.connect('mongodb://localhost:27017/mydatabase', {
     useNewUrlParser: true,
     useUnifiedTopology: true,
     useCreateIndex: true,
   });

   const db = mongoose.connection;
   db.on('error', console.error.bind(console, 'MongoDB connection error:'));
   db.once('open', () => {
     console.log('Connected to MongoDB');
   });

   // Your Express.js server setup continues here...
   ```

   Replace `'mongodb://localhost:27017/mydatabase'` with your actual MongoDB connection string.

5. **Run the backend server:**
   ```bash
   npm start
   ```

   This will start the backend server. By default, it will run on `http://localhost:3000`.

## Flutter Frontend Setup

### Prerequisites
- Flutter SDK
- Android Studio / Xcode (for simulator/emulator) or a physical device for testing

### Getting Started with Flutter Frontend

1. **Navigate to the Flutter project:**
   ```bash
   cd ../flutter_project_directory
   ```

   Replace `../flutter_project_directory` with the actual path to your Flutter project directory.

2. **Set up Flutter environment:**

   Make sure you have Flutter SDK installed. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

3. **Configure Flutter frontend:**

   Create `lib/config.dart` within your Flutter project, set the backend API URL:
   
   ```dart
   

   class Config {
     static const String baseUrl = 'http://localhost:3000/api';
   }
   ```

   Replace `'http://localhost:3000/api'` with your actual backend API URL if you changed port or something or let it be.

4. **Run the Flutter application:**

   Connect your mobile device or start an emulator/simulator and run:
   ```bash
   flutter run
   ```

   This command builds and runs the Flutter application on your connected device or emulator.

## Additional Notes

- Ensure MongoDB is running (`mongod` command) before starting the backend server.
- Adjust firewall settings if necessary to allow connections to MongoDB and your backend server.

This README.md file now provides detailed steps for setting up both the backend (MongoDB, Express.js) and the Flutter frontend 
