import UIKit
import SwiftyJSON
import Alamofire
import Locksmith

class QBController: UITableViewController{
    
    var tableData: [String] = []
    //let (dictionary, error) = Locksmith.loadDataForUserAccount("SportSmash")
    var pos = "qb"
    //var code:String!
    var code = "nfl1"
    var mtoken = "weEmwBoGxqaizpFIkJixhu32c8PKgfvH"
    
    @IBAction func qbsToContest(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //var mtoken = dictionary!.valueForKey("mtoken") as! NSString
        self.tableView.editing = true
        
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
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return tableData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = tableData[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var itemToMove = tableData[fromIndexPath.row]
        tableData.removeAtIndex(fromIndexPath.row)
        tableData.insert(itemToMove, atIndex: toIndexPath.row)
        
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    //segueway stuff
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "qbsToContest") {
            var contCont: ContestController = segue.destinationViewController
                as! ContestController
            
            //update position
            let parameters = ["pos":pos,"mtoken":mtoken,"contest":code,"newOrder":tableData]
            Alamofire.request(.POST, "http://52.24.226.232/msetRank", parameters: parameters as? [String : AnyObject], encoding: .JSON)
                .responseString { _, _, string, _ in
                    //println(string)
            }
        }
        else if (segue.identifier == "qbsToRbs") {
            var rbCont: RBController = segue.destinationViewController
                as! RBController
            
            //update position
            let parameters = ["pos":pos,"mtoken":mtoken,"contest":code,"newOrder":tableData]
            Alamofire.request(.POST, "http://52.24.226.232/msetRank", parameters: parameters as? [String : AnyObject], encoding: .JSON)
                .responseString { _, _, string, _ in
                    //println(string)
            }
            
            rbCont.code = code
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}