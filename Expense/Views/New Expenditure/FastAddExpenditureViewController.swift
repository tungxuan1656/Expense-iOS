//
//  FastAddExpenditureViewController.swift
//  Expense
//
//  Created by Tùng Xuân on 26/01/2022.
//

import UIKit

class FastAddExpenditureViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var add: ((_ ex: Expenditure) -> Void)? = nil
    var expenditures = [Expenditure]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - SetupUI
    func setupUI() {
        self.tableView.register(UINib(nibName: "ExpenditureCell", bundle: nil), forCellReuseIdentifier: "ExpenditureCell")
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 50))
        
        let startTime = Date.fromOrdinalDay(Date().ordinalDay() - 15)
        let endTime = Date()
        self.expenditures = AppData.getExpenditures(start: startTime, end: endTime)
        for ex in self.expenditures {
            ex.setDay(Date())
        }
        self.filterExs()
        self.tableView.reloadData()
    }
    
    // MARK: - Utils
    func addNew(ex: Expenditure) {
        let id = DB.shared.insert(expenditure: ex)
        if id != 0 {
            ex.id = id
            self.add?(ex)
        }
        self.dismiss()
    }
    
    func filterExs() {
        var trueStrings = [String]()
        var outs = [Expenditure]()
        for ex in expenditures {
            let s = "\(ex.value)_\(ex.source)_\(ex.category.rawValue)_\(ex.note)"
            if (!trueStrings.contains(s)) {
                trueStrings.append(s)
                outs.append(ex)
            }
        }
        self.expenditures = outs
    }
    
    // MARK: - CallBacks
    
    
}

extension FastAddExpenditureViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureCell", for: indexPath) as! ExpenditureCell
        cell.setupUI(expenditure: self.expenditures[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenditures.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.addNew(ex: self.expenditures[indexPath.row])
    }
}
