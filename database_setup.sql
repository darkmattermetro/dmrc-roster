-- =============================================
-- DMRC Roster Master - Complete Database Setup
-- Matches your Google Sheet structure EXACTLY
-- =============================================

-- Drop existing tables (if any)
DROP TABLE IF EXISTS public.duties_weekday CASCADE;
DROP TABLE IF EXISTS public.duties_saturday CASCADE;
DROP TABLE IF EXISTS public.duties_sunday CASCADE;
DROP TABLE IF EXISTS public.duties_special CASCADE;
DROP TABLE IF EXISTS public.messages CASCADE;
DROP TABLE IF EXISTS public.config CASCADE;

-- =============================================
-- WEEKDAY DUTIES TABLE
-- =============================================
CREATE TABLE public.duties_weekday (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_loc TEXT,
    sign_off_time TEXT,
    driving_hrs TEXT,
    duty_hrs TEXT,
    same_jurisdiction TEXT,
    rake_num TEXT,
    start_stn TEXT,
    start_time TEXT,
    end_stn TEXT,
    end_time TEXT,
    service_duration TEXT,
    break_time TEXT,
    stepback_rake TEXT
);

-- =============================================
-- SATURDAY DUTIES TABLE
-- =============================================
CREATE TABLE public.duties_saturday (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_loc TEXT,
    sign_off_time TEXT,
    driving_hrs TEXT,
    duty_hrs TEXT,
    same_jurisdiction TEXT,
    rake_num TEXT,
    start_stn TEXT,
    start_time TEXT,
    end_stn TEXT,
    end_time TEXT,
    service_duration TEXT,
    break_time TEXT,
    stepback_rake TEXT
);

-- =============================================
-- SUNDAY DUTIES TABLE
-- =============================================
CREATE TABLE public.duties_sunday (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_loc TEXT,
    sign_off_time TEXT,
    driving_hrs TEXT,
    duty_hrs TEXT,
    same_jurisdiction TEXT,
    rake_num TEXT,
    start_stn TEXT,
    start_time TEXT,
    end_stn TEXT,
    end_time TEXT,
    service_duration TEXT,
    break_time TEXT,
    stepback_rake TEXT
);

-- =============================================
-- SPECIAL DUTIES TABLE
-- =============================================
CREATE TABLE public.duties_special (
    id SERIAL PRIMARY KEY,
    duty_no TEXT,
    sign_on_time TEXT,
    sign_on_loc TEXT,
    sign_off_loc TEXT,
    sign_off_time TEXT,
    driving_hrs TEXT,
    duty_hrs TEXT,
    same_jurisdiction TEXT,
    rake_num TEXT,
    start_stn TEXT,
    start_time TEXT,
    end_stn TEXT,
    end_time TEXT,
    service_duration TEXT,
    break_time TEXT,
    stepback_rake TEXT
);

-- =============================================
-- MESSAGES TABLE
-- =============================================
CREATE TABLE public.messages (
    id SERIAL PRIMARY KEY,
    user_message TEXT DEFAULT '',
    popup_message TEXT DEFAULT '',
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    updated_by TEXT
);

-- =============================================
-- CONFIG TABLE (for settings)
-- =============================================
CREATE TABLE public.config (
    id SERIAL PRIMARY KEY,
    key TEXT UNIQUE NOT NULL,
    value TEXT
);

-- =============================================
-- INSERT DEFAULT MESSAGES
-- =============================================
INSERT INTO public.messages (id, user_message, popup_message) VALUES (1, '', '');

-- =============================================
-- INSERT DEFAULT CONFIG
-- =============================================
INSERT INTO public.config (key, value) VALUES 
    ('wef_date', ''),
    ('app_version', '1.0.0');

-- =============================================
-- ENABLE ROW LEVEL SECURITY (RLS)
-- =============================================
ALTER TABLE public.duties_weekday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_saturday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_sunday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_special ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.config ENABLE ROW LEVEL SECURITY;

-- =============================================
-- CREATE POLICIES (ALLOW ALL OPERATIONS)
-- =============================================

-- Weekday policies
DROP POLICY IF EXISTS "weekday_all" ON public.duties_weekday;
CREATE POLICY "weekday_all" ON public.duties_weekday
    FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "weekday_select" ON public.duties_weekday;
CREATE POLICY "weekday_select" ON public.duties_weekday FOR SELECT USING (true);

-- Saturday policies
DROP POLICY IF EXISTS "saturday_all" ON public.duties_saturday;
CREATE POLICY "saturday_all" ON public.duties_saturday
    FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "saturday_select" ON public.duties_saturday;
CREATE POLICY "saturday_select" ON public.duties_saturday FOR SELECT USING (true);

-- Sunday policies
DROP POLICY IF EXISTS "sunday_all" ON public.duties_sunday;
CREATE POLICY "sunday_all" ON public.duties_sunday
    FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "sunday_select" ON public.duties_sunday;
CREATE POLICY "sunday_select" ON public.duties_sunday FOR SELECT USING (true);

-- Special policies
DROP POLICY IF EXISTS "special_all" ON public.duties_special;
CREATE POLICY "special_all" ON public.duties_special
    FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "special_select" ON public.duties_special;
CREATE POLICY "special_select" ON public.duties_special FOR SELECT USING (true);

-- Messages policies
DROP POLICY IF EXISTS "messages_all" ON public.messages;
CREATE POLICY "messages_all" ON public.messages
    FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "messages_select" ON public.messages;
CREATE POLICY "messages_select" ON public.messages FOR SELECT USING (true);

-- Config policies
DROP POLICY IF EXISTS "config_all" ON public.config;
CREATE POLICY "config_all" ON public.config
    FOR ALL USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "config_select" ON public.config;
CREATE POLICY "config_select" ON public.config FOR SELECT USING (true);

-- =============================================
-- DONE! Tables created and policies set.
-- =============================================

-- Verify tables:
-- SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';
