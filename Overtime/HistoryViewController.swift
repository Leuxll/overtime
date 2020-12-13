//
//  HistoryViewController.swift
//  Overtime
//
//  Created by Yue Fung Lee on 13/12/2020.
//  Copyright © 2020 Yue Fung Lee. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var history = [History]()
    var historyCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        
        tableView.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        tableView.allowsSelection = false
        tableView.reloadData()
        
        historyCollectionRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("history")
        
        listGameHistory()
        
    }
    
    func listGameHistory() {
        
        historyCollectionRef.getDocuments { (snapshot, error) in
            //Trapping any invalid paramters if any
            guard let snap = snapshot else {return}
            
            //For-loop that loops through the documents within the snapshot recieved
            for document in snap.documents {
                //settting each variable to the correct retrieved field
                let data = document.data()
                let time = data["time"] as? String
                let quizName = data["quizName"] as? String
                let points = data["points"] as? String
                let quizInfo = time! + " " + quizName!
                //Appending the information above to the array list
                self.history.append(History(quizInfo: quizInfo, score: points))
                //Reloading the tableview to reflect the sorted users according to points
                self.tableView.reloadData()
            
            }
        
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryTableViewCell {
            
            cell.quizInfo.text = history[indexPath.row].quizInfo
            cell.score.text = history[indexPath.row].score
            cell.configureCell()
            cell.backgroundColor = UIColor.init(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
            return cell
            
        } else {
            
            return UITableViewCell()
            
        }
        
    }
    
}
