# Database Schema

This document outlines the database tables and their columns for the Expenso app.

---

## Tables

### 1. users

| Column     | Type      | Constraints                 |
|------------|-----------|-----------------------------|
| id         | int       | primary key, auto_increment |
| name       | varchar   | not null                    |
| number     | varchar   | not null, unique            |
| email      | varchar   | not null, unique            |
| created_at | timestamp | default now()               |

### SQL to create table in Supabase

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  number VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Enable RLS (Row Level Security)

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
```

### Create Policy for INSERT (allow anyone to register)

```sql
CREATE POLICY "Allow insert for registration" ON users
FOR INSERT
WITH CHECK (true);
```

### Create Policy for SELECT (authenticated users only)

```sql
CREATE POLICY "Allow select for authenticated users" ON users
FOR SELECT
USING (auth.uid() IS NOT NULL);
```