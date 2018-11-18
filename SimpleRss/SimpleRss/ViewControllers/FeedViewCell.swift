//
//  FeedViewCell.swift
//  SimpleRss
//
//  Created by Voldem on 11/18/18.
//  Copyright © 2018 Vladimir Koptev. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {

    let previewImage = UIImageView()
    let dateLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        previewImage.clipsToBounds = true
        previewImage.contentMode = UIView.ContentMode.scaleToFill
        previewImage.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        self.contentView.addSubview(previewImage)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(titleLabel)
        //self.contentView.addSubview(descriptionLabel)
        
       /* let viewsDict = [
            "previewImage" : previewImage,
            "dateLabel" : dateLabel,
            "titleLabel" : titleLabel,
            "descriptionLabel" : descriptionLabel,
            ]
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLabel(30)]-10-[previewImage(200)]-10-[descriptionLabel(30)]-10-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
        
        let titleHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[titleLabel][dateLabel]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[previewImage]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewsDict)
        
        NSLayoutConstraint.activate(verticalConstraints)
        NSLayoutConstraint.activate(horizontalConstraints)
        NSLayoutConstraint.activate(titleHorizontalConstraints)*/

        let titleLabelLeftAhchor = titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        
        let titleLabelTopAhchor = titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        
        let dateLabelLeftAhchor = dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        
        let dateLabelTopAhchor = dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        
        let previewImageLeftAnchor = previewImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        
        let previewImageRightAnchor = previewImage.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
        
        let previewImageTopAnchor = previewImage.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor)
        
        let previewImageBottomAnchor = previewImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        
        let previewImageHeightConstraint = previewImage.heightAnchor.constraint(equalToConstant: 100)

       
        contentView.addConstraints([titleLabelLeftAhchor, titleLabelTopAhchor, dateLabelLeftAhchor, dateLabelTopAhchor, previewImageLeftAnchor, previewImageRightAnchor, previewImageTopAnchor, previewImageBottomAnchor, previewImageHeightConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
