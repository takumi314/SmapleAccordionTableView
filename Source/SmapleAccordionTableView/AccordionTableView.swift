//
//  AccordionTableView.swift
//  SmapleAccordionTableView
//
//  Created by NishiokaKohei on 09/06/2022.
//

import UIKit

struct SectionGroup<T, D> {
    var section: T
    var items: [D]
}

struct CellData {
    let name: String
}

final class AccordionTableView: UITableView {
    typealias Section = String
    typealias Cell = CellData

    enum ExpandMode {
        case single
        case multiple
    }

    private(set) var expandSectionSet = Set<Int>()
    private(set) var expandSection = -1
    private(set) var tableDataList = [SectionGroup<Section, Cell>]()
    private(set) var mode: ExpandMode = .single
    private(set) var bindingTo: ((SectionGroup<Section, Cell>, IndexPath, UITableViewCell) -> Void)?
    private let _locker = NSLock()

    func `switch`(_ mode: ExpandMode) {
        if mode == .multiple {
            expandSectionSet = Set<Int>()
        } else {
            expandSection = -1
        }
        self.mode = mode
    }

    func commitInit() {
        sectionHeaderHeight = 30
        rowHeight = 60
        dataSource = self
        delegate = self
    }

    func registerCell(nib: UINib?, identifier: String) {
        register(nib, forCellReuseIdentifier: identifier)
    }

    func registerHeader(nib: UINib?, identifier: String) {
        register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func reloadData(
        _ group: [SectionGroup<Section, Cell>],
        binding: @escaping (SectionGroup<Section, Cell>, IndexPath, UITableViewCell) -> Void
    ) {
        _locker.lock()
        self.tableDataList = group
        self.bindingTo = binding
        reloadData()
        _locker.unlock()
    }

}

// MARK: - UITableViewDataSource
extension AccordionTableView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableDataList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .multiple {
            return expandSectionSet.contains(section) ? tableDataList[section].items.count : 0
        }
        // singleモード
        return expandSection == section ? tableDataList[section].items.count : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        bindingTo?(tableDataList[indexPath.section], indexPath, cell)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: "AccordionHeaderFooterView") as? AccordionHeaderFooterView
        header?.section = section
        header?.nameLabel.text = tableDataList[section].section
        header?.delegate = self
        return header
    }

}

// MARK: - UITableViewDelegate
extension AccordionTableView: UITableViewDelegate {
    // default
}

// MARK: - AccordionTableViewHeaderFooterViewDelegate
extension AccordionTableView: AccordionTableViewHeaderFooterViewDelegate {
    func accordionTableViewHeaderFooterView(_ header: AccordionHeaderFooterView, section: Int) {
        if mode == .single {
            if expandSection == -1 {
                expandSection = section
                reloadSections([section], with: .automatic)
            } else if expandSection == section {
                expandSection = -1
                reloadSections([section], with: .automatic)
            } else {
                let oldSection = expandSection
                expandSection = section
                reloadSections([section, oldSection], with: .automatic)
            }
        } else if mode == .multiple {
            if expandSectionSet.contains(section) {
                expandSectionSet.remove(section)
            } else {
                expandSectionSet.insert(section)
            }
            reloadSections([section], with: .none)
        }
    }
}
