//
//  ExpenseViewController.swift
//  Expense
//
//  Created by Tùng Xuân on 14/10/2021.
//

import UIKit

class ExpenseViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tableViewExpenditures: UITableView!
    @IBOutlet weak var buttonCalendar: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var expenditures: [Expenditure] = []
    var arrExSummary = [ExSummary]()
    var saveArrExSummary = [ExSummary]()
    var startTime = Date.fromOrdinalDay(Date().ordinalDay() - 30)
    var endTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        
        self.outsideHideKeyboard()
    }
    
    // MARK: - Init
    deinit {
        NotificationCenter.default.removeObserver(self)
        Log.d("Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.clasifyExpenditures()
        self.tableViewExpenditures.reloadData()
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
        self.getExpenditures()
        self.tableViewExpenditures.register(UINib(nibName: "ExpenditureCell", bundle: nil), forCellReuseIdentifier: "ExpenditureCell")
        self.tableViewExpenditures.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 90))
        self.searchBar.searchTextField.font = .systemFont(ofSize: 14)
        self.searchBar.searchTextField.textColor = UIColor(named: "Title")
        self.searchBar.delegate = self
    }
    
    func getExpenditures() {
        self.expenditures = AppData.getExpenditures(start: self.startTime, end: self.endTime)
        self.clasifyExpenditures()
    }
    
    // MARK: - Utils
    func clasifyExpenditures() {
        self.arrExSummary = []
        let arrIndex = expenditures.map { $0.day.ordinalDay() }
        var current = arrIndex.first ?? -1
        var temp = [Expenditure]()
        for i in 0..<arrIndex.count {
            if arrIndex[i] == current {
                temp.append(expenditures[i])
            }
            else {
                self.arrExSummary.append(.init(expenditures: temp, type: .day))
                temp = [expenditures[i]]
                current = arrIndex[i]
            }
        }
        self.arrExSummary.append(.init(expenditures: temp, type: .day))
        self.saveArrExSummary = self.arrExSummary
    }
    
    func showAddExpenditure(_ ex: Expenditure? = nil) {
        if let add = UIStoryboard.main.instantiateViewController(withIdentifier: "AddExpenditureViewController") as? AddExpenditureViewController {
            add.expenditure = ex
            add.add = { [weak self] ex in
                guard let self = self else { return }
                let oday = ex.ordinalDay
                var didInsert = false
                for (i, e) in self.expenditures.enumerated() {
                    if e.ordinalDay <= oday {
                        self.expenditures.insert(ex, at: i)
                        didInsert = true
                        break
                    }
                }
                if !didInsert {
                    self.expenditures.append(ex)
                }
                self.clasifyExpenditures()
                self.tableViewExpenditures.reloadData()
            }
            add.delete = { [weak self] ex in
                DB.shared.tbExpenditure.delete(id: ex.id)
                self?.expenditures.removeAll { $0.id == ex.id }
            }
            self.present(add, animated: true, completion: nil)
        }
    }
    
    func search(_ text: String) {
        if (text == "") {
            self.arrExSummary = self.saveArrExSummary
        }
        else {
            var arrTemp = [ExSummary]()
            for exsum in saveArrExSummary {
                var temp = [Expenditure]()
                for ex in exsum.expenditures {
                    if (ex.note.search(text)) { temp.append(ex) }
                    else if (ex.category.rawValue.search(text)) { temp.append(ex) }
                    else {}
                }
                if (!temp.isEmpty) { arrTemp.append(.init(expenditures: temp, type: .day)) }
            }
            self.arrExSummary = arrTemp
        }
        
        self.tableViewExpenditures.reloadData()
        self.view.endEditing(true)
    }
    
    
    // MARK: - CallBacks
    
    @IBAction func onClickButtonCalendar(_ sender: Any) {
        let picker = DateRangePicker()
        picker.startTime = self.startTime
        picker.endTime = self.endTime
        picker.done = { [weak self] (start, end) in
            self?.startTime = start
            self?.endTime = end
            self?.getExpenditures()
            dpMain {
                self?.tableViewExpenditures.reloadData()
            }
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onClickButtonAdd(_ sender: Any) {
        self.showAddExpenditure()
    }
    
    @IBAction func onClickButtonFastAdd(_ sender: Any) {
        if let fast = UIStoryboard.main.instantiateViewController(withIdentifier: "FastAddExpenditureViewController") as? FastAddExpenditureViewController {
            fast.add = { [weak self] ex in
                guard let self = self else { return }
                let oday = ex.ordinalDay
                var didInsert = false
                for (i, e) in self.expenditures.enumerated() {
                    if e.ordinalDay <= oday {
                        self.expenditures.insert(ex, at: i)
                        didInsert = true
                        break
                    }
                }
                if !didInsert {
                    self.expenditures.append(ex)
                }
                self.clasifyExpenditures()
                self.tableViewExpenditures.reloadData()
            }
            self.present(fast, animated: true, completion: nil)
        }
    }
}

extension ExpenseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ExpenditureHeader()
        let sum = self.arrExSummary[section]
        view.setupUI(summary: sum)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrExSummary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrExSummary[section].expenditures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenditureCell", for: indexPath) as! ExpenditureCell
        let row = indexPath.row
        let section = indexPath.section
        let ex = self.arrExSummary[section].expenditures[row]
        
        cell.setupUI(expenditure: ex)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ex = self.arrExSummary[indexPath.section].expenditures[indexPath.row]
        self.showAddExpenditure(ex)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ex = self.arrExSummary[indexPath.section].expenditures[indexPath.row]
            self.arrExSummary[indexPath.section].expenditures.remove(at: indexPath.row)
            self.expenditures.removeAll { $0.id == ex.id }
            DB.shared.tbExpenditure.delete(id: ex.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ExpenseViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = (searchBar.text ?? "").trim()
        print(text)
        self.search(text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText == "") { self.search("") }
    }
}
