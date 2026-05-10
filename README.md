# Dusto: Complete Car Service Platform

Dusto is a versatile, all-in-one automotive service application built with Flutter. It connects vehicle owners with certified service centers, providing a seamless digital experience for maintenance, repairs, and roadside assistance.

---

### 🚀 Key Features

* Service Booking: Schedule periodic maintenance, oil changes, or mechanical repairs at verified workshops.
* Real-Time Tracking: Monitor your vehicle's service status from "Check-in" to "Ready for Delivery."
* Roadside Assistance: One-tap SOS for towing, battery jumpstarts, or flat tire support based on live GPS location.
* Digital Service Records: Store and access your car's entire service history and digital invoices in one place.
* Transparency & Quotes: Receive detailed cost estimates and approve additional repairs directly through the app.
* Spare Parts Marketplace: Browse and order genuine automotive parts and accessories with doorstep delivery.


this is read me file !

issue list:
https://docs.google.com/document/d/1Py51u0vlNzTWXsUJGpe1Ghbw4kRyVmN1z3Ii5VpW7xc/edit

https://docs.google.com/document/d/1ESNtMD2Qwimtwv0pPbcpLEq72J8uN1uN0iVUdL9fQ7M/edit

FLUTTER SDK: 3.38.1

User APP: v3.5
Provider APP: v3.5
ServiceMan APP: v3.5

flutterwave test card:
Visa Card 3DS authentication 2	4242424242424242	812	3310	01/31	12345


This might be overkill, but this is the best way I know to perform the cleanest pod install and ensure that you have no lingering pod cache issues or misconfigured Xcode settings:

cd ios
rm -rf Podfile.lock
rm -rf Pods
rm -rf pubspec.lock
pod repo update
pod cache clean --all
pod deintegrate
pod setup
pod install --repo-update




flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi

flutter run -d chrome --web-hostname localhost --web-port 5000
