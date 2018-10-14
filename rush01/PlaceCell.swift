//
//  PlaceCell.swift
//  D05
//
//  Created by Thamsanca MNUNE on 2018/10/08.
//  Copyright © 2018 Thamsanca MNUNE. All rights reserved.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    var place: Place?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(place: Place) {
        self.place = place
        self.placeName.text = place.name
        self.subTitle.text = place.subtitle
    }

}
