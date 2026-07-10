//
//  DropDownView.swift
//  CollabPlatformIOS
//
//  Created by 刘凯 on 2026/7/9.
//

import UIKit
internal import SnapKit
fileprivate let AppW : CGFloat = UIScreen.main.bounds.size.width
fileprivate let AppH : CGFloat = UIScreen.main.bounds.size.height

class DropDownView: UIView,UITableViewDelegate,UITableViewDataSource {
    typealias DropDownViewBlock = (Int,String) -> ()
    var selectionAction : DropDownViewBlock?
    @IBOutlet weak var tWidth: NSLayoutConstraint!
    @IBOutlet weak var tHeight: NSLayoutConstraint!
    @IBOutlet weak var rightMargin: NSLayoutConstraint!
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!

    var ddLeftMargin : CGFloat = 0
    var leftOffset : CGFloat = 0
    var topOffset : CGFloat = 0
    var anchorView : UIView = UIView()
    var ddWidth : CGFloat = 0 {
        didSet {
            tWidth.constant = ddWidth
        }
    }
    var ddBackgroundColor : UIColor = UIColor.white {
        didSet {
            tableView.backgroundColor = ddBackgroundColor
        }
    }

    var ddCornerRadius : CGFloat = 0 {
        didSet {
            tableView.layer.cornerRadius = ddCornerRadius
        }
    }
    var borderColor : UIColor = UIColor(red: 247.0, green: 247.0, blue: 247.0, alpha: 1)
    var borderWidth : CGFloat = 1

    var dataSource : [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var cellHeight : CGFloat = 40

    var contentView : UIView?

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: AppW, height: AppH))
        contentView = Bundle.main.loadNibNamed("DropDownView", owner: self)?.first as? UIView
        self.addSubview(contentView!)
        self.backgroundColor = UIColor.clear
        contentView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        tableView.layer.cornerRadius = ddCornerRadius
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.setupBaseInfo()
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nullMethod)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismiss() {
        self.removeFromSuperview()
    }
    @objc func nullMethod() {
    }

    func setupBaseInfo() {
        tableView.layer.borderColor = (borderColor as! CGColor)
        tableView.layer.borderWidth = borderWidth
    }

    func show() {
        let frame = anchorView.frame
        let point = anchorView.convert(CGPoint(x: 0, y: 0), to: nil)

        let tm = point.y
        let bm = AppH - point.y - frame.height
        var height = CGFloat(dataSource.count) * cellHeight
        var isBottom : Bool = true
        /// 如果高度大于下面的间距，则计算高度是否大于100 如果大于100 则在下面，
        /// 如果不大于100则在上面
        if height > bm {
            let syH = height - (height - bm)
            if syH > 100 {
                height = syH
                isBottom = true
            } else {
                isBottom = false
            }
            if !isBottom {
                if height > tm {
                    let tsyh = height - (height - tm)
                    height = tsyh
                }
            }
        }
        tHeight.constant = height
        if isBottom {
            topMargin.constant = point.y + frame.size.height + topOffset
        } else {
            topMargin.constant = point.y - height + topOffset
        }
        if ddLeftMargin != 0 {
            leftMargin.constant = ddLeftMargin
        } else {
            leftMargin.constant = point.x + leftOffset
        }
        if ddWidth == 0 {
            tWidth.constant = frame.size.width
        } else {
            tWidth.constant = ddWidth
        }
        UIApplication.shared.windows.first?.addSubview(self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DownSelectedTableViewCell.tableViewCell(
            tableView,
            type: DownSelectedTableViewCell.self
        ) as! DownSelectedTableViewCell
        cell.index = indexPath.row
        cell.titleValue.text = dataSource[indexPath.row]
        cell.downSelectedTableViewCellBlock = { index in
            if self.selectionAction != nil {
                self.selectionAction?(index,self.dataSource[index])
                self.dismiss()
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView?.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview().offset(0)
        }
    }

}
