//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 10/5/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    weak var delegate:NavigateTwitterProtocol?
    
    var user: User? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableHeaderView = self.headerView
   
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if (user!.useBackgroundImage!) {
            self.backgroundImage.image = nil
            self.backgroundImage.setImageWithURL(NSURL(string:user!.backgroundImageUrl!))
        }
        profileImage.image = nil
        profileImage.setImageWithURL(NSURL(string:user!.profileImageUrl!))
        userName!.text = user!.name!
        screenName!.text = "@\(user!.screenname!)"
        if (user!.screenname == User.currentUser!.screenname) {
            navigationItem.title = "Me"
        } else {
            navigationItem.title = user!.name
        }
        tableView.reloadData()

    }
  
    @IBAction func goBack(sender: UIBarButtonItem) {
       self.delegate!.showTweets()
        
    }
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var headerView: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ProfileStatsCell") as ProfileStatsCell
        cell.setUserStats(user!)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int  {
        return 1
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
