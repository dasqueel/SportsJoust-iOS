import UIKit
import Locksmith
import Alamofire

class HomeController: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var bal: UIButton!
    
    
    var (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    
    @IBAction func toContests(sender: AnyObject) {
    }
    
    @IBAction func toFunds(sender: AnyObject) {
    }
    @IBAction func logOut(sender: AnyObject) {
        let error = Locksmith.deleteDataForUserAccount("SportJoust")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var mtoken = dictionary!.valueForKey("mtoken") as! NSString
        //var userNameText = dictionary!.valueForKey("userName") as! String
        
        //self.userName.text = userNameText
        /*
        Alamofire.request(.GET, "http://52.24.226.232/mgetBal", parameters: ["userName":userNameText])
            .responseString { _, _, string, _ in
                var balText = "$"+string!
                self.bal.setTitle(balText, forState: UIControlState.Normal)
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //segueway stuff
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toBal") {
            var balCont: BalVC = segue.destinationViewController
                as! BalVC
        }
        else if (segue.identifier == "toContest") {
            var contCont: ContestController = segue.destinationViewController
                as! ContestController
        }
        else if (segue.identifier == "logOut") {
            var loginCont: LoginController = segue.destinationViewController
                as! LoginController
        }
    }
    
}
