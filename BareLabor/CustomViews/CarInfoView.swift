//
//  CarInfoView.swift
//  BareLabor
//
//  Dustin Allen
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit

class CarInfoView: UIView {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var engineSizeLabel: UILabel!
    @IBOutlet weak var yearLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var makeLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var modelLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var engineSizeLabelWidth: NSLayoutConstraint!

    
    override init(frame: CGRect) {
       super.init(frame: frame)
        
        if let view = Bundle.main.loadNibNamed("CarInfoView", owner: self, options: nil)?.first as? UIView {
            view.frame = frame
            view.layoutSubviews()
            view.updateConstraints()
            self.addSubview(view)
            
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        
    }
    
    // MARK: - Public Nethod
    
    func setYear(_ year: String, make: String, model: String, engineSize: String) {
        
        let minLabelWidth : CGFloat = (UIScreen.main.bounds.size.width - (8 * 4) - (24 * 3)) / 3
        
        self.yearLabel.text = year
        self.yearLabelWidth.constant = min(minLabelWidth, self.yearLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.bounds.height)).width + 5)
        
        self.makeLabel.text = make
        self.makeLabelWidth.constant = min(minLabelWidth, self.makeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.bounds.height)).width + 5)
        
        self.modelLabel.text = model
        self.modelLabelWidth.constant = min(minLabelWidth, self.modelLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.bounds.height)).width + 5)
        
        self.engineSizeLabel.text = engineSize
        self.engineSizeLabelWidth.constant = self.engineSizeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.bounds.height)).width + 5
        
        
        
        self.updateConstraints()
        self.layoutSubviews()
    }
}
