import UIKit

class SquareTest: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var innerTile: UIView!
    
    var position = CGPoint()
    var rotated:(on: Bool,dir: rotatedCases) = (false,.right)
    
    enum rotatedCases {
        case right, left
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("fatal error")
    }
    func setUp() {
        Bundle.main.loadNibNamed("SquareTest", owner: self, options: nil)
        
        addSubview(contentView)
        
        contentView.frame = self.bounds
    }
    func rotateSquare(angle: CGFloat){
        
        UIView.animate(withDuration: 0.2, animations: {
           self.transform = self.transform.rotated(by: angle)
        })
        
    }
    func rotate() {
        
        if self.rotated.on == false {
            // view is not in rotated state
            if self.rotated.dir == .right {
                
                self.rotateSquare(angle: CGFloat(Double.pi / 32))
                
            }else{

                self.rotateSquare(angle: -CGFloat(Double.pi / 32))
                
            }
        }else{
            //view is not in a rotated state
            if self.rotated.dir == .right{
                self.rotateSquare(angle: -CGFloat(Double.pi / 32))
                self.rotated.on = false
            }else{
                self.rotateSquare(angle: +CGFloat(Double.pi / 32))
                self.rotated.on = false
            }
        }
       
    }
    func animateOut() {
        
        position = CGPoint(x: self.frame.origin.x + 450.0, y: self.frame.origin.y)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = CGRect(x: self.position.x, y: self.position.y, width: self.frame.size.width, height: self.frame.size.height)
        }, completion:{(finished: Bool) in  self.removeFromSuperview()
            //            self.setOne()
        })
    }
    
    
}
