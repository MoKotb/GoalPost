import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var goalType: UILabel!
    @IBOutlet weak var goalProgress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func ConfigureCell(description:String,type:GoalType,progress:Int){
        goalDescription.text = description
        goalType.text = type.rawValue
        goalProgress.text = String(describing: progress)
    }
}
