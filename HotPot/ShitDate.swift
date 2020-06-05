//
//  ShitDate.swift
//  HotPot
//
//  Created by duanzengguang on 2020/2/9.
//  Copyright © 2020 duanzengguang. All rights reserved.
//

import UIKit
import WCDBSwift

class ShitDate: TableCodable {
    var identifier: Int = 0
    var description: String? = nil
    var date: Date = Date()
    var dateString: String {
        return date.string(withFormat: "yyyy年MM月dd日 HH:mm")
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = ShitDate
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case identifier
        case date
        case description
        
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                identifier: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true, isUnique: true, defaultTo: 0)
            ]
        }
    }
    
    var isAutoIncrement: Bool{
        return true
    }
}

