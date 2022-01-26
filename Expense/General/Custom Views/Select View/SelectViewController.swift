//
//  SelectViewController.swift
//  matchme
//
//  Created by Tung Xuan on 7/28/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import UIKit

struct SelectData {
    var icon: UIImage?
    var title: String
}

enum SelectType {
    case radio
    case checkbox
    case maxSelect
}

class SelectViewController: UIViewController {

    @IBOutlet weak var tableViewData: UITableView!
    
    var arrData = [SelectData]()
    var arrSelected = [Bool]()
    var indexSelected = -1
    var arrIndexSelected = [Int]()
    var maxSelect = -1
    var type = SelectType.checkbox
    
    var deleteMode = false
    
    private var selectDone: ((_ arrData: [SelectData],_ arrIndexSelected: [Int]) -> Void)? = nil
    private var deleteCell: ((_ index: Int) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
	deinit {
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

    func setupUI() {
        self.tableViewData.register(UINib(nibName: "SelectCell", bundle: nil), forCellReuseIdentifier: "SelectCell")
        self.tableViewData.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 50))
    }
    
    func done(f: @escaping ((_ arrData: [SelectData],_ arrIndexSelected: [Int]) -> Void)) {
        self.selectDone = f
    }
    
    func delete(f: @escaping ((_ index: Int) -> Void)) {
        self.deleteCell = f
    }
    
    @IBAction func onClickButtonDone(_ sender: Any) {
        var indixes = [Int]()
        if self.type == .radio { indixes = self.indexSelected != -1 ? [self.indexSelected] : [] }
        if self.type == .checkbox {
            for (i, b) in self.arrSelected.enumerated() {
                if b { indixes.append(i) }
            }
        }
        if self.type == .maxSelect {
            indixes = self.arrIndexSelected
        }
        self.selectDone?(self.arrData, indixes)
        self.dismiss()
    }
}

extension SelectViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCell", for: indexPath) as! SelectCell
        let data = self.arrData[row]
        cell.setupUI(icon: data.icon, title: data.title)
        if self.type == .checkbox {
            cell.accessoryType = self.arrSelected[row] ? .checkmark : .none
        }
        if self.type == .radio {
            cell.accessoryType = row == self.indexSelected ? .checkmark : .none
        }
        if self.type == .maxSelect {
            cell.accessoryType = self.arrIndexSelected.firstIndex(of: row) != nil ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.type == .radio {
            self.indexSelected = indexPath.row
            tableView.reloadData()
        }
        if self.type == .checkbox {
            self.arrSelected[indexPath.row] = !self.arrSelected[indexPath.row]
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
        let row = indexPath.row
        if self.type == .maxSelect {
            if self.arrIndexSelected.contains(row) {
                self.arrIndexSelected.removeAll { $0 == row }
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            else {
                self.arrIndexSelected.append(row)
                if (self.arrIndexSelected.count > self.maxSelect) { self.arrIndexSelected.removeFirst() }
                tableView.reloadData()
            }
        }
        
        if self.type == .radio {
            self.onClickButtonDone(0)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if self.deleteMode {
            if editingStyle == .delete {
                self.arrData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.deleteCell?(indexPath.row)
                self.arrSelected.remove(at: indexPath.row)
                if self.indexSelected == indexPath.row { self.indexSelected = -1 }
                self.arrIndexSelected.removeAll { $0 == indexPath.row }
            }
        }
    }
}

extension SelectViewController {
    static func get(title: String, type: SelectType, arrData: [SelectData], preIndexSelected: [Int] = [], maxSelect: Int = -1) -> SelectViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectViewController") as! SelectViewController
        vc.title = title
        vc.type = type
        vc.arrData = arrData
        vc.maxSelect = maxSelect
        if vc.maxSelect == -1 && type == .maxSelect {
            vc.type = .checkbox
        }
        vc.arrSelected = Array(repeating: false, count: arrData.count)
        if preIndexSelected.count == 0 { return vc }
        if type == .radio {
            if let i = preIndexSelected.first {
                vc.indexSelected = i
            }
        }
        else {
            for index in preIndexSelected {
                vc.arrSelected[index] = true
            }
            vc.arrIndexSelected = preIndexSelected.suffix(max(maxSelect, 0))
        }
        return vc
    }
    
    
}


