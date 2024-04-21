# GLive Idol for member

## How to run

**Step 1:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get
    + glive_idol
    + modules/common/common_module
    + modules/core/core_module
    + modules/futures/glive_idol/user_management
    + modules/futures/glive_idol/level
    + modules/futures/glive_idol/live_stream
    + modules/futures/glive_idol/payment
    + modules/libs/rtmp_publisher

Local environment:
    + Copy .env.example ==> .env
```

**Step 2:**

Start simulator or connect real device

**Step 3:**

Run app by your IDE or command:

```
flutter run
```

## Build APK

Debug build type
```
flutter build apk --target=lib/main.dart --debug
```

Staging build type
```
flutter build apk --target=lib/main.staging.dart --release
```

Release build type
```
flutter build apk --target=lib/main.prod.dart --release
```

## Build IPA

Debug build type
```
flutter build ipa --target=lib/main.dart --debug
```

Staging build type
```
flutter build ipa --target=lib/main.staging.dart --release
```

Release build type
```
flutter build ipa --target=lib/main.prod.dart --release
```

