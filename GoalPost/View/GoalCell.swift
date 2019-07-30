import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var goalType: UILabel!
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var goalCompletedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(goal:Goal){
        goalCompleted(goal: goal)
        goalDescription.text = goal.goalDescription
        goalType.text = goal.goalType
        goalProgress.text = String(describing: goal.goalCompleted)
    }
    
    private func goalCompleted(goal:Goal){
        if goal.goalCompleted != goal.goalProgress{
            goalCompletedView.isHidden = true
        }else{
            goalCompletedView.isHidden = false
        }
    }
}
