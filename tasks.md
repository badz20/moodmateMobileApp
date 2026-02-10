# MoodMate Development Tasks

This document breaks down the use cases into actionable development tasks, organized by feature area and priority.

## Tech Stack

- **Frontend:** Flutter (iOS, Android, Web)
- **Backend:** Firebase
  - **Authentication:** Firebase Authentication
  - **Database:** Cloud Firestore
  - **Functions:** Firebase Cloud Functions (Node.js/TypeScript)
  - **Messaging:** Firebase Cloud Messaging (FCM)
  - **Storage:** Firebase Storage (if needed)
  - **Analytics:** Firebase Analytics
  - **Crash Reporting:** Firebase Crashlytics
- **AI Integration:** OpenAI API (via Cloud Functions)
- **State Management:** TBD (Provider, Riverpod, or Bloc)

## 1. Authentication & User Management

### Task 1.1: User Registration (UC-01) ✅

**Priority:** High  
**Dependencies:** None

- [x] Design and implement user registration UI (sign-up form)
- [x] Set up Firebase Authentication
- [x] Create user document schema in Firestore (name, email, role, timestamps)
- [x] Implement Firebase Auth registration method
- [x] Add email validation logic
- [x] Add password strength validation
- [x] Handle duplicate email check (Firebase built-in)
- [x] Send email verification using Firebase Auth
- [x] Create user profile document in Firestore after successful registration
- [x] Handle alternate flow: email already exists error

### Task 1.2: User Login (UC-02) ✅

**Priority:** High  
**Dependencies:** Task 1.1

- [x] Design and implement login UI
- [x] Implement Firebase Auth sign-in method
- [x] Handle authentication state changes
- [x] Implement session persistence (Firebase Auth automatic)
- [x] Create dashboard/home screen
- [x] Add "invalid credentials" error handling
- [x] Implement retry mechanism for failed login attempts
- [x] Fetch user role from Firestore after login
- [x] Add role-based access (User vs Counsellor)

### Task 1.3: User Roles & Permissions ✅

**Priority:** High  
**Dependencies:** Task 1.2

- [x] Define user role enum (User, Counsellor, Admin)
- [x] Implement role assignment during registration in Firestore
- [x] Create Firestore Security Rules for role-based access control
- [x] Add permission checks using Firestore Security Rules
- [x] Implement client-side role checks for UI navigation

---

## 2. Mood Tracking & Journaling

### Task 2.1: Daily Mood Entry (UC-03) ✅

**Priority:** High  
**Dependencies:** Task 1.2

- [x] Design mood entry UI with text input
- [x] Create "New Entry" button/navigation
- [x] Define mood entry document structure in Firestore (user_id, date, text, timestamp)
- [x] Create Firestore collection for mood entries
- [x] Add validation for empty input
- [x] Ensure one entry per day constraint (or allow multiple)
- [x] Store entry in Firestore
- [x] Trigger Cloud Function for AI analysis upon submission
- [x] Show submission confirmation to user

### Task 2.2: AI Mood Analysis Integration (UC-04) ✅

**Priority:** High  
**Dependencies:** Task 2.1

- [x] Set up Firebase Cloud Functions
- [x] Set up OpenAI API integration in Cloud Functions
- [x] Configure API keys using Firebase environment config
- [x] Design prompt for emotion detection
- [x] Create Cloud Function triggered by new mood entry
- [x] Call OpenAI API from Cloud Function
- [x] Parse and extract emotion category and confidence score
- [x] Store analysis results in Firestore (emotion, score, timestamp)
- [x] Update mood entry document with analysis results
- [x] Handle API failures gracefully in Cloud Function
- [x] Implement fallback/retry mechanism
- [x] Mark failed analyses as "pending/failed" in Firestore

### Task 2.3: Mood-Based Recommendations (UC-05) ✅

**Priority:** Medium  
**Dependencies:** Task 2.2

- [x] Create mood-to-prompt mapping logic in Cloud Function
- [x] Design prompts for generating tips/quotes per mood
- [x] Call OpenAI API from Cloud Function to generate personalized suggestions
- [x] Store generated suggestions in Firestore
- [x] Display suggestions to user after mood entry
- [x] Implement fallback static tips for each mood category
- [x] Handle cases when AI is unavailable
- [x] Add option to save favorite suggestions to Firestore

---

## 3. Mood History & Visualization

### Task 3.1: View Mood History (UC-06) ✅

**Priority:** Medium  
**Dependencies:** Task 2.1

- [x] Design mood history/trends UI
- [x] Query Firestore to fetch user's mood logs
- [x] Implement date range filtering using Firestore queries (week, month, custom)
- [x] Display mood entries in a list or timeline view
- [x] Implement pagination using Firestore query cursors
- [x] Handle empty state (no data message)
- [x] Add search/filter functionality with Firestore queries

### Task 3.2: Mood Trend Visualization ✅

**Priority:** Medium  
**Dependencies:** Task 3.1, Task 2.2

- [x] Choose charting library (e.g., charts_flutter, fl_chart)
- [x] Design chart types (line chart, bar chart, mood calendar)
- [x] Aggregate mood data by time period
- [x] Generate visualizations for mood trends
- [x] Implement interactive chart features
- [x] Add export/share functionality for reports

---

## 4. Counsellor Features

### Task 4.1: Contact Counsellor (UC-07) ✅

**Priority:** Medium  
**Dependencies:** Task 1.2

- [x] Design counsellor contact/request UI
- [x] Define counsellor document schema in Firestore
- [x] Implement counsellor listing or selection screen using Firestore query
- [x] Define support request document structure in Firestore (user_id, counsellor_id, status, timestamp)
- [x] Create support request document in Firestore
- [x] Implement Firebase Cloud Messaging for counsellor notifications
- [x] Define conversation thread collection in Firestore
- [x] Link support request to conversation thread using document references
- [x] Handle "no counsellor available" scenario
- [x] Add request status tracking in Firestore (pending, accepted, completed)

### Task 4.2: Counsellor Views User Mood Summary (UC-08) ✅

**Priority:** Medium  
**Dependencies:** Task 4.1, Task 3.1

- [x] Design counsellor dashboard UI
- [x] Implement user selection/assignment logic in Firestore
- [x] Query Firestore for assigned user data
- [x] Enforce user consent and privacy permissions using Firestore Security Rules
- [x] Display user mood trends and charts
- [x] Query and show recent mood entries from Firestore
- [x] Implement access control checks using Firestore Security Rules
- [x] Handle "access denied" for unauthorized requests
- [x] Add filtering and date range options with Firestore queries

### Task 4.3: Counsellor Provides Advice (UC-09) ✅

**Priority:** Medium  
**Dependencies:** Task 4.1

- [x] Design chat/advice UI for counsellors
- [x] Define message document structure in Firestore (sender_id, receiver_id, content, timestamp)
- [x] Create messages subcollection in conversation thread
- [x] Implement real-time messaging using Firestore snapshots
- [x] Store messages in Firestore conversation thread
- [x] Send push notifications using Firebase Cloud Messaging when advice is received
- [x] Handle offline mode with Firebase offline persistence
- [x] Implement automatic retry with Firestore client
- [x] Add message read status tracking in Firestore

---

## Demo Scope

This project is a demo and is not intended for deployment. Remaining unfinished tasks related to production hardening (privacy/security/compliance), testing, and deployment/infrastructure have been removed from this task list.
**Priority:** High
