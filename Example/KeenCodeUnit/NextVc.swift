//
//  NextVc.swift
//  KeenCodeUnit
//
//  Created by chongzone on 2021/3/16.
//

import UIKit
import KeenCodeUnit

class NextVc: UIViewController {

    var type: Int = 0
    
    private var codeUnit: KeenCodeUnit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backColor(.white)
        
        let rect = CGRect(x: 30, y: 200, width: CGFloat.screenWidth - 60, height: 44)
        
        /// 方式 1
        codeUnit = KeenCodeUnit(
            frame: rect,
            delegate: self
        ).addViewTo(view)
        
        /// 其他
//        var attr = KeenCodeUnitAttributes()
//        switch type {
//        case 0:
//            attr.style = .splitline
//        case 1:
//            attr.style = .splitline
//            attr.isSingleAlive = true
//        case 2:
//            attr.style = .splitline
//            attr.isSecureTextEntry = true
//        case 3:
//            attr.style = .splitborder
//        case 4:
//            attr.style = .splitborder
//            attr.isSingleAlive = true
//        case 5:
//            attr.style = .followborder
//        default:
//            attr.style = .splitline
//        }
//        attr.count = 6
//        attr.borderColor = .lightGray
//        attr.borderHighlightedColor = .black
        
        /// 方式 2
//        codeUnit = KeenCodeUnit(
//            frame: rect,
//            attributes: attr,
//            callback: { codeText, complete in
//                if complete {
//                    /// 验证输入内容是否为 "202103" 不是错误处理
//                    if codeText != "202103" {
//                        self.codeUnit.verifyErrorAction()
//                    }
//                    print(codeText)
//                }
//            }
//        )
//            .addViewTo(view)
        
        /// 方式 3
//        codeUnit = KeenCodeUnit(
//            frame: rect,
//            attributes: attr
//        )
//            .addViewTo(view)
//        codeUnit.callback = { (codeText, complete) in
//            if complete {
//                /// 验证输入内容是否为 "202103" 不是错误处理
//                if codeText != "202103" {
//                    self.codeUnit.verifyErrorAction()
//                }
//                print(codeText)
//            }
//        }
    }
}

extension NextVc: KeenCodeUnitDelegate {
    
    func attributesOfCodeUnit(for codeUnit: KeenCodeUnit) -> KeenCodeUnitAttributes {
        var attr = KeenCodeUnitAttributes()
        switch type {
        case 0:
            attr.style = .splitline
        case 1:
            attr.style = .splitline
            attr.isSingleAlive = true
        case 2:
            attr.style = .splitline
            attr.isSecureTextEntry = true
        case 3:
            attr.style = .splitborder
        case 4:
            attr.style = .splitborder
            attr.isSingleAlive = true
        case 5:
            attr.style = .followborder
        default:
            attr.style = .splitline
        }
        return attr
    }
    
    func codeUnit(_ codeUnit: KeenCodeUnit, codeText: String, complete: Bool) {
        if complete {
            /// 验证输入内容是否为 "202103" 不是错误处理
            if codeText != "202103" {
                self.codeUnit.verifyErrorAction()
            }
            print(codeText)
        }
    }
}
