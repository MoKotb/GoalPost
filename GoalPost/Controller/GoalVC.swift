import UIKit
import CoreData

class GoalVC: UIViewController {

    @IBOutlet weak var welcomeMessage: UIStackView!
    @IBOutlet weak var goalsTable: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var goalsList = [Goal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareForSetGoals()
        goalsTable.reloadData()
    }
    
    private func setupView(){
        goalsTable.delegate = self
        goalsTable.dataSource = self
        goalsTable.isHidden = true
        welcomeMessage.isHidden = false
    }
    
    @IBAction func AddNewGoal(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: CREATE_GOAL_VC_IDENTIFIER) as? CreateGoalVC else { return }
        presentDetails(createGoalVC)
    }
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){}
    
    private func prepareForSetGoals(){
        requestGoalsData { (finished) in
            if finished {
                if goalsList.count > 0 {
                    goalsTable.isHidden = false
                    welcomeMessage.isHidden = true
                }else{
                    goalsTable.isHidden = true
                    welcomeMessage.isHidden = false
                }
            }
        }
    }
}

extension GoalVC: UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GOAL_CELL_IDENTIFIER, for: indexPath) as? GoalCell{
            let goal = goalsList[indexPath.row]
            cell.configureCell(goal: goal)
            return cell
        }else{
            return GoalCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.deleteSelectedGoal(index: indexPath, completion: { (finished) in
                if finished{
                    self.prepareForSetGoals()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        let editAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.updateSelectedGoal(index: indexPath, completion: { (finished) in
                if finished{
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            })
        }
        editAction.backgroundColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        let goal = goalsList[indexPath.row]
        if goal.goalCompleted == goal.goalProgress{
            return [deleteAction]
        }
        return [deleteAction,editAction]
    }
}

extension GoalVC{
    
    private func requestGoalsData(completion:(_ finished:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do{
            goalsList = try managedContext.fetch(fetchRequest)
            completion(true)
        }catch{
            debugPrint("RequestGoalsData \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func deleteSelectedGoal(index:IndexPath,completion:(_ finished:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(goalsList[index.row])
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint("DeleteSelectedGoal \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func updateSelectedGoal(index:IndexPath,completion:(_ finished:Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let selectedGoal = goalsList[index.row]
        if selectedGoal.goalProgress > selectedGoal.goalCompleted{
            selectedGoal.goalCompleted = selectedGoal.goalCompleted + 1
        }else{
            return
        }
        do{
            try managedContext.save()
            completion(true)
        }catch{
            debugPrint("updateSelectedGoal \(error.localizedDescription)")
            completion(false)
        }
    }
}
