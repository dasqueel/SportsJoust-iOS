import UIKit
import Locksmith
import Alamofire
import SwiftyJSON

class MatchVC: UIViewController {
    
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    var code:String!
    var matchId: String!

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var uQbName: UILabel!
    @IBOutlet weak var uQbStats: UILabel!
    @IBOutlet weak var uQbPts: UILabel!
    @IBOutlet weak var uRb1Name: UILabel!
    @IBOutlet weak var uRb1Stats: UILabel!
    @IBOutlet weak var uRb1Pts: UILabel!
    @IBOutlet weak var uRb2Name: UILabel!
    @IBOutlet weak var uRb2Stats: UILabel!
    @IBOutlet weak var uRb2Pts: UILabel!
    @IBOutlet weak var uWr1Name: UILabel!
    @IBOutlet weak var uWr1Stats: UILabel!
    @IBOutlet weak var uWr1Pts: UILabel!
    @IBOutlet weak var uWr2Name: UILabel!
    @IBOutlet weak var uWr2Stats: UILabel!
    @IBOutlet weak var uWr2Pts: UILabel!
    @IBOutlet weak var uTeName: UILabel!
    @IBOutlet weak var uTeStats: UILabel!
    @IBOutlet weak var uTePts: UILabel!
    @IBOutlet weak var uDefName: UILabel!
    @IBOutlet weak var uDefStats: UILabel!
    @IBOutlet weak var uDefPts: UILabel!
    
    @IBOutlet weak var opQbName: UILabel!
    @IBOutlet weak var opQbStats: UILabel!
    @IBOutlet weak var opQbPts: UILabel!
    @IBOutlet weak var opRb1Name: UILabel!
    @IBOutlet weak var opRb1Stats: UILabel!
    @IBOutlet weak var opRb1Pts: UILabel!
    @IBOutlet weak var opRb2Name: UILabel!
    @IBOutlet weak var opRb2Stats: UILabel!
    @IBOutlet weak var opRb2Pts: UILabel!
    @IBOutlet weak var opWr1Name: UILabel!
    @IBOutlet weak var opWr1Stats: UILabel!
    @IBOutlet weak var opWr1Pts: UILabel!
    @IBOutlet weak var opWr2Name: UILabel!
    @IBOutlet weak var opWr2Stats: UILabel!
    @IBOutlet weak var opWr2Pts: UILabel!
    @IBOutlet weak var opTeName: UILabel!
    @IBOutlet weak var opTeStats: UILabel!
    @IBOutlet weak var opTePts: UILabel!
    @IBOutlet weak var opDefName: UILabel!
    @IBOutlet weak var opDefStats: UILabel!
    @IBOutlet weak var opDefPts: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        var userNameText = dictionary!.valueForKey("userName") as! String
        self.userName.text = userNameText
        
        var params = ["mtoken": mtoken, "contest": code, "matchId": matchId]
        
        Alamofire.request(.GET, "http://52.24.226.232/mgetContest", parameters: params)
            .responseJSON { _, _, json, _ in
                        
                let json = JSON(json!)
                
                self.uQbName.text = json["uQb"].stringValue
                self.uQbStats.text = json["uQbStatStr"].stringValue
                self.uQbPts.text = json["uQbPts"].stringValue
                self.uRb1Name.text = json["uRb1"].stringValue
                self.uRb1Stats.text = json["uRb1StatStr"].stringValue
                self.uRb1Pts.text = json["uRb1Pts"].stringValue
                self.uRb2Name.text = json["uRb2"].stringValue
                self.uRb2Stats.text = json["uRb2StatStr"].stringValue
                self.uRb2Pts.text = json["uRb2Pts"].stringValue
                self.uWr1Name.text = json["uWr1"].stringValue
                self.uWr1Stats.text = json["uWr1StatStr"].stringValue
                self.uWr1Pts.text = json["uWr1Pts"].stringValue
                self.uWr2Name.text = json["uWr2"].stringValue
                self.uWr2Stats.text = json["uWr2StatStr"].stringValue
                self.uWr2Pts.text = json["uWr2Pts"].stringValue
                self.uTeName.text = json["uTe"].stringValue
                self.uTeStats.text = json["uTeStatStr"].stringValue
                self.uTePts.text = json["uTePts"].stringValue
                self.uDefName.text = json["uDef"].stringValue
                self.uDefStats.text = json["uDefStatStr"].stringValue
                self.uDefPts.text = json["uDefPts"].stringValue
                
                self.opQbName.text = json["opQb"].stringValue
                self.opQbStats.text = json["opQbStatStr"].stringValue
                self.opQbPts.text = json["opQbPts"].stringValue
                self.opRb1Name.text = json["opRb1"].stringValue
                self.opRb1Stats.text = json["opRb1StatStr"].stringValue
                self.opRb1Pts.text = json["opRb1Pts"].stringValue
                self.opRb2Name.text = json["opRb2"].stringValue
                self.opRb2Stats.text = json["opRb2StatStr"].stringValue
                self.opRb2Pts.text = json["opRb2Pts"].stringValue
                self.opWr1Name.text = json["opWr1"].stringValue
                self.opWr1Stats.text = json["opWr1StatStr"].stringValue
                self.opWr1Pts.text = json["opWr1Pts"].stringValue
                self.opWr2Name.text = json["opWr2"].stringValue
                self.opWr2Stats.text = json["opWr2StatStr"].stringValue
                self.opWr2Pts.text = json["opWr2Pts"].stringValue
                self.opTeName.text = json["opTe"].stringValue
                self.opTeStats.text = json["opTeStatStr"].stringValue
                self.opTePts.text = json["opTePts"].stringValue
                self.opDefName.text = json["opDef"].stringValue
                self.opDefStats.text = json["opDefStatStr"].stringValue
                self.opDefPts.text = json["opDefPts"].stringValue
                
                /*
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
                self.opDEF.text = json["opDef"].stringValue*/
            }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
