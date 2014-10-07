//
//  TwitterClient.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/28/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

let twitterConsumerKey = "aumxJa3awTt1f4dLQAHh1PRSE"
let twitterConsumerSecret = "H8GIcSm2PS17ijLtkgHcOzKbSUryWZ9J95ZTTHsAWmyt3Zlfzk"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")




class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion : ((user:User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        
    struct Static {
        static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
        }
        
        return Static.instance
    }
    
    func createFavoriteTweet(id:String, completion: ( error: NSError?) -> ()) {
        
        
        self.POST("https://api.twitter.com/1.1/favorites/create.json?id=\(id)", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(error:nil)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            
                completion(error:error)
        }
  
        
    }
    
    func retweet(id:String, completion: ( error: NSError?) -> ()) {
        
        
        self.POST("https://api.twitter.com/1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(error:nil)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                completion(error:error)
        }
        
        
    }
    
    func postTweet(params:NSDictionary?, completion: ( error: NSError?) -> ()) {
        
        
        self.POST("https://api.twitter.com/1.1/statuses/update.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(error:nil)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                completion(error:error)
        }
        
        
    }
    
    func getRetweetUser(id:String, completion: (dictionary:NSDictionary?, error: NSError?) -> ()) {
        
        
        self.GET("1.1/statuses/retweets/\(id).json", parameters: ["count" : 1], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            
            completion(dictionary:response as? NSDictionary, error:nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get retweet: \(error)")
                completion(dictionary: nil, error: error)
        })

        
        
    }

    func mentionsWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        self.GET("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("mentions_timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            completion(tweets: tweets, error:nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to home timeline")
                completion(tweets: nil, error: error)
        })
        
    }


    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        self.GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            println("home_timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            completion(tweets: tweets, error:nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to home timeline")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func loginWithCompletion(completion: (user:User?, error: NSError?) -> ()) {
       loginCompletion = completion
        
        
        // Fetch request token and redirect to authorzation page
        requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string:"https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            
            
            }) { (error:NSError!) -> Void in
                println("Failed to get request token: \(error!)")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func  openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken:BDBOAuthToken!) -> Void in
          //  println("Got the access token!")
            self.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //   println("user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
              //  println("user name: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("failed to get user")
                    self.loginCompletion?(user: nil, error: error)
            })
           
            
            
            }) { (error:NSError!) -> Void in
                println("Failed to home timeline")
                self.loginCompletion?(user: nil, error: error)
        }

        
    }
    
    
}
