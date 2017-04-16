//
//  ViewController.swift
//  NEW_NOTES_SWIFT3_FIREBASE
//
//  Created by GOD on 3/24/17.
//  Copyright © 2017 ALL ONE SUN. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    //Make a reference to the fb database
    
    var ref: FIRDatabaseReference!
    var note: String!
    var data:[String] = []
    var selectedRow:Int = -1
    var newRowText:String = ""

    
    @IBOutlet var table: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "NOTES"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
       // let doWhatISayToDoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doWhatISay))
        
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        //Load NOTES data from local plist
        load()
        
        //Init a reference to the fb database
        ref = FIRDatabase.database().reference()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        //Set NOTES data from text view on detail view controller
        data[selectedRow] = newRowText
        //Remove row if blank
        if newRowText == "" {
            data.remove(at: selectedRow)
        }
        //Reload the table data
        table.reloadData()
        
        //Save to local plist
        save()
    }
    
    
    func addNote() {
        //Protect against accidental press of add button while editing entry list
        if (table.isEditing) {
            return
        }
        
        //Insert row
        let name:String = ""
        data.insert(name, at: 0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .automatic)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        
        //Perform segue
        self.performSegue(withIdentifier: "detail", sender: nil)
       
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Get number of rows
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Set label of row
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
         cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //Delete a row from the fb database
        self.ref.child("NOTES_APP_DATA").child(data[indexPath.row]).removeValue()
        
        //Remove row from table
        //LOCAL 
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .fade)
        
        //Save data to local plist
        
//        LOCAL
       save()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        detailView.setText(t: data[selectedRow])
    }
    
    func save() {
        //Save data to local plist
        
//        LOCAL
        UserDefaults.standard.set(data, forKey: "notes")
        UserDefaults.standard.synchronize()
        
        
    }
    
    func load() {
        if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
            data = loadedData
            table.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

