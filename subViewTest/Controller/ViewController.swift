import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet var superView: UIView!
    
    var squares = [SquareTest]()
    var position = CGPoint()
    
    var originS: CGPoint?
    var currentS = CGPoint()
    
    var differenceFromXOrigin: CGFloat?
    var differenceFromYOrigin: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOne()
        setOne()
        
    }
    override func viewDidLayoutSubviews() {
        
        originS = CGPoint(x: self.view.center.x , y: view.convert(view.center, to: squares[1]).y)
        squares[0].alpha = 0.0
        
        layerSetUp(view: squares[0])
        layerSetUp(view: squares[1])
        
    }
    func layerSetUp(view: UIView) {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]

        view.layer.insertSublayer(gradient, at: 0)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
    }
    @objc func tapHandler() {
        
    }
    @IBAction func btnTouched(_ sender: UIButton) {
        
//        setOne()
        
//        let panTest = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
//
//        square.addGestureRecognizer(panTest)
        
    }
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        
        currentS = squares[1].center
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
            
            squares[1].rotate()
            
            let finalPoint = CGPoint(x:originS!.x + (velocity.x),
                                     y:originS!.y + (velocity.y))
            
            animateCardInOut(finalPoint: finalPoint, recognizer: recognizer)
            
            squares[1].setAnchorPoint(CGPoint(x: 0.5,y: 0.5))
            squares[1].removeFromSuperview()
            animateReload(view: squares[0])
            
        }else if Float(differenceFromXOrigin!) < Float(150) {
            
            squares[1].rotate()
            
            let finalPoint = CGPoint(x:originS!.x , y:originS!.y)
            self.squares[1].setAnchorPoint(CGPoint(x: 0.5 ,y: 0.5))
            animateCardInOut(finalPoint: finalPoint, recognizer: recognizer)
            
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
    func animateCardInOut(finalPoint: CGPoint, recognizer: UIPanGestureRecognizer){
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                        recognizer.view!.center = finalPoint },
                       completion: nil)
        
    }
    func animateReload(view: UIView) {
        self.view.layoutIfNeeded()
        self.squares[0].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 1
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (Bool) in
            self.setOne()
            self.squares.remove(at: 1)
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
    //MARK: - View setting
    func setOne() {
        
        let newSquare = SquareTest()
        
        squares.append(newSquare)
        
        view.addSubview(newSquare)
        
        newSquare.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newSquare.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            newSquare.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            newSquare.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            newSquare.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20),
        ])
        
        let panTest = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        newSquare.addGestureRecognizer(panTest)

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
