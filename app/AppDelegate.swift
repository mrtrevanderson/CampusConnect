import RealmSwift
import Fabric
import Crashlytics
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

	var window: UIWindow?
	var tabBarController: UITabBarController!

	var chatsView: ChatsView!
	var peopleView: PeopleView!
	var settingsView: SettingsView!


	//---------------------------------------------------
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Handle Migration if needed
        //increment schema version and old schema version if you wish to update schema
        //update schema by deleting obj in respective file for each table
        var config = Realm.Configuration(
            schemaVersion: 6,
            migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 5) {
                }
        })
        Realm.Configuration.defaultConfiguration = config
        config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        let realm = try! Realm()
        
        
		// Firebase initialization
		FirebaseApp.configure()
		Database.database().isPersistenceEnabled = false
		FirebaseConfiguration().setLoggerLevel(.error)


		if (UserDefaultsX.bool(key: "Initialized") == false) {
			UserDefaultsX.setObject(value: true, key: "Initialized")
			FUser.logOut()
		}


        
        //Object initialization for realm
		Shortcut.create()

		_ = Connection.shared
		_ = RelayManager.shared

        _ = Friends.shared
        _ = Messages.shared
		_ = Statuses.shared
		_ = Users.shared
		_ = UserStatuses.shared


        // Crashlytics initialization
        Fabric.with([Crashlytics.self])

		// UI initialization
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

	//-----------------------------------------------------------------
	func applicationWillResignActive(_ application: UIApplication) {

	}

	//-----------------------------------------------------------------
	func applicationDidEnterBackground(_ application: UIApplication) {

	}

	//-----------------------------------------------------------------
	func applicationWillEnterForeground(_ application: UIApplication) {

	}

	//----------------------------------------------------------------
	func applicationDidBecomeActive(_ application: UIApplication) {


		NotificationCenterX.post(notification: NOTIFICATION_APP_STARTED)
	}

	//----------------------------------------------------------------
	func applicationWillTerminate(_ application: UIApplication) {

	}
    //-----------------------------------------------------
	func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

		return false
	}
    //-----------------------------------------------------
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

	}

	//-----------------------------------------------------
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

	}
    //-----------------------------------------------------
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

	}
    //-----------------------------------------------------
	func topViewController() -> UIViewController? {

		var viewController = UIApplication.shared.keyWindow?.rootViewController
		while (viewController?.presentedViewController != nil) {
			viewController = viewController?.presentedViewController
		}
		return viewController
	}
}
