-- Fruits table
CREATE TABLE fruits (
  fruit_id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price FLOAT NOT NULL,
  description TEXT,
  image_url TEXT
);

-- Cart table
CREATE TABLE cart (
  id SERIAL PRIMARY KEY,
  fruit_id INT REFERENCES fruits(fruit_id),
  quantity INT NOT NULL,
  email TEXT,
  total_price FLOAT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Orders table
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  total_price FLOAT NOT NULL,
  status TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  email TEXT
);

-- Order Items table
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  fruit_id INT REFERENCES fruits(fruit_id),
  quantity INT NOT NULL,
  price FLOAT NOT NULL
);
