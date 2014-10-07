//
//  TwitterCell.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/29/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {
    
    weak var delegate:UpdateTweetsProtocol?
    weak var twitterDelegate:NavigateTwitterProtocol?
    var tweet:Tweet? = nil {
        didSet {
            updateValues()
        }
    }
    
    @IBOutlet weak var retweetImage: UIImageView!
    @IBOutlet weak var retweeterLabel: UILabel!
   
    @IBAction func makeFavorite(sender: AnyObject) {
        if (!tweet!.favorited!) {
            self.delegate!.makeFavoriteTweet(tweet!)
            
        }
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.favoriteButton.highlighted = true
        }
        
    }
    @IBOutlet weak var retweetedImageHeight: NSLayoutConstraint!
    @IBOutlet weak var retweetedImageVerticalHeight: NSLayoutConstraint!
  
    @IBOutlet weak var retweetedTextVerticalHeight: NSLayoutConstraint!
    @IBOutlet weak var timeStampVerticalConstriant: NSLayoutConstraint!
    @IBOutlet weak var screenNameVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameVerticalConstraint: NSLayoutConstraint!
        
    @IBOutlet weak var profileViewVerticalContraint: NSLayoutConstraint!
    
    @IBAction func retweet(sender: AnyObject) {
       
        if (!tweet!.retweeted!) {
            self.delegate!.retweet(tweet!)
           
        }
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.retweetButton.highlighted = true
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func withoutRetweetConstraint() {
        
        retweetedImageHeight.constant = 0.0
        retweetedImageVerticalHeight.constant = 0.0
        retweetedTextVerticalHeight.constant = 0.0
        timeStampVerticalConstriant.constant = 15.0
        profileViewVerticalContraint.constant = 15.0
        usernameVerticalConstraint.constant = 15.0
        screenNameVerticalConstraint.constant = 15.0
        retweeterLabel.hidden = true
        retweetImage.hidden = true
    }
    
    func withRetweetConstraint() {
    
        retweetedImageHeight.constant = 16.0
        retweetedImageVerticalHeight.constant = 9.0
        retweetedTextVerticalHeight.constant = 9.0
        timeStampVerticalConstriant.constant = 30.0
        profileViewVerticalContraint.constant = 30.0
        usernameVerticalConstraint.constant = 30.0
        screenNameVerticalConstraint.constant = 30.0
        retweeterLabel.hidden = false
        retweetImage.hidden = false
  
    
    }
    
    
    @IBOutlet weak var timeAgo: UILabel!
    func updateValues() {
        
        tweetText.text = tweet!.text
        twitterName.text = tweet!.user!.name
        profileView.setImageWithURL(NSURL(string:tweet!.user!.profileImageUrl!))
        profileView.userInteractionEnabled = true
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action:"profileImageTapped:")
        profileView.addGestureRecognizer(recognizer)
        
        
        
        twitterHandle.text = "@\(tweet!.user!.screenname!)"
        timeAgo.text = tweet!.createdAt!.timeAgo()
        
        if (tweet!.favorited!) {
            favoriteButton.highlighted = true
        }
        if (tweet!.retweeted!) {
            retweetButton.highlighted = true
        }
        if (tweet!.retweetCount! == 0 || tweet!.retweeter == nil) {
            withoutRetweetConstraint()
        }
        else {
           
            withRetweetConstraint()
            retweeterLabel.text = "\(tweet!.retweeter!.name!) retweeted"
        }
        
    }
    
    
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!

    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    func profileImageTapped(sender: UITapGestureRecognizer) {
        self.twitterDelegate!.showProfile(tweet!)
        
    }
    
}
