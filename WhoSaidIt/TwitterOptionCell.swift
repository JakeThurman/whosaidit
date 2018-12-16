//
//  TwitterOptionCell.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 12/16/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class TwitterOptionCell: UITableViewCell {

    @IBOutlet weak var twitter1Image: UIImageView!
    @IBOutlet weak var twitter2Image: UIImageView!
    @IBOutlet weak var vsLabel: UILabel!
    
    func render(isSelected: Bool, twitterOne: (String, UIImage?), twitterTwo: (String, UIImage?)) {
        accessoryType = isSelected ? .checkmark : .none

        vsLabel.text = "\(twitterOne.0) VS \(twitterTwo.0)"
        
        twitter1Image.image = twitterOne.1
        twitter2Image.image = twitterTwo.1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
