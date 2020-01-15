import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet var superView: UIView!
    
    var position = CGPoint()
    
    var originS: CGPoint?
    var currentS = CGPoint()
    
    var swipeController: SwipeController?
    
//MARK: - View preparation

    override func viewDidLoad() {
        super.viewDidLoad()
        swipeController = SwipeController(view: self.view)
        swipeController!.delegate = self
        
        setOne() //prepare the subview
        setOne() //prepare the subview
        
    }
    override func viewDidLayoutSubviews() {
        
        originS = CGPoint(x: self.view.center.x , y: view.convert(view.center, to: swipeController!.squares[1]).y+30)
        swipeController!.squares[0].alpha = 0.0
        
        swipeController!.originS = self.originS
        swipeController!.currentS = self.currentS
        
        //Layout
        layerSetUp(view: swipeController!.squares[0])
        layerSetUp(view: swipeController!.squares[1])
        
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
        
        swipeController!.handlePan(recognizer: recognizer)
    }
    @objc func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        
        swipeController!.handleSwipe(with: recognizer)
        
    }
    //MARK: - SubView setting
    public func setOne() {
        
        let newSquare = SquareTest()
        
        swipeController!.squares.append(newSquare)
        
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
extension ViewController: SwipeControllerDelegate{
    func didFinishedAnimateReload() {
        setOne()
    }
}

