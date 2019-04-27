
class CallHistories: NSObject {

	private var timer: Timer?
	private var refreshUICallHistories = false
	private var firebase: DatabaseReference?

	//---------------------------------------------------------------------------------------------------------------------------------------------
	static let shared: CallHistories = {
		let instance = CallHistories()
		return instance
	} ()

}
