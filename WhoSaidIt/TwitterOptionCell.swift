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
    
    func render(isSelected: Bool, isCustom: Bool, twitterOne: (String, UIImage?), twitterTwo: (String, UIImage?)) {
        backgroundColor = isSelected ? #colorLiteral(red: 0, green: 0.6431372549, blue: 0.9764705882, alpha: 1) : UIColor.white
        vsLabel.textColor = isSelected ? UIColor.white : UIColor.black
        
        if isCustom {
            accessoryType = .disclosureIndicator
        }
        
        vsLabel.text = "\(twitterOne.0)\nVS\n\(twitterTwo.0)"
        
                
        twitter1Image.image = twitterOne.1
        twitter2Image.image = twitterTwo.1
        
        makeRounded(image: twitter1Image)
        makeRounded(image: twitter2Image)
    }
    
    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = image.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        image.clipsToBounds = true
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
