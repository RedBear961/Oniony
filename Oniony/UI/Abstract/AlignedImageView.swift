/*
 * Copyright (c) 2019  WebView, Lab
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public protocol BitField: OptionSet {
    
    static func | (lhs: Self, rhs: Self) -> Self
    static func & (lhs: Self, rhs: Self) -> Self
    static prefix func ~ (rhs: Self) -> Self
    static func |= (lhs: inout Self, rhs: Self)
    static func &= (lhs: inout Self, rhs: Self)
}

public extension BitField where RawValue: FixedWidthInteger {
    
    static func | (lhs: Self, rhs: Self) -> Self {
        return .init(rawValue: lhs.rawValue | rhs.rawValue)
    }
    
    static func & (lhs: Self, rhs: Self) -> Self {
        return .init(rawValue: lhs.rawValue & rhs.rawValue)
    }
    
    static prefix func ~ (rhs: Self) -> Self {
        return .init(rawValue: ~rhs.rawValue)
    }
    
    static func |= (lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    static func &= (lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }
}

public final class AlignedImageView: UIImageView {
    
    public struct AlignmentMask: BitField {
        
        public static let center    = AlignmentMask(rawValue: 0)
        public static let left      = AlignmentMask(rawValue: 1 << 0)
        public static let right     = AlignmentMask(rawValue: 1 << 1)
        public static let top       = AlignmentMask(rawValue: 1 << 2)
        public static let bottom    = AlignmentMask(rawValue: 1 << 3)
        
        public static let bottomLeft: AlignmentMask = .bottom | .left
        
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}
