//
//  DeviceTableViewController.swift
//  TableViewDemo
//
//  Created by jingzhiwei on 4/9/17.
//  Copyright © 2017 jingzhiwei. All rights reserved.
//

import UIKit

class DeviceTableViewController: UITableViewController {

    var loadMoreView: UIActivityIndicatorView?
    
    
    lazy var nameList = {
        () -> [String] in
        
        var nameArray = [String]()
        for index in 0..<20 {
            nameArray.append("fex:\(index)")
        }
        
        return nameArray
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let refreshCC = UIRefreshControl()
        refreshCC.addTarget(self, action: #selector(DeviceTableViewController.refresh), for: UIControlEvents.valueChanged)

        self.refreshControl = refreshCC
        
        loadMoreView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44.0))
        loadMoreView?.activityIndicatorViewStyle = .gray
        self.tableView.tableFooterView = loadMoreView
    }
    
    func refresh() -> Void {
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Start Fresh")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Freshing")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "Fresh over")
            
            self.tableView.reloadData()
            
            self.refreshControl?.endRefreshing()

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nameList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCellID", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = nameList[indexPath.row]

        return cell
    }
 

    @IBAction func loadMore(_ sender: UIBarButtonItem?) {
        
        let currentNub = nameList.count
        
        if currentNub < 60 {
            
            for index in currentNub..<currentNub+20 {
                nameList.append("fex:\(index)")
            }
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { 
                self.tableView.reloadData()
                self.loadMoreView?.stopAnimating()
            })
        } else {
            self.loadMoreView?.stopAnimating()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffset = scrollView.contentOffset.y
        let screenHeight = scrollView.frame.size.height
        
        let contentHeight = scrollView.contentSize.height
        
        if (contentOffset + screenHeight) > contentHeight && !(self.loadMoreView?.isAnimating)! {
            loadMoreView?.startAnimating()
            self.loadMore(nil)
        }
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }

}
