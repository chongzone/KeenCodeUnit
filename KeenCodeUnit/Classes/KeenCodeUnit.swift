//
//  KeenCodeUnit.swift
//  KeenCodeUnit
//
//  Created by chongzone on 2021/3/16.
//

import UIKit

public extension KeenCodeUnitAttributes {
    
    /// 样式
    enum Style {
        /// 分割下划线
        case splitline
        /// 分割边框
        case splitborder
        /// 连续边框
        case followborder
    }
}

//MARK: - 属性参数
public struct KeenCodeUnitAttributes {
    
    /// 视图背景色 默认 white
    public var viewBackColor: UIColor = UIColor.white
    
    /// 样式 默认 splitline
    public var style: KeenCodeUnitAttributes.Style = .splitline
    
    /// 位数 默认 6 位
    public var count: Int = 6
    /// 控件间隔 默认 12 pt  style 为 followborder 失效
    public var itemSpacing: CGFloat = 12
    /// 控件左右边距 默认 15 pt
    public var itemPadding: CGFloat = 15
    /// 默认情况下首个控件是否高亮显示 默认 true
    public var isFirstAlive: Bool = true
    /// 是否单个高亮 即仅针对获取焦点的控件高亮 默认 false 其中 style 为 followborder 失效
    public var isSingleAlive: Bool = false
    /// 内容是否自动填写 默认 true
    public var isAutoFillin: Bool = true
    /// 文本是否加密 默认 false
    public var isSecureTextEntry: Bool = false
    
    /// 文本颜色 默认 black
    public var textColor: UIColor = .black
    /// 文本字体 默认常规 15pt
    public var textFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    
    /// 光标颜色 默认 blue
    public var cursorColor: UIColor = .blue
    /// 光标宽度 默认 1.6pt
    public var cursorWidth: CGFloat = 1.6
    /// 光标高度百分比 即占视图高度的百分比 默认 0.5
    public var cursorHeightPercent: CGFloat = 0.5
    
    /// 下划线高度 默认 1pt
    public var lineHeight: CGFloat = 1
    /// 下划线圆角 默认 高度 * 0.5
    public var lineRadius: CGFloat = 0.5
    /// 下划线颜色 默认 lightGray
    public var lineColor: UIColor = .lightGray
    /// 下划线高亮颜色 默认 black
    public var lineHighlightedColor: UIColor = .black
    /// 下划线错误颜色 默认 red
    public var lineErrorColor: UIColor = .red
    
    /// 边框高亮时是否视图呈现出覆盖完全 默认 true 仅针对 '连续边框' 样式有效
    public var isSingleCoverAll: Bool = true
    /// 边框宽度 默认 1pt
    public var borderWidth: CGFloat = 1
    /// 边框圆角 默认 4pt
    public var borderRadius: CGFloat = 4
    /// 边框颜色 默认 lightGray
    public var borderColor: UIColor = .lightGray
    /// 边框高亮颜色 默认 black
    public var borderHighlightedColor: UIColor = .black
    /// 边框错误颜色 默认 red
    public var borderErrorColor: UIColor = .red
    
    public init() { }
}

//MARK: - 协议
public protocol KeenCodeUnitDelegate: AnyObject {
    
    /// 属性参数 可选 不设置取默认值
    /// - Returns: 属性对象
    func attributesOfCodeUnit(for codeUnit: KeenCodeUnit) -> KeenCodeUnitAttributes
    
    /// 输入回调事件 优先级高于闭包回调
    func codeUnit(_ codeUnit: KeenCodeUnit, codeText: String, complete: Bool)
}

public extension KeenCodeUnitDelegate {
    
    func attributesOfCodeUnit(for codeUnit: KeenCodeUnit) -> KeenCodeUnitAttributes {
        return KeenCodeUnitAttributes()
    }
}

//MARK: - KeenCodeUnit 类
public class KeenCodeUnit: UIView {
    
    /// 代理
    public weak var delegate: KeenCodeUnitDelegate?
    
    /// 光标
    private lazy var cursors: [CAShapeLayer] = []
    /// 下划线、边框
    private lazy var layers: [CAShapeLayer] = []
    /// 文本框
    private lazy var fileds: [UITextField] = []
    /// 属性参数
    private lazy var attributes: KeenCodeUnitAttributes = {
        if let d = delegate {
            return d.attributesOfCodeUnit(for: self)
        }else {
            return KeenCodeUnitAttributes()
        }
    }()
    /// 输入回调 优先级低于代理回调
    public var callback: ((String, Bool) -> ())?
    
    private lazy var textFiled: UITextField = {
        let view = UITextField(frame: bounds)
            .textColor(.clear)
            .backColor(.clear)
            .tintColor(.clear)
            .keyboardType(.numberPad)
            .addViewTo(self)
        if attributes.isAutoFillin {
            if #available(iOS 12.0, *) {
                view.textContentType =  .oneTimeCode
            }
        }
        view.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        return view
    }()
    
    /// 初始化 推荐
    /// - Parameters:
    ///   - frame: frame
    ///   - delegate: 代理
    public init(
        frame: CGRect,
        delegate: KeenCodeUnitDelegate
    ) {
        super.init(frame: frame)
        self.delegate = delegate
        createSubviews()
    }
    
    /// 初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - attributes: 属性参数 若为 nil 取默认值
    public init(
        frame: CGRect,
        attributes: KeenCodeUnitAttributes? = nil
    ) {
        super.init(frame: frame)
        if let attr = attributes { self.attributes = attr }
        createSubviews()
    }
    
    /// 初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - attributes: 属性参数 若为 nil 取默认值
    ///   - callback: 输入回调事件
    public init(
        frame: CGRect,
        attributes: KeenCodeUnitAttributes?,
        callback: @escaping ((String, Bool) -> ())
    ) {
        super.init(frame: frame)
        self.callback = callback
        if let attr = attributes { self.attributes = attr }
        createSubviews()
    }
    
    /// 输入内容验证错误处理
    public func verifyErrorAction() {
        textFiled.text = ""
        fileds.forEach { $0.text = nil }
        layers.forEach({ layer in
            switch attributes.style {
            case .splitline: layer.backColor(attributes.lineErrorColor)
            case .splitborder: layer.borderColor(attributes.borderErrorColor)
            case .followborder: layer.strokeColor(attributes.borderErrorColor)
            }
            /// 水平抖动
            let fromValue = CGPoint(x: layer.position.x + 2, y: layer.position.y)
            let endValue = CGPoint(x: layer.position.x - 2, y: layer.position.y)
            layer.basicAnimationKeyPath(
                keyPath: "position",
                fromValue: fromValue,
                toValue: endValue,
                duration: 0.1,
                delay: 0,
                repeatCount: 1,
                fillMode: .forwards,
                removedOnCompletion: true,
                option: .easeInEaseOut,
                animationKey: nil
            )
        })
        cursorConfiguration(at: 0, hidden: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [unowned self] in
            for idx in 0..<self.layers.count {
                var isSet = false
                if idx == 0, self.attributes.isFirstAlive { isSet = true }
                self.itemConfiguration(at: idx, isSet: isSet)
            }
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            textFiled.becomeFirstResponder()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textFiled.becomeFirstResponder()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - 布局|配置
private extension KeenCodeUnit {
    
    /// 布局控件
    func createSubviews() {
        textFiled.frame = bounds
        backgroundColor = attributes.viewBackColor
        for idx in 0..<attributes.count {
            if attributes.style == .followborder { attributes.itemSpacing = 0 }
            let itemSpacings = CGFloat(attributes.count-1) * attributes.itemSpacing
            let totalSpace = itemSpacings + attributes.itemPadding * 2
            let itemH = height
            let itemW = (width - totalSpace) / CGFloat(attributes.count)
            let viewX = (itemW + attributes.itemSpacing) * CGFloat(idx) + attributes.itemPadding
            
            let backView = UIView(x: viewX, y: 0, width: itemW, height: itemH)
                .isUserInteractionEnabled(false)
                .backColor(.clear)
                .addViewTo(self)
            
            /// 文本框
            let field = UITextField(x: 0, y: 0, width: itemW, height: itemH)
                .textColor(attributes.textColor)
                .font(attributes.textFont)
                .alignment(.center)
                .isSecureText(attributes.isSecureTextEntry)
                .addViewTo(backView)
            
            /// 光标
            let rect = CGRect(
                x: itemW * 0.5,
                y: (itemH - itemH * attributes.cursorHeightPercent) * 0.5,
                width: attributes.cursorWidth,
                height: itemH * attributes.cursorHeightPercent
            )
            let cursor = CAShapeLayer()
                .isHidden(idx != 0)
                .fillColor(attributes.cursorColor)
                .path(UIBezierPath(rect: rect).cgPath)
                .addLayerTo(backView)
            if idx == 0 {
                cursorAnimation(cursor)
            }
            
            /// 下划线、边框
            let layer = CAShapeLayer()
            switch attributes.style {
            case .splitline:
                let layerH = attributes.lineHeight
                let layerY = itemH - attributes.lineHeight
                layer.frame(CGRect(x: 0, y: layerY, width: itemW, height: layerH))
                    .corner(attributes.lineRadius)
                    .addLayerTo(backView)
                if idx == 0 {
                    if !attributes.isFirstAlive {
                        layer.backColor(attributes.lineColor)
                    }else {
                        layer.backColor(attributes.lineHighlightedColor)
                    }
                }else {
                    layer.backColor(attributes.lineColor)
                }
            case .splitborder:
                layer.frame(CGRect(x: 0, y: 0, width: itemW, height: itemH))
                    .borderWidth(attributes.borderWidth)
                    .corner(attributes.borderRadius)
                    .addLayerTo(backView)
                if idx == 0 {
                    if !attributes.isFirstAlive {
                        layer.borderColor(attributes.borderColor)
                    }else {
                        layer.borderColor(attributes.borderHighlightedColor)
                    }
                }else {
                    layer.borderColor(attributes.borderColor)
                }
            case .followborder:
                let path = UIBezierPath()
                if idx == 0 {
                    path.move(to: CGPoint(x: attributes.borderRadius, y: 0))
                    path.addLine(to: CGPoint(x: itemW, y: 0))
                    path.addLine(to: CGPoint(x: itemW, y: itemH))
                    path.addLine(to: CGPoint(x: attributes.borderRadius, y: itemH))
                    path.addArc(
                        withCenter: CGPoint(x: attributes.borderRadius, y: itemH - attributes.borderRadius),
                        radius: attributes.borderRadius,
                        startAngle: CGFloat(Double.pi/2),
                        endAngle: CGFloat(Double.pi),
                        clockwise: true
                    )
                    path.addLine(to: CGPoint(x: 0, y: attributes.borderRadius))
                    path.addArc(
                        withCenter: CGPoint(x: attributes.borderRadius, y: attributes.borderRadius),
                        radius: attributes.borderRadius,
                        startAngle: CGFloat(Double.pi),
                        endAngle: CGFloat(Double.pi + Double.pi/2),
                        clockwise: true
                    )
                }else if idx == attributes.count - 1 {
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: itemW - attributes.borderRadius, y: 0))
                    path.addArc(
                        withCenter: CGPoint(x: itemW - attributes.borderRadius, y: attributes.borderRadius),
                        radius: attributes.borderRadius,
                        startAngle: CGFloat(Double.pi/2 + Double.pi),
                        endAngle: CGFloat(Double.pi*2),
                        clockwise: true
                    )
                    path.addLine(to: CGPoint(x: itemW, y: itemH - attributes.borderRadius))
                    path.addArc(
                        withCenter: CGPoint(x: itemW - attributes.borderRadius, y: itemH - attributes.borderRadius),
                        radius: attributes.borderRadius,
                        startAngle: 0.0,
                        endAngle: CGFloat(Double.pi/2),
                        clockwise: true
                    )
                }else {
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: itemW, y: 0))
                    path.addLine(to: CGPoint(x: itemW, y: itemH))
                }
                if idx != 0 {
                    path.addLine(to: CGPoint(x: 0, y: itemH))
                    if !attributes.isSingleCoverAll { path.addLine(to: .zero) }
                }
                
                layer.frame(backView.bounds)
                    .borderColor(.clear)
                    .borderWidth(0.0)
                    .path(path.cgPath)
                    .fillColor(.clear)
                    .lineJoin(.round)
                    .addLayerTo(backView)
                if idx == 0 {
                    if !attributes.isFirstAlive {
                        layer.strokeColor(attributes.borderColor)
                    }else {
                        layer.strokeColor(attributes.borderHighlightedColor)
                    }
                }else {
                    layer.strokeColor(attributes.borderColor)
                }
            }
            layers.append(layer)
            fileds.append(field)
            cursors.append(cursor)
        }
    }
    
    @objc func textChange(_ textField: UITextField) {
        var code = textField.text ?? ""
        if code.count > attributes.count {
            let substring = textField.text!.prefix(attributes.count)
            textField.text = String(substring)
            code = textField.text!
        }
        for idx in 0..<attributes.count {
            let field: UITextField = fileds[idx]
            field.text = idx < code.count ? code.substring(at: idx, length: 1) : ""
            cursorConfiguration(at: idx, hidden: code.count != idx)
            if attributes.isSingleAlive, attributes.style != .followborder {
                itemConfiguration(at: idx, isSet: idx == code.count)
            }else {
                itemConfiguration(at: idx, isSet: idx <= code.count)
            }
        }
        if let d = delegate {
            d.codeUnit(self, codeText: code, complete: code.count == attributes.count)
        }else {
            if let c = callback {
                c(code, code.count == attributes.count)
            }
        }
    }
    
    /// 光标动画
    func cursorAnimation(_ layer: CAShapeLayer) {
        layer.basicAnimationKeyPath(
            keyPath: "opacity",
            fromValue: 1.0,
            toValue: 0.0,
            duration: 1.0,
            delay: 0,
            repeatCount: .greatestFiniteMagnitude,
            fillMode: .forwards,
            removedOnCompletion: true,
            option: .easeIn,
            animationKey: "kCursorOpacicy"
        )
    }
    
    /// 光标事件
    func cursorConfiguration(at index: Int, hidden: Bool) {
        let cursor = cursors[index]
        if hidden {
            cursor.removeAnimation(forKey: "kCursorOpacicy")
        }else {
            cursorAnimation(cursor)
        }
        UIView.animate(withDuration: 0.25) {
            cursor.isHidden = hidden
        }
    }
    
    /// 下划线、边框等事件
    func itemConfiguration(at index: Int, isSet: Bool) {
        let layer = layers[index]
        let lineColor = isSet ? attributes.lineHighlightedColor : attributes.lineColor
        let borderColor = isSet ? attributes.borderHighlightedColor : attributes.borderColor
        switch attributes.style {
        case .splitline: layer.backColor(lineColor)
        case .splitborder: layer.borderColor(borderColor)
        case .followborder: layer.strokeColor(borderColor)
        }
    }
}
