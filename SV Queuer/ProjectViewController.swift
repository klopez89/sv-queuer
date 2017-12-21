import UIKit

class ProjectViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var project: Dictionary<String, AnyObject?>?
    override func viewDidLoad() {
        super.viewDidLoad()
        let red = CGFloat((0x31e1a3 & 0xFF0000) >> 16)/256.0
        let green = CGFloat((0x31e1a3 & 0xFF00) >> 8)/256.0
        let blue = CGFloat(0x31e1a3 & 0xFF)/256.0
        tableView.dataSource = self
        tableView.delegate = self
        
        title = "Tasks"
        navigationController?.navigationBar.barTintColor = UIColor(red:red, green:green, blue:blue, alpha:1.0)
        var request = URLRequest(url: URL(string: AppDelegate.PROJECTS_URL + "/" + String(self.project!["id"]! as! Int) )!)
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
            DispatchQueue.main.async{
                if let error = optError {
                    UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                }
                if let jsonData = data {
                    self.project = try! JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? Dictionary<String, AnyObject?>
                    self.tableView.reloadData()
                    //                        }catch let jsonError as NSError {
                    //
                    //                        }
                }else{
                    
                }
            }
        }).resume()
        navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem: .add, target: self, action: Selector("addTask"))
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTask() {
        let vc = UIAlertController(title: "Task name", message: nil, preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
            var request = URLRequest(url: URL(string: AppDelegate.PROJECTS_URL + "/" + String(self.project!["id"]! as! Int) + "/tasks")!)
            request.httpBody = try? JSONSerialization.data(withJSONObject: ["task" : ["name": vc.textFields![0].text as? AnyObject]], options: .prettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            request.httpMethod="POST"
            request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                DispatchQueue.main.async{
                    if let error = optError
                    {
                        UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                    }
                    var request = URLRequest(url: URL(string: AppDelegate.PROJECTS_URL + "/" + String(self.project!["id"]! as! Int) )!)
                    request.addValue("application/json", forHTTPHeaderField: "Content-type")
                    request.addValue(UserDefaults.standard.string(forKey: "apiKey")!, forHTTPHeaderField: "X-Qer-Authorization")
                    request.addValue("application/json", forHTTPHeaderField: "Accept")
                    URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data, response, optError) in
                        DispatchQueue.main.async{
                            if let error = optError {
                                UIAlertView(title: "Ruh roh", message: error.localizedDescription + "\nMaybe check your internet?", delegate: nil, cancelButtonTitle: ":(").show()
                            }
                            if let jsonData = data {
                                let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                                self.project = json as! Dictionary<String, AnyObject?>
                                self.tableView.reloadData()
                                //                        }catch let jsonError as NSError {
                                //
                                //                        }
                            }else{
                                
                            }
                        }
                    }).resume()
                }
            }).resume()
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            vc.dismiss(animated: true, completion: nil)
        }))
        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: "task")
        c?.textLabel?.text = ((project!["tasks"])! as! Array<Dictionary<String, AnyObject?>>)[indexPath.row]["name"]! as? String
        return c!
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = project!["tasks"]??.count {
            return count
        }
        else
        {
            return 0;
        }
    }

}
