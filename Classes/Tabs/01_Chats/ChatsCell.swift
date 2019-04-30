
class ChatsCell: MGSwipeTableCell {

	@IBOutlet var viewUnread: UIView!
	@IBOutlet var imageUser: UIImageView!
	@IBOutlet var labelInitials: UILabel!
	@IBOutlet var labelDescription: UILabel!
	@IBOutlet var labelLastMessage: UILabel!
	@IBOutlet var labelElapsed: UILabel!
	@IBOutlet var imageMuted: UIImageView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(dbchat: DBChat) {

		let lastRead = Status.lastRead(chatId: dbchat.chatId)

		viewUnread.isHidden = (lastRead >= dbchat.lastIncoming)

		labelDescription.text = dbchat.details
		labelLastMessage.text = dbchat.lastMessage

		labelElapsed.text = TimeElapsed(timestamp: dbchat.lastMessageDate)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadImage(dbchat: DBChat, tableView: UITableView) {

		imageUser.layer.cornerRadius = imageUser.frame.size.width / 2
		imageUser.layer.masksToBounds = true

		if let path = DownloadManager.pathImage(link: dbchat.picture) {
			imageUser.image = UIImage(contentsOfFile: path)
			labelInitials.text = nil
		} else {
			imageUser.image = UIImage(named: "chats_blank")
			labelInitials.text = dbchat.initials
			downloadImage(dbchat: dbchat, tableView: tableView)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func downloadImage(dbchat: DBChat, tableView: UITableView) {

		DownloadManager.image(link: dbchat.picture) { path, error, network in
			if (error == nil) {
				tableView.reloadData()
			} else if ((error! as NSError).code == 102) {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.downloadImage(dbchat: dbchat, tableView: tableView)
				}
			}
		}
	}
}
