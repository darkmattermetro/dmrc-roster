-- =============================================
-- Complete Database Setup for DMRC Roster App
-- Run this ONE TIME to create all tables and fix permissions
-- =============================================

-- Create duties_weekday table
CREATE TABLE IF NOT EXISTS public.duties_weekday (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_time TEXT,
    sign_off_loc TEXT,
    running_time TEXT,
    trip_no TEXT,
    station TEXT,
    train TEXT,
    dep_loc TEXT,
    dep_time TEXT,
    arr_loc TEXT,
    arr_time TEXT,
    rake TEXT,
    wef_date TEXT,
    remarks TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create duties_saturday table
CREATE TABLE IF NOT EXISTS public.duties_saturday (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_time TEXT,
    sign_off_loc TEXT,
    running_time TEXT,
    trip_no TEXT,
    station TEXT,
    train TEXT,
    dep_loc TEXT,
    dep_time TEXT,
    arr_loc TEXT,
    arr_time TEXT,
    rake TEXT,
    wef_date TEXT,
    remarks TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create duties_sunday table
CREATE TABLE IF NOT EXISTS public.duties_sunday (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_time TEXT,
    sign_off_loc TEXT,
    running_time TEXT,
    trip_no TEXT,
    station TEXT,
    train TEXT,
    dep_loc TEXT,
    dep_time TEXT,
    arr_loc TEXT,
    arr_time TEXT,
    rake TEXT,
    wef_date TEXT,
    remarks TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create duties_special table
CREATE TABLE IF NOT EXISTS public.duties_special (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_time TEXT,
    sign_off_loc TEXT,
    running_time TEXT,
    trip_no TEXT,
    station TEXT,
    train TEXT,
    dep_loc TEXT,
    dep_time TEXT,
    arr_loc TEXT,
    arr_time TEXT,
    rake TEXT,
    wef_date TEXT,
    remarks TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create messages table
CREATE TABLE IF NOT EXISTS public.messages (
    id SERIAL PRIMARY KEY,
    user_message TEXT,
    popup_message TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by TEXT
);

-- =============================================
-- Enable RLS
-- =============================================
ALTER TABLE public.duties_weekday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_saturday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_sunday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_special ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

-- =============================================
-- DROP all existing policies
-- =============================================
DROP POLICY IF EXISTS "Public can view weekday duties" ON public.duties_weekday;
DROP POLICY IF EXISTS "Public can view saturday duties" ON public.duties_saturday;
DROP POLICY IF EXISTS "Public can view sunday duties" ON public.duties_sunday;
DROP POLICY IF EXISTS "Public can view special duties" ON public.duties_special;
DROP POLICY IF EXISTS "Public can view messages" ON public.messages;
DROP POLICY IF EXISTS "Admin can manage weekday duties" ON public.duties_weekday;
DROP POLICY IF EXISTS "Admin can manage saturday duties" ON public.duties_saturday;
DROP POLICY IF EXISTS "Admin can manage sunday duties" ON public.duties_sunday;
DROP POLICY IF EXISTS "Admin can manage special duties" ON public.duties_special;
DROP POLICY IF EXISTS "Admin can update messages" ON public.messages;

-- =============================================
-- Create NEW policies (ALLOW ALL)
-- =============================================

-- Weekday duties - Allow ALL operations
CREATE POLICY "weekday_all" ON public.duties_weekday
    FOR ALL USING (true) WITH CHECK (true);

-- Saturday duties - Allow ALL operations
CREATE POLICY "saturday_all" ON public.duties_saturday
    FOR ALL USING (true) WITH CHECK (true);

-- Sunday duties - Allow ALL operations
CREATE POLICY "sunday_all" ON public.duties_sunday
    FOR ALL USING (true) WITH CHECK (true);

-- Special duties - Allow ALL operations
CREATE POLICY "special_all" ON public.duties_special
    FOR ALL USING (true) WITH CHECK (true);

-- Messages - Allow ALL operations
CREATE POLICY "messages_all" ON public.messages
    FOR ALL USING (true) WITH CHECK (true);

-- =============================================
-- Insert default messages row
-- =============================================
INSERT INTO public.messages (id, user_message, popup_message)
VALUES (1, '', '')
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- DONE! Now try uploading data again.
-- =============================================
