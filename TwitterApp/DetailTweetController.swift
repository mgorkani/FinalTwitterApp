//
//  DetailTweetController.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/29/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class DetailTweetController: UIViewController {

    
    
    var tweet:Tweet = Tweet(dictionary: [:])

    @IBOutlet weak var retweets: UILabel!
    @IBOutlet weak var tweetDate: UILabel!
    @IBOutlet weak var tweetHandle: UILabel!
    @IBOutlet weak var tweetName: UILabel!
    weak var delegate:UpdateTweetsProtocol?
    weak var twitterDelegate:NavigateTwitterProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.setImageWithURL(NSURL(string:tweet.user!.profileImageUrl!))
        profileView.userInteractionEnabled = true
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action:"profileImageTapped:")
        profileView.addGestureRecognizer(recognizer)
  
        tweetName.text = tweet.user!.name!
        tweetHandle.text = "@\(tweet.user!.screenname!)"
        tweetText.text = tweet.text
        tweetDate.text = tweet.createdAtString
        retweets.text = "\(tweet.retweetCount!.stringValue) Retweets"
        favorites.text = "\(tweet.favoriteCount!.stringValue) Favorites"
        if (tweet.favorited!) {
            favoriteButton.highlighted = true
        }
        if (tweet.retweeted!) {
            retweetButton.highlighted = true
        }

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var tweetText: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var favorites: UILabel!
    @IBAction func goBack(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
 
    @IBAction func replyTweet(sender: AnyObject) {
        performSegueWithIdentifier("replyFromTweet", sender: self)
        
        
    }

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileView: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func makeFavorite(sender: AnyObject) {
        if (!tweet.favorited!) {
            self.delegate!.makeFavoriteTweet(tweet)
          
        }
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.favoriteButton.highlighted = true
        }
        
        
    }
    
    @IBAction func retweet(sender: AnyObject) {
        
        if (!tweet.retweeted!) {
            self.delegate!.retweet(tweet)
         
        }
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.retweetButton.highlighted = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "replyFromTweet") {
            let navigationController = segue.destinationViewController as UINavigationController
            let replyController = navigationController.viewControllers[0] as ReplyController
            replyController.tweet = tweet
            replyController.delegate = self.delegate
        }
    }
    
    func profileImageTapped(sender: UITapGestureRecognizer) {
        self.twitterDelegate!.showProfile(tweet)
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
    }


}
