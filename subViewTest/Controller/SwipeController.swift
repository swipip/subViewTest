//
//  swipeView.swift
//  subViewTest
//
//  Created by Gautier Billard on 15/01/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

protocol SwipeControllerDelegate {
    func didFinishedAnimateReload()
}

class SwipeController {
    
    var squares = [SquareTest]()
    var delegate: SwipeControllerDelegate?
    var originS: CGPoint?
    var currentS = CGPoint()
    var differenceFromXOrigin: CGFloat?
    var differenceFromYOrigin: CGFloat?
    var motherView: UIView
    
    init(view: UIView) {
        motherView = view
    }
    
    func animateCardInOut(finalPoint: CGPoint, view: UIView){
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        view.center = finalPoint },
                       completion: nil)
        
    }
    func animateReload(view: UIView) {
        self.motherView.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 1
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (Bool) in
            self.delegate?.didFinishedAnimateReload()
            self.squares.remove(at: 1)
        }

    }
    func changeRotationDirection(recognizer: UIPanGestureRecognizer) {
        if originS!.x > currentS.x {
            squares[1].rotate()
            defineRotationDirection(recognizer: recognizer)
        }else if originS!.x < currentS.x{
            squares[1].rotate()
            defineRotationDirection(recognizer: recognizer)
        }
    }
    func defineRotationDirection(recognizer: UIPanGestureRecognizer) {
        if recognizer.velocity(in: squares[1]).x < 0 {
            squares[1].setAnchorPoint(CGPoint(x: 0.5, y: 0.9))
            squares[1].rotated = (true, .right)
            squares[1].rotate()
        }else{
            squares[1].setAnchorPoint(CGPoint(x: 0.5, y: 0.9))
            squares[1].rotated = (true, .left)
            squares[1].rotate()
        }
    }
    func handlePanEnded(velocity: CGPoint, recognizer: UIPanGestureRecognizer){
        if Float(differenceFromXOrigin!) >= Float(150) {
            
            squares[1].rotate()
            
            let finalPoint = CGPoint(x:originS!.x + (velocity.x),
                                     y:originS!.y + (velocity.y))
            
            animateCardInOut(finalPoint: finalPoint, view: recognizer.view!)
            
            squares[1].setAnchorPoint(CGPoint(x: 0.5,y: 0.5))
            squares[1].removeFromSuperview()
            squares[0].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
            animateReload(view: squares[0])
            
        }else if Float(differenceFromXOrigin!) < Float(150) {
            
            squares[1].rotate()
            
            let finalPoint = CGPoint(x:originS!.x , y:originS!.y)
            self.squares[1].setAnchorPoint(CGPoint(x: 0.5 ,y: 0.5))
            animateCardInOut(finalPoint: finalPoint, view: recognizer.view!)
            
        }
    }
    func handlePan(recognizer: UIPanGestureRecognizer){
         currentS = squares[1].center
         let translation = recognizer.translation(in: motherView)
         let velocity = recognizer.velocity(in: motherView)
         
         differenceFromXOrigin = abs((originS?.x)! - currentS.x)
         differenceFromYOrigin = abs((originS?.y)! - currentS.y)
         
         switch recognizer.state {
         case .began:
             defineRotationDirection(recognizer: recognizer)
         case .ended:
             handlePanEnded(velocity: velocity, recognizer: recognizer)
         case .changed:
             changeRotationDirection(recognizer: recognizer)
         default:
             print("error")
         }
         
         if let view = recognizer.view {
             view.center = CGPoint(x:view.center.x + translation.x,
                                   y:view.center.y + translation.y)
         }
         recognizer.setTranslation(CGPoint.zero, in: motherView)
     }
    func handleSwipe(with recognizer: UISwipeGestureRecognizer) {
        let finalPoint = CGPoint(x:originS!.x + 1000,
                                 y:originS!.y + 50)
        
        animateCardInOut(finalPoint: finalPoint, view: recognizer.view!)
        squares[1].setAnchorPoint(CGPoint(x: 0.5,y: 0.5))
        squares[1].removeFromSuperview()
        animateReload(view: squares[0])
    }
}
