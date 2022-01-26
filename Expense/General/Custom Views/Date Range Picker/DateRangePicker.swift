//
//  DateRangePicker.swift
//  Expense
//
//  Created by Tùng Xuân on 06/11/2021.
//

import UIKit

class DateRangePicker: UIViewController {

    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var buttonStartDate: UIButton!
    @IBOutlet weak var buttonEndDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startTime = Date.fromOrdinalDay(Date().ordinalDay() - 30)
    var endTime = Date()
    var pickStartTime = true
    var done: ((_ start: Date, _ end: Date) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }

    // MARK: - Init
    init() {
        super.init(nibName: "DateRangePicker", bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        Log.d("Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.datePicker.addTarget(self, action: #selector(valueChangedDatePicker), for: .valueChanged)
        self.buttonStartDate.setTitle(self.startTime.toString(format: .custom("dd/MM/yyyy")), for: .normal)
        self.buttonEndDate.setTitle(self.endTime.toString(format: .custom("dd/MM/yyyy")), for: .normal)
        self.pickStartTime = true
        self.refreshDatePicker()
    }
    
    func refreshDatePicker() {
        self.buttonStartDate.isSelected = self.pickStartTime
        self.buttonEndDate.isSelected = !self.pickStartTime
        self.datePicker.minimumDate = self.pickStartTime ? nil : self.startTime
        self.datePicker.maximumDate = self.pickStartTime ? self.endTime : nil
        self.datePicker.date = self.pickStartTime ? self.startTime : self.endTime
    }
    
    func show() {
        self.viewContent.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.viewContent.transform = .identity
            self.viewContent.layer.opacity = 1
        }
    }
    // MARK: - Utils
    
    
    // MARK: - CallBacks
    @IBAction func onClickButtonStartDate(_ sender: Any) {
        self.pickStartTime = true
        self.refreshDatePicker()
    }
    
    @IBAction func onClickButtonEndDate(_ sender: Any) {
        self.pickStartTime = false
        self.refreshDatePicker()
    }
    
    @IBAction func onClickButtonDone(_ sender: Any) {
        self.done?(self.startTime, self.endTime)
        self.dismiss()
    }
    
    @objc func valueChangedDatePicker() {
        if self.pickStartTime {
            self.startTime = self.datePicker.date
            self.buttonStartDate.setTitle(self.startTime.toString(format: .custom("dd/MM/yyyy")), for: .normal)
        }
        else {
            self.endTime = self.datePicker.date
            self.buttonEndDate.setTitle(self.endTime.toString(format: .custom("dd/MM/yyyy")), for: .normal)
        }
    }
}
