//
//  Extensions.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

extension String {
    subscript (r: Range<Int>) -> String {
        var start = advance(startIndex, r.startIndex)
        var end = advance(startIndex, r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }

    func length() -> Int {
        return Array(self).count
    }

    // From: https://github.com/Halotis/EscapeHTML/blob/master/EscapeHTML/EscapeHTML.swift
    func escapeHTML() -> String{
        var result = self.stringByReplacingOccurrencesOfString("&", withString: "&amp;", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString("\"", withString: "&quot;", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString("'", withString: "&#39;", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString("<", withString: "&lt;", options: nil, range: nil)
        result = result.stringByReplacingOccurrencesOfString(">", withString: "&gt;", options: nil, range: nil)
        return result
    }

    func trimWhitespace() -> String {
        var f = {(c: Character) -> Bool in c == " "};
        var front = Array(self).dropWhile(f)
        var back = front.reverse().dropWhile(f).reverse()

        return String(seq: back)
    }
}

extension Array {
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }

    func dropWhile(p : T -> Bool) -> [T] {
        var list = Array<T>()
        var dropping = true
        for x in self {
            if dropping && p(x) {
                continue
            } else if dropping {
                dropping = false
                list.append(x)
            } else {
                list.append(x)
            }
        }
        return list
    }

    func takeWhile (p : T -> Bool) -> [T] {
        var list = Array<T>()
        var taking = true
        for x in self {
            if taking && p(x) {
                list.append(x)
            } else if taking {
                break
            }
        }
        return list
    }
}


func +=<K, V> (inout left: Dictionary<K, V>, right: Dictionary<K, V>) -> Dictionary<K, V> {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
    return left
}
extension Dictionary {


}
