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
    @IBOutlet weak var buttonEdit: UIBarButtonItem!
    @IBOutlet weak var buttonCalendar: UIBarButtonItem!
    
    var expenditures: [Expenditure] = []
    var arrExSummary = [ExSummary]()
    var startTime = Date.fromOrdinalDay(Date().ordinalDay() - 30)
    var endTime = Date()
    
    override var isEditing: Bool {
        didSet {
            self.buttonEdit.title = isEditing ? "Xong" : "Sửa"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
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
                DB.shared.delete(id: ex.id)
                self?.expenditures.removeAll { $0.id == ex.id }
            }
            self.push(add)
        }
    }
    
    
    // MARK: - CallBacks
    @IBAction func onClickButtonEdit(_ sender: Any) {
        self.isEditing = !self.isEditing
        self.tableViewExpenditures.setEditing(self.isEditing, animated: true)
    }
    
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
            DB.shared.delete(id: ex.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}


/*
 
 [
   {
     "value": -300000,
     "source": "Ví",
     "note": "Cưới Thơi",
     "category": "Xã giao",
     "time": "2021-11-06T00:04+0700"
   },
   {
     "value": -50000,
     "source": "Ví",
     "note": "Thuốc nhỏ",
     "category": "Thuốc",
     "time": "2021-11-04T05:21+0700"
   },
   {
     "value": -105000,
     "source": "Ví",
     "note": "Bún hải sản",
     "category": "Ăn tiệm",
     "time": "2021-11-04T05:20+0700"
   },
   {
     "value": -80000,
     "source": "VietinBank",
     "note": "Bóng điện",
     "category": "Sửa chữa",
     "time": "2021-11-03T20:09+0700"
   },
   {
     "value": -30000,
     "source": "Ví",
     "note": "Phở",
     "category": "Ăn tiệm",
     "time": "2021-11-02T21:19+0700"
   },
   {
     "value": -50000,
     "source": "Ví",
     "note": "",
     "category": "Xăng dầu",
     "time": "2021-11-01T21:57+0700"
   },
   {
     "value": -500000,
     "source": "VietinBank",
     "note": "Camera",
     "category": "Nhà cửa",
     "time": "2021-10-28T18:51+0700"
   },
   {
     "value": -50000,
     "source": "Ví",
     "note": "Bình nước, móc",
     "category": "Nước",
     "time": "2021-10-28T13:14+0700"
   },
   {
     "value": -50000,
     "source": "Ví",
     "note": "",
     "category": "Xăng dầu",
     "time": "2021-10-28T13:13+0700"
   },
   {
     "value": -10000,
     "source": "Ví",
     "note": "",
     "category": "Ăn vặt",
     "time": "2021-10-28T13:13+0700"
   },
   {
     "value": -50000,
     "source": "Ví",
     "note": "",
     "category": "Xăng dầu",
     "time": "2021-10-26T12:47+0700"
   },
   {
     "value": -230000,
     "source": "ShopeePay",
     "note": "Bình úp cây nóng lạnh",
     "category": "Sắm đồ",
     "time": "2021-10-26T12:46+0700"
   },
   {
     "value": -1500000,
     "source": "VietinBank",
     "note": "Cây nóng lạnh",
     "category": "Sắm đồ",
     "time": "2021-10-25T19:35+0700"
   },
   {
     "value": -50000,
     "source": "ShopeePay",
     "note": "Bàn học",
     "category": "Sách",
     "time": "2021-10-22T23:45+0700"
   },
   {
     "value": -130000,
     "source": "ShopeePay",
     "note": "Dép",
     "category": "Sắm đồ",
     "time": "2021-10-22T23:45+0700"
   },
   {
     "value": -160000,
     "source": "ShopeePay",
     "note": "Đồng hồ loa",
     "category": "Sắm đồ",
     "time": "2021-10-16T23:44+0700"
   },
   {
     "value": -135000,
     "source": "ShopeePay",
     "note": "Cân điện tử",
     "category": "Sắm đồ",
     "time": "2021-10-12T23:43+0700"
   },
   {
     "value": -100000,
     "source": "VietinBank",
     "note": "Giấy gấu trúc",
     "category": "Nhà cửa",
     "time": "2021-10-07T23:39+0700"
   }
 ]
 
 */
