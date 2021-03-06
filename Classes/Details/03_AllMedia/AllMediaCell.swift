
class AllMediaCell: UICollectionViewCell {

	@IBOutlet var imageItem: UIImageView!
	@IBOutlet var imageVideo: UIImageView!
	@IBOutlet var imageSelected: UIImageView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(dbmessage: DBMessage, selected: Bool) {

		imageItem.image = UIImage(named: "allmedia_blank")
		imageVideo.isHidden = (dbmessage.type == MESSAGE_PICTURE)

		if (dbmessage.type == MESSAGE_PICTURE) {
			bindPicture(dbmessage: dbmessage)
		}

		if (dbmessage.type == MESSAGE_VIDEO) {
			bindVideo(dbmessage: dbmessage)
		}

		imageSelected.isHidden = (selected == false)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindPicture(dbmessage: DBMessage) {

		if let path = DownloadManager.pathImage(link: dbmessage.picture) {
			if let image = UIImage(contentsOfFile: path) {
				imageItem.image = Image.square(image: image, size: 320)
			}
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindVideo(dbmessage: DBMessage) {

		if let path = DownloadManager.pathVideo(link: dbmessage.video) {
			DispatchQueue(label: "bindVideo").async {
				let image = Video.thumbnail(path: path)
				DispatchQueue.main.async {
					self.imageItem.image = Image.square(image: image, size: 320)
				}
			}
		}
	}
}
