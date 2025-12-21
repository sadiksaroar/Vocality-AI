# vocality_ai

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Vocality AI - Subscription API Documentation
Overview
Complete subscription system with personality purchases, time packages, and monthly plans. All prices auto-convert based on user's country.

Base URLs
Admin APIs: http://10.10.7.24:8000/core/
User Subscription APIs: http://10.10.7.24:8000/subscription/
Chat APIs: http://10.10.7.24:8000/core/conversations/
Authentication
All endpoints require authentication. Include user token in header:

Authorization: Token YOUR_AUTH_TOKEN
1. ADMIN APIs (Core App)
1.1 Personality Management
List/Create Personalities

GET/POST /core/personalities/
Update/Delete Personality

PUT/PATCH/DELETE /core/personalities/{id}/
Create Example:

POST /core/personalities/
{
  "personality_name": "Friendly Assistant",
  "personality_price": "24.99",
  "personality_promt": "You are a warm, friendly AI assistant..."
}
1.2 Time Management
List/Create Time Packages

GET/POST /core/time-management/
Create Example:

POST /core/time-management/
{
  "time": "12 min",
  "price": "4.00"
}
1.3 Plan Management
List/Create Subscription Plans

GET/POST /core/plan-management/
Create Example:

POST /core/plan-management/
{
  "plan_name": "Premium",
  "plan_price": "29.99",
  "plan_time": "month"
}
2. USER SUBSCRIPTION APIs
2.1 Get Subscription Status
Check user's current subscription, owned personalities, and remaining minutes.

GET /subscription/subscription/status/
Response:

{
  "id": 1,
  "remaining_minutes": "15.00",
  "daily_minutes_used": "5.00",
  "last_message_date": "2025-12-16",
  "owned_personalities": [
    {
      "id": 1,
      "personality_name": "Free Assistant",
      "personality_price": "0.00"
    }
  ],
  "accessible_personalities": [
    {
      "id": 1,
      "personality_name": "Free Assistant"
    },
    {
      "id": 2,
      "personality_name": "Professional" 
    }
  ],
  "active_plan_details": {
    "id": 1,
    "plan_name": "Premium",
    "plan_price": "29.99",
    "plan_time": "month"
  },
  "plan_expires_at": "2026-01-16T00:00:00Z",
  "has_active_plan": true,
  "daily_limit": 60,
  "discount_rate": 0.20,
  "country_code": "US",
  "free_minutes_day1_given": true,
  "free_minutes_day2_given": true
}
2.2 Get Available Personalities
List all personalities with prices converted to user's currency.

GET /subscription/subscription/available_personalities/
Response:

[
  {
    "id": 1,
    "name": "Free Assistant",
    "original_price": "0.00",
    "converted_price": "0.00",
    "currency": "USD",
    "is_owned": true,
    "is_free": true
  },
  {
    "id": 2,
    "name": "Professional",
    "original_price": "24.99",
    "converted_price": "2076.47",
    "currency": "INR",
    "is_owned": false,
    "is_free": false
  }
]
2.3 Get Available Time Packages
List time packages with auto-applied subscription discounts.

GET /subscription/subscription/available_time_packages/
Response:

[
  {
    "id": 1,
    "name": "12 min Talk Time",
    "time_value": "12 min",
    "original_price": "3.20",
    "converted_price": "3.20",
    "currency": "USD",
    "discount_applied": true,
    "discount_percentage": 20
  }
]
2.4 Get Available Plans
List subscription plans with converted prices.

GET /subscription/subscription/available_plans/
Response:

[
  {
    "id": 1,
    "name": "Basic",
    "time_value": "month",
    "original_price": "14.99",
    "converted_price": "14.99",
    "currency": "USD",
    "is_active": false
  },
  {
    "id": 2,
    "name": "Premium",
    "time_value": "month",
    "original_price": "29.99",
    "converted_price": "29.99",
    "currency": "USD",
    "is_active": true
  }
]
2.5 Purchase Personality
Confirm personality purchase after Apple/Google Pay completes.

POST /subscription/subscription/purchase_personality/
Request:

{
  "personality_id": 2,
  "payment_id": "apple_pay_transaction_12345",
  "amount_paid": "24.99",
  "currency": "USD"
}
Response:

{
  "success": true,
  "message": "Successfully purchased Professional",
  "personality_id": 2
}
Errors: - 400: Personality already owned - 400: Payment ID already processed (duplicate) - 404: Personality not found

2.6 Purchase Time Package
Confirm time package purchase after payment.

POST /subscription/subscription/purchase_time/
Request:

{
  "time_management_id": 1,
  "payment_id": "google_pay_transaction_67890",
  "amount_paid": "4.00",
  "currency": "USD"
}
Response:

{
  "success": true,
  "message": "Successfully added 12.0 minutes",
  "remaining_minutes": 27.0
}
2.7 Purchase Subscription Plan
Confirm plan purchase after payment.

POST /subscription/subscription/purchase_plan/
Request:

{
  "plan_id": 2,
  "payment_id": "apple_subscription_11111",
  "amount_paid": "29.99",
  "currency": "USD"
}
Response:

{
  "success": true,
  "message": "Successfully activated Premium",
  "expires_at": "2026-01-16T10:30:00Z"
}
2.8 Get Purchase History
View all past purchases.

GET /subscription/subscription/purchase_history/
Response:

[
  {
    "id": 5,
    "purchase_type": "plan",
    "personality_name": null,
    "plan_name": "Premium",
    "minutes_purchased": null,
    "amount_paid": "29.99",
    "currency": "USD",
    "payment_id": "apple_subscription_11111",
    "payment_status": "completed",
    "created_at": "2025-12-16T10:30:00Z"
  }
]
2.9 Update Country
Update user's country for currency conversion.

POST /subscription/subscription/update_country/
Request:

{
  "country_code": "IN"
}
Response:

{
  "success": true,
  "country_code": "IN"
}
3. CHAT APIs
3.1 Send Message to AI
Send message with personality. Automatically checks permissions and deducts minutes.

POST /core/conversations/send_message/
Request:

{
  "personality_id": 1,
  "message": "Hello, how are you?",
  "conversation_id": null
}
Success Response:

{
  "success": true,
  "conversation_id": 5,
  "personality_name": "Friendly Assistant",
  "ai_message": "Hello! I'm doing great, thank you for asking...",
  "voice_url": "https://ai-service.com/audio/voice_123.mp3",
  "remaining_minutes": 14.0,
  "daily_minutes_used": 6.0
}
Error Responses:

403 - No Access to Personality:

{
  "error": "You do not have access to this personality. Please purchase it or subscribe to a plan.",
  "personality_id": 3
}
402 - Insufficient Minutes:

{
  "error": "Insufficient talk time. Please purchase more minutes or subscribe to a plan.",
  "remaining_minutes": 0.0
}
4. SUBSCRIPTION LOGIC SUMMARY
Free Users
Get 5 minutes on Day 1 (signup)
Get 5 minutes on Day 2 (if they return)
Can only use Personality 1 (free)
Must purchase time packages or subscribe
Personality Ownership
Personality 1: Free for all users
Personalities 2-4: One-time purchase ($24.99, $34.99, $59.99)
Once purchased, owned forever
Still need talk time (minutes) to use
Subscription Plans
Basic ($14.99/month): - 20 minutes/day - Access to Personality B (rented, lost after expiry) - 10% discount on extra time packages

Premium ($29.99/month): - 60 minutes/day - Access to all personalities (rented) - 20% discount on extra time packages

Ultimate ($49.99/month): - Unlimited talk time - Access to all personalities (rented) - 20% discount on extra time packages - Priority processing

Daily Reset
Daily minutes reset at midnight (local time)
Uses plan's daily quota first
Then uses purchased minutes
Currency Conversion
Supported currencies: USD, EUR, GBP, INR, AUD, CAD, JPY, CNY, MXN, BRL - Prices auto-convert based on user's country_code - Update country via /subscription/update_country/

5. FLUTTER INTEGRATION FLOW
Step 1: User Browses Personalities
GET /subscription/subscription/available_personalities/
// Show list with converted prices in user's currency
Step 2: User Initiates Purchase
// User taps "Buy Personality B - ₹2076"
// Flutter shows Apple Pay / Google Pay
Step 3: Payment Completes
// Apple/Google returns payment confirmation
String paymentId = "apple_pay_xyz123";
Step 4: Confirm Purchase to Backend
POST /subscription/subscription/purchase_personality/
{
  "personality_id": 2,
  "payment_id": paymentId,
  "amount_paid": "2076.47",
  "currency": "INR"
}
Step 5: Backend Activates Purchase
Adds personality to user's owned_personalities
Records purchase in history
Returns success confirmation
Same Flow for Time Packages & Plans
Use /purchase_time/ for time packages
Use /purchase_plan/ for subscriptions
6. IMPORTANT NOTES
Payment IDs Must Be Unique
Use Apple/Google transaction IDs
Backend prevents duplicate processing
If same payment_id sent twice, returns error
Subscription Expiration
Plans expire after 30 days (month) or 365 days (year)
Check has_active_plan in status endpoint
Rented personalities removed after expiry
Owned personalities stay forever
Minutes Calculation
Currently: 1 minute deducted per message exchange
In production: Calculate based on audio duration from AI service
Update minutes_used in send_message endpoint
Country Detection
Flutter should detect user's country on first launch
Call /update_country/ with ISO 3166-1 alpha-2 code
All prices will auto-convert
7. TESTING ENDPOINTS
Create Test Personality (Admin)
curl -X POST http://10.10.7.24:8000/core/personalities/ \
  -H "Authorization: Token ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "personality_name": "Test Bot",
    "personality_price": "9.99",
    "personality_promt": "You are a test assistant"
  }'
Test Purchase (User)
curl -X POST http://10.10.7.24:8000/subscription/subscription/purchase_personality/ \
  -H "Authorization: Token USER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "personality_id": 2,
    "payment_id": "test_payment_12345",
    "amount_paid": "24.99",
    "currency": "USD"
  }'
Support
For issues or questions, contact backend team or check Django admin panel at: http://10.10.7.24:8000/admin/