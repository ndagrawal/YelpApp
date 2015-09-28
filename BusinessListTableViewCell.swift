//
//  BusinessListTableViewCell.swift
//  Yelp
//
//  Created by Nilesh Agrawal on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var foodListLabel: UILabel!
    @IBOutlet weak var AddressLabel: UILabel!
    
    var business:Business!{
        didSet{
            thumbImageView.setImageWithURL(business.imageURL)
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            AddressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            ratingsImageView.setImageWithURL(business.ratingImageURL)
            foodListLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 5.0
        thumbImageView.clipsToBounds = true
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

    
    
}
