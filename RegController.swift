import UIKit
import Alamofire
import Locksmith

class RegController: UIViewController {
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var rpwd: UITextField!
    
    @IBAction func sendReg(sender: AnyObject) {
        
        self.fname.resignFirstResponder()
        self.lname.resignFirstResponder()
        self.email.resignFirstResponder()
        self.userName.resignFirstResponder()
        self.pwd.resignFirstResponder()
        self.rpwd.resignFirstResponder()
        
        var mtoken = randomString()
        var parameters = ["firstName":fname.text,"lastName":lname.text,"email":email.text,"userName":userName.text,"pwd":pwd.text,"rpwd":rpwd.text,"mtoken":mtoken]
        Alamofire.request(.POST, "http://52.24.226.232/mregister", parameters: parameters)
            .responseString { _, _, string, _ in
                //println(string)
                if string == "registered" {
                    //store mtoken
                    let error = Locksmith.saveData(["mtoken": mtoken,"userName":self.userName.text], forUserAccount: "SportJoust")
                    
                    //segue way to home
                    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
                        var homeCont: HomeController = segue.destinationViewController
                            as! HomeController
                    }
                }
                else if string == "please fill in all data"{
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "Please fill in all data."
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else if string == "passwords dont match, try again" {
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "Passwords dont match, try again"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else if string == "email has already been registered" {
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "Email has already been registered"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
                else if string == "userName has been taken" {
                    let alert = UIAlertView()
                    alert.title = "Alert"
                    alert.message = "User name has been taken"
                    alert.addButtonWithTitle("Understood")
                    alert.show()
                }
        }

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func randomString() -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s:String = ""
        for n in (1...32) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
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
