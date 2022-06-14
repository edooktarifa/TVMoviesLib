//
//  CardView.swift
//  Pods-TVMoviesLib_Example
//
//  Created by Phincon on 13/06/22.
//

import UIKit

public final class CardView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardViewImg: UIImageView!
    @IBOutlet weak var cardViewLbl: UILabel!
    
    public var titleText: String? {
        didSet {
            cardViewLbl.text = titleText
        }
    }


    public override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
    
        let bundle = Bundle(for: self.CardView)
        bundle.loadNibNamed("CardView", owner: nil, options: nil)?.first
//
//
//        addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
}
