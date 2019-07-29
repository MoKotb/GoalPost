import UIKit

class GoalVC: UIViewController {

    @IBOutlet weak var welcomeMessage: UIStackView!
    @IBOutlet weak var goalsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalsTable.delegate = self
        goalsTable.dataSource = self
        goalsTable.isHidden = true
        welcomeMessage.isHidden = false
    }
    
    @IBAction func AddNewGoal(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: CREATE_GOAL_VC_IDENTIFIER) as? CreateGoalVC else { return }
        presentDetails(createGoalVC)
    }
}

extension GoalVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GOAL_CELL_IDENTIFIER, for: indexPath) as? GoalCell{
            return cell
        }else{
            return GoalCell()
        }
    }
}
