# DMRC Line 7 Roster Master - PWA

A Progressive Web App for DMRC Line 7 metro crew to search duty schedules, calculate KM, and analyze rake requirements.

## Features

- **User Authentication** - Login/Register with Emp ID
- **Duty Search** - Search by duty number across Weekday/Saturday/Sunday/Special rosters
- **KM Calculation** - Automatic kilometer calculation based on station distances
- **Rake Analysis** - Identify reliever points (X markers) in duty schedules
- **Admin Dashboard** - Manage messages, upload data, view statistics
- **PWA Support** - Installable on mobile devices

## Tech Stack

- **Flutter** - Frontend framework
- **Supabase** - Backend database & authentication
- **Vercel** - Hosting (free)

## Setup Instructions

### 1. Supabase Setup

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Go to **SQL Editor** in the Supabase dashboard
3. Copy and paste the contents of `supabase_schema.sql`
4. Click **Run** to execute

### 2. Get Supabase Credentials

1. Go to **Settings → API** in your Supabase project
2. Copy:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon/public key**

### 3. Update Flutter App

Open `lib/config/supabase_config.dart` and replace:
```dart
static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
```

### 4. Add Admin User

In Supabase SQL Editor, run:
```sql
INSERT INTO public.allowed_admins (emp_id) VALUES ('YOUR_EMP_ID');
```

### 5. Run the App

```bash
# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Build for web
flutter build web
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/
│   ├── supabase_config.dart  # Supabase connection
│   └── constants.dart        # App constants & KM mappings
├── models/
│   ├── user.dart            # User model
│   ├── duty.dart            # Duty model
│   ├── message.dart         # Message model
│   └── form.dart            # Form models
├── services/
│   ├── auth_service.dart    # Authentication
│   ├── duty_service.dart    # Duty operations
│   ├── message_service.dart # Message operations
│   └── ad_service.dart      # Ad integration
└── screens/
    ├── splash_screen.dart   # Splash screen
    ├── login_screen.dart    # Login/Register
    ├── home_screen.dart     # Main screen
    ├── duty_result_screen.dart # Duty results
    └── admin/               # Admin screens
```

## Deployment

### Deploy to Vercel

1. Build the web app: `flutter build web`
2. Go to [vercel.com](https://vercel.com)
3. Sign up with GitHub
4. Upload the `build/web` folder or connect GitHub repo
5. Deploy!

### Publish to Play Store (Optional)

Use [PWABuilder](https://www.pwabuilder.com):
1. Enter your PWA URL
2. Click "Package for stores"
3. Download Android APK
4. Publish to Play Store (₹825 one-time fee)

## Monetization

The app is set up with AdSense integration ready. To enable ads:

1. Create AdSense account
2. Get your Publisher ID and Ad Unit IDs
3. Update `lib/services/ad_service.dart`

## Access Codes

- **Admin Registration**: `satvik` (case-insensitive)
- **Crew Controller Registration**: `satvik`

## Support

For issues or questions, create an issue in the repository.

---

**Built with ❤️ for DMRC Line 7 Crew**
