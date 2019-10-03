//
//  DogeSelectionTableViewController.swift
//  DogeSwaggle
//
//  Created by Aaron Jubbal on 10/2/19.
//  Copyright © 2019 Richard Yeh. All rights reserved.
//

import UIKit

class DogeSelectionTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UITextFieldDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var dogBreeds = [String]()
    var filteredDogBreeds = [String]()
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        self.title = "What kind of dog do you have?"
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Pick your dog's type..."
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.searchTextField.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if let dogBreeds = readJson() {
            self.dogBreeds = dogBreeds
        }
        
        self.tableView.register(UINib(nibName: "DogeSelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "kDogeSelectionTableViewCell")
    }

    // MARK: - Helper Methods
    
    func filterContentForSearchText(_ searchText: String) {
      filteredDogBreeds = dogBreeds.filter({( dogBreed : String ) -> Bool in
        dogBreed.lowercased().contains(searchText.lowercased())
      })
      tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
      return searchController.isActive && !searchBarIsEmpty()
    }
    
    func readJson() -> Array<String>? {
        // Get url for file
        guard let fileUrl = Bundle.main.url(forResource: "dog_breeds", withExtension: "json") else {
            print("File could not be located at the given url")
            return nil
        }

        do {
            // Get data from file
            let data = try Data(contentsOf: fileUrl)

            // Decode data to a Dictionary<String, Any> object
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Could not cast JSON content as a Dictionary<String, Any>")
                return nil
            }

            if let dogBreeds = dictionary["dogs"] as? [String] {
                return dogBreeds
            }
            return nil
        } catch {
            // Print error if something went wrong
            print("Error: \(error)")
        }
        return nil
    }
    
    @objc func doneButtonTapped(sender: UIBarButtonItem) -> Void {
        if let selectedIndexPath = selectedIndexPath {
            let selectedDogBreed = dogBreeds[selectedIndexPath.row]
            UserDefaults.standard.set(selectedDogBreed, forKey: "dogType")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchController.isActive = false
        return true
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredDogBreeds.count
        }
        return dogBreeds.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("\(String(describing: searchController.searchBar.text))")
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kDogeSelectionTableViewCell", for: indexPath)

        if isFiltering() {
            cell.textLabel?.text = filteredDogBreeds[indexPath.row]
        } else {
            cell.textLabel?.text = dogBreeds[indexPath.row]
        }
        
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if let selectedIndexPath = selectedIndexPath {
            let selectedCell = tableView.cellForRow(at: selectedIndexPath)
            selectedCell?.accessoryType = .none
        }
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
