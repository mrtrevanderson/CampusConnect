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
class DBMessage: RLMObject {

	@objc dynamic var objectId = ""

	@objc dynamic var chatId = ""
	@objc dynamic var members = ""

	@objc dynamic var senderId = ""
	@objc dynamic var senderName = ""
	@objc dynamic var senderInitials = ""
	@objc dynamic var senderPicture = ""

	@objc dynamic var recipientId = ""
	@objc dynamic var recipientName = ""
	@objc dynamic var recipientInitials = ""
	@objc dynamic var recipientPicture = ""

	@objc dynamic var groupId = ""
	@objc dynamic var groupName = ""
	@objc dynamic var groupPicture = ""

	@objc dynamic var type = ""
	@objc dynamic var text = ""

	@objc dynamic var picture = ""
	@objc dynamic var picture_width: Int = 0
	@objc dynamic var picture_height: Int = 0
	@objc dynamic var picture_md5 = ""

	@objc dynamic var video = ""
	@objc dynamic var video_duration: Int = 0
	@objc dynamic var video_md5 = ""

	@objc dynamic var audio = ""
	@objc dynamic var audio_duration: Int = 0
	@objc dynamic var audio_md5 = ""

	@objc dynamic var latitude: CLLocationDegrees = 0
	@objc dynamic var longitude: CLLocationDegrees = 0

	@objc dynamic var status = ""
	@objc dynamic var isDeleted = false

	@objc dynamic var createdAt: Int64 = 0
	@objc dynamic var updatedAt: Int64 = 0

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func lastUpdatedAt() -> Int64 {

		let dbmessage = DBMessage.allObjects().sortedResults(usingKeyPath: "updatedAt", ascending: true).lastObject() as? DBMessage
		return dbmessage?.updatedAt ?? 0
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override static func primaryKey() -> String? {

		return FMESSAGE_OBJECTID
	}
}
