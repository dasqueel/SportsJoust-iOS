import UIKit
import Alamofire
import SwiftyJSON
import Locksmith

class MatchesVC: UIViewController {
    
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    var code:String!
    
    var matchId: String!
    var opTeam: String!
    
    var uQBText: String!
    var uRB1Text: String!
    var uRB2Text: String!
    var uWR1Text: String!
    var uWR2Text: String!
    var uTEText: String!
    var uDEFText: String!
    
    var opUserNameText: String!
    var opQBText: String!
    var opRB1Text: String!
    var opRB2Text: String!
    var opWR1Text: String!
    var opWR2Text: String!
    var opTEText: String!
    var opDEFText: String!

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
    
    @IBAction func reject(sender: AnyObject) {
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        
        let parameters = ["outcome":"reject","mtoken":mtoken,"contest":code,"matchId":matchId,"opTeam":opTeam]
        Alamofire.request(.POST, "http://52.24.226.232/mpostMatch", parameters: parameters, encoding: .JSON)
            .responseString { _, _, string, _ in
                //if rejection completed, grab a new match
                //println(string)
                
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    let resp = json["matchResp"].stringValue
                    //println(resp)
                    
                    //get a new match
                    self.displayMatch(mtoken,code: self.code)
                }
        }
    }
    
    @IBAction func accept(sender: AnyObject) {
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        
        let parameters = ["outcome":"accept","mtoken":mtoken,"contest":code,"matchId":matchId,"opTeam":opTeam]
        Alamofire.request(.POST, "http://52.24.226.232/mpostMatch", parameters: parameters, encoding: .JSON)
            .responseString { _, _, string, _ in
                //if rejection completed, grab a new match
                //println(string)
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    let resp = json["matchResp"].stringValue
                    //println(resp)
                    
                    //if user is first to accept
                    if resp == "added user to opponents potential" {
                        self.displayMatch(mtoken,code: self.code)
                    }
                        //else second user to accept and its a match
                    else if resp == "matched" {
                        //alert user
                        let alert = UIAlertView()
                        alert.title = "Matched"
                        alert.message = "start wager negotiation"
                        alert.addButtonWithTitle("Understood")
                        alert.show()
                        
                        //segway
                        self.performSegueWithIdentifier("matchToBarter", sender: self)
                        
                    }
                }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        var userNameText = dictionary!.valueForKey("userName") as! String
        self.userName.text = userNameText
        println(mtoken+code);
        displayMatch(mtoken,code: code)
        /*
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                //send accept post
                let parameters = ["outcome":"accept","mtoken":mtoken,"contest":code,"matchId":matchId,"opTeam":opTeam]
                Alamofire.request(.POST, "http://52.24.226.232/mpostMatch", parameters: parameters, encoding: .JSON)
                    .responseString { _, _, string, _ in
                        //if rejection completed, grab a new match
                        //println(string)
                        if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                            let json = JSON(data: dataFromString)
                            let resp = json["matchResp"].stringValue
                            //println(resp)
                            
                            //if user is first to accept
                            if resp == "added user to opponents potential" {
                                self.displayMatch(mtoken,code: self.code)
                            }
                            //else second user to accept and its a match
                            else if resp == "matched" {
                                //alert user
                                let alert = UIAlertView()
                                alert.title = "Matched"
                                alert.message = "start wager negotiation"
                                alert.addButtonWithTitle("Understood")
                                alert.show()

                                //segway
                                self.performSegueWithIdentifier("matchToBarter", sender: self)
                                
                            }
                        }
                }
            case UISwipeGestureRecognizerDirection.Left:
                //send reject post
                let parameters = ["outcome":"reject","mtoken":mtoken,"contest":code,"matchId":matchId,"opTeam":opTeam]
                Alamofire.request(.POST, "http://52.24.226.232/mpostMatch", parameters: parameters, encoding: .JSON)
                    .responseString { _, _, string, _ in
                        //if rejection completed, grab a new match
                        //println(string)

                        if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                            let json = JSON(data: dataFromString)
                            let resp = json["matchResp"].stringValue
                            //println(resp)
                            
                            //get a new match
                            self.displayMatch(mtoken,code: self.code)
                        }
                }
                

            default:
                break
            }
        }
    }*/
    
    func displayMatch(mtoken:String,code:String){
        Alamofire.request(.GET, "http://52.24.226.232/mgetMatch", parameters: ["mtoken": mtoken, "contest": code])
            .responseString { _, _, string, _ in
                if string == "no possible matches" {
                    // render no possibles matches to view
                    self.performSegueWithIdentifier("matchToHome", sender: self)
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "No matches at this time"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                    //let vc = self.storyboard.instantiateViewControllerWithIdentifier("noMatches")
                    //self.presentViewController(vc, animated: false, completion: nil)
                }
                    
                else if string == "no rankings entered" {
                    // segue to contests qb rankings
                    //add contest code as well
                    //self.performSegueWithIdentifier("matchToRank", sender: self)
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "Enter contest first.  Complete all rankings"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else {
                    if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                        
                        let json = JSON(data: dataFromString)
                        
                        self.matchId = json["matchId"].stringValue
                        
                        self.uQB.text = json["uQb"].stringValue
                        self.uQBText = json["uQb"].stringValue
                        self.uRB1.text = json["uRb1"].stringValue
                        self.uRB1Text = json["uRb1"].stringValue
                        self.uRB2.text = json["uRb2"].stringValue
                        self.uRB2Text = json["uRb2"].stringValue
                        self.uWR1.text = json["uWr1"].stringValue
                        self.uWR1Text = json["uWr1"].stringValue
                        self.uWR2.text = json["uWr2"].stringValue
                        self.uWR2Text = json["uWr2"].stringValue
                        self.uTE.text = json["uTe"].stringValue
                        self.uTEText = json["uTe"].stringValue
                        self.uDEF.text = json["uDef"].stringValue
                        self.uDEFText = json["uDef"].stringValue
                        
                        self.opUserName.text = json["opTeam"].stringValue
                        self.opUserNameText = json["opTeam"].stringValue
                        self.opTeam = json["opTeam"].stringValue
                        self.opQB.text = json["opQb"].stringValue
                        self.opQBText = json["opQb"].stringValue
                        self.opRB1.text = json["opRb1"].stringValue
                        self.opRB1Text = json["opRb1"].stringValue
                        self.opRB2.text = json["opRb2"].stringValue
                        self.opRB2Text = json["opRb2"].stringValue
                        self.opWR1.text = json["opWr1"].stringValue
                        self.opWR1Text = json["opWr1"].stringValue
                        self.opWR2.text = json["opWr2"].stringValue
                        self.opWR2Text = json["opWr2"].stringValue
                        self.opTE.text = json["opTe"].stringValue
                        self.opTEText = json["opTe"].stringValue
                        self.opDEF.text = json["opDef"].stringValue
                        self.opDEFText = json["opDef"].stringValue
                        
                        
                    }
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "matchToRank") {
            var qbCont: QBVC = segue.destinationViewController
                as! QBVC
            
            qbCont.code = code
        }
        else if (segue.identifier == "matchToHome") {
            var homeCont: HomeController = segue.destinationViewController
                as! HomeController
        }
            
        else if (segue.identifier == "matchToBarter") {
            var barterCont: FirstWageVC = segue.destinationViewController
                as! FirstWageVC
            
            barterCont.code = self.code
            barterCont.matchId = self.matchId

        }
    }
}
