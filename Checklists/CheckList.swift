//
//  CheckList.swift
//  Checklists
//
//  Created by Boris Ofon on 12/17/22.
//

import Foundation

class Checklist: NSObject {
    var name = ""
    
    init(name: String = "") {
        self.name = name
        super.init()
    }
}
