import UIKit

class FinishGoalVC: UIViewController {

    @IBOutlet weak var createGoalButton: UIButton!
    @IBOutlet weak var progressTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    var goalDescription:String?
    var goalType:GoalType?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func initData(description:String,type:GoalType){
        goalDescription = description
        goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        createGoalButton.bindToKeyboard()
        //Add Tap Gesture To Dismiss Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToClose))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc private func tapToClose(){
        view.endEditing(true)
    }
    
    @IBAction func createGoalPressed(_ sender: Any) {
        if progressTextField.text != ""{
            saveNewGoal(goalCompleted: progressTextField.text!) { (Finished) in
                performSegue(withIdentifier: UNWIND_TO_GOAL_VC_IDENTIFIER, sender: self)
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetails()
    }
    
    private func saveNewGoal(goalCompleted:String,completion : (_ finished:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: managedContext)
        goal.goalCompleted = Int32(0)
        goal.goalDescription = goalDescription
        goal.goalType = goalType?.rawValue
        goal.goalProgress = Int32(goalCompleted) ?? 0
        do {
            try managedContext.save()
            completion(true)
        }catch {
            debugPrint("saveNewGoal \(error.localizedDescription)")
            completion(false)
        }
    }
}
