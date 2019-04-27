
class StickersCell: UICollectionViewCell {

	@IBOutlet var imageItem: UIImageView!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func bindData(file: String) {

		imageItem.image = UIImage(named: file)
	}
}
