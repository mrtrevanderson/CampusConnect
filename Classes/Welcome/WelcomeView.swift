class WelcomeView: UIViewController, LoginEmailDelegate, RegisterEmailDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
	}
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }





	//---------------------------------------------------------------------------------------------------------------------------------------------


	// MARK: - Email login methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionLoginEmail(_ sender: Any) {

		let loginEmailView = LoginEmailView()
		loginEmailView.delegate = self
		present(loginEmailView, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didLoginEmail() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_EMAIL)
		}
	}

	// MARK: - Email register methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRegisterEmail(_ sender: Any) {

		let registerEmailView = RegisterEmailView()
		registerEmailView.delegate = self
		present(registerEmailView, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didRegisterUser() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_EMAIL)
		}
	}
}
