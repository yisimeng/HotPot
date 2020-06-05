//
//  DBManager.swift
//  HotPot
//
//  Created by duanzengguang on 2020/2/9.
//  Copyright © 2020 duanzengguang. All rights reserved.
//

import UIKit
import WCDBSwift

struct DBManager {
    
    private static var dataBase: Database = {
        guard let documenPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first  else {
            fatalError("error document directory")
        }
        let db_path = documenPath+"/hotpot.db"
        return Database(withPath: db_path)
    }()
    
    static func create<T:TableCodable>(table name: String, for objectClass: T.Type) {
        do {
            let isExist = try dataBase.isTableExists(name)
            if isExist == false {
                try dataBase.create(table: name, of: objectClass)
            }
        } catch let error {
            debugPrint("create error: \(error.localizedDescription)")
        }
    }
    
    static func inseart<Object: TableCodable>(objects: Object..., intoTable: String){
        do {
            try dataBase.insert(objects: objects, intoTable: intoTable)
        } catch let error {
            debugPrint("insert error: \(error.localizedDescription)")
        }
    }
    static func delete(fromTable: String, where condition: Condition? = nil) -> Void {
        do {
            try dataBase.delete(fromTable: fromTable, where: condition)
        } catch let error {
            debugPrint("delete error \(error.localizedDescription)")
        }
    }
    static func qurey<T: TableDecodable>(fromTable: String, cls cName: T.Type, where condition: Condition? = nil, orderBy orderList:[OrderBy]? = nil) -> [T]? {
        do {
            let allObjects: [T] = try (dataBase.getObjects(fromTable: fromTable, where: condition, orderBy: orderList))
            return allObjects
        } catch let error {
            debugPrint("no data find \(error.localizedDescription)")
        }
        return nil
    }
}
