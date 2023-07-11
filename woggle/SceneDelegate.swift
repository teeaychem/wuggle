//
//  SceneDelegate.swift
//  woggle
//
//  Created by sparkes on 2023/06/23.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  // Store a general reference to the settings.
  var settingsToUse: Settings?
  var stackViewController: CardStackViewController?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let w = (scene as? UIWindowScene) else { return }
    
    let window = UIWindow(windowScene: w)
    
    // See if there's already some settings to pull from!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let settingsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
    do {
      let result = try context.fetch(settingsFetchRequest)
      
      if result.count > 0 {
        settingsToUse = (result.first as! Settings)
        // TODO: Delete other instances.
      } else {
        // If nothing found, default settings.
        settingsToUse = getDefaultSettings(context: context)
      }
    } catch {
      // If load fails, things should be fine with default settings.
      settingsToUse = getDefaultSettings(context: context)
    }
    settingsToUse!.ensureDefaults()
    stackViewController = CardStackViewController(settings: settingsToUse!)

    window.rootViewController = stackViewController!
    self.window = window
    window.makeKeyAndVisible()
  }
  
  
  func getDefaultSettings(context c: NSManagedObjectContext) -> Settings {
    let dSettings = Settings(context: c)
    dSettings.stats = StatsCollection(context: c)
    
    
    return dSettings
  }
  

  func sceneDidDisconnect(_ scene: UIScene) {
    print("Ouch")
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    
//    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
    stackViewController!.gameCardC?.pauseGameMain(animated: false)
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    
//    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }


}

