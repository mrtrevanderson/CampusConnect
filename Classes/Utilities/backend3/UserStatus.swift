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
class UserStatus: NSObject {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItems() {

		createItem(name: "Accounting")
		createItem(name: "Anthropology")
		createItem(name: "Architecture")
		createItem(name: " ")
		createItem(name: "At work")
		createItem(name: "Battery about to die")
		createItem(name: "Can't talk now")
		createItem(name: "In a meeting")
		createItem(name: "At the gym")
		createItem(name: "Sleeping")
		createItem(name: "Urgent calls only")
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	class func createItem(name: String) {

		let object = FObject(path: FUSERSTATUS_PATH)

		object[FUSERSTATUS_NAME] = name

		object.saveInBackground(block: { error in
			if (error != nil) {
				print("UserStatus createItem error: \(error)")
			}
		})
	}
}
