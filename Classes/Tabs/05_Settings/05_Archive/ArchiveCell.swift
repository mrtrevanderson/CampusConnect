//
// Copyright (c) 2018 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

//-------------------------------------------------------------------------------------------------------------------------------------------------
class ArchiveCell: MGSwipeTableCell {

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
		let mutedUntil = Status.mutedUntil(chatId: dbchat.chatId)

		viewUnread.isHidden = (lastRead >= dbchat.lastIncoming)

		labelDescription.text = dbchat.details
		labelLastMessage.text = dbchat.lastMessage

		labelElapsed.text = TimeElapsed(timestamp: dbchat.lastMessageDate)
		imageMuted.isHidden = (mutedUntil < Date().timestamp())
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadImage(dbchat: DBChat, tableView: UITableView, indexPath: IndexPath) {

		imageUser.layer.cornerRadius = imageUser.frame.size.width / 2
		imageUser.layer.masksToBounds = true

		if let path = DownloadManager.pathImage(link: dbchat.picture) {
			imageUser.image = UIImage(contentsOfFile: path)
			labelInitials.text = nil
		} else {
			imageUser.image = UIImage(named: "archive_blank")
			labelInitials.text = dbchat.initials
			downloadImage(dbchat: dbchat, tableView: tableView, indexPath: indexPath)
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func downloadImage(dbchat: DBChat, tableView: UITableView, indexPath: IndexPath) {

		DownloadManager.image(link: dbchat.picture) { path, error, network in
			if (error == nil) {
				if (tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false) {
					let cell = tableView.cellForRow(at: indexPath) as! ArchiveCell
					cell.imageUser.image = UIImage(contentsOfFile: path!)
					cell.labelInitials.text = nil
				}
			} else if ((error! as NSError).code == 102) {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.downloadImage(dbchat: dbchat, tableView: tableView, indexPath: indexPath)
				}
			}
		}
	}
}
