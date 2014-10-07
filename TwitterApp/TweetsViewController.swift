//
//  TweetsViewController.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/28/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

protocol UpdateTweetsProtocol : class
{
    func makeFavoriteTweet(tweet:Tweet)
    func retweet(tweet:Tweet)
    func replyTweet(tweet:Tweet, status:String)
    func postTweet(status:String)
  
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateTweetsProtocol{
    
    @IBOutlet weak var retweeterLabel: UILabel!
    var tweets: [Tweet]?
    var refreshControl = UIRefreshControl()
    var type:String = "Home" {
        didSet(oldValue) {
            if type != oldValue {
                // type changed so we need to reload the tweets
                loadTweets();
            }
        }
    }

    
    func loadTweets(refresh:Bool=false) {
        if (!refresh) {
            self.view.showActivityViewWithLabel("Loading")
        }
        // Do any additional setup after loading the view.
        if (type == "Home") {
            TwitterClient.sharedInstance.homeTimelineWithParams(["count":20], completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                if (!refresh) {
                    self.view.hideActivityView()
                }
                else {
                    self.refreshControl.endRefreshing()
                }
            
            })
        }
        else {
            TwitterClient.sharedInstance.mentionsWithParams(["count":20], completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                if (!refresh) {
                    self.view.hideActivityView()
                }
                else {
                     self.refreshControl.endRefreshing()
                }
                
            })

        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTweets()
       
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 141
        self.tableView.rowHeight = UITableViewAutomaticDimension
       
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        
    }
    
       
    func refresh(sender:AnyObject)
    {
       loadTweets(refresh: true)
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logout(sender: AnyObject) {
        
        User.currentUser?.logout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeFavoriteTweet(tweet:Tweet) {
            tweet.favorited = true
        TwitterClient.sharedInstance.createFavoriteTweet(tweet.id!, completion: { (error) -> () in
            if (error != nil) {
                
                println(error)
                tweet.favorited = false
            }
            else {
                self.tableView.reloadData()
            }
        })
    }
    
    func retweet(tweet:Tweet) {
        tweet.retweeted = true
        TwitterClient.sharedInstance.retweet(tweet.id!, completion: { (error) -> () in
            if (error != nil) {
                
                println(error)
                tweet.retweeted = false
            }
            else {
                self.tableView.reloadData()
            }
        })
    }
    
    func replyTweet(tweet:Tweet, status:String) {
        
    var params = NSMutableDictionary()
        params.setValue(status, forKey: "status")
        params.setValue(tweet.id, forKey:"in_reply_to_status_id")
        
        TwitterClient.sharedInstance.postTweet(params, completion: { (error) -> () in
            if (error != nil) {
                
                println(error)
                
            }
            
         })
        
    }
    
    func postTweet(status:String) {
        
        var params = NSMutableDictionary()
        params.setValue(status, forKey: "status")
      
        
        TwitterClient.sharedInstance.postTweet(params, completion: { (error) -> () in
            if (error != nil) {
                
                println(error)
                
            }
           
        })
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell") as TwitterCell
        let tweet = tweets![indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        cell.twitterDelegate = self.navigationController!.parentViewController as ContainerViewController
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            
            var indexPath:NSIndexPath = self.tableView.indexPathForSelectedRow()!
            let tweet = tweets![indexPath.row]

            let navigationController = segue.destinationViewController as UINavigationController
            let detailViewController = navigationController.viewControllers[0] as DetailTweetController
            detailViewController.tweet = tweet
            detailViewController.delegate = self
            detailViewController.twitterDelegate = self.navigationController!.parentViewController as ContainerViewController
            
            
            
            
        }
        if (segue.identifier == "showReplyFromTweets") {
            var button = sender as UIButton
            
            var cell = button.superview!.superview! as TwitterCell
            let tweet = cell.tweet
            let navigationController = segue.destinationViewController as UINavigationController
            let replyController = navigationController.viewControllers[0] as ReplyController
            replyController.tweet = tweet!
            replyController.delegate = self
            
        }
        
          if (segue.identifier == "createTweet") {
            let navigationController = segue.destinationViewController as UINavigationController
            let createTweetController = navigationController.viewControllers[0] as CreateTweetController
            createTweetController.delegate = self

        
        }
      
    }

}
