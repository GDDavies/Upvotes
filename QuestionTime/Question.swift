import Foundation
import Firebase

struct Question {
    
    let key: String
    let text: String
    let addedByUser: String
    let ref: DatabaseReference?
    var votes: Int
    
    init(text: String, addedByUser: String, votes: Int, key: String) {
        self.key = key
        self.text = text
        self.addedByUser = addedByUser
        self.votes = votes
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        text = snapshotValue["text"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        votes = snapshotValue["votes"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "text": text,
            "addedByUser": addedByUser,
            "votes": votes,
            "key": key
        ]
    }
    
}
