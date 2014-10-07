//
//  ProfileStatsCell.swift
//  TwitterApp
//
//  Created by Monika Gorkani on 10/6/14.
//  Copyright (c) 2014 Monika Gorkani. All rights reserved.
//

import UIKit

class ProfileStatsCell: UITableViewCell {
    
    
    @IBOutlet weak var tweets: UILabel!

    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var following: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUserStats(user:User) {
        
        tweets.text = user.statusCount!.stringValue
        following.text = user.friendsCount!.stringValue
        followers.text = user.followersCount!.stringValue
        
        
    }
    
    
    

}
