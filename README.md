# TREELOVE
TreeLove – Smart Tree Plantation & Monitoring System.

## Configuration

\- flutter version : 3.27.1

\- dart version : 3.6.0

## Feature-Based Project Structure

```
lib/
│
├── core/                     # Global utilities & config
│   ├── config/               # Routes, themes, constants
│   ├── services/             # Notifications, storage, etc.
│   ├── network/              # API base client, interceptors
│   ├── utils/                # Helpers
│   ├── widgets/              # Reusable UI widgets
│
├── common/                   # Shared between features or roles
│   ├── models/               # Common models (User, Error, etc.)
│   ├── repositories/         # Common data logic
│   ├── bloc/                 # Global/shared blocs or cubits
│   ├── screens/              # Shared screens (splash, onboarding, etc.)
│
├── features/                 
│   ├── authentication/       # Login, registration, etc.
│   │   ├── bloc/
│   │   ├── screens/
│   │   ├── repository/
│   │   ├── model/
│
│   ├── vendor/               # Vendor-specific features
│   │   ├── dashboard/
│   │       ├── bloc/
│   │       ├── screens/
│   │       ├── repository/
│   │       ├── model/
│  
│   ├── fieldworker/          # Fieldworker-specific features
│   │   ├── Plantation/
│   │       ├── bloc/
│   │       ├── screens/
│   │       ├── repository/
│   │       ├── model/
│
│   │
│   ├── customer/             # Both B2B & Retail under customer
│   │   ├── b2b/
│   │   │   ├── orders/
│   │   │   ├── analytics/
│   │   ├── retail/
│   │   │   ├── tree_browser/
│   │   │   ├── purchase/
│
│   ├── home/                 # Common Home screen logic
│   ├── profile/              # Profile for all users
│
├── main.dart

```