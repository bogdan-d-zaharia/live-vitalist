# Live Vitalist (Flutter)

A nutrition-focused journaling app built with Flutter. Track your meals, habits, and nutrient intake in a clean, data-focused interface.

---

## Technologies used:
* Flutter - The framework used for the mobile application
* Dart - The programming language used with Flutter, with a C-like syntax
* Riverpod - A Flutter tool used for reactive state management
* Shared Preferences - A package for saving simple app data locally (primitives)
* Firebase Realtime Database - In Cloud, NoSQL Database
* Firebase Cloud Messaging (FCM) - Platform used for Android Push Notifications
* TypeScript - The programming language used for the server
* NodeJS - The server's Runtime Environment, with the `npm` package manager
* Express - The framework used for creating the API
* Vitest - Tool for testing TypeScript code
* Ngrok - Used for forwarding a private localhost port to a public subdomain
* Nginx - Used for forwarding a private localhost port to a public port
* PM2 - Used for automatic application restart and start at server startup.

---

## 🔧 Getting Started

To run this project locally:

### 1. **Clone the repo**

```bash
git clone https://github.com/bogdan-d-zaharia/live-vitalist.git
cd live-vitalist
```

### 2. **Install dependencies**

```bash
flutter pub get
```

### 3. **Firebase setup**

This app uses Firebase. To use it:

**3.1. Set up the Firebase console**

* Go to https://console.firebase.google.com/
* Create a new Firebase project
* After creating it, select `Databases & Storage` > `Realtime Database` > `Create Database`
* With it selected from `Project shortcuts`, go to `Rules` and replace its contents with the text below, then `Publish`
```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "server": {
      "active_users": {
      	".indexOn": "last_active"
      }
    }
  }
}
```

**3.2. Setting up Firebase for Android**
* Go to `Settings` > `General` and at the bottom select `Android`, follow the instructions, making changes inside the `android/` folder
* Download the Firebase CLI from https://firebase.google.com/docs/cli/
* Run the following commands at the root of the project
```
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```
* Select your project and Android as the platform.

### 4. **Setting up the Server**
* Create a file named `env.dart` inside `lib/`
* Add the following code, replacing the placeholder with your server's IP, domain, or you can use `localhost:3000`
```dart
const String apiUrl = 'http:// << Your Server IP / Domain >> /api';
```
> ⚠️ Sending `Push Notifications` doesn't work on localhost! To make it work, you can install `ngrok` from Microsoft Store, create an account, and run `ngrok http 3000`. You can then use their provided public URL, which forwards traffic to your local port.
* Go to `server/`, create the file `.env`, and paste the code below
```env
PORT=3000
LOCAL_URL="http://localhost:${PORT}"
GOOGLE_APPLICATION_CREDENTIALS=./.config/<< Your Firebase Admin SDK .json >>
DATABASE_URL=<< Your Firebase Realtime Database URL >>
```
* Go to your Firebase project, `Settings` > `Service accounts`
* Copy the database URL from code snippet and replace the DATABASE_URL placeholder
* Click the `Generate new private key` button. It will download your Firebase Admin SDK json
* Move the file to `server/.config/` inside your project

**If you're using your computer**

Make sure you have NodeJS 24 installed. Then, you can run the server with
```bash
cd server
npm install
npm run dev
```
And optionally forward your port with Ngrok.

**If you're using an actual server**

In this case, you will have to forward your port to an internet port, using Nginx. For Ubuntu, this is:
```bash
sudo apt update
sudo apt install -y nginx
sudo nano /etc/nginx/sites-available/vitalist-api
```
* Add the following Nginx configuration, replacing the IP/Domain placeholder
```nginx
server {
    listen 80;
    server_name << Your IP/Domain >>;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```
* Then run
```
sudo ln -s /etc/nginx/sites-available/vitalist-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'
```
* If you are connected to your server using SSH, run
```bash
sudo ufw allow ssh
```
* Finish with running
```bash
sudo ufw enable
```

If you don't have NodeJS installed, run
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.bashrc
nvm install 24
nvm alias default 24
```

If you are using a server, you probably want the application to start with the server and restart on crash automatically. You can use PM2 for this:
```bash
npm install -g pm2 tsx
```
* Make sure all dependencies were installed. If you get an message like `scripts not yet covered by allowScripts`, you will have to review and potentially approve the scripts using `npx npm approve-scripts << The list of packages >>`. Then continue with
```bash
pm2 install -g tsx
pm2 start --interpreter tsx src/index.ts --name "vitalist-api"
pm2 save
pm2 startup
```
* Run the command generated by `pm2 startup` (`sudo env PATH=`)

**Now the setup is fully done!**

### 5. **Run the app**

Make sure a device or emulator is connected. Then run

```bash
flutter run
```

---

## 🧪 Unit Tests

Currently there is only a limited test inside `server/test/` (for unit named `DateUtils`), but no application test. You can add such tests in the `test/` directory.

To run the `DateUtils` test (and other unit tests for the server that you might make), run
```bash
cd server
npm install -D vitest
npm test
```

---

## 📁 Project Structure Highlights

* `lib/` - App source code
* `assets/` - UI background and placeholder images
* `store_images/` - Play Store graphics
* `android/` - Android native configuration
* `server/` - The server module and its source code

---

## 📐 Project Architecture

### 1. **Clean Architecture**

The source code inside the `lib/` folder follows the Clean Architecture design approach.
More specifically, inside `lib/` there are 2 main folders:
* `core/` - Containing common functionalities used through the application, independent of it
* `features/` - Containing functionalities specific to the application developed

Each _feature_ is contained in its own folder inside one of the 2 named above.
One is composed of multiple classes, each with its own **single responsibility (SRP)**,
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

### 2. **SOLID Principles**

**Single Responsibility Principle (SRP)**

As mentioned before, each class/script has a **single responsibility**. For example, for the class `AnnouncementsApi`, its only responsibility is to provide a set of behaviours specific to an announcements api, specifically, packaging data from other APIs as announcements.

It shouldn't (and doesn't) connect to the internet to retrieve the raw data and deserialize it and process it. It also doesn't handle the presentation of each announcement on the screen.

**Open/Closed Principle (OCP)**

Components are open to extension, and closed to modification.

For example, the class `Day` has little functionality by itself. As such, we use extensions, like `extension DayAnalysis on Day` to enhance it.

Another example is the class `WeekReport`, a simple data class. It is inherited by `WeekReportModel` to add serializing and deserializing abilities. Then it is composed inside `WeekReportAnnouncement` and `WeekReportOverlay`, adding specific announcement behaviour and presentation logic respectively.

Notice we didn't modify *it* for serialization or presentation or for adding announcement behaviour.

**Liskov Substitution Principle (LSP)**

Each subclass can be substituted for its superclass, without altering behaviour.

This can be seen with our `WeekReport` and `WeekReportModel` example. The method `loadLatestWeekReport()` of `ReportApi` has a `WeekReport` type, but it actually returns a `WeekReportModel`. It is then used in the place of an actual `WeekReport` for presentation safely.

Especially if we would have used polymorphism, we would have had to make sure each method has the same effect as before, in addition to its new functionality.

I used to have the interfaces `ILocalDeletion` and `ICloudDeletion` united inside `IStorageHandler` (with a `.delete()` method). Concrete implementations of `IStorageHandler` like `FileHandler` or `FirebaseHandler` could not be properly substituted, because `FileHandler` would delete only local files, and `FirebaseHandler` would only delete data in Firebase. It was only a specific behavior.

**Interface Segregation Principle (ISP)**

There are multiple small interfaces instead of big ones, and classes only implement what they need.

As mentioned, an anti-example of this was `IStorageHandler` that forced classes to implement an unrelated deletion method, which I had to break down into separate interfaces for deletion, having
* `IStorageHandler` - Solely for saving and loading data
* `ILocalDeletion` - For deleting data locally
* `ICloudDeletion` - For deleting data on the cloud

**Dependency Inversion Principle (DIP)**

High-level and low-level modules depend on abstractions, and not one by the other. And abstractions do not depend on details.

For example, for data storage there is a storage system in place, with the main solution `Storage` implementing the interface `IStorageHandler`.

`Storage` is also a Riverpod Provider, used for injecting dependencies. In our code, we read this dependency as an abstraction, an `IStorageHandler`. As such, our concrete classes (presentation and logic) depend on an abstraction. If we change the dependency, everything else remains in place. We don't need to change the object in each class and the way we use it.

Also, our abstractions (like interfaces) don't depend on details of concrete implementations, and mostly on primitives. When they do, they don't depend on their details. For example, `loadLatestWeekReport()` inside the interface `IReportApi` will return a `WeekReport`, but it doesn't concretely use a `WeekReport` in any way.
