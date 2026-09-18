import Flutter
import UIKit
import UserNotifications
import CoreSpotlight
import UniformTypeIdentifiers

enum AppSpotlight {
  static let journalIdentifier = "live.vitalist.app.journal"

  static func isJournalActivity(_ activity: NSUserActivity) -> Bool {
    activity.activityType == CSSearchableItemActionType
      && activity.userInfo?[CSSearchableItemActivityIdentifier] as? String == journalIdentifier
  }

  static func indexJournal() {
    guard CSSearchableIndex.isIndexingAvailable() else { return }

    let languageCode = Locale(identifier: Locale.preferredLanguages.first ?? "en").languageCode ?? "en"
    let title: String
    let description: String
    let keywords: [String]
    switch languageCode {
    case "ro":
      title = "Live Vitalist — Calorii și nutriție"
      description = "Jurnal alimentar pentru calorii, alimente, mese și nutrienți."
      keywords = [
        "calorie", "calorii", "kcal", "nutritie", "nutriție", "alimente",
        "alimentatie", "alimentație", "mese", "jurnal alimentar", "nutrienti",
        "nutrienți", "proteine", "carbohidrati", "carbohidrați", "grasimi", "grăsimi",
      ]
    case "fr":
      title = "Live Vitalist — Calories et nutrition"
      description = "Journal alimentaire pour suivre les calories, les repas et les nutriments."
      keywords = [
        "calorie", "calories", "kcal", "nutrition", "aliments", "alimentation",
        "repas", "journal alimentaire", "nutriments", "protéines", "proteines",
        "glucides", "lipides",
      ]
    case "ko":
      title = "Live Vitalist — 칼로리와 영양"
      description = "칼로리, 음식, 식사, 영양소를 기록하는 식단 일지."
      keywords = [
        "칼로리", "열량", "kcal", "영양", "음식", "식품", "식사", "식단",
        "식단 일지", "영양소", "단백질", "탄수화물", "지방",
      ]
    case "tr":
      title = "Live Vitalist — Kalori ve beslenme"
      description = "Kalori, yiyecek, öğün ve besin öğelerini takip etmek için yemek günlüğü."
      keywords = [
        "kalori", "kcal", "beslenme", "yiyecek", "gıda", "gida", "öğün", "ogun",
        "yemek", "yemek günlüğü", "besin", "protein", "karbonhidrat", "yağ", "yag",
      ]
    default:
      title = "Live Vitalist — Calories and nutrition"
      description = "Food diary to track calories, foods, meals and nutrients."
      keywords = [
        "calorie", "calories", "kcal", "nutrition", "food", "foods", "meal", "meals",
        "food diary", "calorie tracker", "nutrients", "protein", "carbs",
        "carbohydrates", "fat", "fats",
      ]
    }

    let attributes = CSSearchableItemAttributeSet(contentType: .text)
    attributes.title = title
    attributes.displayName = attributes.title
    attributes.contentDescription = description
    attributes.keywords = keywords

    let item = CSSearchableItem(
      uniqueIdentifier: journalIdentifier,
      domainIdentifier: "live.vitalist.app",
      attributeSet: attributes
    )
    item.expirationDate = .distantFuture

    CSSearchableIndex.default().indexSearchableItems([item]) { error in
      if let error = error {
        NSLog("Unable to index Live Vitalist in Spotlight: %@", error.localizedDescription)
      }
    }
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    // This entry opens the app's normal journal flow, including onboarding if needed.
    if AppSpotlight.isJournalActivity(userActivity) { return true }
    return super.application(
      application,
      continue: userActivity,
      restorationHandler: restorationHandler
    )
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
