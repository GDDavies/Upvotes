import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    private var _refHandle: DatabaseHandle!
    var questions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        configureDatabase()
    }
    
    deinit {
        if let _ = _refHandle {
            self.ref.child("questions").removeObserver(withHandle: _refHandle)
        }
    }
    
    private func configureDatabase() {
        var questionsArray = [Question]()
        _refHandle = ref.child("questions").observe(.childAdded, with: { (snapshot) -> Void in
            if let value = snapshot.value as? [String:AnyObject] {
                let questionValue = value["text"] as! String
                let user = value["addedByUser"] as! String
                let votes = value["votes"] as! Int
                let key = value["key"] as! String
                let question = Question(text: questionValue, addedByUser: user, votes: votes, key: key)
                questionsArray.append(question)
            }
            self.questions = questionsArray.sorted { $0.votes > $1.votes }
            self.tableView.reloadData()
        })
    }

    @IBAction func addQuestionTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Question",
                                      message: "Ask a question",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            let questionItemRef = self.ref.child("questions").childByAutoId()
            let questionItem = Question(text: text, addedByUser: "Anon", votes: 0, key: questionItemRef.key)
            
            questionItemRef.setValue(questionItem.toAnyObject())
            self.configureDatabase()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func makeUpVote(sender: UIButton) {
        let question = ref.child("questions/\(questions[sender.tag].key)")
        question.updateChildValues(["votes" : questions[sender.tag].votes + 1])
        configureDatabase()
    }
    
    @objc private func makeDownVote(sender: UIButton) {
        let question = ref.child("questions/\(questions[sender.tag].key)")
        question.updateChildValues(["votes" : questions[sender.tag].votes - 1])
        configureDatabase()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCellId") as? QuestionTableViewCell
        if self.questions.count > 0 {
            let question = self.questions[indexPath.row]
            cell?.questionLbl.text = question.text
            cell?.votesLbl.text = question.votes.description
            cell?.upvoteBtn.addTarget(self, action: #selector(makeUpVote(sender:)), for: .touchUpInside)
            cell?.downvoteBtn.addTarget(self, action: #selector(makeDownVote(sender:)), for: .touchUpInside)
            cell?.upvoteBtn.tag = indexPath.row
            cell?.downvoteBtn.tag = indexPath.row
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

