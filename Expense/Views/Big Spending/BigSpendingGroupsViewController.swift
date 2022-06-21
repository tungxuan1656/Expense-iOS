//
//  BigSpendingGroupsViewController.swift
//  Expense
//
//  Created by Tùng Xuân on 20/06/2022.
//

import UIKit

class BigSpendingGroupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrGroups = [BigSpendingGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.arrGroups = AppData.getBigSpendingGroups()
        self.getAllSpending()
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
        self.tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 90))
    }
    
    func getAllSpending() {
        for (i, group) in arrGroups.enumerated() {
            let arr = DB.shared.tbBigSpending.select(groupId: group.id)
            self.arrGroups[i].arrSpending = arr
            let value = arr.reduce(0, { $0 + $1.value })
            self.arrGroups[i].value = value
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Utils
    func addNewGroup(group: BigSpendingGroup) {
        let id = DB.shared.tbBigSpendingGroup.insert(group: group)
        if id != 0 {
            group.id = id
            self.arrGroups.insert(group, at: 0)
            self.tableView.reloadData()
        }
    }
    
    func editGroup(id: Int, name: String, note: String) {
        if DB.shared.tbBigSpendingGroup.update(id: id, name: name, note: note) {
            for group in arrGroups {
                if (group.id == id) {
                    group.name = name
                    group.note = note
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - CallBacks
    @IBAction func onClickButtonAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Thêm nhóm chi tiêu lớn", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Tên nhóm"
            textField.font = FontBook.AvenirNext.Medium.size(14)
            textField.textColor = UIColor(named: "Title")
        }
        alert.addTextField { textField in
            textField.placeholder = "Ghi chú nhóm"
            textField.font = FontBook.AvenirNext.Medium.size(14)
            textField.textColor = UIColor(named: "Title")
        }
        alert.addAction(.init(title: "Xong", style: .default, handler: { _ in
            let group = BigSpendingGroup()
            if let text = alert.textFields?.first?.text, text != "" {
                group.name = text
            }
            if let text = alert.textFields?.last?.text, text != "" {
                group.note = text
            }
            if (group.name != "") {
                self.addNewGroup(group: group)
            }
        }))
        alert.addAction(.init(title: "Hủy", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BigSpendingGroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureCell", for: indexPath) as! ExpenditureCell
        let row = indexPath.row
        
        cell.setupGroup(group: arrGroups[row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = self.arrGroups[indexPath.row]
        if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "BigSpendingViewController") as? BigSpendingViewController {
            vc.bigSpendingGroup = group
            self.push(vc)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return .init(actions: [
            .init(style: .destructive, title: "Xóa", handler: { _, _, handle in
                let group = self.arrGroups[indexPath.row]
                self.arrGroups.removeAll { $0.id == group.id }
                DB.shared.tbBigSpendingGroup.delete(id: group.id)
            }), .init(style: .normal, title: "Sửa", handler: { _, _, _ in
                let group = self.arrGroups[indexPath.row]
                let alert = UIAlertController(title: "Sửa", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "Tên nhóm"
                    textField.text = group.name
                    textField.font = FontBook.AvenirNext.Medium.size(14)
                    textField.textColor = UIColor(named: "Title")
                }
                alert.addTextField { textField in
                    textField.placeholder = "Ghi chú nhóm"
                    textField.text = group.note
                    textField.font = FontBook.AvenirNext.Medium.size(14)
                    textField.textColor = UIColor(named: "Title")
                }
                alert.addAction(.init(title: "Xong", style: .default, handler: { _ in
                    let t = alert.textFields?.first?.text ?? ""
                    let n = alert.textFields?.last?.text ?? ""
                    self.editGroup(id: group.id, name: t, note: n)
                }))
                alert.addAction(.init(title: "Hủy", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
        
        if editingStyle == .insert {
            print("Edit")
        }
    }
}
