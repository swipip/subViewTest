//
//  swipeView.swift
//  subViewTest
//
//  Created by Gautier Billard on 15/01/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

class SwipeController {
    
    var squares = [SquareTest]()
    
    func animateCardInOut(finalPoint: CGPoint, view: UIView){
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        view.center = finalPoint },
                       completion: nil)
        
    }
}
