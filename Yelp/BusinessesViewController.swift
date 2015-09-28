//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,FiltersViewControllerDelegate{

    var businesses: [Business]!
    var searchBar:UISearchBar!
    var filterButton:UIBarButtonItem!
    var filteredData: [String]!
    var data:[String]! = [String]()
    var filters:FilterViewController = FilterViewController()
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View Controller Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegates()
        self.setUpUI()
        self.searchFilters()
        filters.delegate = self
        filteredData = data
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addSearchBarAndFilterButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.removeFromSuperview()
    }
    //MARK: - Setup Methods
    func setupDelegates(){
        //Setting up the tableview delegates and data source
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    func addSearchBarAndFilterButton(){

        //Setting up the search bar
        self.automaticallyAdjustsScrollViewInsets = false
        searchBar = UISearchBar()
        searchBar.delegate = self
        let width:CGFloat = (self.navigationController?.navigationBar.bounds.size.width)!-120
        let height:CGFloat = (self.navigationController?.navigationBar.bounds.size.height)!
        searchBar.frame = CGRectMake(40, 0,width,height)
        self.navigationController?.navigationBar.addSubview(searchBar)
        self.navigationController?.navigationBar.bringSubviewToFront(searchBar)
        self.navigationController?.navigationBar.clipsToBounds = false
        searchBar.backgroundColor = UIColor.redColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()

        //Setting up the filter button
        filterButton = UIBarButtonItem.init(title: "Filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterButtonPressed")
        filterButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    
    func filterButtonPressed(){
        let filerViewController:FilterViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FilterViewController") as! FilterViewController
        filerViewController.delegate = self
           // self.presentViewController(filerViewController, animated: true, completion: nil)
            self.navigationController?.pushViewController(filerViewController, animated: true)
    }
    
    func setUpUI(){
            //Setting up the table View
            tableView.rowHeight = 140
    }
    
    func setUpInitialValues(){
        
        
    }
    
    func searchFilters(){
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                business.name!
                self.data.append("\(business.name!)")
                print(business.address!)
            }
            filteredData = data
        })
    }
    
    
    //MARK: - Table View Delegate Methods
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let businesses = businesses{
            return businesses.count
        }else{
            return 0;
    }
}
    
    
    func filtersViewController(filterSviewController:FilterViewController,didUpdateFilters filters:NSMutableDictionary){
     
        var filteredCategories:[String]? = [""]
        var filteredDealsString:String! = "off"
        var filterSortMode:String! = "bestmatch"
        var filterDeal:Bool!
        var sortMode:YelpSortMode!
        filteredCategories = filters.objectForKey("categories") as! [String]!
        filteredDealsString = filters.objectForKey("deal") as! String!
        filterSortMode = filters.objectForKey("sortBy") as! String!
        
        if (filteredDealsString != nil && filteredDealsString == "on") {
            
            filterDeal = true
        }else{
            filterDeal = false
        }
        
        if (filterSortMode != nil && filterSortMode == "bestmatch"){
            sortMode = YelpSortMode.BestMatched
        }else if (filterSortMode != nil && filterSortMode == "distance"){
            sortMode = YelpSortMode.Distance
        }else{
            sortMode = YelpSortMode.HighestRated
        }
        
        Business.searchWithTerm("Restaurants", sort: sortMode, categories: filteredCategories, deals:filterDeal) {(businesses: [Business]!, error: NSError!) -> Void in
        self.businesses = businesses
        self.tableView.reloadData()
        self.data.removeAll()
        for business in businesses {
        self.data.append("\(business.name!)")
        print(business.name!)
        print(business.address!)
        }
        }
    }
    
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
    let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessListTableViewCell
    cell.business = businesses[indexPath.row];
    return cell;
    }
    
    //MARK: - SearchBar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        tableView.reloadData()
    }
 
    func hideKeyBoardWithSearchBar(searchBar:UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    

    
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
     //MARK: - Memory Warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
