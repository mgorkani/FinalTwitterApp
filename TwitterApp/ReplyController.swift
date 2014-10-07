//
//  ReplyController.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 9/29/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class ReplyController: UIViewController {
    
    var tweet = Tweet(dictionary: [:])
    weak var delegate:UpdateTweetsProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        replyText.becomeFirstResponder()
        replyText.text = "@\(tweet.user!.screenname!) "

        // Do any additional setup after loading the view.
    }

    @IBAction func replyTweet(sender: AnyObject) {
        
        self.delegate!.replyTweet(tweet, status: replyText.text)
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    @IBOutlet weak var replyText: UITextView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
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
