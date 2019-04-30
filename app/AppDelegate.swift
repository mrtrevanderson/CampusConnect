import RealmSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

	var window: UIWindow?
	var tabBarController: UITabBarController!

	var chatsView: ChatsView!
	var peopleView: PeopleView!
	var settingsView: SettingsView!


	//---------------------------------------------------------------------------------------------------------------------------------------------
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Inside your application(application:didFinishLaunchingWithOptions:)
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
		// Firebase initialization
		//-----------------------------------------------------------------------------------------------------------------------------------------
		FirebaseApp.configure()
		Database.database().isPersistenceEnabled = false
		FirebaseConfiguration().setLoggerLevel(.error)

		//-----------------------------------------------------------------------------------------------------------------------------------------
		// Crashlytics initialization
		//-----------------------------------------------------------------------------------------------------------------------------------------
		Fabric.with([Crashlytics.self])

		if (UserDefaultsX.bool(key: "Initialized") == false) {
			UserDefaultsX.setObject(value: true, key: "Initialized")
			FUser.logOut()
		}


		Shortcut.create()

		_ = Connection.shared
		_ = RelayManager.shared

        _ = Friends.shared
        _ = Messages.shared
		_ = Statuses.shared
		_ = Users.shared
		_ = UserStatuses.shared

		//-----------------------------------------------------------------------------------------------------------------------------------------
		// UI initialization
		//-----------------------------------------------------------------------------------------------------------------------------------------
		window = UIWindow(frame: UIScreen.main.bounds)

		chatsView = ChatsView(nibName: "ChatsView", bundle: nil)
		peopleView = PeopleView(nibName: "PeopleView", bundle: nil)
		settingsView = SettingsView(nibName: "SettingsView", bundle: nil)

		let navController1 = NavigationController(rootViewController: chatsView)
		let navController3 = NavigationController(rootViewController: peopleView)
		let navController5 = NavigationController(rootViewController: settingsView)

		tabBarController = UITabBarController()
		tabBarController.viewControllers = [navController1, navController3 , navController5]
		tabBarController.tabBar.isTranslucent = false
		tabBarController.selectedIndex = Int(DEFAULT_TAB)

		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()

		_ = chatsView.view
		_ = peopleView.view
		_ = settingsView.view


		return true
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func applicationWillResignActive(_ application: UIApplication) {

	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func applicationDidEnterBackground(_ application: UIApplication) {

	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func applicationWillEnterForeground(_ application: UIApplication) {

	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func applicationDidBecomeActive(_ application: UIApplication) {

		CacheManager.cleanupExpired()

		NotificationCenterX.post(notification: NOTIFICATION_APP_STARTED)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func applicationWillTerminate(_ application: UIApplication) {

	}

	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

		return false
	}

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

	}

	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func topViewController() -> UIViewController? {

		var viewController = UIApplication.shared.keyWindow?.rootViewController
		while (viewController?.presentedViewController != nil) {
			viewController = viewController?.presentedViewController
		}
		return viewController
	}
}
