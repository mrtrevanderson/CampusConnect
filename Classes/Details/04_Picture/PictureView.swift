
class PictureView: NYTPhotosViewController, SelectUsersDelegate {

	private var isMessages = false
	private var statusBarIsHidden = false

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func photos(picture: UIImage) -> [NYTPhoto] {

		let photoItem = NYTPhotoItem()
		photoItem.image = picture
		return [photoItem]
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func photos(messageId: String, chatId: String) -> [String: Any] {

		var photoItems: [NYTPhotoItem] = []
		var initialPhoto: NYTPhotoItem? = nil

		let predicate = NSPredicate(format: "chatId == %@ AND type == %@ AND isDeleted == NO", chatId, MESSAGE_PICTURE)
		let dbmessages = DBMessage.objects(with: predicate).sortedResults(usingKeyPath: FMESSAGE_CREATEDAT, ascending: true)

		let attributesTitle = [NSAttributedString.Key.foregroundColor: UIColor.white,
							   NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body)]
		let attributesCredit = [NSAttributedString.Key.foregroundColor: UIColor.gray,
								NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)]

		for i in 0..<dbmessages.count {
			let dbmessage = dbmessages[i] as! DBMessage
			if let path = DownloadManager.pathImage(link: dbmessage.picture) {
				let title = dbmessage.senderName

				let date = Date.date(timestamp: dbmessage.createdAt)
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "dd MMMM, HH:mm"
				let credit = dateFormatter.string(from: date)

				let photoItem = NYTPhotoItem()
				photoItem.image = UIImage(contentsOfFile: path)
				photoItem.attributedCaptionTitle = NSAttributedString(string: title, attributes: attributesTitle)
				photoItem.attributedCaptionCredit = NSAttributedString(string: credit, attributes: attributesCredit)
				photoItem.objectId = dbmessage.objectId

				if (dbmessage.objectId == messageId) {
					initialPhoto = photoItem
				}

				photoItems.append(photoItem)
			}
		}

		if (initialPhoto == nil) { initialPhoto = photoItems.first }

		return ["photoItems": photoItems, "initialPhoto": initialPhoto]
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func setMessages(messages: Bool)
	{
		isMessages = messages
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()

		statusBarIsHidden = UIApplication.shared.isStatusBarHidden

		

		updateOverlayViewConstraints()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override var prefersStatusBarHidden: Bool {

		return statusBarIsHidden
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override var preferredStatusBarStyle: UIStatusBarStyle {

		return .lightContent
	}

	// MARK: - Initialization methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func updateOverlayViewConstraints() {

		if let overlay = overlayView {
			for constraint in overlay.constraints {
				if (constraint.firstItem is UINavigationBar) {
					if (constraint.firstAttribute == .top) {
						constraint.constant = 20
					}
				}
			}
		}
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionMore() {

		let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

		
		
	


		present(alert, animated: true)
	}

	// MARK: - User actions (save)
	//---------------------------------------------------------------------------------------------------------------------------------------------


	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer?) {

	}

	// MARK: - User actions (forward)
	//---------------------------------------------------------------------------------------------------------------------------------------------

	// MARK: - SelectUsersDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func didSelectUsers(users: [DBUser]) {

	}

	// MARK: - User actions (share)
	//---------------------------------------------------------------------------------------------------------------------------------------------

	// MARK: - User actions (delete)


	//---------------------------------------------------------------------------------------------------------------------------------------------

}
