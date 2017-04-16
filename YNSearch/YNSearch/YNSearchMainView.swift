//
//  YNSearchMainView.swift
//  YNSearch
//
//  Created by YiSeungyoun on 2017. 4. 16..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

class YNSearchMainView: UIView {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height

    var categoryLabel: UILabel!
    var ynCategoryButtons = [YNCategoryButton]()
    
    var searchHistoryLabel: UILabel!
    var ynSearchHistoryButtons = [YNSearchHistoryButton]()
    
    var leftMargin:CGFloat = 15
    var delegate: YNSearchMainViewDelegate?
    
    var ynSerach = YNSerach()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let categories = YNSerach.shared.getCategories() else { return }
        self.initView(categories: categories)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.redrawSearchHistoryButtons()
    }

    
    func ynCategoryButtonClicked(_ sender: UIButton) {
        self.delegate?.ynCategoryButtonClicked(sender)
    }
    
    func ynSearchHistoryButtonClicked(_ sender: UIButton) {
        self.delegate?.ynSearchHistoryButtonClicked(sender)
    }
    
    

    func initView(categories: [String]) {
        self.categoryLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: width - 40, height: 50))
        self.categoryLabel.text = "Categories"
        self.categoryLabel.font = UIFont.systemFont(ofSize: 13)
        self.categoryLabel.textColor = UIColor.darkGray
        self.addSubview(self.categoryLabel)
        
        let font = UIFont.systemFont(ofSize: 12)
        let userAttributes = [NSFontAttributeName : font, NSForegroundColorAttributeName: UIColor.gray]
        
        var formerWidth: CGFloat = leftMargin
        var formerHeight: CGFloat = 50
        
        for i in 0..<categories.count {
            let size = categories[i].size(attributes: userAttributes)
            if i > 0 {
                formerWidth = ynCategoryButtons[i-1].frame.size.width + ynCategoryButtons[i-1].frame.origin.x + 10
                if formerWidth + size.width + 10 > UIScreen.main.bounds.width {
                    formerHeight += ynCategoryButtons[i-1].frame.size.height + 10
                    formerWidth = leftMargin
                }
            }
            let button = YNCategoryButton(frame: CGRect(x: formerWidth, y: formerHeight, width: size.width + 10, height: size.height + 10))
            button.addTarget(self, action: #selector(ynCategoryButtonClicked(_:)), for: .touchUpInside)
            button.setTitle(categories[i], for: .normal)
            button.tag = i
            
            ynCategoryButtons.append(button)
            self.addSubview(button)
            
        }
        guard let originY = ynCategoryButtons.last?.frame.origin.y else { return }
        self.searchHistoryLabel = UILabel(frame: CGRect(x: leftMargin, y: originY + 30, width: width - 40, height: 50))
        self.searchHistoryLabel.text = "Search History"
        self.searchHistoryLabel.font = UIFont.systemFont(ofSize: 13)
        self.searchHistoryLabel.textColor = UIColor.darkGray
        self.addSubview(self.searchHistoryLabel)
        
        
    }
    
    func redrawSearchHistoryButtons() {
        let histories = ynSerach.getSearchHistories() ?? [String]()
        
        let searchHistoryLabelOriginY: CGFloat = searchHistoryLabel.frame.origin.y + 20

        for i in 0..<histories.count {
            let button = YNSearchHistoryButton(frame: CGRect(x: leftMargin, y: searchHistoryLabelOriginY + CGFloat(i * 20) , width: width - (leftMargin * 20), height: 40))
            button.addTarget(self, action: #selector(ynSearchHistoryButtonClicked(_:)), for: .touchUpInside)
            button.setTitle(histories[i], for: .normal)
            button.tag = i
            
            ynSearchHistoryButtons.append(button)
            self.addSubview(button)
            
        }

    }
}
