-- =============================================
-- DMRC Line 7 Roster Master - Database Schema
-- Run this in Supabase SQL Editor
-- =============================================

-- STEP 1: PROFILES (Users)
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    emp_id TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    password_hash TEXT,
    access_level TEXT DEFAULT 'crewcontroller' 
        CHECK (access_level IN ('admin', 'crewcontroller')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_login TIMESTAMPTZ
);

-- STEP 2: ACCESS CONTROL LISTS
CREATE TABLE IF NOT EXISTS public.allowed_admins (
    id SERIAL PRIMARY KEY,
    emp_id TEXT UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS public.allowed_crew_controllers (
    id SERIAL PRIMARY KEY,
    emp_id TEXT UNIQUE NOT NULL
);

-- STEP 3: DUTIES DATA
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

CREATE TABLE IF NOT EXISTS public.duties_saturday (LIKE public.duties_weekday INCLUDING ALL);
CREATE TABLE IF NOT EXISTS public.duties_sunday (LIKE public.duties_weekday INCLUDING ALL);
CREATE TABLE IF NOT EXISTS public.duties_special (LIKE public.duties_weekday INCLUDING ALL);

-- STEP 4: CONFIG & MESSAGES
CREATE TABLE IF NOT EXISTS public.config (
    id SERIAL PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT,
    value2 TEXT
);

CREATE TABLE IF NOT EXISTS public.messages (
    id SERIAL PRIMARY KEY,
    user_message TEXT,
    popup_message TEXT,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by TEXT
);

-- STEP 5: FORM SYSTEM
CREATE TABLE IF NOT EXISTS public.form_config (
    id SERIAL PRIMARY KEY,
    heading TEXT,
    fields JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.form_responses (
    id SERIAL PRIMARY KEY,
    form_id INTEGER REFERENCES public.form_config(id),
    submitted_by TEXT,
    emp_no TEXT,
    data JSONB NOT NULL,
    status TEXT DEFAULT 'Pending',
    submitted_at TIMESTAMPTZ DEFAULT NOW()
);

-- STEP 6: MESSAGE LOGS
CREATE TABLE IF NOT EXISTS public.message_logs (
    id SERIAL PRIMARY KEY,
    emp_id TEXT,
    emp_name TEXT,
    action TEXT,
    details TEXT,
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_weekday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_saturday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_sunday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_special ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.allowed_admins ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.allowed_crew_controllers ENABLE ROW LEVEL SECURITY;

-- Profiles Policies
CREATE POLICY "Public can view profiles" ON public.profiles
    FOR SELECT USING (true);

CREATE POLICY "Public can insert profiles" ON public.profiles
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Public can update own profile" ON public.profiles
    FOR UPDATE USING (true);

-- Duties Policies (Everyone can read)
CREATE POLICY "Public can view weekday duties" ON public.duties_weekday
    FOR SELECT USING (true);

CREATE POLICY "Public can view saturday duties" ON public.duties_saturday
    FOR SELECT USING (true);

CREATE POLICY "Public can view sunday duties" ON public.duties_sunday
    FOR SELECT USING (true);

CREATE POLICY "Public can view special duties" ON public.duties_special
    FOR SELECT USING (true);

-- Admin can insert/update duties
CREATE POLICY "Admin can manage weekday duties" ON public.duties_weekday
    FOR ALL USING (true);

CREATE POLICY "Admin can manage saturday duties" ON public.duties_saturday
    FOR ALL USING (true);

CREATE POLICY "Admin can manage sunday duties" ON public.duties_sunday
    FOR ALL USING (true);

CREATE POLICY "Admin can manage special duties" ON public.duties_special
    FOR ALL USING (true);

-- Messages Policies
CREATE POLICY "Public can view messages" ON public.messages
    FOR SELECT USING (true);

CREATE POLICY "Admin can update messages" ON public.messages
    FOR UPDATE USING (true);

-- Form Policies
CREATE POLICY "Public can view form config" ON public.form_config
    FOR SELECT USING (true);

CREATE POLICY "Public can submit forms" ON public.form_responses
    FOR INSERT WITH CHECK (true);

-- Allowed lists
CREATE POLICY "Public can view allowed admins" ON public.allowed_admins
    FOR SELECT USING (true);

CREATE POLICY "Public can view allowed crew controllers" ON public.allowed_crew_controllers
    FOR SELECT USING (true);

-- =============================================
-- INSERT DEFAULT DATA
-- =============================================

-- Default Admin (add your admin emp_id here)
INSERT INTO public.allowed_admins (emp_id) VALUES ('3623') ON CONFLICT DO NOTHING;

-- Default Messages
INSERT INTO public.messages (id, user_message, popup_message) 
VALUES (1, '', '') 
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- HELPER FUNCTIONS
-- =============================================

-- Function to get duties by day type
CREATE OR REPLACE FUNCTION get_duties_by_day(
    p_day_type TEXT,
    p_duty_no TEXT
)
RETURNS TABLE (
    id INT,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_time TEXT,
    sign_off_loc TEXT,
    dep_loc TEXT,
    dep_time TEXT,
    arr_loc TEXT,
    arr_time TEXT,
    rake TEXT
) AS $$
BEGIN
    IF p_day_type = 'Weekday' THEN
        RETURN QUERY SELECT 
            d.id, d.duty_no, d.sign_on_time, d.sign_on_loc,
            d.sign_off_time, d.sign_off_loc, d.dep_loc, d.dep_time,
            d.arr_loc, d.arr_time, d.rake
        FROM public.duties_weekday d
        WHERE d.duty_no ILIKE '%' || p_duty_no || '%';
    ELSIF p_day_type = 'Saturday' THEN
        RETURN QUERY SELECT 
            d.id, d.duty_no, d.sign_on_time, d.sign_on_loc,
            d.sign_off_time, d.sign_off_loc, d.dep_loc, d.dep_time,
            d.arr_loc, d.arr_time, d.rake
        FROM public.duties_saturday d
        WHERE d.duty_no ILIKE '%' || p_duty_no || '%';
    ELSIF p_day_type = 'Sunday' THEN
        RETURN QUERY SELECT 
            d.id, d.duty_no, d.sign_on_time, d.sign_on_loc,
            d.sign_off_time, d.sign_off_loc, d.dep_loc, d.dep_time,
            d.arr_loc, d.arr_time, d.rake
        FROM public.duties_sunday d
        WHERE d.duty_no ILIKE '%' || p_duty_no || '%';
    ELSE
        RETURN QUERY SELECT 
            d.id, d.duty_no, d.sign_on_time, d.sign_on_loc,
            d.sign_off_time, d.sign_off_loc, d.dep_loc, d.dep_time,
            d.arr_loc, d.arr_time, d.rake
        FROM public.duties_special d
        WHERE d.duty_no ILIKE '%' || p_duty_no || '%';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- COMPLETE!
-- =============================================
