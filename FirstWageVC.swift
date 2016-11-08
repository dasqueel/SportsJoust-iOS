import UIKit
import Locksmith
import Alamofire
import SwiftyJSON

class FirstWageVC: UIViewController {
    
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    var code:String!
    var matchId:String!
    
    var uQBStr:String!
    var uRB1Str:String!
    var uRB2Str:String!
    var uWR1Str:String!
    var uWR2Str:String!
    var uTEStr:String!
    var uDEFStr:String!
    
    var opTeamStr:String!
    var opQBStr:String!
    var opRB1Str:String!
    var opRB2Str:String!
    var opWR1Str:String!
    var opWR2Str:String!
    var opTEStr:String!
    var opDEFStr:String!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var uQB: UILabel!
    @IBOutlet weak var uRB1: UILabel!
    @IBOutlet weak var uRB2: UILabel!
    @IBOutlet weak var uWR1: UILabel!
    @IBOutlet weak var uWR2: UILabel!
    @IBOutlet weak var uTE: UILabel!
    @IBOutlet weak var uDEF: UILabel!
    
    @IBOutlet weak var opUserName: UILabel!
    @IBOutlet weak var opQB: UILabel!
    @IBOutlet weak var opRB1: UILabel!
    @IBOutlet weak var opRB2: UILabel!
    @IBOutlet weak var opWR1: UILabel!
    @IBOutlet weak var opWR2: UILabel!
    @IBOutlet weak var opTE: UILabel!
    @IBOutlet weak var opDEF: UILabel!
    
    
    @IBOutlet weak var wagerText: UITextField!
    
    @IBAction func sendWager(sender: AnyObject) {
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        //post request to send wager
        let wage:Int = wagerText.text.toInt()!
        println(wage)
        var params = ["mtoken": mtoken, "contest": code, "matchId": matchId, "wager": wage]
        
        Alamofire.request(.POST, "http://52.24.226.232/msetWager", parameters: params as? [String : AnyObject], encoding: .JSON)
            .responseString { _, _, string, _ in
                //println(string)
                
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    var outcome = json["outcome"].stringValue
                    
                    if outcome == "user insufficient" {
                        let alert = UIAlertView()
                        alert.title = "Wager Error"
                        alert.message = "You have insufficient funds"
                        alert.addButtonWithTitle("Understood")
                        alert.show()
                    }
                    else if outcome == "opp insufficient" {
                        let alert = UIAlertView()
                        alert.title = "Wager Error"
                        alert.message = "Opponent has insufficient funds"
                        alert.addButtonWithTitle("Understood")
                        alert.show()
                    }
                    else if outcome == "set new wager and turn" {
                        let alert = UIAlertView()
                        alert.title = "Wager Sent!"
                        alert.message = "Waiting for opponents response"
                        alert.addButtonWithTitle("Understood")
                        alert.show()
                        
                        //segue back to matches
                        self.performSegueWithIdentifier("firstWageToMatch", sender: self)
                        
                        //send push notifaction to opponent
                        
                    }
                }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        var userNameText = dictionary!.valueForKey("userName") as! String
        self.userName.text = userNameText
        
        Alamofire.request(.GET, "http://52.24.226.232/mbarter", parameters: ["mtoken": mtoken, "contest": code, "matchId":matchId])
            .responseString { _, _, string, _ in
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    
                    let json = JSON(data: dataFromString)
                    
                    self.matchId = json["matchId"].stringValue
                    
                    self.uQB.text = json["uQb"].stringValue
                    self.uRB1.text = json["uRb1"].stringValue
                    self.uRB2.text = json["uRb2"].stringValue
                    self.uWR1.text = json["uWr1"].stringValue
                    self.uWR2.text = json["uWr2"].stringValue
                    self.uTE.text = json["uTe"].stringValue
                    self.uDEF.text = json["uDef"].stringValue
                    
                    self.opUserName.text = json["opTeam"].stringValue
                    self.opQB.text = json["opQb"].stringValue
                    self.opRB1.text = json["opRb1"].stringValue
                    self.opRB2.text = json["opRb2"].stringValue
                    self.opWR1.text = json["opWr1"].stringValue
                    self.opWR2.text = json["opWr2"].stringValue
                    self.opTE.text = json["opTe"].stringValue
                    self.opDEF.text = json["opDef"].stringValue
                    
                }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "firstWageToMatch") {
            var matchCont: MatchesVC = segue.destinationViewController
                as! MatchesVC
            
            matchCont.code = code
        }
    }
    
}
