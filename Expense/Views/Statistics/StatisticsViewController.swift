//
//  StatisticsViewController.swift
//  Expense
//
//  Created by Tùng Xuân on 14/10/2021.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var scrollViewContent: UIScrollView!
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var labelStartTime: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var labelOut: UILabel!
    @IBOutlet weak var labelIn: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    
    @IBOutlet weak var pieChartSource: PieChartView!
    @IBOutlet weak var pieChartCategory: PieChartView!
    
    var refreshControl = UIRefreshControl()
    var expenditures: [Expenditure] = []
    var startTime = Date.fromOrdinalDay(Date().ordinalDay() - 30)
    var endTime = Date()
    var valueOut: Double = 0
    var valueIn: Double = 0
    var valueSummary: Double = 0
    var dictOutCategory: [Category: Double] = [:]
    var dictSource: [String: Double] = [:]
    
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
        self.refreshControl.addTarget(self, action: #selector(refreshUI), for: .valueChanged)
        self.scrollViewContent.refreshControl = self.refreshControl
        
        self.refreshUI()
    }
    
    @objc func refreshUI() {
        self.getExpenditures()
        self.labelStartTime.text = self.startTime.toString(format: .custom("dd/MM/yyyy"))
        self.labelEndTime.text = self.endTime.toString(format: .custom("dd/MM/yyyy"))
        
        self.labelIn.text = Currency.vnd.get(self.valueIn)
        self.labelOut.text = Currency.vnd.get(self.valueOut)
        self.labelSummary.text = Currency.vnd.get(self.valueSummary)
        self.labelSummary.textColor = self.valueSummary >= 0 ? UIColor(named: "Green") : UIColor(named: "Feature")
        
        var outCategoryEntries = [PieChartDataEntry]()
        for k in self.dictOutCategory.keys {
            if let y = self.dictOutCategory[k] {
                outCategoryEntries.append(.init(value: -y, label: k.rawValue))
            }
        }
        outCategoryEntries = Array(outCategoryEntries.sorted { $0.value > $1.value }.prefix(5))
        let v = -self.valueOut - outCategoryEntries.map { $0.value }.reduce(0, +)
        outCategoryEntries.append(.init(value: v, label: "Khác"))
        let outCategorySet = PieChartDataSet(entries: outCategoryEntries, label: "")
        outCategorySet.entryLabelColor = .clear
        outCategorySet.valueTextColor = .clear
        outCategorySet.colors = ChartColorTemplates.colorful() + ChartColorTemplates.material()
        let outCategoryData = PieChartData(dataSet: outCategorySet)
        self.pieChartCategory.data = outCategoryData
        
        var sourceEntries = [PieChartDataEntry]()
        for k in self.dictSource.keys {
            if let y = self.dictSource[k] {
                sourceEntries.append(.init(value: -y, label: k))
            }
        }
        let sourceSet = PieChartDataSet(entries: sourceEntries, label: "")
        sourceSet.colors = ChartColorTemplates.joyful() + ChartColorTemplates.liberty()
        sourceSet.entryLabelColor = .clear
        sourceSet.valueTextColor = .clear
        let sourceData = PieChartData(dataSet: sourceSet)
        self.pieChartSource.data = sourceData
        self.refreshControl.endRefreshing()
    }
    
    // MARK: - Utils
    func getExpenditures() {
        self.expenditures = AppData.getExpenditures(start: self.startTime, end: self.endTime)
        self.valueIn = 0
        self.valueOut = 0
        self.dictSource.removeAll()
        self.dictOutCategory.removeAll()
        
        for ex in self.expenditures {
            if ex.value >= 0 { self.valueIn += ex.value }
            else { self.valueOut += ex.value }
            
            if ex.value < 0 {
                self.dictOutCategory[ex.category, default: 0] += ex.value
                self.dictSource[ex.source, default: 0] += ex.value
            }
        }
        self.valueSummary = self.valueIn + self.valueOut
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
                self?.refreshUI()
            }
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func onClickButtonShare(_ sender: Any) {
        if let image = UIImage.imageCapture(with: self.viewContent) {
            let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(ac, animated: true, completion: nil)
        }
    }
}
