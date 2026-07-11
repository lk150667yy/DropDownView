//
//  DownSelectedTableViewCell.swift
//  CollabPlatformIOS
//
//  Created by 刘凯 on 2026/3/1.
//

import UIKit

class DownSelectedTableViewCell: UITableViewCell {
    typealias DownSelectedTableViewCellBlock = (Int) -> ()
    var downSelectedTableViewCellBlock : DownSelectedTableViewCellBlock?
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var titleValue: UILabel!
    var index : Int = 0
    var value : String = "" {
        didSet {
            titleValue.text = value
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchMethod)))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static func tableViewCell(_ tableView:UITableView,type : UITableViewCell.Type) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: getCellID(type))
        if cell == nil {
            tableView.register(UINib(nibName: "\(type)", bundle: nil), forCellReuseIdentifier: getCellID(type))
            cell = tableView.dequeueReusableCell(withIdentifier: getCellID(type))
        }
        return cell!
    }

    static func getCellID(_ type : UITableViewCell.Type) -> String {
        return "\(type)ID"
    }
    @objc func touchMethod() {
        if self.downSelectedTableViewCellBlock != nil {
            self.downSelectedTableViewCellBlock?(index)
        }
    }
}
