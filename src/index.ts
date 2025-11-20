import express from 'express';
const app = express();
const port = 3000;
import pool from './db/db';
import cors from 'cors';

import authRoutes from './routes/authRoutes';
import postRoutes from "./routes/postRoutes";


// Enable CORS for all routes
app.use(cors(
  {
    origin: 'http://localhost:5173', // Adjust this to your frontend's origin
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true,
  }
));

app.use(express.json());

// Use auth routes
app.use('/api/auth', authRoutes);
app.use('/api/post', postRoutes);


pool.connect()
  .then(() => {
    console.log('Connected to the database');
  })
  .catch((err) => {
    console.error('Error connecting to the database', err);
  });



app.get('/', (req, res) => {
  res.send('CCP Backend with TypeScript and Express!');
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
