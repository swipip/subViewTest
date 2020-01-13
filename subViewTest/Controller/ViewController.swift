import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var superView: UIView!
    
    var square = SquareTest()
    var position = CGPoint()
    
    var originS: CGPoint?
    var currentS = CGPoint()
    
    var differenceFromXOrigin: CGFloat?
    var differenceFromYOrigin: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        
        originS = CGPoint(x: self.view.center.x , y: view.convert(view.center, to: square).y)
        
    }
    @objc func tapHandler() {
        
    }
    @IBAction func btnTouched(_ sender: UIButton) {
        
        setOne()
        
        let panTest = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        
        square.addGestureRecognizer(panTest)
        
    }
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        currentS = square.center
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
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
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    func handlePanEnded(velocity: CGPoint, recognizer: UIPanGestureRecognizer){
        if Float(differenceFromXOrigin!) >= Float(150) {
            
            square.rotate()
            
            let finalPoint = CGPoint(x:originS!.x + (velocity.x),
                                     y:originS!.y + (velocity.y))
            
            animateCardInOut(finalPoint: finalPoint, recognizer: recognizer)
            
            self.square.setAnchorPoint(CGPoint(x: 0.5,y: 0.5))
            self.square.removeFromSuperview()
            
        }else if Float(differenceFromXOrigin!) < Float(150) {
            
            square.rotate()
            
            let finalPoint = CGPoint(x:originS!.x , y:originS!.y)
            self.square.setAnchorPoint(CGPoint(x: 0.5 ,y: 0.5))
            animateCardInOut(finalPoint: finalPoint, recognizer: recognizer)
            
        }
    }
    func changeRotationDirection(recognizer: UIPanGestureRecognizer) {
        if originS!.x > currentS.x {
            square.rotate()
            defineRotationDirection(recognizer: recognizer)
        }else if originS!.x < currentS.x{
            square.rotate()
            defineRotationDirection(recognizer: recognizer)
        }
    }
    func animateCardInOut(finalPoint: CGPoint, recognizer: UIPanGestureRecognizer){
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        recognizer.view!.center = finalPoint },
                       completion: nil)
        
    }
    func defineRotationDirection(recognizer: UIPanGestureRecognizer) {
        if recognizer.velocity(in: square).x < 0 {
            square.setAnchorPoint(CGPoint(x: 0.5, y: 0.9))
            square.rotated = (true, .right)
            square.rotate()
        }else{
            square.setAnchorPoint(CGPoint(x: 0.5, y: 0.9))
            square.rotated = (true, .left)
            square.rotate()
        }
    }
    //MARK: - View setting
    func setOne() {
        
        view.addSubview(square)
        
        square.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            square.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            square.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            square.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            square.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
        ])
        
        let testTouch = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        
        square.innerTile.addGestureRecognizer(testTouch)
        
        self.square.alpha = 1
        
    }
}
//MARK: - Extensions
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    func getCenter() -> CGPoint {
        let x = self.frame.width/2
        print(self.frame.width)
        let y = self.frame.height/2
        return CGPoint(x: x, y: y)
    }
}
