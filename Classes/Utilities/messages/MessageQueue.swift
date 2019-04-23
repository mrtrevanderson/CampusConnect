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
class MessageQueue: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func send(chatId: String, recipientId: String, status: String?, text: String?, picture: UIImage?, video: URL?, audio: String?) {

		let predicate = NSPredicate(format: "objectId == %@", recipientId)
		let dbuser = DBUser.objects(with: predicate).firstObject() as! DBUser

		let senderPicture = FUser.thumbnail()
		let recipientPicture = dbuser.thumbnail

		let message = FObject(path: FMESSAGE_PATH)

		message.objectIdInit()

		message[FMESSAGE_CHATID] = chatId
		message[FMESSAGE_MEMBERS] = [FUser.currentId(), recipientId]

		message[FMESSAGE_SENDERID] = FUser.currentId()
		message[FMESSAGE_SENDERNAME] = FUser.fullname()
		message[FMESSAGE_SENDERINITIALS] = FUser.initials()
		message[FMESSAGE_SENDERPICTURE] = senderPicture

		message[FMESSAGE_RECIPIENTID] = recipientId
		message[FMESSAGE_RECIPIENTNAME] = dbuser.fullname
		message[FMESSAGE_RECIPIENTINITIALS] = dbuser.initials()
		message[FMESSAGE_RECIPIENTPICTURE] = recipientPicture

		message[FMESSAGE_GROUPID] = ""
		message[FMESSAGE_GROUPNAME] = ""
		message[FMESSAGE_GROUPPICTURE] = ""

		message[FMESSAGE_TYPE] = ""
		message[FMESSAGE_TEXT] = ""

		message[FMESSAGE_PICTURE] = ""
		message[FMESSAGE_PICTURE_WIDTH] = 0
		message[FMESSAGE_PICTURE_HEIGHT] = 0
		message[FMESSAGE_PICTURE_MD5] = ""

		message[FMESSAGE_VIDEO] = ""
		message[FMESSAGE_VIDEO_DURATION] = 0
		message[FMESSAGE_VIDEO_MD5] = ""

		message[FMESSAGE_AUDIO] = ""
		message[FMESSAGE_AUDIO_DURATION] = 0
		message[FMESSAGE_AUDIO_MD5] = ""

		message[FMESSAGE_LATITUDE] = 0
		message[FMESSAGE_LONGITUDE] = 0

		message[FMESSAGE_STATUS] = TEXT_QUEUED
		message[FMESSAGE_ISDELETED] = false

		let timestamp = Date().timestamp()
		message[FMESSAGE_CREATEDAT] = timestamp
		message[FMESSAGE_UPDATEDAT] = timestamp

		if (status != nil)			{ sendStatusMessage(message: message, status: status!)		}
		else if (text != nil)		{ sendTextMessage(message: message, text: text!)			}
		else if (picture != nil)	{ sendPictureMessage(message: message, picture: picture!)	}
		else if (video != nil)		{ sendVideoMessage(message: message, video: video!)			}
		else if (audio != nil)		{ sendAudioMessage(message: message, audio: audio!)			}
		else						{ sendLoactionMessage(message: message)						}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func send(chatId: String, groupId: String, status: String?, text: String?, picture: UIImage?, video: URL?, audio: String?) {

		let predicate = NSPredicate(format: "objectId == %@", groupId)
		let dbgroup = DBGroup.objects(with: predicate).firstObject() as! DBGroup

		let senderPicture = FUser.thumbnail()
		let groupPicture = dbgroup.picture

		let message = FObject(path: FMESSAGE_PATH)

		message.objectIdInit()

		message[FMESSAGE_CHATID] = chatId
		message[FMESSAGE_MEMBERS] = dbgroup.members.components(separatedBy: ",")

		message[FMESSAGE_SENDERID] = FUser.currentId()
		message[FMESSAGE_SENDERNAME] = FUser.fullname()
		message[FMESSAGE_SENDERINITIALS] = FUser.initials()
		message[FMESSAGE_SENDERPICTURE] = senderPicture

		message[FMESSAGE_RECIPIENTID] = ""
		message[FMESSAGE_RECIPIENTNAME] = ""
		message[FMESSAGE_RECIPIENTINITIALS] = ""
		message[FMESSAGE_RECIPIENTPICTURE] = ""

		message[FMESSAGE_GROUPID] = groupId
		message[FMESSAGE_GROUPNAME] = dbgroup.name
		message[FMESSAGE_GROUPPICTURE] = groupPicture

		message[FMESSAGE_TYPE] = ""
		message[FMESSAGE_TEXT] = ""

		message[FMESSAGE_PICTURE] = ""
		message[FMESSAGE_PICTURE_WIDTH] = 0
		message[FMESSAGE_PICTURE_HEIGHT] = 0
		message[FMESSAGE_PICTURE_MD5] = ""

		message[FMESSAGE_VIDEO] = ""
		message[FMESSAGE_VIDEO_DURATION] = 0
		message[FMESSAGE_VIDEO_MD5] = ""

		message[FMESSAGE_AUDIO] = ""
		message[FMESSAGE_AUDIO_DURATION] = 0
		message[FMESSAGE_AUDIO_MD5] = ""

		message[FMESSAGE_LATITUDE] = 0
		message[FMESSAGE_LONGITUDE] = 0

		message[FMESSAGE_STATUS] = TEXT_QUEUED
		message[FMESSAGE_ISDELETED] = false

		let timestamp = Date().timestamp()
		message[FMESSAGE_CREATEDAT] = timestamp
		message[FMESSAGE_UPDATEDAT] = timestamp

		if (status != nil)			{ sendStatusMessage(message: message, status: status!)		}
		else if (text != nil)		{ sendTextMessage(message: message, text: text!)			}
		else if (picture != nil)	{ sendPictureMessage(message: message, picture: picture!)	}
		else if (video != nil)		{ sendVideoMessage(message: message, video: video!)			}
		else if (audio != nil)		{ sendAudioMessage(message: message, audio: audio!)			}
		else						{ sendLoactionMessage(message: message)						}
	}


	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func sendStatusMessage(message: FObject, status: String) {

		message[FMESSAGE_TYPE] = MESSAGE_STATUS
		message[FMESSAGE_TEXT] = status

		createMessage(message: message)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func sendTextMessage(message: FObject, text: String) {

		message[FMESSAGE_TYPE] = Emoji.isEmoji(text: text) ? MESSAGE_EMOJI : MESSAGE_TEXT
		message[FMESSAGE_TEXT] = text

		createMessage(message: message)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func sendPictureMessage(message: FObject, picture: UIImage) {

		message[FMESSAGE_TYPE] = MESSAGE_PICTURE
		message[FMESSAGE_TEXT] = "[Picture message]"

		if let dataPicture = picture.jpegData(compressionQuality: 0.6) {
			DownloadManager.saveImage(data: dataPicture, link: message.objectId())

			message[FMESSAGE_PICTURE] = message.objectId()
			message[FMESSAGE_PICTURE_WIDTH] = Int(picture.size.width)
			message[FMESSAGE_PICTURE_HEIGHT] = Int(picture.size.height)

			createMessage(message: message)
		} else {
			ProgressHUD.showError("Picture data error.")
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func sendVideoMessage(message: FObject, video: URL) {

		message[FMESSAGE_TYPE] = MESSAGE_VIDEO
		message[FMESSAGE_TEXT] = "[Video message]"

		if let dataVideo = try? Data(contentsOf: video) {
			DownloadManager.saveVideo(data: dataVideo, link: message.objectId())

			message[FMESSAGE_VIDEO] = message.objectId()
			message[FMESSAGE_VIDEO_DURATION] = Video.duration(path: video.path)

			createMessage(message: message)
		} else {
			ProgressHUD.showError("Video data error.")
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func sendAudioMessage(message: FObject, audio: String) {

		message[FMESSAGE_TYPE] = MESSAGE_AUDIO
		message[FMESSAGE_TEXT] = "[Audio message]"

		if let dataAudio = try? Data(contentsOf: URL(fileURLWithPath: audio)) {
			DownloadManager.saveAudio(data: dataAudio, link: message.objectId())

			message[FMESSAGE_AUDIO] = message.objectId()
			message[FMESSAGE_AUDIO_DURATION] = Audio.duration(path: audio)

			createMessage(message: message)
		} else {
			ProgressHUD.showError("Audio data error.")
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func sendLoactionMessage(message: FObject) {

		message[FMESSAGE_TYPE] = MESSAGE_LOCATION
		message[FMESSAGE_TEXT] = "[Location message]"

		message[FMESSAGE_LATITUDE] = Location.latitude()
		message[FMESSAGE_LONGITUDE] = Location.longitude()

		createMessage(message: message)
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createMessage(message: FObject) {

		updateRealm(message: message.values)
		updateChat(message: message.values)

		NotificationCenterX.post(notification: NOTIFICATION_REFRESH_MESSAGES1)
		NotificationCenterX.post(notification: NOTIFICATION_REFRESH_CHATS)

		playMessageOutgoing(message: message)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updateRealm(message: [String: Any]) {

		var temp = message

		let members = message[FMESSAGE_MEMBERS] as! [String]
		temp[FMESSAGE_MEMBERS] = members.joined(separator: ",")

		do {
			let realm = RLMRealm.default()
			realm.beginWriteTransaction()
			DBMessage.createOrUpdate(in: realm, withValue: temp)
			try realm.commitWriteTransaction()
		} catch {
			ProgressHUD.showError("Realm commit error.")
		}
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func updateChat(message: [String: Any]) {

		let chatId = message[FMESSAGE_CHATID] as! String

		Chat.updateChat(chatId: chatId)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func playMessageOutgoing(message: FObject) {

		let type = message[FMESSAGE_TYPE] as! String

		if (type != MESSAGE_STATUS) {
			Audio.playMessageOutgoing()
		}
	}
}
