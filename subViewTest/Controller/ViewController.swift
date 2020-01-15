import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet var superView: UIView!
    
//    var squares = [SquareTest]()
    var position = CGPoint()
    
    var originS: CGPoint?
    var currentS = CGPoint()
    
    var differenceFromXOrigin: CGFloat?
    var differenceFromYOrigin: CGFloat?
    
    let swipeController = SwipeController()
    
//MARK: - View preparation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOne() //prepare the subview
        setOne() //prepare the subview
        
    }
    override func viewDidLayoutSubviews() {
        
        originS = CGPoint(x: self.view.center.x , y: view.convert(view.center, to: squares[1]).y+30)
        swipeController.squares[0].alpha = 0.0
        
        //Layout
        layerSetUp(view: squares[0])
        layerSetUp(view: squares[1])
        
        layoutButton(button: leftButton)
        layoutButton(button: rightButton)
        
    }
    func layoutButton(button : UIButton) {
        
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.systemOrange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        button.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    //MARK: - Methods and Logic
    @objc func tapHandler() {
        
    }
    @IBAction func btnTouched(_ sender: UIButton) {
        
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
    @objc func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        let finalPoint = CGPoint(x:originS!.x + 1000,
                                 y:originS!.y + 50)
        
        swipeController.animateCardInOut(finalPoint: finalPoint, view: recognizer.view!)
        
        squares[1].setAnchorPoint(CGPoint(x: 0.5,y: 0.5))
        squares[1].removeFromSuperview()
        animateReload(view: squares[0])
    }
    func handlePanEnded(velocity: CGPoint, recognizer: UIPanGestureRecognizer){
        if Float(differenceFromXOrigin!) >= Float(150) {
            
            squares[1].rotate()
            
            let finalPoint = CGPoint(x:originS!.x + (velocity.x),
                                     y:originS!.y + (velocity.y))
            
            swipeController.animateCardInOut(finalPoint: finalPoint, view: recognizer.view!)
            
            squares[1].setAnchorPoint(CGPoint(x: 0.5,y: 0.5))
            squares[1].removeFromSuperview()
            squares[0].transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            animateReload(view: squares[0])
            
        }else if Float(differenceFromXOrigin!) < Float(150) {
            
            squares[1].rotate()
            
            let finalPoint = CGPoint(x:originS!.x , y:originS!.y)
            self.squares[1].setAnchorPoint(CGPoint(x: 0.5 ,y: 0.5))
            swipeController.animateCardInOut(finalPoint: finalPoint, view: recognizer.view!)
            
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

    func animateReload(view: UIView) {
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, animations: {
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
    //MARK: - SubView setting
    func setOne() {
        
        let newSquare = SquareTest()
        
        swipeController.squares.append(newSquare)
        
        view.addSubview(newSquare)
        
        newSquare.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newSquare.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            newSquare.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            newSquare.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60),
            newSquare.bottomAnchor.constraint(equalTo: rightButton.topAnchor, constant: -20),
        ])
        
        let panTest = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        newSquare.addGestureRecognizer(panTest)
        
        let swipeGest = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        newSquare.addGestureRecognizer(swipeGest)

    }
    func layerSetUp(view: UIView) {
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]

        view.layer.insertSublayer(gradient, at: 0)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        
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
