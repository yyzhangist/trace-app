# Trace Backend - Firebase/Supabase Setup

## Backend Architecture

Trace uses a lightweight backend for:
- Anonymous user authentication
- Drawing cloud sync (premium feature)
- Waitlist management
- Analytics

## Option 1: Firebase (Recommended)

### Setup Steps

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create new project: "Trace"
   - Enable Analytics (optional)

2. **Enable Authentication**
   - Go to Authentication > Sign-in method
   - Enable "Anonymous" authentication

3. **Setup Firestore Database**
   - Go to Firestore Database
   - Create database in production mode
   - Set up collections:

```
users/
  {userId}/
    - email: string (optional)
    - isPremium: boolean
    - streak: number
    - createdAt: timestamp
    
drawings/
  {drawingId}/
    - userId: string
    - strokes: array
    - prompt: string
    - date: timestamp
    - isPrivate: boolean

waitlist/
  {email}/
    - signupDate: timestamp
    - source: string
    - utmParams: object
```

4. **Security Rules**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Drawings
    match /drawings/{drawingId} {
      allow read: if request.auth != null && resource.data.userId == request.auth.uid;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
    
    // Waitlist (write-only for public)
    match /waitlist/{email} {
      allow create: if true;
      allow read: if false;
    }
  }
}
```

5. **Add Firebase to iOS App**

Add to `TraceApp.swift`:
```swift
import Firebase

@main
struct TraceApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    // ... rest of code
}
```

Install Firebase SDK via SPM:
```
https://github.com/firebase/firebase-ios-sdk
```

6. **Download Configuration**
   - Download `GoogleService-Info.plist`
   - Add to Xcode project

### Environment Variables

Create `.env` file:
```
FIREBASE_API_KEY=your_api_key
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_APP_ID=your_app_id
```

## Option 2: Supabase (Alternative)

### Setup Steps

1. **Create Supabase Project**
   - Go to [Supabase](https://supabase.com)
   - Create new project

2. **Create Tables**

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT,
  is_premium BOOLEAN DEFAULT false,
  streak INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Drawings table
CREATE TABLE drawings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  strokes JSONB,
  prompt TEXT,
  date TIMESTAMP DEFAULT NOW(),
  is_private BOOLEAN DEFAULT true
);

-- Waitlist table
CREATE TABLE waitlist (
  email TEXT PRIMARY KEY,
  signup_date TIMESTAMP DEFAULT NOW(),
  source TEXT
);

-- Enable Row Level Security
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE drawings ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own data" 
  ON users FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can view own drawings" 
  ON drawings FOR SELECT 
  USING (auth.uid() = user_id);
```

3. **Add to iOS App**

```swift
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "YOUR_SUPABASE_URL")!,
    supabaseKey: "YOUR_SUPABASE_ANON_KEY"
)
```

## Backend API Endpoints (Optional Cloud Functions)

### 1. Waitlist Signup
```javascript
// Firebase Cloud Function
exports.addToWaitlist = functions.https.onRequest(async (req, res) => {
  const { email } = req.body;
  
  await admin.firestore().collection('waitlist').doc(email).set({
    signupDate: admin.firestore.FieldValue.serverTimestamp(),
    source: req.headers.referer || 'direct'
  });
  
  // Send welcome email (optional)
  await sendWelcomeEmail(email);
  
  res.json({ success: true });
});
```

### 2. Premium Subscription Webhook
```javascript
// Stripe webhook for subscription
exports.handleSubscription = functions.https.onRequest(async (req, res) => {
  const event = req.body;
  
  if (event.type === 'customer.subscription.created') {
    const userId = event.data.object.metadata.userId;
    await admin.firestore().collection('users').doc(userId).update({
      isPremium: true
    });
  }
  
  res.json({ received: true });
});
```

## Environment Setup

### Development
- Use Firebase emulator for local testing
- Mock premium features

### Production
- Enable Firebase App Check for security
- Set up backup/restore for Firestore
- Monitor usage and costs

## Cost Estimate

**Firebase Free Tier:**
- 50,000 reads/day
- 20,000 writes/day
- 1 GB storage
- Good for first 5,000-10,000 users

**Estimated Monthly Cost (10,000 active users):**
- Firebase: $25-50/month
- Supabase: $25/month (Pro plan)

## Integration Checklist

- [ ] Create Firebase/Supabase project
- [ ] Set up authentication
- [ ] Create database schema
- [ ] Add SDK to iOS app
- [ ] Implement sync logic
- [ ] Test offline functionality
- [ ] Set up analytics
- [ ] Configure security rules
- [ ] Set up cloud functions
- [ ] Add payment integration (Stripe/RevenueCat)

## Next Steps

1. Choose backend (Firebase recommended for iOS)
2. Follow setup guide above
3. Integrate SDK into app
4. Test cloud sync
5. Add payment processing
6. Launch! 🚀
