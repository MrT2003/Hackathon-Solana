import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

export default {
  PORT: parseInt(process.env.PORT || '8000', 10),
};