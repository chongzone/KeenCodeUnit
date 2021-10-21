//
//  KeenUtils.swift
//  KeenCodeUnit
//
//  Created by chongzone on 2021/3/16.
//

import UIKit

// 更多控件的扩展可参考地址 https://github.com/chongzone/KeenExtension.git
extension NSObject {
    
    /// 类名
    public var className: String {
        let name = type(of: self).description()
        if name.contains(".") {
            return name.components(separatedBy: ".").last!
        }else {
            return name
        }
    }
    
    /// 类名
    public static var className: String {
        return String(describing: self)
    }
}

extension String {
    
    /// 截取特定范围的字符串 索引从 0 开始
    /// - Parameters:
    ///   - location: 开始的索引位置
    ///   - length: 截取长度
    /// - Returns: 字符串
    public func substring(at location: Int, length: Int) -> String {
        if location > self.count || (location+length > self.count) {
            assert(location < self.count && location+length <= self.count, "越界, 检查设置的范围")
        }
        var subStr: String = ""
        for idx in location..<(location+length) {
            subStr += self[self.index(self.startIndex, offsetBy: idx)].description
        }
        return subStr
    }
}

extension CGFloat {
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat { UIScreen.main.bounds.size.width }
    /// 屏幕高度
    public static var screenHeight: CGFloat { UIScreen.main.bounds.size.height }
}

extension UIView {
    
    /// 初始化
    public convenience init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: width, height: height))
    }
}

extension UIView {

    public var x: CGFloat {
        get {
            return frame.origin.x
        } set(value) {
            frame = CGRect(x: value, y: y, width: width, height: height)
        }
    }

    public var y: CGFloat {
        get {
            return frame.origin.y
        } set(value) {
            frame = CGRect(x: x, y: value, width: width, height: height)
        }
    }

    public var width: CGFloat {
        get {
            return frame.size.width
        } set(value) {
            frame = CGRect(x: x, y: y, width: value, height: height)
        }
    }

    public var height: CGFloat {
        get {
            return frame.size.height
        } set(value) {
            frame = CGRect(x: x, y: y, width: width, height: value)
        }
    }

    public var origin: CGPoint {
        get {
            return frame.origin
        } set(value) {
            frame = CGRect(origin: value, size: frame.size)
        }
    }

    public var size: CGSize {
        get {
            return frame.size
        } set(value) {
            frame = CGRect(origin: frame.origin, size: value)
        }
    }

    public var centerX: CGFloat {
        get {
            return center.x
        } set(value) {
            center = CGPoint(x: value, y: centerY)
        }
    }

    public var centerY: CGFloat {
        get {
            return center.y
        } set(value) {
            center = CGPoint(x: centerX, y: value)
        }
    }

    public var top: CGFloat {
        get {
            return y
        } set(value) {
            y = value
        }
    }

    public var left: CGFloat {
        get {
            return x
        } set(value) {
            x = value
        }
    }

    public var bottom: CGFloat {
        get {
            return y + height
        } set(value) {
            y = value - height
        }
    }

    public var right: CGFloat {
        get {
            return x + width
        } set(value) {
            x = value - width
        }
    }
}

extension UIView {
    
    /// frame
    /// - Parameter frame: frame
    /// - Returns: 自身
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    /// 背景色
    /// - Parameter color: 颜色
    /// - Returns: 自身
    @discardableResult
    public func backColor(_ color: UIColor?) -> Self {
        backgroundColor = color
        return self
    }
    
    /// tag 值
    /// - Parameter tag: tag 值
    /// - Returns: 自身
    @discardableResult
    public func tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    
    /// 是否支持响应 label & imageView 默认 false
    /// - Parameter enabled: 是否支持响应
    /// - Returns: 自身
    @discardableResult
    public func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        isUserInteractionEnabled = enabled
        return self
    }
    
    /// 着色
    /// 具有传递性 即: 传递到子视图 若子视图设置 tintColor 则使用子视图 否则使用父视图的 tintColor
    /// 若父子视图都没设置则使用系统的 tintColor 其中系统默认蓝色 如: 系统按钮默认蓝色背景
    /// 对图片可通过其 UIImage.RenderingMode 中的  alwaysTemplate &  tintColor 达到实现指定色值的图片
    /// - Parameter color: 颜色值
    /// - Returns: 自身
    @discardableResult
    public func tintColor(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    /// 添加到父视图
    /// - Parameter superView: 父视图
    /// - Returns: 自身
    @discardableResult
    public func addViewTo(_ superView: UIView) -> Self {
        superView.addSubview(self)
        return self
    }
}

extension CALayer {
    
    /// frame
    /// - Parameter frame: frame
    /// - Returns: 自身
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    
    /// 背景色
    /// - Parameter color: 颜色
    /// - Returns: 自身
    @discardableResult
    public func backColor(_ color: UIColor) -> Self {
        backgroundColor = color.cgColor
        return self
    }
    
    /// 是否隐藏
    /// - Parameter isHidden: 是否隐藏
    /// - Returns: 自身
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }
    
    /// 圆角 默认裁剪
    /// - Parameter radius: 圆角
    /// - Parameter mask: 是否裁剪
    /// - Returns: 自身
    @discardableResult
    public func corner(_ radius: CGFloat, mask: Bool = true) -> Self {
        cornerRadius = radius
        masksToBounds = mask
        return self
    }
    
    /// 边框宽度
    /// - Parameter width: 宽度
    /// - Returns: 自身
    @discardableResult
    public func borderWidth(_ width: CGFloat) -> Self {
        borderWidth = width
        return self
    }
    
    /// 边框颜色
    /// - Parameter color: 颜色
    /// - Returns: 自身
    @discardableResult
    public func borderColor(_ color: UIColor) -> Self {
        borderColor = color.cgColor
        return self
    }
    
    /// 添加到父视图
    /// - Parameter superView: 父视图
    /// - Returns: 自身
    @discardableResult
    public func addLayerTo(_ superView: UIView) -> Self {
        superView.layer.addSublayer(self)
        return self
    }
}

extension CALayer {
    
    /// 基础动画配置 默认配置: 执行 1 次 时长 2s 无延迟 效果慢进慢出
    /// - Parameters:
    ///   - keyPath: 动画类型
    ///   - fromValue: 开始值
    ///   - toValue: 结束值
    ///   - duration: 动画持续时间 单位 s
    ///   - delay: 延迟时间 单位 s
    ///   - repeatCount: 动画重复次数
    ///   - fillMode: 动画填充模式 默认 forwards
    ///   - speed: 动画速度 默认 1.0 若速度为 0 且设置对应的 timeOffset 则可暂停动画
    ///   - timeOffset: 附加的偏移量 默认 0
    ///   - repeatDuration: 动画重复的时长 默认 0
    ///   - autoreverses: 动画结束是否自动反向运动 默认 false
    ///   - isCumulative: 是否累计动画 默认 false
    ///   - removedOnCompletion: 结束后是否回到原状态 默认 false
    ///   - option: 动画的控制方式
    ///   - animationKey: 控制动画执行对应的key
    public func basicAnimationKeyPath(
        keyPath: String,
        fromValue: Any?,
        toValue: Any?,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        fillMode: CAMediaTimingFillMode = .forwards,
        speed: Float = 1.0,
        timeOffset: TimeInterval = 0,
        repeatDuration: TimeInterval = 0,
        autoreverses: Bool = false,
        isCumulative: Bool = false,
        removedOnCompletion: Bool = false,
        option: CAMediaTimingFunctionName = .default,
        animationKey: String?
    ) {
        let animation: CABasicAnimation = CABasicAnimation()
        animation.beginTime = delay + self.convertTime(CACurrentMediaTime(), to: nil)
        
        if let fValue = fromValue { animation.fromValue = fValue }
        if let tValue = toValue { animation.toValue = tValue }
        
        animation.keyPath = keyPath
        animation.duration = duration
        animation.fillMode = fillMode
        animation.repeatCount = repeatCount
        animation.autoreverses = autoreverses
        
        animation.speed = speed
        animation.timeOffset = timeOffset
        animation.repeatDuration = repeatDuration
        
        animation.isCumulative = isCumulative
        animation.isRemovedOnCompletion = removedOnCompletion
        animation.timingFunction = CAMediaTimingFunction(name: option)
        self.add(animation, forKey: animationKey)
    }
}

extension CAShapeLayer {
 
    /// 设置路径 决定了其形状
    /// - Parameters:
    ///   - path: 路径
    /// - Returns: 自身
    @discardableResult
    public func path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }
    
    /// 填充色
    /// - Parameters:
    ///   - color: 填充色
    /// - Returns: 自身
    @discardableResult
    public func fillColor(_ color: UIColor) -> Self {
        self.fillColor = color.cgColor
        return self
    }
    
    /// 线条颜色
    /// - Parameters:
    ///   - color: 线条颜色
    /// - Returns: 自身
    @discardableResult
    public func strokeColor(_ color: UIColor) -> Self {
        self.strokeColor = color.cgColor
        return self
    }
    
    /// path 终点样式 butt(无样式) round(圆形) square(方形)
    /// - Parameters:
    ///   - cap: 终点样式
    /// - Returns: 自身
    @discardableResult
    public func lineCap(_ cap: CAShapeLayerLineCap) -> Self {
        self.lineCap = cap
        return self
    }
    
    /// 路径连接部分的拐角样式 miter(尖状) round(圆形) bevel(平形)
    /// - Parameters:
    ///   - join: 拐角样式
    /// - Returns: 自身
    @discardableResult
    public func lineJoin(_ join: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = join
        return self
    }
}

extension UITextField {
    
    /// 代理
    /// - Parameter delegate: 代理
    /// - Returns: 自身
    @discardableResult
    public func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    
    /// 文本
    /// - Parameter text: 文本
    /// - Returns: 自身
    @discardableResult
    public func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    /// 字体 默认系统 12pt 字体
    /// - Parameter font: 字体
    /// - Returns: 自身
    @discardableResult
    public func font(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }
    
    /// 文本颜色
    /// - Parameter color: 颜色
    /// - Returns:  自身
    @discardableResult
    public func textColor(_ color: UIColor?) -> Self {
        textColor = color
        return self
    }
    
    /// 对齐方式  默认靠左
    /// - Parameter alignment: 对齐方式
    /// - Returns: 自身
    @discardableResult
    public func alignment(_ alignment: NSTextAlignment = .left) -> Self {
        textAlignment = alignment
        return self
    }
    
    /// 键盘样式
    /// - Parameter type: 键盘样式
    /// - Returns: 自身
    @discardableResult
    public func keyboardType(_ type: UIKeyboardType) -> Self {
        keyboardType = type
        return self
    }
    
    /// 文本加密 默认 false
    /// - Parameter isSecure: 是否加密
    /// - Returns: 自身
    @discardableResult
    public func isSecureText(_ isSecure: Bool = false) -> Self {
        isSecureTextEntry = isSecure
        return self
    }
}
