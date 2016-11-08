import UIKit
import Alamofire
import Locksmith

class LoginController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var pwd: UITextField!
    let (dictionary, error) = Locksmith.loadDataForUserAccount("SportSmash")
    //var mtoken = dictionary!.valueForKey("mtoken") as! String
    
    @IBAction func login(sender: AnyObject) {
        var mtoken = randomStringWithLength(32)
        Alamofire.request(.POST, "http://52.24.226.232/mlogin", parameters: ["userName": userName.text, "pwd":pwd.text,"mtoken":mtoken])
            .responseString { _, _, string, _ in
                if string == "yes" {
                    let error = Locksmith.updateData(["mtoken": mtoken,"userName": self.userName.text], forUserAccount: "SportJoust")
                    self.performSegueWithIdentifier("login", sender: self)
                }
                else if string == "no un"{
                    
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "Unregistered User Name"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else if string == "no pass" {
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "Incorrect Password"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
        }
    }

    @IBAction func register(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func randomString() -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s:String = ""
        for n in (1...32) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }*/
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    
}
