# User Profile Table - Supabase

This table stores application user information separately from `auth.users`.

## Features

- Linked with Supabase Auth using foreign key
- Stores app-specific user data
- Supports Row Level Security (RLS)
- Secure access for authenticated users
- Optimized with indexes

---

# SQL Schema

```sql
CREATE TABLE user_profile (
  id uuid primary key references auth.users(id) on delete cascade,

  name VARCHAR(255) NOT NULL,

  number VARCHAR(20) NOT NULL UNIQUE,

  email VARCHAR(255) NOT NULL UNIQUE,

  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE user_profile ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow insert for registration"
ON user_profile
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Users can view own profile"
ON user_profile
FOR SELECT
USING (auth.uid() = id);

CREATE INDEX idx_user_profile_id
ON user_profile(id);

```

---

# Expense Table

This table stores user expense records linked to `user_profile`.

## Features

- Linked to `user_profile` via foreign key
- Supports Row Level Security (RLS)
- Users can only access their own expenses

---

# SQL Schema

```sql
CREATE TABLE expense (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL,
  category VARCHAR(100) NOT NULL,
  date DATE NOT NULL,
  note TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE expense ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own expenses"
ON expense
FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own expenses"
ON expense
FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own expenses"
ON expense
FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own expenses"
ON expense
FOR DELETE
USING (auth.uid() = user_id);

CREATE INDEX idx_expense_user_id
ON expense(user_id);

CREATE INDEX idx_expense_date
ON expense(date);
```

---

# Friends Table

This table stores the friends added by the user to keep track of shared expenses or balances.

## Features

- Linked to `user_profile` via `owner_id` (the user who added the friend).
- Can optionally be linked to another registered user via `linked_user_id`.
- Tracks `closing_balance` (Positive = user will take, Negative = user will give).
- Supports Row Level Security (RLS) to ensure users only access their own friend list.

---

# SQL Schema

```sql
CREATE TABLE friends (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID NOT NULL REFERENCES user_profile(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  linked_user_id UUID REFERENCES user_profile(id) ON DELETE SET NULL,
  closing_balance DECIMAL(10, 2) DEFAULT 0.00,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE friends ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own friends"
ON friends
FOR SELECT
USING (auth.uid() = owner_id);

CREATE POLICY "Users can insert own friends"
ON friends
FOR INSERT
WITH CHECK (auth.uid() = owner_id);

CREATE POLICY "Users can update own friends"
ON friends
FOR UPDATE
USING (auth.uid() = owner_id);

CREATE POLICY "Users can delete own friends"
ON friends
FOR DELETE
USING (auth.uid() = owner_id);

CREATE INDEX idx_friends_owner_id
ON friends(owner_id);

CREATE INDEX idx_friends_linked_user_id
ON friends(linked_user_id);
```