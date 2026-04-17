-- =============================================
-- Fix RLS Policies for DMRC Roster App
-- Run this in Supabase SQL Editor
-- =============================================

-- Messages table - Allow public UPDATE
DROP POLICY IF EXISTS "Admin can update messages" ON public.messages;
CREATE POLICY "Allow public update on messages" ON public.messages
    FOR UPDATE USING (true);

-- Duties tables - Allow public INSERT and DELETE
DROP POLICY IF EXISTS "Admin can manage weekday duties" ON public.duties_weekday;
CREATE POLICY "Allow public all weekday duties" ON public.duties_weekday
    FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Admin can manage saturday duties" ON public.duties_saturday;
CREATE POLICY "Allow public all saturday duties" ON public.duties_saturday
    FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Admin can manage sunday duties" ON public.duties_sunday;
CREATE POLICY "Allow public all sunday duties" ON public.duties_sunday
    FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "Admin can manage special duties" ON public.duties_special;
CREATE POLICY "Allow public all special duties" ON public.duties_special
    FOR ALL USING (true) WITH CHECK (true);

-- Ensure RLS is enabled on all tables
ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_weekday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_saturday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_sunday ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.duties_special ENABLE ROW LEVEL SECURITY;

-- =============================================
-- Test by inserting test data
-- =============================================
-- INSERT INTO public.duties_weekday (duty_no, dep_loc, dep_time, arr_loc, arr_time, rake)
-- VALUES ('TEST', 'KKDA DN', '05:00', 'PBGW DN', '06:00', '701');

-- =============================================
-- If still not working, run this to disable RLS temporarily:
-- (Not recommended for production, but helps diagnose)
-- =============================================
-- ALTER TABLE public.messages DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.duties_weekday DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.duties_saturday DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.duties_sunday DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.duties_special DISABLE ROW LEVEL SECURITY;

-- =============================================
-- DONE!
-- =============================================
