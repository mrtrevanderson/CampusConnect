
@objc protocol SelectUsersDelegate: class {

	func didSelectUsers(users: [DBUser])
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class SelectUsersView: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

	@IBOutlet weak var delegate: SelectUsersDelegate?

	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var tableView: UITableView!

	private var blockerIds: [String] = []
	private var friendIds: [String] = []
	private var dbusers: RLMResults = DBUser.objects(with: NSPredicate(value: false))

	private var selection: [String] = []
	private var sections: [[DBUser]] = []
	private let collation = UILocalizedIndexedCollation.current()

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Select Users"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDone))

		tableView.register(UINib(nibName: "SelectUsersCell", bundle: nil), forCellReuseIdentifier: "SelectUsersCell")

		tableView.tableFooterView = UIView()

		loadBlockers()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)

		dismissKeyboard()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func dismissKeyboard() {

		view.endEditing(true)
	}

	// MARK: - Realm methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadBlockers() {

		blockerIds.removeAll()

		let predicate = NSPredicate(format: "isDeleted == NO")
		let dbblockers = DBBlocker.objects(with: predicate)

		for i in 0..<dbblockers.count {
			let dbblocker = dbblockers[i] as! DBBlocker
			blockerIds.append(dbblocker.blockerId)
		}

		loadFriends()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadFriends() {

		friendIds.removeAll()

		let predicate = NSPredicate(format: "isDeleted == NO")
		let dbfriends = DBFriend.objects(with: predicate)

		for i in 0..<dbfriends.count {
			let dbfriend = dbfriends[i] as! DBFriend
			friendIds.append(dbfriend.friendId)
		}

		loadUsers()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func loadUsers() {

		var predicate = NSPredicate(format: "NOT objectId IN %@ AND objectId IN %@", blockerIds, friendIds)

		if let text = searchBar.text {
			if (text.count != 0) {
				predicate = NSPredicate(format: "NOT objectId IN %@ AND objectId IN %@ AND fullname CONTAINS[c] %@", blockerIds, friendIds, text)
			}
		}

		dbusers = DBUser.objects(with: predicate).sortedResults(usingKeyPath: FUSER_FULLNAME, ascending: true)

		refreshTableView()
	}

	// MARK: - Refresh methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func refreshTableView() {

		setObjects()
		tableView.reloadData()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func setObjects() {

		sections.removeAll()

		let selector: Selector = "fullname"
		sections = Array(repeating: [], count: collation.sectionTitles.count)

		var unsorted: [DBUser] = []
		for i in 0..<dbusers.count {
			unsorted.append(dbusers[i] as! DBUser)
		}

		let sorted = collation.sortedArray(from: unsorted, collationStringSelector: selector) as! [DBUser]
		for dbuser in sorted {
			let section = collation.section(for: dbuser, collationStringSelector: selector)
			sections[section].append(dbuser)
		}
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionDone() {

		if (selection.count == 0) {
			ProgressHUD.showError("Please select some users.")
			return
		}

		var users:[DBUser] = []

		for i in 0..<dbusers.count {
			let dbuser = dbusers[i] as! DBUser
			if (selection.contains(dbuser.objectId)) {
				users.append(dbuser)
			}
		}

		dismiss(animated: true) {
			self.delegate?.didSelectUsers(users: users)
		}
	}

	// MARK: - UIScrollViewDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

		dismissKeyboard()
	}

	// MARK: - Table view data source
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func numberOfSections(in tableView: UITableView) -> Int {

		return sections.count
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return sections[section].count
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

		return (sections[section].count != 0) ? collation.sectionTitles[section] : nil
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {

		return collation.sectionIndexTitles
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {

		return collation.section(forSectionIndexTitle: index)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "SelectUsersCell", for: indexPath) as! SelectUsersCell

		let dbuser = sections[indexPath.section][indexPath.row]

		cell.bindData(dbuser: dbuser)
		cell.loadImage(dbuser: dbuser, tableView: tableView, indexPath: indexPath)

		cell.accessoryType = selection.contains(dbuser.objectId) ? .checkmark : .none

		return cell
	}

	// MARK: - Table view delegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

		let dbuser = sections[indexPath.section][indexPath.row]

		if (selection.contains(dbuser.objectId)) {
			if let index = selection.index(of: dbuser.objectId) {
				selection.remove(at: index)
			}
		} else {
			selection.append(dbuser.objectId)
		}

		let cell: UITableViewCell! = tableView.cellForRow(at: indexPath)
		cell.accessoryType = selection.contains(dbuser.objectId) ? .checkmark : .none
	}

	// MARK: - UISearchBarDelegate
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

		loadUsers()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func searchBarTextDidBeginEditing(_ searchBar_: UISearchBar) {

		searchBar.setShowsCancelButton(true, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func searchBarTextDidEndEditing(_ searchBar_: UISearchBar) {

		searchBar.setShowsCancelButton(false, animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func searchBarCancelButtonClicked(_ searchBar_: UISearchBar) {

		searchBar.text = ""
		searchBar.resignFirstResponder()
		loadUsers()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func searchBarSearchButtonClicked(_ searchBar_: UISearchBar) {

		searchBar.resignFirstResponder()
	}
}
