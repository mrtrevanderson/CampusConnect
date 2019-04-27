
class AddAccountView: UIViewController, LoginEmailDelegate, RegisterEmailDelegate {

	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Add Account"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionLoginEmail(_ sender: Any) {

		let loginEmailView = LoginEmailView()
		loginEmailView.delegate = self
		present(loginEmailView, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRegisterEmail(_ sender: Any) {

		let registerEmailView = RegisterEmailView()
		registerEmailView.delegate = self
		present(registerEmailView, animated: true)
	}

	// MARK: - LoginEmailDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didLoginEmail() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_EMAIL)
		}
	}

	// MARK: - RegisterEmailDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didRegisterUser() {

		dismiss(animated: true) {
			UserLoggedIn(loginMethod: LOGIN_EMAIL)
		}
	}
}
