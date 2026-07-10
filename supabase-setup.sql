-- Create Students Table
CREATE TABLE IF NOT EXISTS students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  stars INTEGER NOT NULL DEFAULT 0,
  avatar TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create History/Transaction Table
CREATE TABLE IF NOT EXISTS history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
  type VARCHAR(50) NOT NULL CHECK (type IN ('achievement', 'penalty')),
  stars_changed INTEGER NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_students_stars ON students(stars DESC);
CREATE INDEX IF NOT EXISTS idx_history_student_id ON history(student_id);
CREATE INDEX IF NOT EXISTS idx_history_created_at ON history(created_at DESC);

-- Enable Row Level Security (optional but recommended)
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE history ENABLE ROW LEVEL SECURITY;

-- Create policies to allow public access (for development)
CREATE POLICY "Allow public read on students" ON students FOR SELECT USING (true);
CREATE POLICY "Allow public insert on students" ON students FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on students" ON students FOR UPDATE USING (true);
CREATE POLICY "Allow public delete on students" ON students FOR DELETE USING (true);

CREATE POLICY "Allow public read on history" ON history FOR SELECT USING (true);
CREATE POLICY "Allow public insert on history" ON history FOR INSERT WITH CHECK (true);
