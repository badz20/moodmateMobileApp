# Use Case Table – MoodMate

## UC-01 — Register Account

| Field          | Details                                                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Use Case ID    | UC-01                                                                                                                           |
| Use Case Name  | Register Account                                                                                                                |
| Primary Actor  | User                                                                                                                            |
| Goal           | Create a new account to use MoodMate                                                                                            |
| Preconditions  | User has not registered; app is accessible                                                                                      |
| Trigger        | User selects “Sign Up”                                                                                                          |
| Main Flow      | 1) User enters name/email/password<br>2) System validates input<br>3) System creates account<br>4) System confirms registration |
| Alternate Flow | A1: Email already exists → system asks user to log in/reset password                                                            |
| Postconditions | User account is created and stored                                                                                              |

## UC-02 — Login

| Field          | Details                                                                                                                    |
| -------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Use Case ID    | UC-02                                                                                                                      |
| Use Case Name  | Login                                                                                                                      |
| Primary Actor  | User / Counsellor                                                                                                          |
| Goal           | Access the system securely                                                                                                 |
| Preconditions  | Actor has a valid account                                                                                                  |
| Trigger        | Actor enters credentials and clicks “Login”                                                                                |
| Main Flow      | 1) Actor enters email/password<br>2) System verifies credentials<br>3) System grants access<br>4) Actor lands on dashboard |
| Alternate Flow | A1: Invalid credentials → error message; allow retry                                                                       |
| Postconditions | Actor is authenticated and session is active                                                                               |

## UC-03 — Record Daily Mood (Text Journal)

| Field          | Details                                                                                                           |
| -------------- | ----------------------------------------------------------------------------------------------------------------- |
| Use Case ID    | UC-03                                                                                                             |
| Use Case Name  | Record Daily Mood                                                                                                 |
| Primary Actor  | User                                                                                                              |
| Goal           | Save a daily emotion entry using text input                                                                       |
| Preconditions  | User is logged in                                                                                                 |
| Trigger        | User taps “New Entry”                                                                                             |
| Main Flow      | 1) User types feelings<br>2) User submits entry<br>3) System stores entry<br>4) System sends entry to AI analysis |
| Alternate Flow | A1: Empty input → system asks user to type something                                                              |
| Postconditions | Mood entry is saved for the day                                                                                   |

## UC-04 — AI Mood Analysis (NLP)

| Field            | Details                                                                                              |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| Use Case ID      | UC-04                                                                                                |
| Use Case Name    | Analyze Mood using AI                                                                                |
| Primary Actor    | System (OpenAI)                                                                                      |
| Supporting Actor | User                                                                                                 |
| Goal             | Detect emotion from the user’s text entry                                                            |
| Preconditions    | UC-03 entry exists                                                                                   |
| Trigger          | User submits mood entry                                                                              |
| Main Flow        | 1) System sends text to OpenAI<br>2) AI returns emotion category + score<br>3) System stores results |
| Alternate Flow   | A1: AI/API fails → system stores entry only and marks analysis “pending/failed”                      |
| Postconditions   | Emotion label and analysis score are saved                                                           |

## UC-05 — Generate Recommendations

| Field            | Details                                                                                                       |
| ---------------- | ------------------------------------------------------------------------------------------------------------- |
| Use Case ID      | UC-05                                                                                                         |
| Use Case Name    | Generate Mood Suggestions                                                                                     |
| Primary Actor    | System                                                                                                        |
| Supporting Actor | OpenAI                                                                                                        |
| Goal             | Provide helpful tips/quotes based on detected mood                                                            |
| Preconditions    | UC-04 completed (emotion detected)                                                                            |
| Trigger          | Emotion result available                                                                                      |
| Main Flow        | 1) System maps mood to suggestion prompt<br>2) OpenAI generates tips/quotes<br>3) System displays suggestions |
| Alternate Flow   | A1: No AI → fallback static tips based on mood category                                                       |
| Postconditions   | Suggestions are displayed and optionally saved                                                                |

## UC-06 — View Mood History & Trends

| Field          | Details                                                                                                            |
| -------------- | ------------------------------------------------------------------------------------------------------------------ |
| Use Case ID    | UC-06                                                                                                              |
| Use Case Name  | View Mood Trends                                                                                                   |
| Primary Actor  | User                                                                                                               |
| Goal           | View mood patterns over time                                                                                       |
| Preconditions  | User logged in; mood entries exist                                                                                 |
| Trigger        | User opens “History/Trends”                                                                                        |
| Main Flow      | 1) System loads mood logs<br>2) System generates charts<br>3) User filters by week/month<br>4) System updates view |
| Alternate Flow | A1: No data → show “Start your first entry” message                                                                |
| Postconditions | Mood history is displayed                                                                                          |

## UC-07 — Contact Counsellor

| Field          | Details                                                                                                                                |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| Use Case ID    | UC-07                                                                                                                                  |
| Use Case Name  | Contact Counsellor                                                                                                                     |
| Primary Actor  | User                                                                                                                                   |
| Goal           | Request support from a counsellor                                                                                                      |
| Preconditions  | User logged in; counsellor module available                                                                                            |
| Trigger        | User taps “Contact Counsellor”                                                                                                         |
| Main Flow      | 1) User selects counsellor/request<br>2) System sends request<br>3) Counsellor receives notification<br>4) Conversation thread created |
| Alternate Flow | A1: No counsellor available → system shows “Try again later”                                                                           |
| Postconditions | Support request and conversation are created                                                                                           |

## UC-08 — Counsellor Views User Mood Summary

| Field          | Details                                                                                               |
| -------------- | ----------------------------------------------------------------------------------------------------- |
| Use Case ID    | UC-08                                                                                                 |
| Use Case Name  | View User Mood Summary                                                                                |
| Primary Actor  | Counsellor                                                                                            |
| Goal           | Review user’s mood trends before advising                                                             |
| Preconditions  | Counsellor logged in; user consent/assignment exists                                                  |
| Trigger        | Counsellor selects a user profile                                                                     |
| Main Flow      | 1) System loads user mood trends<br>2) Shows charts + recent entries<br>3) Counsellor reviews summary |
| Alternate Flow | A1: No permission → access denied                                                                     |
| Postconditions | Counsellor sees the user’s emotional overview                                                         |

## UC-09 — Counsellor Provides Advice

| Field          | Details                                                                                                     |
| -------------- | ----------------------------------------------------------------------------------------------------------- |
| Use Case ID    | UC-09                                                                                                       |
| Use Case Name  | Provide Advice to User                                                                                      |
| Primary Actor  | Counsellor                                                                                                  |
| Goal           | Send professional support/advice to user                                                                    |
| Preconditions  | UC-07 thread exists; counsellor logged in                                                                   |
| Trigger        | Counsellor replies in chat/advice panel                                                                     |
| Main Flow      | 1) Counsellor types advice<br>2) System sends message<br>3) User receives notification<br>4) Message stored |
| Alternate Flow | A1: Message not delivered → system retries / shows error                                                    |
| Postconditions | Advice is delivered and recorded                                                                            |

## UC-10 — Privacy & Data Protection

| Field            | Details                                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Use Case ID      | UC-10                                                                                                                  |
| Use Case Name    | Protect User Emotional Data                                                                                            |
| Primary Actor    | System                                                                                                                 |
| Supporting Actor | User / Counsellor                                                                                                      |
| Goal             | Ensure emotional data is confidential and access-controlled                                                            |
| Preconditions    | System operational                                                                                                     |
| Trigger          | Any mood data request/store action                                                                                     |
| Main Flow        | 1) System enforces authentication<br>2) Applies role-based access<br>3) Encrypts transmission<br>4) Logs access events |
| Alternate Flow   | A1: Unauthorized access → block + log attempt                                                                          |
| Postconditions   | Data remains secure; only permitted access allowed                                                                     |
