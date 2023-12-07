//
//  ViewController.swift
//  HWS-Project-7
//
//  Created by Ade Dwi Prayitno on 06/12/23.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions: [Petition] = []
    var petitionsMaster: [Petition] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(showCredit))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(showFilter))
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url) {
            parse(data)
        } else {
            showError()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem with your connection", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showCredit() {
        let ac = UIAlertController(title: "Credit", message: "This App Using API From The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func showFilter() {
        let ac = UIAlertController(title: "Filter", message: "Writerdown the petition you want to search", preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Search", style:.default) { [weak self, weak ac] _ in
            guard let self, let filterText = ac?.textFields?.first?.text else { return }
            self.search(filterText)
        }
        
        ac.addAction(submitAction)
        ac.addAction(
            UIAlertAction(title: "Reset",
                          style: .cancel,
                          handler: {
                              [weak self] _ in
                              guard let self else { return }
                              self.resetPetitionList()
                              self.tableView.reloadData()
                          })
        )
        present(ac, animated: true)
    }
    
    func search(_ filterText: String) {
        let filterLowercased = filterText.lowercased()
        
        if filterLowercased.isEmpty {
            resetPetitionList()
        } else {
            petitions = petitionsMaster.filter { item in
                item.title.lowercased().contains(filterLowercased) || item.body.lowercased().contains(filterLowercased)
            }
        }
        
        tableView.reloadData()
    }
    
    func resetPetitionList() {
        petitions = petitionsMaster
    }
    
    func parse(_ json: Data) {
        let decoder = JSONDecoder()
        guard let jsonPetitions = try? decoder.decode(Petitions.self, from: json) else { return }
        petitionsMaster = jsonPetitions.results
        petitions = petitionsMaster
        
        tableView.reloadData()
    }
}

//MARK: -tableview Delegate
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

