# Live Vitalist (Flutter)

A nutrition-focused journaling app built with Flutter. Track your meals, habits, and nutrient intake in a clean, data-focused interface.

## 🔧 Getting Started

To run this project locally:

### 1. **Clone the repo**

```bash
git clone https://github.com/your-username/live-vitalist.git
cd live-vitalist
```

### 2. **Install dependencies**

```bash
flutter pub get
```

### 3. **Firebase setup**

This app uses Firebase. To run it:

* Download your `google-services.json` from Firebase Console
* Place it in:

  ```
  android/app/google-services.json
  ```

> ⚠️ Note: This file is required but not included in the repo.

### 4. **Run the app**

```bash
flutter run
```

Make sure a device or emulator is connected.

---

## 🧪 Testing

Currently no test suite is set up. You can add tests in the `test/` directory.

---

## 📁 Project Structure Highlights

* `lib/` - App source code
* `assets/` - UI background and placeholder images
* `store_images/` - Play Store graphics
* `android/` - Android native configuration

## 📐 Project Architecture

The source code inside the `lib/` folder follows the Clean Architecture design approach.
More specifically, inside `lib/` there are 2 main folders:
* `core/` - Containing common functionalities used through the application, independent of it
* `features/` - Containing functionalities specific to the application developed

Each _feature_ is contained in its own folder inside one of the 2 named above.
One is composed of multiple classes, each with its own **single responsability (SRP)**,
separated into multiple subfolders (layers), based on the **separation of concerns (SoC)** principle:
* `domain/` - Pure code that is not reliant on external/framework-specific packages
  * Here it contains interfaces, models, constants and pure logic
* `data/` - Infrastructure that is reliant on external packages
  * Here it contains handlers, extensions, providers; actual implementations
* `presentation/` - Code that is specific to the user interface, either UI components or UI-specific logic. Here it is further separated into:
  * `widgets/` - UI components (Flutter widgets)
  * `controllers/` - Providers containing logic specific to the feature's presentation logic
  * `ui_helpers/` - Other logic specific to the presentation (like extensions, functions or helper classes)

The final result of each feature, the public module interface, is stored in the feature's folder.
