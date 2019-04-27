
class MapView: UIViewController {

	@IBOutlet var mapView: MKMapView!

	private var location: CLLocation!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func myInit(location location_: CLLocation) {

		location = location_
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()
		title = "Map"

		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(actionCancel))
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		var region: MKCoordinateRegion = MKCoordinateRegion()
		region.center.latitude = location.coordinate.latitude
		region.center.longitude = location.coordinate.longitude
		region.span.latitudeDelta = CLLocationDegrees(0.01)
		region.span.longitudeDelta = CLLocationDegrees(0.01)
		mapView.setRegion(region, animated: false)

		let annotation = MKPointAnnotation()
		mapView.addAnnotation(annotation)
		annotation.coordinate = location.coordinate
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func actionCancel() {

		dismiss(animated: true)
	}
}
