//
//  LocationCell.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

protocol CallOrLocationButtonDelegate {
    
    func callOrLocationButtonPressed(_ item: IndexPath, sentderTag:Int)
}

class LocationCell: UITableViewCell {

    @IBOutlet weak var shopeNameLabel: UILabel!
    @IBOutlet weak var addressNameLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var indexPath : IndexPath!
    
    var delegate: CallOrLocationButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didCallOrLocationButtonPressed (_ sender: UIButton!){
        self.delegate?.callOrLocationButtonPressed(self.indexPath, sentderTag: sender.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
