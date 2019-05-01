@objc protocol LoginEmailDelegate: class {

	func didLoginEmail()
}

//------------------------------------------------
class LoginEmailView: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var delegate: LoginEmailDelegate?

	@IBOutlet var fieldEmail: UITextField!
	@IBOutlet var fieldPassword: UITextField!

	//----------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false
	}

	//----------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)

		dismissKeyboard()
	}

	//----------------------------------------------
	@objc func dismissKeyboard() {

		view.endEditing(true)
	}

	// MARK: - User actions
	//----------------------------------------------
	@IBAction func actionLogin(_ sender: Any) {

		var email = (fieldEmail.text ?? "").lowercased()
		var password = fieldPassword.text ?? ""

		if (email.count == 0)		{ ProgressHUD.showError("Please enter your email.");	return 	}
		if (password.count == 0)	{ ProgressHUD.showError("Please enter your password.");	return 	}

		LogoutUser(delAccount: DEL_ACCOUNT_NONE)

		ProgressHUD.show(nil, interaction: false)

		FUser.signIn(email: email, password: password) { user, error in
			if (error == nil) {
				Account.add(email: email, password: password)
				self.dismiss(animated: true) {
					self.delegate?.didLoginEmail()
				}
			} else {
				ProgressHUD.showError(error!.localizedDescription)
			}
		}
	}

	//----------------------------------------------
	@IBAction func actionDismiss(_ sender: Any) {

		dismiss(animated: true)
	}

	// MARK: - UITextField delegate
	//-----------------------------------------------
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		if (textField == fieldEmail) {
			fieldPassword.becomeFirstResponder()
		}
		if (textField == fieldPassword) {
			actionLogin(0)
		}
		return true
	}
}
