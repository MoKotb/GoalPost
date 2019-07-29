import UIKit

class FinishGoalVC: UIViewController {

    @IBOutlet weak var createGoalButton: UIButton!
    @IBOutlet weak var progressTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var goalDescription:String?
    var goalType:GoalType?
    
    func initData(description:String,type:GoalType){
        goalDescription = description
        goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupView()
    }
    
    private func SetupView(){
        createGoalButton.bindToKeyboard()
        //Add Tap Gesture To Dismiss Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(TapToClose))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc private func TapToClose(){
        view.endEditing(true)
    }
    
    @IBAction func createGoalPressed(_ sender: Any) {
        
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetails()
    }
}
