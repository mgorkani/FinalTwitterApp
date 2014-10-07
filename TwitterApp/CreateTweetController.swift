//
//  CreateTweetController.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/30/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class CreateTweetController: UIViewController {
    
    @IBOutlet weak var tweet: UITextView!
    weak var delegate:UpdateTweetsProtocol?

    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var username: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tweet.becomeFirstResponder()
        let user = User.currentUser
        
        
        profileView.setImageWithURL(NSURL(string:user!.profileImageUrl!))
        
        username.text = user!.name!
        twitterHandle.text = "@\(user!.screenname!)"

        // Do any additional setup after loading the view.
    }

    @IBAction func createTweet(sender: AnyObject) {
        
        if (!tweet.text.isEmpty) {
            self.delegate?.postTweet(tweet.text)
        }
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        
    }
    @IBOutlet weak var profileView: UIImageView!
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
