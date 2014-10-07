//
//  Tweet.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/28/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit



class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var retweetCount:NSNumber?
    var favoriteCount:NSNumber?
    var id:String?
    var favorited:Bool?
    var retweeted:Bool?
    var retweeter: User?
      
    
    init(dictionary:NSDictionary) {
        if (dictionary.count == 0) {
            return
        }
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        retweetCount = dictionary["retweet_count"] as? NSNumber
        favoriteCount = dictionary["favorite_count"] as? NSNumber
        id = dictionary["id_str"] as? String
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        if (retweetCount! == 0) {
        
            user = User(dictionary: dictionary["user"] as NSDictionary)
        }
        else if (dictionary["retweeted_status"] != nil) {
            retweeter = User(dictionary: dictionary["user"] as NSDictionary)
            var retweetedStatus = dictionary["retweeted_status"] as? NSDictionary
            user = User(dictionary: retweetedStatus!["user"] as NSDictionary)
        }
        else {
            user = User(dictionary: dictionary["user"] as NSDictionary)
        }

  
    }
    
   
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in array {
            var tweet = Tweet(dictionary:dictionary)
            
            
            tweets.append(tweet)
            
        }
        return tweets
    }
    
    func getRetweeterUser() {
        if self.retweetCount! > 0 {
            TwitterClient.sharedInstance.getRetweetUser(self.id!, completion: { (dictionary, error) -> () in
                if (dictionary != nil) {
                    self.retweeter = User(dictionary: dictionary!["user"] as NSDictionary)
                }
            })
        }

    }
   
   
}
