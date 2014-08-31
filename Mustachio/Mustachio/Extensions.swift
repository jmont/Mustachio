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
