//
//  AccordionHeaderFooterView.swift
//  SmapleAccordionTableView
//
//  Created by NishiokaKohei on 09/06/2022.
//

import UIKit

protocol AccordionTableViewHeaderFooterViewDelegate: AnyObject {
    func accordionTableViewHeaderFooterView(_ header: AccordionHeaderFooterView, section: Int)
}

class AccordionHeaderFooterView: UITableViewHeaderFooterView {

    weak var delegate: AccordionTableViewHeaderFooterViewDelegate?
    @IBOutlet weak var nameLabel: UILabel!
    var section = 0

    override var reuseIdentifier: String? {
        return "AccordionHeaderFooterView"
    }

    override func awakeFromNib() {
        if #available(iOS 14.0, *) {
            var backgroundConfig =  UIBackgroundConfiguration.listPlainHeaderFooter()
            backgroundConfig.backgroundColor = .systemBackground
            backgroundConfiguration = backgroundConfig
        } else if #available(iOS 13.0, *) {
            contentView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
    }

    @IBAction private func didTap(_ sender: Any) {
        delegate?.accordionTableViewHeaderFooterView(self, section: section)
    }

}
