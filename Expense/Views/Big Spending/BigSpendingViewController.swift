//
//  BigSpendingViewController.swift
//  Expense
//
//  Created by Tùng Xuân on 20/06/2022.
//

import UIKit

class BigSpendingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bigSpendingGroup = BigSpendingGroup()

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
        self.navigationItem.title = self.bigSpendingGroup.name
        
        self.tableView.register(UINib(nibName: "ExpenditureCell", bundle: nil), forCellReuseIdentifier: "ExpenditureCell")
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 90))
        self.tableView.reloadData()
    }
    
    // MARK: - Utils
    func showAddBigSpending(_ s: BigSpending? = nil) {
        if let add = UIStoryboard.main.instantiateViewController(withIdentifier: "AddExpenditureViewController") as? AddExpenditureViewController {
            if let s = s {
                let ex = Expenditure(id: s.id, day: s.day, category: .khac, value: s.value, note: s.note, source: "")
                add.expenditure = ex
            }
            add.isBigSpending = true
            add.done = { [weak self] ex in
                guard let self = self else { return }
                Log.e("eeeeee")
                Log.e(ex)
                if let id = s?.id {
                    DB.shared.tbBigSpending.delete(id: id)
                }
                let temp = BigSpending()
                temp.note = ex.note
                temp.groupId = self.bigSpendingGroup.id
                temp.day = ex.day
                temp.value = ex.value
                
                let id = DB.shared.tbBigSpending.insert(spending: temp)
                if (id != 0) {
                    temp.id = id
                    self.bigSpendingGroup.arrSpending.insert(temp, at: 0)
                    self.tableView.reloadData()
                }
            }
            
            self.present(add, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - CallBacks
    @IBAction func onClickButtonAdd(_ sender: Any) {
        self.showAddBigSpending()
    }
}

extension BigSpendingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bigSpendingGroup.arrSpending.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureCell", for: indexPath) as! ExpenditureCell
        let row = indexPath.row
        let spending = self.bigSpendingGroup.arrSpending[row]
        
        cell.setupSpending(spending)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.showAddBigSpending(self.bigSpendingGroup.arrSpending[indexPath.row])
    }
}
