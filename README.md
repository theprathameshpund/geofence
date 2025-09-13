# 📍 Geofence App

A Flutter-based **Geofence Tracking Application** that allows users to set up a geofence around their current GPS location, track movements in the background, and receive **real-time notifications** when entering or exiting the defined area.  

---

## 🚀 Features

### 1. Location Setup
- Fetch current GPS location on launch (via a button).
- Allow user to define a **radius (in meters)** for the geofence.
- (Optional) Display the geofence on a **map view with a circle overlay**.

### 2. Geofence Tracking
- Continuously track user location in the background.
- Detect whether the user is **inside or outside** the defined geofence.
- Trigger **local notifications** when:
  - ✅ Entering the geofence  
  - ❌ Exiting the geofence  

### 3. Notifications
- Event type (**Entered / Exited**)  
- Timestamp of the event  
- Current coordinates  

### 4. Permissions
- Handles **foreground and background location permissions** (Android-specific).  
- Works even when the app is **minimized or closed**.  

---

## 📲 Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/theprathameshpund/geofence.git
   cd geofence
   ```
2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```
## ⚙️ Requirements

1. Flutter SDK (latest stable version)
2. Android SDK
3. Permissions:
     * ACCESS_FINE_LOCATION
     * ACCESS_COARSE_LOCATION
     * ACCESS_BACKGROUND_LOCATION (for Android 10+)
