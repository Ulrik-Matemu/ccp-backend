import express from 'express';
const app = express();
const port = 3000;
import pool from './db/db';


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
