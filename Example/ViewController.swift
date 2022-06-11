//
//  ViewController.swift
//  SmapleAccordionTableView
//
//  Created by NishiokaKohei on 09/06/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: AccordionTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.switch(.single)
        tableView.registerHeader(
            nib: .init(nibName: "AccordionHeaderFooterView", bundle: nil),
            identifier: "AccordionHeaderFooterView")
        tableView.commitInit()

        var tableDataList = [SectionGroup<String, CellData>]()
        tableDataList.append(
            SectionGroup(section: "AAA",
                         items: [.init(name: "test_001"),
                                 .init(name: "test_002"),
                                 .init(name: "test_003")]))
        tableDataList.append(
            SectionGroup(section: "BBB",
                         items: [.init(name: "test_004"),
                                 .init(name: "test_005"),
                                 .init(name: "test_006")]))
        tableDataList.append(
            SectionGroup(section: "CCC",
                         items: [.init(name: "test_007"),
                                 .init(name: "test_008"),
                                 .init(name: "test_009")]))
        tableDataList.append(
            SectionGroup(section: "DDD",
                         items: [.init(name: "test_010"),
                                 .init(name: "test_011")]))
        tableDataList.append(
            SectionGroup(section: "EEE",
                         items: [.init(name: "test_012"),
                                 .init(name: "test_013")]))
        tableView.reloadData(tableDataList) { sectionGroup, indexPath, cell in
            print("bind > section: \(indexPath.section), row: \(indexPath.row)")
            cell.textLabel?.text = sectionGroup.items[indexPath.row].name
        }
    }

}

