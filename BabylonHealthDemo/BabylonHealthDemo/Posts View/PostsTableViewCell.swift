//
//  PostsTableViewCell.swift
//  BabylonHealthDemo
//
//  Created by Evan Roth on 10/25/17.
//  Copyright © 2017 Evan Roth. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
	@IBOutlet weak var postTitleLabel: UILabel!
	@IBOutlet weak var postBodyLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
