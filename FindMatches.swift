import UIKit
import Alamofire
import Locksmith
import SwiftyJSON


class FindMatches: UIViewController {
    
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    var nflCode = ""
    var ncaaCode = ""
    var code = ""
    
    @IBOutlet weak var nflBtn: UIButton!
    @IBOutlet weak var ncaaBtn: UIButton!
    
    @IBAction func findMatchesToHome(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mtoken = dictionary!.valueForKey("mtoken") as! NSString
        
        Alamofire.request(.GET, "http://52.24.226.232/mgetContests")
            .responseString { _, _, string, _ in
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    let nfl = json["nfl"].stringValue
                    let nflCode = json["nflCode"].stringValue
                    let ncaa = json["ncaa"].stringValue
                    let ncaaCode = json["ncaaCode"].stringValue
                    
                    self.nflBtn.setTitle(nfl, forState: UIControlState.Normal)
                    self.ncaaBtn.setTitle(ncaa, forState: UIControlState.Normal)
                    
                    //self.nfl = nfl
                    self.nflCode = nflCode
                    //self.ncaa = ncaa
                    self.ncaaCode = ncaaCode
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toNflMatches") {
            var matchCont: MatchesVC = segue.destinationViewController
                as! MatchesVC
            
            matchCont.code = nflCode
        }
        else if (segue.identifier == "toNcaaMatches") {
            var matchCont: MatchesVC = segue.destinationViewController
                as! MatchesVC
            
            matchCont.code = ncaaCode
        }
        else if (segue.identifier == "findMatchesToHome") {
            var homeCont: HomeController = segue.destinationViewController
                as! HomeController
        }
    }
    
}
