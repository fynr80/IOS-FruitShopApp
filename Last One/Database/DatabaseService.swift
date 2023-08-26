//
//  DatabaseService.swift
//  Client1
//
//  Created by ii on 13.06.23.
//

 import Foundation
 import GRDB

class DatabaseService: ObservableObject {
    let queue: DatabaseQueue
    
    init(previewContent: Bool) {
        
        if previewContent {
        queue = try! DatabaseQueue(path: ":memory:")
        }else{
        let documentsDirectory = try! FileManager.default
        .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let databaseUrl = documentsDirectory.appendingPathComponent("database.sqlite")
        let databasePath = databaseUrl.absoluteString
            print("Database Path: \(databasePath)")
        queue = try! DatabaseQueue(path: databasePath)
        }
        
        var migrator = DatabaseMigrator()
        migrator.registerMigration("V1") { db in
            try db.create(table: "DatabaseProduct") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("vendorId", .text).notNull()
                t.column("productId", .text).notNull()
                t.column("categoryId", .text).notNull()
                t.column("name", .text).notNull()
                t.column("description", .text).notNull()
                t.column("price", .double).notNull()
                t.column("amount", .integer).notNull()

            }
        }
        try! migrator.migrate(queue)
    }
}



