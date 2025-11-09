# 🐘 PostgreSQL Deep Dive - Complete Database Mastery

> **Master PostgreSQL from fundamentals to advanced optimization and production patterns**

---

## 📋 Table of Contents

1. [Introduction & Setup](#introduction--setup)
2. [SQL Fundamentals](#sql-fundamentals)
3. [Data Types](#data-types)
4. [CRUD Operations](#crud-operations)
5. [Queries & Filtering](#queries--filtering)
6. [Joins & Relations](#joins--relations)
7. [Aggregations & Grouping](#aggregations--grouping)
8. [Subqueries & CTEs](#subqueries--ctes)
9. [Indexes & Performance](#indexes--performance)
10. [Transactions & ACID](#transactions--acid)
11. [Constraints & Validation](#constraints--validation)
12. [Views & Materialized Views](#views--materialized-views)
13. [Functions & Procedures](#functions--procedures)
14. [Triggers](#triggers)
15. [JSON & JSONB](#json--jsonb)
16. [Full-Text Search](#full-text-search)
17. [Query Optimization](#query-optimization)
18. [Backup & Recovery](#backup--recovery)
19. [Security & Permissions](#security--permissions)
20. [Real-World Patterns](#real-world-patterns)

---

## Introduction & Setup

### What is PostgreSQL?

PostgreSQL is a **powerful, open-source relational database** that provides:
- **ACID compliance** - Reliable transactions
- **Advanced data types** - JSON, arrays, custom types
- **Full-text search** - Built-in search capabilities
- **Extensibility** - Custom functions, operators, types
- **Standards compliant** - Follows SQL standards
- **Performance** - Excellent query optimization
- **Scalability** - Handles large datasets efficiently

### Installation

```bash
# macOS (using Homebrew)
brew install postgresql@15
brew services start postgresql@15

# Ubuntu/Debian
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql

# Docker (recommended for development)
docker run --name postgres \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_DB=mydb \
  -p 5432:5432 \
  -d postgres:15

# Verify installation
psql --version
```

### Connecting to PostgreSQL

```bash
# Connect to default database
psql -U postgres

# Connect to specific database
psql -U username -d database_name -h localhost -p 5432

# Using connection string
psql postgresql://username:password@localhost:5432/database_name

# From Docker
docker exec -it postgres psql -U postgres
```

### Basic Commands

```sql
-- List all databases
\l

-- Connect to database
\c database_name

-- List all tables
\dt

-- Describe table structure
\d table_name

-- List all schemas
\dn

-- List all users
\du

-- Exit psql
\q

-- Execute SQL file
\i /path/to/file.sql

-- Show query execution time
\timing
```

---

## SQL Fundamentals

### Creating Databases

```sql
-- Create database
CREATE DATABASE mydb;

-- Create with specific encoding
CREATE DATABASE mydb
  ENCODING 'UTF8'
  LC_COLLATE 'en_US.UTF-8'
  LC_CTYPE 'en_US.UTF-8';

-- Delete database
DROP DATABASE mydb;

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS mydb;
```

### Creating Tables

```sql
-- Basic table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE,
  name VARCHAR(100),
  age INTEGER,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table with multiple constraints
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  stock INTEGER DEFAULT 0,
  category VARCHAR(50),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Table with foreign key
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  total DECIMAL(10, 2) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Table with composite primary key
CREATE TABLE order_items (
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (order_id, product_id)
);
```

### Altering Tables

```sql
-- Add column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Drop column
ALTER TABLE users DROP COLUMN phone;

-- Rename column
ALTER TABLE users RENAME COLUMN name TO full_name;

-- Change column type
ALTER TABLE users ALTER COLUMN age TYPE SMALLINT;

-- Add constraint
ALTER TABLE users ADD CONSTRAINT email_check CHECK (email LIKE '%@%');

-- Drop constraint
ALTER TABLE users DROP CONSTRAINT email_check;

-- Add foreign key
ALTER TABLE orders 
  ADD CONSTRAINT fk_user 
  FOREIGN KEY (user_id) 
  REFERENCES users(id);

-- Rename table
ALTER TABLE users RENAME TO customers;
```

---

## Data Types

### Numeric Types

```sql
-- Integer types
SMALLINT      -- -32,768 to 32,767
INTEGER       -- -2,147,483,648 to 2,147,483,647
BIGINT        -- -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
SERIAL        -- Auto-incrementing integer
BIGSERIAL     -- Auto-incrementing bigint

-- Decimal types
DECIMAL(10, 2)  -- Exact numeric (10 digits, 2 after decimal)
NUMERIC(10, 2)  -- Same as DECIMAL
REAL            -- 6 decimal digits precision
DOUBLE PRECISION -- 15 decimal digits precision

-- Example
CREATE TABLE financial_data (
  id SERIAL PRIMARY KEY,
  amount DECIMAL(15, 2),  -- For money
  quantity INTEGER,
  percentage REAL,
  scientific_value DOUBLE PRECISION
);
```

### String Types

```sql
-- Character types
CHAR(10)         -- Fixed length, padded with spaces
VARCHAR(100)     -- Variable length with limit
TEXT             -- Unlimited length

-- Example
CREATE TABLE content (
  id SERIAL PRIMARY KEY,
  code CHAR(10),           -- Fixed: 'ABC       '
  title VARCHAR(200),      -- Limited variable
  description TEXT         -- Unlimited
);
```

### Date & Time Types

```sql
-- Date and time types
DATE              -- Date only: '2025-01-15'
TIME              -- Time only: '14:30:00'
TIMESTAMP         -- Date and time: '2025-01-15 14:30:00'
TIMESTAMPTZ       -- With timezone: '2025-01-15 14:30:00+00'
INTERVAL          -- Duration: '1 year 2 months 3 days'

-- Example
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  event_date DATE,
  event_time TIME,
  created_at TIMESTAMP DEFAULT NOW(),
  scheduled_at TIMESTAMPTZ,
  duration INTERVAL
);

-- Working with dates
INSERT INTO events (event_date, duration) 
VALUES 
  (CURRENT_DATE, '2 hours'),
  ('2025-12-31', '1 day 3 hours');

-- Date functions
SELECT 
  NOW(),                          -- Current timestamp with TZ
  CURRENT_DATE,                   -- Today's date
  CURRENT_TIME,                   -- Current time
  CURRENT_TIMESTAMP,              -- Now
  NOW() + INTERVAL '7 days',      -- One week from now
  EXTRACT(YEAR FROM NOW()),       -- Get year
  AGE(TIMESTAMP '2000-01-01');    -- Calculate age
```

### Boolean Type

```sql
-- Boolean
BOOLEAN  -- TRUE, FALSE, or NULL

CREATE TABLE settings (
  id SERIAL PRIMARY KEY,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false
);

-- Insert boolean values
INSERT INTO settings (is_active, is_verified) 
VALUES 
  (TRUE, FALSE),
  ('yes', 'no'),    -- Also accepts: yes/no, y/n, 1/0
  (1, 0);
```

### Array Types

```sql
-- Arrays
INTEGER[]
TEXT[]
VARCHAR(100)[]

CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title TEXT,
  tags TEXT[],
  ratings INTEGER[]
);

-- Insert arrays
INSERT INTO articles (title, tags, ratings) 
VALUES 
  ('PostgreSQL Guide', ARRAY['database', 'sql', 'postgres'], ARRAY[5, 4, 5]),
  ('React Tips', '{"react", "javascript", "frontend"}', '{5, 5, 4}');

-- Query arrays
SELECT * FROM articles WHERE 'database' = ANY(tags);
SELECT * FROM articles WHERE tags @> ARRAY['sql'];  -- Contains
SELECT * FROM articles WHERE tags && ARRAY['react', 'vue'];  -- Overlaps
```

### JSON & JSONB

```sql
-- JSON types
JSON   -- Stored as text, slow
JSONB  -- Binary format, fast, indexable (USE THIS)

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT,
  metadata JSONB
);

-- Insert JSON
INSERT INTO users (name, metadata) VALUES
  ('John', '{"age": 30, "city": "NYC", "hobbies": ["reading", "coding"]}'),
  ('Jane', '{"age": 25, "city": "LA", "premium": true}');

-- Query JSON
SELECT * FROM users WHERE metadata->>'city' = 'NYC';
SELECT * FROM users WHERE metadata->'age' > '25';
SELECT * FROM users WHERE metadata @> '{"premium": true}';
SELECT * FROM users WHERE metadata ? 'age';  -- Has key
```

### UUID Type

```sql
-- UUID (Universally Unique Identifier)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id INTEGER,
  token TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO sessions (user_id, token) VALUES (1, 'abc123');
```

---

## CRUD Operations

### INSERT

```sql
-- Basic insert
INSERT INTO users (name, email, age) 
VALUES ('John Doe', 'john@example.com', 30);

-- Insert multiple rows
INSERT INTO users (name, email, age) VALUES
  ('Jane Smith', 'jane@example.com', 25),
  ('Bob Johnson', 'bob@example.com', 35),
  ('Alice Brown', 'alice@example.com', 28);

-- Insert with RETURNING
INSERT INTO users (name, email) 
VALUES ('Charlie', 'charlie@example.com')
RETURNING id, created_at;

-- Insert from SELECT
INSERT INTO archive_users (name, email, age)
SELECT name, email, age FROM users WHERE created_at < '2020-01-01';

-- Insert with conflict handling (upsert)
INSERT INTO users (email, name, age) 
VALUES ('john@example.com', 'John Updated', 31)
ON CONFLICT (email) 
DO UPDATE SET 
  name = EXCLUDED.name,
  age = EXCLUDED.age,
  updated_at = NOW();

-- Insert or do nothing
INSERT INTO users (email, name) 
VALUES ('existing@example.com', 'Name')
ON CONFLICT (email) DO NOTHING;
```

### SELECT

```sql
-- Select all columns
SELECT * FROM users;

-- Select specific columns
SELECT name, email FROM users;

-- Select with alias
SELECT name AS full_name, email AS contact FROM users;

-- Select with expression
SELECT 
  name,
  age,
  age * 365 AS age_in_days,
  UPPER(email) AS email_upper
FROM users;

-- Select distinct
SELECT DISTINCT city FROM users;

-- Select with LIMIT and OFFSET
SELECT * FROM users LIMIT 10;           -- First 10
SELECT * FROM users LIMIT 10 OFFSET 20; -- Skip 20, get 10 (pagination)

-- Select with ORDER BY
SELECT * FROM users ORDER BY created_at DESC;
SELECT * FROM users ORDER BY age ASC, name DESC;

-- Count rows
SELECT COUNT(*) FROM users;
SELECT COUNT(*) AS total_users FROM users;
```

### UPDATE

```sql
-- Update single column
UPDATE users SET age = 31 WHERE id = 1;

-- Update multiple columns
UPDATE users 
SET 
  name = 'John Smith',
  age = 32,
  updated_at = NOW()
WHERE id = 1;

-- Update with calculation
UPDATE products SET price = price * 1.1;  -- 10% increase

-- Update from another table
UPDATE orders o
SET status = 'shipped'
FROM shipments s
WHERE o.id = s.order_id AND s.shipped_at IS NOT NULL;

-- Update with RETURNING
UPDATE users 
SET age = age + 1 
WHERE id = 1
RETURNING *;

-- Conditional update
UPDATE users
SET status = CASE
  WHEN age < 18 THEN 'minor'
  WHEN age >= 18 AND age < 65 THEN 'adult'
  ELSE 'senior'
END;
```

### DELETE

```sql
-- Delete specific row
DELETE FROM users WHERE id = 1;

-- Delete with condition
DELETE FROM users WHERE created_at < '2020-01-01';

-- Delete all rows (be careful!)
DELETE FROM users;

-- Delete with RETURNING
DELETE FROM users WHERE id = 1 RETURNING *;

-- Delete with join
DELETE FROM order_items
USING orders
WHERE order_items.order_id = orders.id
  AND orders.status = 'cancelled';

-- Truncate (faster than DELETE for all rows)
TRUNCATE TABLE users;                    -- Delete all
TRUNCATE TABLE users RESTART IDENTITY;   -- Also reset sequence
TRUNCATE TABLE users CASCADE;            -- Also truncate dependent tables
```

---

## Queries & Filtering

### WHERE Clause

```sql
-- Equality
SELECT * FROM users WHERE age = 30;
SELECT * FROM users WHERE name = 'John';

-- Comparison operators
SELECT * FROM products WHERE price > 100;
SELECT * FROM products WHERE price <= 50;
SELECT * FROM products WHERE stock != 0;

-- BETWEEN
SELECT * FROM products WHERE price BETWEEN 10 AND 100;
SELECT * FROM users WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';

-- IN
SELECT * FROM users WHERE id IN (1, 2, 3, 4, 5);
SELECT * FROM users WHERE city IN ('NYC', 'LA', 'Chicago');

-- NOT IN
SELECT * FROM users WHERE city NOT IN ('NYC', 'LA');

-- IS NULL / IS NOT NULL
SELECT * FROM users WHERE phone IS NULL;
SELECT * FROM users WHERE email IS NOT NULL;

-- LIKE (pattern matching)
SELECT * FROM users WHERE email LIKE '%@gmail.com';
SELECT * FROM users WHERE name LIKE 'J%';        -- Starts with J
SELECT * FROM users WHERE name LIKE '%son';      -- Ends with son
SELECT * FROM users WHERE name LIKE '%oh%';      -- Contains oh

-- ILIKE (case-insensitive)
SELECT * FROM users WHERE name ILIKE 'john%';

-- Regular expressions
SELECT * FROM users WHERE email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$';
SELECT * FROM users WHERE name ~* '^j';  -- Case-insensitive regex
```

### Logical Operators

```sql
-- AND
SELECT * FROM products 
WHERE price > 50 AND stock > 0;

-- OR
SELECT * FROM users 
WHERE city = 'NYC' OR city = 'LA';

-- NOT
SELECT * FROM users 
WHERE NOT (age < 18);

-- Combining operators
SELECT * FROM products 
WHERE (category = 'electronics' OR category = 'books')
  AND price < 100
  AND stock > 0;

-- Complex conditions
SELECT * FROM users
WHERE (city = 'NYC' AND age > 30)
   OR (city = 'LA' AND age > 25);
```

---

## Joins & Relations

### INNER JOIN

```sql
-- Basic inner join
SELECT 
  users.name,
  orders.total,
  orders.created_at
FROM users
INNER JOIN orders ON users.id = orders.user_id;

-- Join with aliases
SELECT 
  u.name,
  o.total,
  o.created_at AS order_date
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- Multiple joins
SELECT 
  u.name,
  o.id AS order_id,
  p.name AS product_name,
  oi.quantity,
  oi.price
FROM users u
INNER JOIN orders o ON u.id = o.user_id
INNER JOIN order_items oi ON o.id = oi.order_id
INNER JOIN products p ON oi.product_id = p.id;
```

### LEFT JOIN

```sql
-- Returns all rows from left table, matching rows from right
SELECT 
  u.name,
  o.id AS order_id,
  o.total
FROM users u
LEFT JOIN orders o ON u.id = o.user_id;

-- Find users with no orders
SELECT u.name
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
WHERE o.id IS NULL;
```

### RIGHT JOIN

```sql
-- Returns all rows from right table, matching rows from left
SELECT 
  u.name,
  o.id AS order_id,
  o.total
FROM users u
RIGHT JOIN orders o ON u.id = o.user_id;
```

### FULL OUTER JOIN

```sql
-- Returns all rows from both tables
SELECT 
  u.name,
  o.total
FROM users u
FULL OUTER JOIN orders o ON u.id = o.user_id;
```

### CROSS JOIN

```sql
-- Cartesian product (every combination)
SELECT 
  colors.name AS color,
  sizes.name AS size
FROM colors
CROSS JOIN sizes;
```

### SELF JOIN

```sql
-- Join table to itself
CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  manager_id INTEGER REFERENCES employees(id)
);

-- Find employees and their managers
SELECT 
  e.name AS employee,
  m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

---

## Aggregations & Grouping

### Aggregate Functions

```sql
-- COUNT
SELECT COUNT(*) FROM users;
SELECT COUNT(DISTINCT city) FROM users;

-- SUM
SELECT SUM(total) FROM orders;
SELECT SUM(quantity * price) AS revenue FROM order_items;

-- AVG
SELECT AVG(age) FROM users;
SELECT AVG(price) AS avg_price FROM products;

-- MIN / MAX
SELECT MIN(price), MAX(price) FROM products;
SELECT MIN(created_at) AS first_order FROM orders;

-- STRING_AGG (concatenate)
SELECT STRING_AGG(name, ', ') AS all_users FROM users;
SELECT STRING_AGG(DISTINCT city, ' | ') FROM users;

-- ARRAY_AGG (create array)
SELECT ARRAY_AGG(name) FROM users;
```

### GROUP BY

```sql
-- Basic grouping
SELECT 
  city,
  COUNT(*) AS user_count
FROM users
GROUP BY city;

-- Multiple columns
SELECT 
  city,
  age,
  COUNT(*) AS count
FROM users
GROUP BY city, age
ORDER BY city, age;

-- Grouping with aggregate functions
SELECT 
  user_id,
  COUNT(*) AS order_count,
  SUM(total) AS total_spent,
  AVG(total) AS avg_order_value,
  MAX(total) AS biggest_order
FROM orders
GROUP BY user_id;

-- Group by with join
SELECT 
  u.name,
  COUNT(o.id) AS order_count,
  COALESCE(SUM(o.total), 0) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### HAVING

```sql
-- Filter grouped results
SELECT 
  city,
  COUNT(*) AS user_count
FROM users
GROUP BY city
HAVING COUNT(*) > 10;

-- Multiple conditions
SELECT 
  user_id,
  COUNT(*) AS order_count,
  SUM(total) AS total_spent
FROM orders
GROUP BY user_id
HAVING COUNT(*) >= 3 AND SUM(total) > 1000;

-- Having with aggregate in condition
SELECT 
  category,
  AVG(price) AS avg_price
FROM products
GROUP BY category
HAVING AVG(price) > 50
ORDER BY avg_price DESC;
```

### Window Functions

```sql
-- ROW_NUMBER
SELECT 
  name,
  price,
  ROW_NUMBER() OVER (ORDER BY price DESC) AS price_rank
FROM products;

-- RANK (with gaps)
SELECT 
  name,
  price,
  RANK() OVER (ORDER BY price DESC) AS rank
FROM products;

-- DENSE_RANK (no gaps)
SELECT 
  name,
  price,
  DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank
FROM products;

-- PARTITION BY
SELECT 
  category,
  name,
  price,
  AVG(price) OVER (PARTITION BY category) AS category_avg_price,
  price - AVG(price) OVER (PARTITION BY category) AS diff_from_avg
FROM products;

-- Running totals
SELECT 
  order_date,
  total,
  SUM(total) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- LAG / LEAD (previous/next row)
SELECT 
  date,
  revenue,
  LAG(revenue, 1) OVER (ORDER BY date) AS previous_day,
  LEAD(revenue, 1) OVER (ORDER BY date) AS next_day,
  revenue - LAG(revenue, 1) OVER (ORDER BY date) AS change
FROM daily_revenue;
```

---

## Subqueries & CTEs

### Subqueries

```sql
-- Subquery in WHERE
SELECT name, age
FROM users
WHERE age > (SELECT AVG(age) FROM users);

-- Subquery in FROM
SELECT 
  category,
  avg_price
FROM (
  SELECT 
    category,
    AVG(price) AS avg_price
  FROM products
  GROUP BY category
) AS category_averages
WHERE avg_price > 50;

-- Subquery in SELECT
SELECT 
  name,
  (SELECT COUNT(*) FROM orders WHERE orders.user_id = users.id) AS order_count
FROM users;

-- IN with subquery
SELECT name
FROM products
WHERE id IN (
  SELECT product_id 
  FROM order_items 
  WHERE order_id IN (SELECT id FROM orders WHERE status = 'completed')
);

-- EXISTS
SELECT name
FROM users u
WHERE EXISTS (
  SELECT 1 FROM orders o WHERE o.user_id = u.id
);

-- NOT EXISTS (users with no orders)
SELECT name
FROM users u
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.user_id = u.id
);
```

### Common Table Expressions (CTEs)

```sql
-- Basic CTE
WITH high_value_orders AS (
  SELECT * FROM orders WHERE total > 1000
)
SELECT 
  u.name,
  hvo.total
FROM users u
JOIN high_value_orders hvo ON u.id = hvo.user_id;

-- Multiple CTEs
WITH 
  active_users AS (
    SELECT * FROM users WHERE is_active = true
  ),
  recent_orders AS (
    SELECT * FROM orders WHERE created_at > NOW() - INTERVAL '30 days'
  )
SELECT 
  au.name,
  COUNT(ro.id) AS recent_order_count
FROM active_users au
LEFT JOIN recent_orders ro ON au.id = ro.user_id
GROUP BY au.id, au.name;

-- Recursive CTE (hierarchy)
WITH RECURSIVE employee_hierarchy AS (
  -- Base case
  SELECT id, name, manager_id, 1 AS level
  FROM employees
  WHERE manager_id IS NULL
  
  UNION ALL
  
  -- Recursive case
  SELECT e.id, e.name, e.manager_id, eh.level + 1
  FROM employees e
  JOIN employee_hierarchy eh ON e.manager_id = eh.id
)
SELECT * FROM employee_hierarchy ORDER BY level, name;

-- Recursive CTE (generate series)
WITH RECURSIVE date_series AS (
  SELECT DATE '2024-01-01' AS date
  UNION ALL
  SELECT date + INTERVAL '1 day'
  FROM date_series
  WHERE date < DATE '2024-01-31'
)
SELECT * FROM date_series;
```

---

## Indexes & Performance

### Creating Indexes

```sql
-- Basic index
CREATE INDEX idx_users_email ON users(email);

-- Unique index
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- Composite index
CREATE INDEX idx_users_city_age ON users(city, age);

-- Partial index (conditional)
CREATE INDEX idx_active_users ON users(email) WHERE is_active = true;

-- Expression index
CREATE INDEX idx_users_lower_email ON users(LOWER(email));

-- Full-text search index
CREATE INDEX idx_articles_search ON articles USING GIN(to_tsvector('english', content));

-- JSONB index
CREATE INDEX idx_users_metadata ON users USING GIN(metadata);
```

### Index Types

```sql
-- B-tree (default, most common)
CREATE INDEX idx_users_name ON users USING BTREE(name);

-- Hash (equality only)
CREATE INDEX idx_users_id_hash ON users USING HASH(id);

-- GIN (full-text search, JSONB, arrays)
CREATE INDEX idx_tags ON articles USING GIN(tags);

-- GiST (geometric data, full-text)
CREATE INDEX idx_location ON places USING GIST(location);

-- BRIN (very large tables, sorted data)
CREATE INDEX idx_logs_created ON logs USING BRIN(created_at);
```

### Managing Indexes

```sql
-- List all indexes
SELECT * FROM pg_indexes WHERE tablename = 'users';

-- Drop index
DROP INDEX idx_users_email;

-- Rebuild index
REINDEX INDEX idx_users_email;

-- Rebuild all indexes on table
REINDEX TABLE users;

-- Get index size
SELECT 
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
ORDER BY pg_relation_size(indexrelid) DESC;
```

### Query Performance Analysis

```sql
-- EXPLAIN
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';

-- EXPLAIN ANALYZE (actually runs query)
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john@example.com';

-- EXPLAIN with options
EXPLAIN (ANALYZE, BUFFERS, VERBOSE) 
SELECT * FROM users WHERE email = 'john@example.com';

-- Check if index is used
EXPLAIN SELECT * FROM users WHERE LOWER(email) = 'john@example.com';
-- If "Seq Scan" appears, index is not used
-- If "Index Scan" appears, index is used

-- Get query statistics
SELECT 
  query,
  calls,
  total_exec_time,
  mean_exec_time,
  max_exec_time
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
```

---

## Transactions & ACID

### Transaction Basics

```sql
-- Basic transaction
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;

-- Rollback on error
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  -- Something goes wrong...
ROLLBACK;

-- Savepoints
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  SAVEPOINT sp1;
  
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
  -- Error occurs, rollback to savepoint
  ROLLBACK TO sp1;
  
  UPDATE accounts SET balance = balance + 100 WHERE id = 3;
COMMIT;
```

### Isolation Levels

```sql
-- Read Uncommitted (not supported in PostgreSQL, uses Read Committed)
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Read Committed (default)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SELECT * FROM users WHERE id = 1;
  -- Other transactions can modify data between reads
COMMIT;

-- Repeatable Read
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  SELECT * FROM users WHERE id = 1;
  -- Same SELECT will return same result
  SELECT * FROM users WHERE id = 1;
COMMIT;

-- Serializable (strictest)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  SELECT * FROM accounts WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 1;
COMMIT;
```

### Locking

```sql
-- Row-level locks

-- SELECT FOR UPDATE (exclusive lock)
BEGIN;
  SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
COMMIT;

-- SELECT FOR SHARE (shared lock)
BEGIN;
  SELECT * FROM accounts WHERE id = 1 FOR SHARE;
  -- Other transactions can read but not modify
COMMIT;

-- NOWAIT (don't wait for lock)
SELECT * FROM accounts WHERE id = 1 FOR UPDATE NOWAIT;

-- SKIP LOCKED (skip locked rows)
SELECT * FROM jobs WHERE status = 'pending' 
FOR UPDATE SKIP LOCKED 
LIMIT 1;

-- Table-level locks
LOCK TABLE users IN ACCESS EXCLUSIVE MODE;
```

---

## Constraints & Validation

### Primary Key

```sql
-- Single column primary key
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT
);

-- Composite primary key
CREATE TABLE order_items (
  order_id INTEGER,
  product_id INTEGER,
  quantity INTEGER,
  PRIMARY KEY (order_id, product_id)
);

-- Add primary key to existing table
ALTER TABLE users ADD PRIMARY KEY (id);
```

### Foreign Key

```sql
-- Basic foreign key
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id)
);

-- Foreign key with actions
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) 
    ON DELETE CASCADE        -- Delete orders when user deleted
    ON UPDATE CASCADE        -- Update order if user id changes
);

-- Other actions:
-- ON DELETE SET NULL
-- ON DELETE SET DEFAULT
-- ON DELETE RESTRICT (default)
-- ON DELETE NO ACTION

-- Add foreign key to existing table
ALTER TABLE orders
  ADD CONSTRAINT fk_user
  FOREIGN KEY (user_id) REFERENCES users(id);
```

### Unique Constraint

```sql
-- Single column unique
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT UNIQUE
);

-- Multiple column unique (composite)
CREATE TABLE user_roles (
  user_id INTEGER,
  role_id INTEGER,
  UNIQUE (user_id, role_id)
);

-- Named unique constraint
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  CONSTRAINT unique_email UNIQUE (email)
);

-- Partial unique (conditional)
CREATE UNIQUE INDEX idx_active_email 
ON users(email) WHERE is_active = true;
```

### Check Constraint

```sql
-- Basic check
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT,
  price DECIMAL CHECK (price > 0)
);

-- Multiple checks
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  age INTEGER CHECK (age >= 0 AND age <= 120),
  email TEXT CHECK (email LIKE '%@%')
);

-- Named check
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  price DECIMAL,
  discount DECIMAL,
  CONSTRAINT valid_price CHECK (price > 0),
  CONSTRAINT valid_discount CHECK (discount >= 0 AND discount <= price)
);

-- Add check to existing table
ALTER TABLE products
  ADD CONSTRAINT price_positive CHECK (price > 0);
```

### NOT NULL

```sql
-- Column cannot be NULL
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL,
  name TEXT NOT NULL
);

-- Add NOT NULL to existing column
ALTER TABLE users ALTER COLUMN email SET NOT NULL;

-- Remove NOT NULL
ALTER TABLE users ALTER COLUMN email DROP NOT NULL;
```

### Default Values

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  status TEXT DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  is_verified BOOLEAN DEFAULT false,
  credits INTEGER DEFAULT 0
);

-- Add default to existing column
ALTER TABLE users ALTER COLUMN status SET DEFAULT 'active';

-- Remove default
ALTER TABLE users ALTER COLUMN status DROP DEFAULT;
```

---

## Views & Materialized Views

### Views

```sql
-- Create view
CREATE VIEW active_users AS
SELECT id, name, email, created_at
FROM users
WHERE is_active = true;

-- Use view
SELECT * FROM active_users;

-- Create or replace view
CREATE OR REPLACE VIEW user_orders AS
SELECT 
  u.id,
  u.name,
  COUNT(o.id) AS order_count,
  COALESCE(SUM(o.total), 0) AS total_spent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Drop view
DROP VIEW active_users;

-- Updatable views (simple views)
CREATE VIEW simple_users AS
SELECT id, name, email FROM users;

-- Can update through view
UPDATE simple_users SET name = 'John' WHERE id = 1;
```

### Materialized Views

```sql
-- Create materialized view (stores result)
CREATE MATERIALIZED VIEW user_stats AS
SELECT 
  u.id,
  u.name,
  COUNT(o.id) AS order_count,
  COALESCE(SUM(o.total), 0) AS total_spent,
  AVG(o.total) AS avg_order_value
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name;

-- Create index on materialized view
CREATE INDEX idx_user_stats_order_count 
ON user_stats(order_count);

-- Query materialized view (fast!)
SELECT * FROM user_stats WHERE order_count > 10;

-- Refresh materialized view
REFRESH MATERIALIZED VIEW user_stats;

-- Refresh concurrently (non-blocking)
REFRESH MATERIALIZED VIEW CONCURRENTLY user_stats;

-- Drop materialized view
DROP MATERIALIZED VIEW user_stats;
```

---

## Functions & Procedures

### Functions

```sql
-- Basic function
CREATE OR REPLACE FUNCTION get_user_count()
RETURNS INTEGER AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM users);
END;
$$ LANGUAGE plpgsql;

-- Use function
SELECT get_user_count();

-- Function with parameters
CREATE OR REPLACE FUNCTION get_user_by_email(user_email TEXT)
RETURNS TABLE(id INTEGER, name TEXT, email TEXT) AS $$
BEGIN
  RETURN QUERY
  SELECT u.id, u.name, u.email
  FROM users u
  WHERE u.email = user_email;
END;
$$ LANGUAGE plpgsql;

-- Use function
SELECT * FROM get_user_by_email('john@example.com');

-- Function with calculations
CREATE OR REPLACE FUNCTION calculate_discount(
  price DECIMAL,
  discount_percent DECIMAL
)
RETURNS DECIMAL AS $$
BEGIN
  RETURN price * (1 - discount_percent / 100);
END;
$$ LANGUAGE plpgsql;

SELECT calculate_discount(100, 20);  -- Returns 80

-- Function with conditionals
CREATE OR REPLACE FUNCTION get_user_status(user_age INTEGER)
RETURNS TEXT AS $$
BEGIN
  IF user_age < 18 THEN
    RETURN 'minor';
  ELSIF user_age >= 18 AND user_age < 65 THEN
    RETURN 'adult';
  ELSE
    RETURN 'senior';
  END IF;
END;
$$ LANGUAGE plpgsql;
```

### Stored Procedures

```sql
-- Create procedure (can commit/rollback)
CREATE OR REPLACE PROCEDURE transfer_funds(
  from_account INTEGER,
  to_account INTEGER,
  amount DECIMAL
)
LANGUAGE plpgsql AS $$
BEGIN
  -- Deduct from source
  UPDATE accounts SET balance = balance - amount
  WHERE id = from_account;
  
  -- Add to destination
  UPDATE accounts SET balance = balance + amount
  WHERE id = to_account;
  
  -- Commit transaction
  COMMIT;
END;
$$;

-- Call procedure
CALL transfer_funds(1, 2, 100);

-- Procedure with error handling
CREATE OR REPLACE PROCEDURE safe_transfer(
  from_account INTEGER,
  to_account INTEGER,
  amount DECIMAL
)
LANGUAGE plpgsql AS $$
DECLARE
  current_balance DECIMAL;
BEGIN
  -- Check balance
  SELECT balance INTO current_balance
  FROM accounts WHERE id = from_account;
  
  IF current_balance < amount THEN
    RAISE EXCEPTION 'Insufficient funds';
  END IF;
  
  -- Perform transfer
  UPDATE accounts SET balance = balance - amount
  WHERE id = from_account;
  
  UPDATE accounts SET balance = balance + amount
  WHERE id = to_account;
  
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE NOTICE 'Transfer failed: %', SQLERRM;
END;
$$;
```

---

## Triggers

### Basic Trigger

```sql
-- Create trigger function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Now updated_at is automatically set on update
UPDATE users SET name = 'John' WHERE id = 1;
```

### Audit Trigger

```sql
-- Create audit table
CREATE TABLE audit_log (
  id SERIAL PRIMARY KEY,
  table_name TEXT,
  operation TEXT,
  old_data JSONB,
  new_data JSONB,
  changed_by TEXT,
  changed_at TIMESTAMP DEFAULT NOW()
);

-- Create audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_log (table_name, operation, new_data, changed_by)
    VALUES (TG_TABLE_NAME, TG_OP, row_to_json(NEW), current_user);
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_log (table_name, operation, old_data, new_data, changed_by)
    VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), row_to_json(NEW), current_user);
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO audit_log (table_name, operation, old_data, changed_by)
    VALUES (TG_TABLE_NAME, TG_OP, row_to_json(OLD), current_user);
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Apply to table
CREATE TRIGGER users_audit
  AFTER INSERT OR UPDATE OR DELETE ON users
  FOR EACH ROW
  EXECUTE FUNCTION audit_trigger();
```

### Validation Trigger

```sql
-- Prevent deletion of important records
CREATE OR REPLACE FUNCTION prevent_admin_deletion()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.role = 'admin' THEN
    RAISE EXCEPTION 'Cannot delete admin users';
  END IF;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_admin_delete
  BEFORE DELETE ON users
  FOR EACH ROW
  EXECUTE FUNCTION prevent_admin_deletion();
```

---

## JSON & JSONB

### Working with JSONB

```sql
-- Insert JSONB
INSERT INTO users (name, metadata) VALUES
  ('John', '{"age": 30, "city": "NYC", "tags": ["developer", "designer"]}'),
  ('Jane', '{"age": 25, "city": "LA", "premium": true, "settings": {"theme": "dark"}}');

-- Query operators
-- -> returns JSON
-- ->> returns TEXT
SELECT 
  name,
  metadata->'age' AS age_json,
  metadata->>'age' AS age_text,
  metadata->'settings'->>'theme' AS theme
FROM users;

-- Array elements
SELECT 
  name,
  metadata->'tags'->0 AS first_tag,
  metadata->'tags'->>1 AS second_tag_text
FROM users;

-- Path extraction
SELECT 
  name,
  metadata #> '{settings, theme}' AS theme,
  metadata #>> '{settings, theme}' AS theme_text
FROM users;
```

### JSONB Operators

```sql
-- Contains (@>)
SELECT * FROM users WHERE metadata @> '{"city": "NYC"}';
SELECT * FROM users WHERE metadata @> '{"premium": true}';

-- Contained by (<@)
SELECT * FROM users WHERE '{"age": 30}' <@ metadata;

-- Has key (?)
SELECT * FROM users WHERE metadata ? 'premium';

-- Has any key (?|)
SELECT * FROM users WHERE metadata ?| ARRAY['premium', 'vip'];

-- Has all keys (?&)
SELECT * FROM users WHERE metadata ?& ARRAY['age', 'city'];

-- Concatenation (||)
UPDATE users 
SET metadata = metadata || '{"verified": true}'
WHERE id = 1;

-- Remove key (-)
UPDATE users 
SET metadata = metadata - 'premium'
WHERE id = 1;
```

### JSONB Functions

```sql
-- jsonb_array_elements
SELECT 
  name,
  jsonb_array_elements(metadata->'tags') AS tag
FROM users;

-- jsonb_array_elements_text
SELECT 
  name,
  jsonb_array_elements_text(metadata->'tags') AS tag
FROM users;

-- jsonb_object_keys
SELECT jsonb_object_keys(metadata) FROM users;

-- jsonb_each
SELECT name, (jsonb_each(metadata)).*
FROM users;

-- jsonb_array_length
SELECT 
  name,
  jsonb_array_length(metadata->'tags') AS tag_count
FROM users;

-- jsonb_build_object
SELECT jsonb_build_object(
  'name', name,
  'age', metadata->>'age',
  'city', metadata->>'city'
) FROM users;

-- jsonb_agg (aggregate to array)
SELECT jsonb_agg(name) FROM users;
```

### GIN Index on JSONB

```sql
-- Create GIN index
CREATE INDEX idx_users_metadata ON users USING GIN(metadata);

-- Index for specific path
CREATE INDEX idx_users_metadata_tags 
ON users USING GIN((metadata->'tags'));

-- Index for full-text search on JSONB
CREATE INDEX idx_users_metadata_search 
ON users USING GIN(to_tsvector('english', metadata));
```

---

## Full-Text Search

### Basic Full-Text Search

```sql
-- Create table with text column
CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title TEXT,
  content TEXT,
  search_vector tsvector
);

-- Insert data
INSERT INTO articles (title, content) VALUES
  ('PostgreSQL Tutorial', 'Learn PostgreSQL database management'),
  ('Advanced SQL', 'Master complex SQL queries and optimization');

-- Update search vector
UPDATE articles 
SET search_vector = to_tsvector('english', title || ' ' || content);

-- Search
SELECT title, content
FROM articles
WHERE search_vector @@ to_tsquery('english', 'postgresql');

-- Ranked search
SELECT 
  title,
  ts_rank(search_vector, query) AS rank
FROM articles, to_tsquery('english', 'postgresql | sql') AS query
WHERE search_vector @@ query
ORDER BY rank DESC;
```

### Automatic Search Vector

```sql
-- Generated column
CREATE TABLE articles (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  search_vector tsvector GENERATED ALWAYS AS (
    to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, ''))
  ) STORED
);

-- Create GIN index
CREATE INDEX idx_articles_search ON articles USING GIN(search_vector);

-- Search
SELECT title, content
FROM articles
WHERE search_vector @@ to_tsquery('english', 'postgresql & database');
```

### Search with Triggers

```sql
-- Trigger function
CREATE OR REPLACE FUNCTION update_search_vector()
RETURNS TRIGGER AS $$
BEGIN
  NEW.search_vector = to_tsvector('english', 
    coalesce(NEW.title, '') || ' ' || coalesce(NEW.content, '')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
CREATE TRIGGER tsvector_update
  BEFORE INSERT OR UPDATE ON articles
  FOR EACH ROW
  EXECUTE FUNCTION update_search_vector();
```

### Advanced Search

```sql
-- Phrase search
SELECT * FROM articles
WHERE search_vector @@ phraseto_tsquery('english', 'database management');

-- Prefix search
SELECT * FROM articles
WHERE search_vector @@ to_tsquery('english', 'postgr:*');

-- Boolean search
SELECT * FROM articles
WHERE search_vector @@ to_tsquery('english', 'postgresql & (tutorial | guide)');

-- With highlighting
SELECT 
  title,
  ts_headline('english', content, to_tsquery('english', 'postgresql'), 
    'MaxWords=50, MinWords=10, MaxFragments=3') AS snippet
FROM articles
WHERE search_vector @@ to_tsquery('english', 'postgresql');
```

---

## Query Optimization

### EXPLAIN Analysis

```sql
-- Basic EXPLAIN
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';

-- EXPLAIN ANALYZE (runs query)
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john@example.com';

-- With all options
EXPLAIN (ANALYZE, BUFFERS, VERBOSE, COSTS, TIMING)
SELECT * FROM users WHERE email = 'john@example.com';

-- Reading EXPLAIN output:
-- Seq Scan = Table scan (slow for large tables)
-- Index Scan = Using index (good)
-- Index Only Scan = Using index without table access (best)
-- Nested Loop = Join method
-- Hash Join = Join method for large tables
-- Merge Join = Join method for sorted data
```

### Query Optimization Techniques

```sql
-- ❌ BAD: Using function on indexed column
SELECT * FROM users WHERE LOWER(email) = 'john@example.com';

-- ✅ GOOD: Use expression index or store lowercase
CREATE INDEX idx_users_email_lower ON users(LOWER(email));
-- Or store email as lowercase

-- ❌ BAD: Using OR with different columns
SELECT * FROM users WHERE name = 'John' OR email = 'john@example.com';

-- ✅ GOOD: Use UNION
SELECT * FROM users WHERE name = 'John'
UNION
SELECT * FROM users WHERE email = 'john@example.com';

-- ❌ BAD: SELECT *
SELECT * FROM users JOIN orders ON users.id = orders.user_id;

-- ✅ GOOD: Select only needed columns
SELECT users.name, orders.total 
FROM users JOIN orders ON users.id = orders.user_id;

-- ❌ BAD: N+1 queries
-- SELECT * FROM users;
-- For each user: SELECT * FROM orders WHERE user_id = ?;

-- ✅ GOOD: Single JOIN query
SELECT 
  u.*,
  COALESCE(json_agg(o.*) FILTER (WHERE o.id IS NOT NULL), '[]') AS orders
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;
```

### Index Optimization

```sql
-- Check index usage
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC;

-- Find missing indexes
SELECT 
  schemaname,
  tablename,
  attname,
  n_distinct,
  correlation
FROM pg_stats
WHERE schemaname = 'public'
ORDER BY n_distinct DESC;

-- Remove unused indexes
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND indexrelname NOT LIKE 'pg_toast%';
```

### Vacuum and Analyze

```sql
-- VACUUM (reclaim space)
VACUUM users;

-- VACUUM FULL (more aggressive)
VACUUM FULL users;

-- ANALYZE (update statistics)
ANALYZE users;

-- VACUUM ANALYZE (both)
VACUUM ANALYZE users;

-- Auto-vacuum settings (in postgresql.conf)
autovacuum = on
autovacuum_vacuum_scale_factor = 0.2
autovacuum_analyze_scale_factor = 0.1
```

---

## Backup & Recovery

### pg_dump (Logical Backup)

```bash
# Backup single database
pg_dump -U postgres mydb > mydb_backup.sql

# Backup with compression
pg_dump -U postgres -Fc mydb > mydb_backup.dump

# Backup specific table
pg_dump -U postgres -t users mydb > users_backup.sql

# Backup schema only
pg_dump -U postgres --schema-only mydb > schema_backup.sql

# Backup data only
pg_dump -U postgres --data-only mydb > data_backup.sql

# Backup all databases
pg_dumpall -U postgres > all_databases.sql

# Custom format (parallel restore)
pg_dump -U postgres -Fd mydb -j 4 -f mydb_dir
```

### Restore

```bash
# Restore SQL dump
psql -U postgres mydb < mydb_backup.sql

# Restore custom format
pg_restore -U postgres -d mydb mydb_backup.dump

# Restore with clean (drop existing objects)
pg_restore -U postgres -d mydb --clean mydb_backup.dump

# Restore specific table
pg_restore -U postgres -d mydb -t users mydb_backup.dump

# Parallel restore
pg_restore -U postgres -d mydb -j 4 mydb_dir
```

### Point-in-Time Recovery (PITR)

```sql
-- Enable WAL archiving (in postgresql.conf)
wal_level = replica
archive_mode = on
archive_command = 'cp %p /path/to/archive/%f'

-- Take base backup
pg_basebackup -D /path/to/backup -Ft -z -P

-- Restore to specific point in time
-- 1. Stop PostgreSQL
-- 2. Replace data directory with backup
-- 3. Create recovery.conf
restore_command = 'cp /path/to/archive/%f %p'
recovery_target_time = '2025-01-15 14:30:00'
-- 4. Start PostgreSQL
```

---

## Security & Permissions

### User Management

```sql
-- Create user
CREATE USER john WITH PASSWORD 'securepassword';

-- Create user with options
CREATE USER jane WITH 
  PASSWORD 'password'
  CREATEDB
  CREATEROLE
  VALID UNTIL '2026-01-01';

-- Create role (no login)
CREATE ROLE readonly;

-- Drop user
DROP USER john;

-- Change password
ALTER USER john WITH PASSWORD 'newpassword';
```

### Granting Permissions

```sql
-- Grant database connection
GRANT CONNECT ON DATABASE mydb TO john;

-- Grant schema usage
GRANT USAGE ON SCHEMA public TO john;

-- Grant SELECT on table
GRANT SELECT ON users TO john;

-- Grant multiple privileges
GRANT SELECT, INSERT, UPDATE ON users TO john;

-- Grant on all tables in schema
GRANT SELECT ON ALL TABLES IN SCHEMA public TO john;

-- Grant future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO john;

-- Grant to role
GRANT readonly TO john;

-- Revoke permissions
REVOKE INSERT, UPDATE ON users FROM john;
```

### Row-Level Security

```sql
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY user_policy ON users
  FOR ALL
  TO public
  USING (id = current_user_id());

-- Policy for SELECT
CREATE POLICY user_select_policy ON users
  FOR SELECT
  USING (is_active = true);

-- Policy for INSERT
CREATE POLICY user_insert_policy ON users
  FOR INSERT
  WITH CHECK (created_by = current_user);

-- Drop policy
DROP POLICY user_policy ON users;

-- Disable RLS
ALTER TABLE users DISABLE ROW LEVEL SECURITY;
```

---

## Real-World Patterns

### Soft Deletes

```sql
-- Add deleted_at column
ALTER TABLE users ADD COLUMN deleted_at TIMESTAMP;

-- Create index for active records
CREATE INDEX idx_users_active ON users(id) WHERE deleted_at IS NULL;

-- Soft delete
UPDATE users SET deleted_at = NOW() WHERE id = 1;

-- Query active records
SELECT * FROM users WHERE deleted_at IS NULL;

-- Create view for active records
CREATE VIEW active_users AS
SELECT * FROM users WHERE deleted_at IS NULL;
```

### Timestamps Pattern

```sql
CREATE TABLE base_table (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by INTEGER,
  updated_by INTEGER
);

-- Auto-update trigger
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_timestamp
  BEFORE UPDATE ON base_table
  FOR EACH ROW
  EXECUTE FUNCTION update_timestamp();
```

### Pagination Pattern

```sql
-- Offset pagination (simple but slow for large offsets)
SELECT * FROM users 
ORDER BY created_at DESC
LIMIT 20 OFFSET 40;  -- Page 3

-- Cursor pagination (efficient)
SELECT * FROM users 
WHERE created_at < '2025-01-15 12:00:00'
ORDER BY created_at DESC
LIMIT 20;

-- Keyset pagination (best for large datasets)
SELECT * FROM users 
WHERE (created_at, id) < ('2025-01-15 12:00:00', 12345)
ORDER BY created_at DESC, id DESC
LIMIT 20;
```

### Hierarchical Data (Adjacency List)

```sql
CREATE TABLE categories (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  parent_id INTEGER REFERENCES categories(id)
);

-- Get all descendants (recursive CTE)
WITH RECURSIVE descendants AS (
  SELECT * FROM categories WHERE id = 1
  UNION ALL
  SELECT c.* FROM categories c
  JOIN descendants d ON c.parent_id = d.id
)
SELECT * FROM descendants;

-- Get all ancestors
WITH RECURSIVE ancestors AS (
  SELECT * FROM categories WHERE id = 10
  UNION ALL
  SELECT c.* FROM categories c
  JOIN ancestors a ON c.id = a.parent_id
)
SELECT * FROM ancestors;
```

### Audit Trail Pattern

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT,
  name TEXT,
  version INTEGER DEFAULT 1
);

CREATE TABLE users_history (
  history_id SERIAL PRIMARY KEY,
  id INTEGER,
  email TEXT,
  name TEXT,
  version INTEGER,
  operation TEXT,
  changed_at TIMESTAMP DEFAULT NOW(),
  changed_by TEXT
);

-- Trigger to save history
CREATE OR REPLACE FUNCTION save_history()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO users_history 
    SELECT OLD.*, 'UPDATE', NOW(), current_user;
    NEW.version = OLD.version + 1;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO users_history 
    SELECT OLD.*, 'DELETE', NOW(), current_user;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_history_trigger
  BEFORE UPDATE OR DELETE ON users
  FOR EACH ROW
  EXECUTE FUNCTION save_history();
```

### Counter Cache Pattern

```sql
-- Add counter column
ALTER TABLE users ADD COLUMN orders_count INTEGER DEFAULT 0;

-- Update counter on insert
CREATE OR REPLACE FUNCTION increment_orders_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET orders_count = orders_count + 1
  WHERE id = NEW.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER increment_orders
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION increment_orders_count();

-- Decrement on delete
CREATE OR REPLACE FUNCTION decrement_orders_count()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE users SET orders_count = orders_count - 1
  WHERE id = OLD.user_id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER decrement_orders
  AFTER DELETE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION decrement_orders_count();
```

---

## 🎯 Practice Projects

### Project 1: Blog System
- Users, posts, comments, tags
- Full-text search on posts
- Pagination with cursors
- Soft deletes

### Project 2: E-commerce Database
- Products, categories, orders, order_items
- Inventory management
- Transaction handling for orders
- Price history tracking

### Project 3: Social Media Backend
- Users, posts, likes, follows
- Hierarchical comments
- Activity feed queries
- Efficient friend suggestions

### Project 4: Analytics System
- Time-series data
- Aggregation queries
- Materialized views for dashboards
- Partitioning for large datasets

---

## 📚 Next Steps

1. **Practice Daily** - Write queries every day
2. **Build Real Projects** - Apply patterns in real applications
3. **Learn Query Optimization** - Master EXPLAIN and indexes
4. **Study Advanced Features** - Partitioning, replication, extensions
5. **Integrate with Apps** - Use with Prisma, Drizzle, TypeORM

---

## 🔗 Resources

- **Official Docs**: https://www.postgresql.org/docs/
- **pgAdmin**: GUI management tool
- **DBeaver**: Universal database tool
- **PostgREST**: Instant REST API
- **pg_stat_statements**: Query performance tracking

**You're now equipped to build production-grade database systems!** 🚀