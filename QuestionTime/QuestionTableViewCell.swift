import UIKit

class QuestionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    
    @IBOutlet weak var upvoteBtn: UIButton!
    @IBOutlet weak var downvoteBtn: UIButton!
    @IBOutlet weak var votesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
