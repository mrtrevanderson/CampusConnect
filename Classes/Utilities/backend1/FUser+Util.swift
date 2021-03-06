
extension FUser {

	// MARK: - Class methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func fullname() -> String		{ return FUser.currentUser().fullname()			}
	class func initials() -> String		{ return FUser.currentUser().initials()			}
	class func picture() -> String		{ return FUser.currentUser().picture()			}
	class func thumbnail() -> String	{ return FUser.currentUser().thumbnail()		}
	class func status() -> String		{ return FUser.currentUser().status()			}
	class func loginMethod() -> String	{ return FUser.currentUser().loginMethod()		}
	class func oneSignalId() -> String	{ return FUser.currentUser().oneSignalId()		}

	class func keepMedia() -> Int		{ return FUser.currentUser().keepMedia()		}
	class func networkImage() -> Int	{ return FUser.currentUser().networkImage()		}
	class func networkVideo() -> Int	{ return FUser.currentUser().networkVideo()		}
	class func networkAudio() -> Int	{ return FUser.currentUser().networkAudio()		}

	class func wallpaper() -> String	{ return FUser.currentUser().wallpaper() 		}
	class func isOnboardOk() -> Bool	{ return FUser.currentUser().isOnboardOk()		}

	// MARK: - Instance methods
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func fullname() -> String			{ return (self[FUSER_FULLNAME] as? String)		?? ""						}
	func picture() -> String			{ return (self[FUSER_PICTURE] as? String)		?? ""						}
	func thumbnail() -> String			{ return (self[FUSER_THUMBNAIL] as? String)		?? ""						}
	func status() -> String				{ return (self[FUSER_STATUS] as? String)		?? ""						}
	func loginMethod() -> String		{ return (self[FUSER_LOGINMETHOD] as? String)	?? ""						}
	func oneSignalId() -> String		{ return (self[FUSER_ONESIGNALID] as? String)	?? ""						}

	func keepMedia() -> Int				{ return (self[FUSER_KEEPMEDIA] as? Int)		?? Int(KEEPMEDIA_FOREVER)	}
	func networkImage() -> Int			{ return (self[FUSER_NETWORKIMAGE] as? Int)		?? Int(NETWORK_ALL)			}
	func networkVideo() -> Int			{ return (self[FUSER_NETWORKVIDEO] as? Int)		?? Int(NETWORK_ALL)			}
	func networkAudio() -> Int			{ return (self[FUSER_NETWORKAUDIO] as? Int)		?? Int(NETWORK_ALL)			}

	func wallpaper() -> String			{ return (self[FUSER_WALLPAPER] as? String)		?? ""						}
	func isOnboardOk() -> Bool			{ return self[FUSER_FULLNAME] != nil										}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func initials() -> String {

		if let firstname = self[FUSER_FIRSTNAME] as? String {
			if let lastname = self[FUSER_LASTNAME] as? String {
				let initial1 = (firstname.count != 0) ? firstname.prefix(1) : ""
				let initial2 = (lastname.count != 0) ? lastname.prefix(1) : ""
				return "\(initial1)\(initial2)"
			}
		}
		return ""
	}
}
