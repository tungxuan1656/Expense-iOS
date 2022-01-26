//
//  AddExpenditureViewController.swift
//  Expense
//
//  Created by Tùng Xuân on 16/10/2021.
//

import UIKit

class AddExpenditureViewController: UIViewController {
    
    enum Mode {
        case In
        case Out
    }
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var textFieldNote: UITextField!
    @IBOutlet weak var imageViewCategory: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonCategory: UIButton!
    @IBOutlet weak var buttonSource: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var expenditure: Expenditure? = nil
    var category: Category = .khac
    var source = ""
    var mode = Mode.Out
    var add: ((_ ex: Expenditure) -> Void)? = nil
    var delete: ((_ ex: Expenditure) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.outsideHideKeyboard()
        self.setupUI()
    }
    
    // MARK: - Init
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        Log.d("Deinit")
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
        if let ex = self.expenditure {
            self.mode = ex.value >= 0 ? .In : .Out
            self.source = ex.source
            self.category = ex.category
            self.textFieldValue.text = ex.value.converDecimal()
            self.textFieldNote.text = ex.note
            self.datePicker.date = ex.day
        }
        else {
            self.source = AppData.sources.first ?? "Ví"
            self.category = (self.mode == .Out ? AppData.outCategories.first : AppData.inCategories.first) ?? .khac
            self.textFieldValue.becomeFirstResponder()
        }
        self.textFieldValue.textColor = self.mode == .Out ? UIColor(named: "Feature") : UIColor(named: "Green")
        
        
        self.refreshUI()
    }
    
    func refreshUI() {
        self.buttonCategory.setTitle(self.category.rawValue, for: .normal)
        self.imageViewCategory.image = UIImage(named: self.category.icon)
        self.buttonSource.setTitle(self.source, for: .normal)
    }
    
    // MARK: - Utils
    
    
    // MARK: - CallBacks
    @IBAction func onClickButtonDone(_ sender: Any) {
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        guard let text = self.textFieldValue.text?.trim() else { return }
        let s = regex.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, text.count), withTemplate: "")
        guard var value = Double(s) else { return }
        
        // delete
        if let ex = self.expenditure { self.delete?(ex) }
        
        // add new
        value = self.mode == .In ? value : -value
        
        let ex = Expenditure(id: 0, day: self.datePicker.date, category: self.category, value: value, note: self.textFieldNote.text?.trim() ?? "", source: self.source)
        
        let id = DB.shared.insert(expenditure: ex)
        if id != 0 {
            ex.id = id
            self.add?(ex)
        }
        self.dismiss()
    }
    
    @IBAction func onClickButtonCategory(_ sender: Any) {
        var all = [SelectData]()
        if self.mode == .Out {
            all = AppData.outCategories.map { SelectData(icon: UIImage(named: $0.icon), title: $0.rawValue) }
        }
        else {
            all = AppData.inCategories.map { SelectData(icon: UIImage(named: $0.icon), title: $0.rawValue) }
        }
        let select = SelectViewController.get(title: "Chọn Nhóm", type: .radio, arrData: all, preIndexSelected: [0])
        
        select.done { arrData, arrIndexSelected in
            if let index = arrIndexSelected.first {
                if let c = Category(rawValue: arrData[index].title) {
                    if self.mode == .Out {
                        AppData.outCategories.remove(at: index)
                        AppData.outCategories.insert(c, at: 0)
                        AppData.saveOutCategories()
                    }
                    else {
                        AppData.inCategories.remove(at: index)
                        AppData.inCategories.insert(c, at: 0)
                        AppData.saveInCategories()
                    }
                    self.category = c
                    self.refreshUI()
                }
            }
        }
        
        self.push(select)
    }
    
    @IBAction func onClickButtonSource(_ sender: Any) {
        let all = AppData.sources.map { SelectData(icon: nil, title: $0) }
        let select = SelectViewController.get(title: "Chọn Nguồn", type: .radio, arrData: all, preIndexSelected: [0])
        
        select.done { arrData, arrIndexSelected in
            if let index = arrIndexSelected.first {
                self.source = arrData[index].title
                AppData.sources.remove(at: index)
                AppData.sources.insert(self.source, at: 0)
                AppData.saveSources()
                self.refreshUI()
            }
        }
        select.deleteMode = true
        select.delete { index in
            AppData.sources.remove(at: index)
            AppData.saveSources()
        }
        
        self.push(select)
    }
    
    @IBAction func onClickButtonAddSource(_ sender: Any) {
        let alert = UIAlertController(title: "Thêm Nguồn Tiền", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.font = FontBook.AvenirNext.Medium.size(14)
            textField.textColor = UIColor(named: "Title")
        }
        alert.addAction(.init(title: "Xong", style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text, text != "" {
                self.source = text
                if !AppData.sources.contains(self.source) {
                    AppData.sources.append(text)
                    AppData.saveSources()
                }
                self.refreshUI()
            }
        }))
        alert.addAction(.init(title: "Hủy", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func valueChangedSegmentedMode(_ sender: Any) {
        self.mode = self.segmentedControl.selectedSegmentIndex == 0 ? .Out : .In
        self.textFieldValue.textColor = self.mode == .Out ? UIColor(named: "Feature") : UIColor(named: "Green")
    }
    
    @IBAction func valueChangedTextFieldValue(_ sender: Any) {
        if let text = self.textFieldValue.text?.trim() {
            self.textFieldValue.text = text.decimalInputFormatting()
        }
    }
}

extension AddExpenditureViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
