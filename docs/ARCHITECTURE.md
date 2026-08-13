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
