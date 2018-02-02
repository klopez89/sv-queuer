import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    var projects: [[String : AnyObject?]]?
    var selectedProject: [String : AnyObject?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        downloadProjects()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vC = segue.destination as? ProjectViewController {
            vC.project = selectedProject;
        }
    }

    func configureView() {
        title = "Projects"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createProjectButtonPressed))
    }
}

// MARK: - Project Data Related

extension ProjectsViewController {
    func downloadProjects() {
        ProjectsDataManager.requestProjects { (projects, error) in
            if let retrievedProjects = projects {
                self.projects = retrievedProjects
                self.tableView.reloadData()
            } else {
                Alerts.presentGenericErrorAlert(on: self, error: error)
            }
        }
    }

    func createProjectWith(_ name: String) {
        ProjectsDataManager.createNewProject(name) { (success) in
            if success {
                self.downloadProjects()
            } else {
                Alerts.presentGenericErrorAlert(on: self, error: "Error creating new project")
            }
        }
    }
}

// MARK: - Create Project Related

extension ProjectsViewController {

    @objc func createProjectButtonPressed() {
        presentCreateProjectPrompt()
    }

    private func presentCreateProjectPrompt() {
        let vc = UIAlertController(title: "Project name", message: nil, preferredStyle: .alert)

        vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
            self?.okayButtonPressed(vc)
        }))

        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        vc.addTextField { (textfield) in
            textfield.placeholder = "Name"
        }

        present(vc, animated: true, completion: nil)
    }

    private func okayButtonPressed(_ viewController: UIAlertController) {
        guard let name = viewController.textFields?[0].text, !name.isEmpty else {
            Alerts.presentSimpleAlert(on: self, title: "No Project Title", message: "Please enter a valid project title")
            return
        }
        createProjectWith(name)
    }
}

// MARK: - TableView Data Source and Delegate Functions

extension ProjectsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects?.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "project")
        cell?.textLabel?.text = (projects![indexPath.row])["name"]! as? String
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedProject = projects![indexPath.row];
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "viewproject", sender: self)
    }
}
