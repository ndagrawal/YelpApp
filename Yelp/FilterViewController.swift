//
//  FilterViewController.swift
//  Yelp
//
//  Created by Nilesh Agrawal on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate{
    func filtersViewController(filterSviewController:FilterViewController,didUpdateFilters filters:NSMutableDictionary)
}
class FilterViewController: UIViewController,UITableViewDataSource,SwitchTableViewDelegate,UITableViewDelegate {

    @IBOutlet weak var dealSelectButton: UISwitch!
    @IBOutlet weak var filterNavigationBar: UINavigationBar!
    var cancelButton:UIBarButtonItem!
    var filterButton:UIBarButtonItem!
    
    var categories:[[String:String]] = []
    var filters:NSMutableDictionary = NSMutableDictionary()
    var selectedCategories:[String] = []
    @IBOutlet weak var offeringDealView: UIView!
    //Distance
    @IBOutlet weak var distanceFilter: UIButton!
    @IBOutlet weak var distanceTableView: UITableView!
    var distanceFilterDataSet:[String] = ["0.3 Miles","1 Mile","5 Miles","10 Miles"]
    @IBOutlet weak var distancebetweenlabelAndDistanceTable: NSLayoutConstraint!
    weak var delegate:FiltersViewControllerDelegate?
    
    //Sort
    
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var sortByTable: UITableView!
    @IBOutlet weak var distanceBetweenLabelAndSortByTable: NSLayoutConstraint!
    var sortByFilterDataSet:[String] = ["Best Match","Distance","Highest Rated"]
    //Category
    @IBOutlet weak var categoryTableView: UITableView!
    var categoriesFilterDataSet:[String] = ["Category1","Category 2 ","Categorty 3"];
 //   var selectedCategories:[String] = []
    
    //MARK: ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
        setUpDelegate()
        setUpInitialise()
        setUpView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    
    //MARK: Setup Methods
    func setUpDelegate(){
        
        distanceTableView.delegate = self
        distanceTableView.dataSource = self
        
        sortByTable.delegate = self
        sortByTable.dataSource = self
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
    }
    
    func setUpViewBackGround(selectedView:UIView){
        selectedView.backgroundColor = UIColor.whiteColor()
        selectedView.layer.borderColor = UIColor.grayColor().CGColor
        selectedView.layer.borderWidth = 1.0
        selectedView.layer.cornerRadius = 5.0
    }
    
    func setUpView(){
        setUpViewBackGround(offeringDealView)
        setUpViewBackGround(distanceFilter)
        setUpViewBackGround(sortByButton)
        
         filterButton = UIBarButtonItem.init(title: "Apply Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterButtonPressed")
        filterButton.tintColor = UIColor.whiteColor()

        self.navigationItem.rightBarButtonItem = filterButton
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        dealSelectButton.setOn(false, animated: false)
    }
    
  
    func setUpInitialise(){
        distanceTableView.hidden = true
        distancebetweenlabelAndDistanceTable.constant = 30.00 - distanceTableView.bounds.size.height
        
        sortByTable.hidden = true
        distanceBetweenLabelAndSortByTable.constant = 30.00 - sortByTable.bounds.size.height
        
        categories = yelpCategories()
    }
   
    func showTableView(selectedTableView:UITableView,distanceBetweenTableAndLayoutBelow:NSLayoutConstraint){
        selectedTableView.hidden = false;
        selectedTableView.reloadData()
        distanceBetweenTableAndLayoutBelow.constant = 30.00
    }
    
    func hideTableView(selectedTableView:UITableView,distanceBetweenTableAndLayoutBelow:NSLayoutConstraint){
        selectedTableView.hidden = true;
        selectedTableView.reloadData()
        distanceBetweenTableAndLayoutBelow.constant = 30.00 - selectedTableView.bounds.size.height
    }
    
    //MARK: IBActions
    @IBAction func distanceFilterClicked(sender: AnyObject) {
        
        distanceFilter.selected = !distanceFilter.selected
        if(distanceFilter.selected){
            showTableView(distanceTableView, distanceBetweenTableAndLayoutBelow: distancebetweenlabelAndDistanceTable)
                  }else{
            hideTableView(distanceTableView, distanceBetweenTableAndLayoutBelow:distancebetweenlabelAndDistanceTable)
                }
    }
    @IBAction func sortByFilterClicked(sender: AnyObject) {
        sortByButton.selected = !sortByButton.selected
        if(sortByButton.selected){
            showTableView(sortByTable, distanceBetweenTableAndLayoutBelow: distanceBetweenLabelAndSortByTable)
        }else{
            hideTableView(sortByTable, distanceBetweenTableAndLayoutBelow: distanceBetweenLabelAndSortByTable)
        }
    }
    
    @IBAction func DealSelected(sender: AnyObject) {
        if dealSelectButton.on {
            filters.setObject("on", forKey: "deal")
                  }else{
            filters.setObject("off", forKey: "deal")
           
        }
    }
    
    func filterButtonPressed(){
        print(filters)
        self.navigationController?.popToRootViewControllerAnimated(true)
        delegate?.filtersViewController(self, didUpdateFilters: filters)
    }
    
 
    
    //MARK: Tableview Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView.isEqual(distanceTableView){
            return distanceFilterDataSet.count
        }else if tableView.isEqual(sortByTable){
            return sortByFilterDataSet.count
        }else{
            return categories.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView.isEqual(distanceTableView){
        let distanceCell:UITableViewCell  = tableView.dequeueReusableCellWithIdentifier("DistanceCell", forIndexPath: indexPath) as UITableViewCell!
        setUpViewBackGround(distanceCell)
        distanceCell.textLabel!.text = distanceFilterDataSet[indexPath.row]
        print( distanceCell.textLabel?.text)
        return distanceCell
        }else if tableView.isEqual(sortByTable){
        let sortByTableCell:UITableViewCell  = tableView.dequeueReusableCellWithIdentifier("SortByCell", forIndexPath: indexPath) as UITableViewCell!
            setUpViewBackGround(sortByTableCell)
            sortByTableCell.textLabel!.text = sortByFilterDataSet[indexPath.row]
                print(sortByTableCell.textLabel?.text)
        
        return sortByTableCell
        }else{
            let categoryCell:SwitchTableViewCell  = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! SwitchTableViewCell
            
            setUpViewBackGround(categoryCell)
            var valueForCategoryCell:[String:String]!
            valueForCategoryCell = categories[indexPath.row]
            let sampleString:String = valueForCategoryCell["code"] as String!
            categoryCell.tableViewCellLabel!.text = sampleString
            categoryCell.delegate = self
            print(categoryCell.textLabel?.text)
            return categoryCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.isEqual(distanceTableView){
            switch indexPath.row{
            case 0:
                filters.setObject(0.3, forKey: "distance")
            case 1:
                  filters.setObject(1, forKey: "distance")
            case 2:
                filters.setObject(5, forKey: "distance")
            case 3:
                 filters.setObject(10, forKey: "distance")
            default:
                 filters.setObject(50, forKey: "distance")
            }
        }else if tableView.isEqual(sortByTable){
            switch indexPath.row{
            case 0:
                filters.setObject("bestmatch", forKey: "sortBy")
            case 1:
                filters.setObject("distance", forKey: "sortBy")
            case 2:
                filters.setObject("highrated", forKey: "sortBy")
            default:
                filters.setObject("bestmatch", forKey: "sortBy")
              
            }
        }
    }
    
    //Mark: SwitchDelegate
    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
        if value{
        selectedCategories.append("\(switchCell.tableViewCellLabel.text!)")
        filters.setObject(selectedCategories, forKey: "categories")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func yelpCategories()->[[String:String]]{
    return [["name" : "Afghan", "code": "afghani"],
        ["name" : "African", "code": "african"],
        ["name" : "American, New", "code": "newamerican"],
        ["name" : "American, Traditional", "code": "tradamerican"],
        ["name" : "Arabian", "code": "arabian"],
        ["name" : "Argentine", "code": "argentine"],
        ["name" : "Armenian", "code": "armenian"],
        ["name" : "Asian Fusion", "code": "asianfusion"],
        ["name" : "Asturian", "code": "asturian"],
        ["name" : "Australian", "code": "australian"],
        ["name" : "Austrian", "code": "austrian"],
        ["name" : "Baguettes", "code": "baguettes"],
        ["name" : "Bangladeshi", "code": "bangladeshi"],
        ["name" : "Barbeque", "code": "bbq"],
        ["name" : "Basque", "code": "basque"],
        ["name" : "Bavarian", "code": "bavarian"],
        ["name" : "Beer Garden", "code": "beergarden"],
        ["name" : "Beer Hall", "code": "beerhall"],
        ["name" : "Beisl", "code": "beisl"],
        ["name" : "Belgian", "code": "belgian"],
        ["name" : "Bistros", "code": "bistros"],
        ["name" : "Black Sea", "code": "blacksea"],
        ["name" : "Brasseries", "code": "brasseries"],
        ["name" : "Brazilian", "code": "brazilian"],
        ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
        ["name" : "British", "code": "british"],
        ["name" : "Buffets", "code": "buffets"],
        ["name" : "Bulgarian", "code": "bulgarian"],
        ["name" : "Burgers", "code": "burgers"],
        ["name" : "Burmese", "code": "burmese"],
        ["name" : "Cafes", "code": "cafes"],
        ["name" : "Cafeteria", "code": "cafeteria"],
        ["name" : "Cajun/Creole", "code": "cajun"],
        ["name" : "Cambodian", "code": "cambodian"],
        ["name" : "Canadian", "code": "New)"],
        ["name" : "Canteen", "code": "canteen"],
        ["name" : "Caribbean", "code": "caribbean"],
        ["name" : "Catalan", "code": "catalan"],
        ["name" : "Chech", "code": "chech"],
        ["name" : "Cheesesteaks", "code": "cheesesteaks"],
        ["name" : "Chicken Shop", "code": "chickenshop"],
        ["name" : "Chicken Wings", "code": "chicken_wings"],
        ["name" : "Chilean", "code": "chilean"],
        ["name" : "Chinese", "code": "chinese"],
        ["name" : "Comfort Food", "code": "comfortfood"],
        ["name" : "Corsican", "code": "corsican"],
        ["name" : "Creperies", "code": "creperies"],
        ["name" : "Cuban", "code": "cuban"],
        ["name" : "Curry Sausage", "code": "currysausage"],
        ["name" : "Cypriot", "code": "cypriot"],
        ["name" : "Czech", "code": "czech"],
        ["name" : "Czech/Slovakian", "code": "czechslovakian"],
        ["name" : "Danish", "code": "danish"],
        ["name" : "Delis", "code": "delis"],
        ["name" : "Diners", "code": "diners"],
        ["name" : "Dumplings", "code": "dumplings"],
        ["name" : "Eastern European", "code": "eastern_european"],
        ["name" : "Ethiopian", "code": "ethiopian"],
        ["name" : "Fast Food", "code": "hotdogs"],
        ["name" : "Filipino", "code": "filipino"],
        ["name" : "Fish & Chips", "code": "fishnchips"],
        ["name" : "Fondue", "code": "fondue"],
        ["name" : "Food Court", "code": "food_court"],
        ["name" : "Food Stands", "code": "foodstands"],
        ["name" : "French", "code": "french"],
        ["name" : "French Southwest", "code": "sud_ouest"],
        ["name" : "Galician", "code": "galician"],
        ["name" : "Gastropubs", "code": "gastropubs"],
        ["name" : "Georgian", "code": "georgian"],
        ["name" : "German", "code": "german"],
        ["name" : "Giblets", "code": "giblets"],
        ["name" : "Gluten-Free", "code": "gluten_free"],
        ["name" : "Greek", "code": "greek"],
        ["name" : "Halal", "code": "halal"],
        ["name" : "Hawaiian", "code": "hawaiian"],
        ["name" : "Heuriger", "code": "heuriger"],
        ["name" : "Himalayan/Nepalese", "code": "himalayan"],
        ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
        ["name" : "Hot Dogs", "code": "hotdog"],
        ["name" : "Hot Pot", "code": "hotpot"],
        ["name" : "Hungarian", "code": "hungarian"],
        ["name" : "Iberian", "code": "iberian"],
        ["name" : "Indian", "code": "indpak"],
        ["name" : "Indonesian", "code": "indonesian"],
        ["name" : "International", "code": "international"],
        ["name" : "Irish", "code": "irish"],
        ["name" : "Island Pub", "code": "island_pub"],
        ["name" : "Israeli", "code": "israeli"],
        ["name" : "Italian", "code": "italian"],
        ["name" : "Japanese", "code": "japanese"],
        ["name" : "Jewish", "code": "jewish"],
        ["name" : "Kebab", "code": "kebab"],
        ["name" : "Korean", "code": "korean"],
        ["name" : "Kosher", "code": "kosher"],
        ["name" : "Kurdish", "code": "kurdish"],
        ["name" : "Laos", "code": "laos"],
        ["name" : "Laotian", "code": "laotian"],
        ["name" : "Latin American", "code": "latin"],
        ["name" : "Live/Raw Food", "code": "raw_food"],
        ["name" : "Lyonnais", "code": "lyonnais"],
        ["name" : "Malaysian", "code": "malaysian"],
        ["name" : "Meatballs", "code": "meatballs"],
        ["name" : "Mediterranean", "code": "mediterranean"],
        ["name" : "Mexican", "code": "mexican"],
        ["name" : "Middle Eastern", "code": "mideastern"],
        ["name" : "Milk Bars", "code": "milkbars"],
        ["name" : "Modern Australian", "code": "modern_australian"],
        ["name" : "Modern European", "code": "modern_european"],
        ["name" : "Mongolian", "code": "mongolian"],
        ["name" : "Moroccan", "code": "moroccan"],
        ["name" : "New Zealand", "code": "newzealand"],
        ["name" : "Night Food", "code": "nightfood"],
        ["name" : "Norcinerie", "code": "norcinerie"],
        ["name" : "Open Sandwiches", "code": "opensandwiches"],
        ["name" : "Oriental", "code": "oriental"],
        ["name" : "Pakistani", "code": "pakistani"],
        ["name" : "Parent Cafes", "code": "eltern_cafes"],
        ["name" : "Parma", "code": "parma"],
        ["name" : "Persian/Iranian", "code": "persian"],
        ["name" : "Peruvian", "code": "peruvian"],
        ["name" : "Pita", "code": "pita"],
        ["name" : "Pizza", "code": "pizza"],
        ["name" : "Polish", "code": "polish"],
        ["name" : "Portuguese", "code": "portuguese"],
        ["name" : "Potatoes", "code": "potatoes"],
        ["name" : "Poutineries", "code": "poutineries"],
        ["name" : "Pub Food", "code": "pubfood"],
        ["name" : "Rice", "code": "riceshop"],
        ["name" : "Romanian", "code": "romanian"],
        ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
        ["name" : "Rumanian", "code": "rumanian"],
        ["name" : "Russian", "code": "russian"],
        ["name" : "Salad", "code": "salad"],
        ["name" : "Sandwiches", "code": "sandwiches"],
        ["name" : "Scandinavian", "code": "scandinavian"],
        ["name" : "Scottish", "code": "scottish"],
        ["name" : "Seafood", "code": "seafood"],
        ["name" : "Serbo Croatian", "code": "serbocroatian"],
        ["name" : "Signature Cuisine", "code": "signature_cuisine"],
        ["name" : "Singaporean", "code": "singaporean"],
        ["name" : "Slovakian", "code": "slovakian"],
        ["name" : "Soul Food", "code": "soulfood"],
        ["name" : "Soup", "code": "soup"],
        ["name" : "Southern", "code": "southern"],
        ["name" : "Spanish", "code": "spanish"],
        ["name" : "Steakhouses", "code": "steak"],
        ["name" : "Sushi Bars", "code": "sushi"],
        ["name" : "Swabian", "code": "swabian"],
        ["name" : "Swedish", "code": "swedish"],
        ["name" : "Swiss Food", "code": "swissfood"],
        ["name" : "Tabernas", "code": "tabernas"],
        ["name" : "Taiwanese", "code": "taiwanese"],
        ["name" : "Tapas Bars", "code": "tapas"],
        ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
        ["name" : "Tex-Mex", "code": "tex-mex"],
        ["name" : "Thai", "code": "thai"],
        ["name" : "Traditional Norwegian", "code": "norwegian"],
        ["name" : "Traditional Swedish", "code": "traditional_swedish"],
        ["name" : "Trattorie", "code": "trattorie"],
        ["name" : "Turkish", "code": "turkish"],
        ["name" : "Ukrainian", "code": "ukrainian"],
        ["name" : "Uzbek", "code": "uzbek"],
        ["name" : "Vegan", "code": "vegan"],
        ["name" : "Vegetarian", "code": "vegetarian"],
        ["name" : "Venison", "code": "venison"],
        ["name" : "Vietnamese", "code": "vietnamese"],
        ["name" : "Wok", "code": "wok"],
        ["name" : "Wraps", "code": "wraps"],
        ["name" : "Yugoslav", "code": "yugoslav"]]
    }
    
}
