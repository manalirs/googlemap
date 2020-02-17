//import UIKit
//import GooglePlaces
//
//class googleintegration: UIViewController {
//
//    var resultsViewController: GMSAutocompleteResultsViewController?
//    var searchController: UISearchController?
//    var resultView: UITextView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//         GMSPlacesClient.provideAPIKey("822947803544-ludovapf10tidkpjds6uf6iaol18i76i.apps.googleusercontent.com")
//
//        resultsViewController = GMSAutocompleteResultsViewController()
//        resultsViewController?.delegate = self
//
//        searchController = UISearchController(searchResultsController: resultsViewController)
//        searchController?.searchResultsUpdater = resultsViewController
//
//        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
//
//        subView.addSubview((searchController?.searchBar)!)
//        view.addSubview(subView)
//        searchController?.searchBar.sizeToFit()
//        searchController?.hidesNavigationBarDuringPresentation = false
//
//        // When UISearchController presents the results view, present it in
//        // this view controller, not one further up the chain.
//        definesPresentationContext = true
//    }
//}
//
//// Handle the user's selection.
//extension googleintegration: GMSAutocompleteResultsViewControllerDelegate {
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didAutocompleteWith place: GMSPlace) {
//        searchController?.isActive = false
//        // Do something with the selected place.
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
//    }
//
//    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
//                           didFailAutocompleteWithError error: Error){
//        // TODO: handle the error.
//        print("Error: ", error.localizedDescription)
//    }
//
//    // Turn the network activity indicator on and off again.
//    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        GMSPlacesClient.provideAPIKey("822947803544-ludovapf10tidkpjds6uf6iaol18i76i.apps.googleusercontent.com")
//    }
//
//    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        GMSPlacesClient.provideAPIKey("822947803544-ludovapf10tidkpjds6uf6iaol18i76i.apps.googleusercontent.com")
//    }
//}
//
//
//
//
//
import UIKit
import GooglePlaces
class googleintegration: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = Pune.localised
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        definesPresentationContext = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelAct(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension googleintegration: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place Address: \(place.formattedAddress)")
        searchController?.searchBar.text = place.formattedAddress
        self.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
