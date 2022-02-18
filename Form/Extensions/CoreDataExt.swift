//
//  CoreDataExt.swift
//  Form
//
//  Created by Fernando González González on 18/02/22.
//

import Foundation
import CoreData
import UIKit

extension UIViewController{
    
    func getContextCoreData() -> NSManagedObjectContext{
        let ctx = UIApplication.shared.delegate as! AppDelegate
        return ctx.persistentContainer.viewContext
    }
    
}
