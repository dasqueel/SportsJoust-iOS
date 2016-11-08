import UIKit
import Alamofire
import Locksmith
import SwiftyJSON


class ContestController: UIViewController {
    
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    var nflCode = ""
    var ncaaCode = ""
    var code = ""
    
    @IBOutlet weak var nflBtn: UIButton!
    @IBOutlet weak var ncaaBtn: UIButton!
    
    
    @IBAction func toHome(sender: AnyObject) {
    }
    
    @IBAction func toNfl(sender: AnyObject) {
    }
    @IBOutlet weak var toNcaa: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mtoken = dictionary!.valueForKey("mtoken") as! NSString
        
        Alamofire.request(.GET, "http://52.24.226.232/mgetContests")
            .responseString { _, _, string, _ in
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    let nfl = json["nfl"].stringValue
                    let nflCode = json["nflCode"].stringValue
                    //let ncaa = json["ncaa"].stringValue
                    //let ncaaCode = json["ncaaCode"].stringValue
                    
                    self.nflBtn.setTitle(nfl, forState: UIControlState.Normal)
                    //self.ncaaBtn.setTitle(ncaa, forState: UIControlState.Normal)
                    
                    //self.nfl = nfl
                    self.nflCode = nflCode
                    //self.ncaa = ncaa
                    //self.ncaaCode = ncaaCode
                }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toNflQbs") {
            var qbCont: QBVC = segue.destinationViewController
                as! QBVC
            
            qbCont.code = nflCode
        }
        else if (segue.identifier == "toNcaaQbs") {
            var qbCont: QBVC = segue.destinationViewController
                as! QBVC
            
            qbCont.code = ncaaCode
        }
        else if (segue.identifier == "contestToHome") {
            var homeCont: HomeController = segue.destinationViewController
                as! HomeController
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
