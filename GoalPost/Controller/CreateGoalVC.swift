import UIKit

class CreateGoalVC: UIViewController , UITextViewDelegate {

    @IBOutlet weak var goalDescription: UITextView!
    @IBOutlet weak var shortTermButton: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var goalType : GoalType = .ShortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        goalDescription.delegate = self
        nextButton.bindToKeyboard()
        configureGoalType(type: .ShortTerm)
        //Add Tap Gesture To Dismiss Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToClose))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func tapToClose(){
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let description = goalDescription.text else { return }
        if description != "" , description != "What is your goal?" {
            goalDescription.text = description
        }else{
            goalDescription.text = ""
        }
        goalDescription.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    private func configureGoalType(type:GoalType){
        if type == .ShortTerm{
            goalType = .ShortTerm
            shortTermButton.setSelectedColor()
            longTermButton.setDeselectedColor()
        }else{
            goalType = .LongTerm
            longTermButton.setSelectedColor()
            shortTermButton.setDeselectedColor()
        }
    }

    @IBAction func ShortTermPressed(_ sender: Any) {
        configureGoalType(type: .ShortTerm)
    }
    
    @IBAction func LongTermPressed(_ sender: Any) {
        configureGoalType(type: .LongTerm)
    }
    
    @IBAction func NextPressed(_ sender: Any) {
        guard let description = goalDescription.text else { return }
        if description != "" , description != "What is your goal?" {
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: FINISH_GOAL_VC_IDENTIFIER) as? FinishGoalVC else { return }
            finishGoalVC.initData(description: description, type: goalType)
            presentDetails(finishGoalVC)
        }else{
            return
        }
    }
    
    @IBAction func BackPressed(_ sender: Any) {
        dismissDetails()
    }
}
