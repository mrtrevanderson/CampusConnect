extension NSDictionary {

	//----------------------------------------------
	@objc func name() -> String? {

		return self["name"] as? String
	}
}
