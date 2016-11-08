import UIKit
import SwiftyJSON
import Alamofire
import Locksmith

class MyMatchesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var tableData: [String] = []
    var matchIds: [String]!
    var contestList: [String]!
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportJoust")
    
    var matchId = ""
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var mtoken = dictionary!.valueForKey("mtoken") as! String
        
        Alamofire.request(.GET, "http://52.24.226.232/muserContests", parameters: ["mtoken": mtoken])
            .responseJSON { req, res, json, error in
                
                var json = JSON(json!)
                var matchesJson = json["matches"]
                var matches:[String] = []
                for (k,v) in matchesJson {
                    matches.append(v.stringValue)
                }
                
                var matchIdsJson = json["matchIds"]
                var matchIds:[String] = []
                for (k,v) in matchIdsJson {
                    matchIds.append(v.stringValue)
                }
                self.matchIds = matchIds
                
                var contestListJson = json["contestList"]
                var contestList:[String] = []
                for (k,v) in contestListJson {
                    contestList.append(v.stringValue)
                }
                self.contestList = contestList
                
                self.tableData = matches
                
                self.tableView.reloadData()
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
        
        return cell
    }
    
    //when matched is clicked, go to its barter
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow();
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!);
        
        var matchId = matchIds[indexPath!.row]
        self.matchId = matchId
        var code = contestList[indexPath!.row]
        self.code = code
        
        //segue to MatchVC, pass along matchId?
        self.performSegueWithIdentifier("myMatchesToMatch", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "myMatchesToMatch") {
            var matchCont: MatchVC = segue.destinationViewController
                as! MatchVC
            
            matchCont.matchId = matchId
            matchCont.code = code
        }
    }
}