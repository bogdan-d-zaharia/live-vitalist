import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    AppSpotlight.indexJournal()
  }

  override func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if AppSpotlight.isJournalActivity(userActivity) { return }
    super.scene(scene, continue: userActivity)
  }
}
