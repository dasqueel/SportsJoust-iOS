import UIKit
import SwiftyJSON
import Alamofire
import Locksmith

class RBVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var tableData: [String] = []
    var pos = "rb"
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    var code:String!
    //var code = "nfl1"
    //var mtoken = "weEmwBoGxqaizpFIkJixhu32c8PKgfvH"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.editing = true
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        //println(mtoken)
        
        Alamofire.request(.GET, "http://52.24.226.232/mgetPos", parameters: ["mtoken": mtoken, "contest": code, "pos": pos])
            .responseString { _, _, string, _ in
                if let dataFromString = string!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let json = JSON(data: dataFromString)
                    let posStr = self.pos+"r"
                    var qbr = json[posStr]
                    
                    var players: [String] = []
                    for (myKey,myValue) in qbr {
                        var name = myValue["name"]
                        var opp = myValue["opp"]
                        players.append("\(name) -- \(opp)")
                    }
                    self.tableData = players
                    self.tableView.reloadData()
                }
        }
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = tableData[indexPath.row]
        
        var elements = [0,1,2,3,4,5,6,7,8,9]
        if (contains(elements, indexPath.row)) {
            cell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
            
        } else {
            cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.1)
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var itemToMove = tableData[fromIndexPath.row]
        tableData.removeAtIndex(fromIndexPath.row)
        tableData.insert(itemToMove, atIndex: toIndexPath.row)
        self.tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //segueway stuff
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        //println(token)
        
        if (segue.identifier == "rbsToQbs") {
            var qbCont: QBVC = segue.destinationViewController
                as! QBVC
            
            //update position
            let parameters = ["pos":pos,"mtoken":mtoken,"contest":code,"newOrder":tableData]
            Alamofire.request(.POST, "http://52.24.226.232/msetRank", parameters: parameters as? [String : AnyObject], encoding: .JSON)
                .responseString { _, _, string, _ in
                    //println(string)
            }
            qbCont.code = code
        }
        else if (segue.identifier == "rbsToWrs") {
            var wrCont: WRVC = segue.destinationViewController
                as! WRVC
            
            //update position
            let parameters = ["pos":pos,"mtoken":mtoken,"contest":code,"newOrder":tableData]
            Alamofire.request(.POST, "http://52.24.226.232/msetRank", parameters: parameters as? [String : AnyObject], encoding: .JSON)
                .responseString { _, _, string, _ in
                    //println(string)
            }
            
            wrCont.code = code
        }
    }
}