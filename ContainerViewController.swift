//
//  ContainerViewController.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 10/5/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

protocol NavigateTwitterProtocol : class
{
    
    func showProfile(tweet:Tweet)
    func showTweets()
}

class ContainerViewController: UIViewController, NavigateTwitterProtocol {
    
    var viewControllers:NSMutableDictionary = NSMutableDictionary()
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVc = oldViewControllerOrNil {
                oldVc.willMoveToParentViewController(nil)
                oldVc.view.removeFromSuperview()
                oldVc.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.frame = self.contentView.bounds
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var storyboard = UIStoryboard(name:"Main",bundle: nil)
        let homeController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as UIViewController
        viewControllers["tweets_timeline"] = homeController
        let profileController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UIViewController
        viewControllers["profile"] = profileController
        self.activeViewController = homeController
        
        
        
    }
    @IBOutlet weak var mentionsButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBAction func menuButtonTapped(sender: UIButton) {
        if (sender == homeButton) {
            switchToTweetsList(type: "Home")
            
        }
        if (sender == profileButton) {
           switchToProfileView(User.currentUser!)
            
        }
        
        if (sender == mentionsButton) {
            switchToTweetsList(type: "Mentions")
        }
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.centerXLayout.constant = 0.0
            self.view.layoutIfNeeded()
        })
        
    }
    @IBAction func doSwipeBack(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.centerXLayout.constant = 0.0
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    func switchToTweetsList(type:String="") {
        self.activeViewController = viewControllers["tweets_timeline"] as? UIViewController
        let controller = self.activeViewController as UINavigationController
        let tweetsController = controller.viewControllers[0] as TweetsViewController
        if (!type.isEmpty) {
            tweetsController.type = type
            tweetsController.navigationItem.title! = type
        }

    }
    
    func switchToProfileView(user:User) {
        
        let controller = viewControllers["profile"] as UINavigationController
        let profileController = controller.viewControllers[0] as ProfileViewController
        profileController.user = user
        profileController.delegate = self
        self.activeViewController = controller 
       
    }

    @IBOutlet weak var contentView: UIView!
    @IBAction func doSwipe(sender: UISwipeGestureRecognizer) {
        
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: { () -> Void in
                self.centerXLayout.constant = -160.0
                self.view.layoutIfNeeded()
            })
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var centerXLayout: NSLayoutConstraint!
    
    func showProfile(tweet: Tweet) {
        switchToProfileView(tweet.user!)
        
        
    }
    
    func showTweets() {
        
        switchToTweetsList()
        
        
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
