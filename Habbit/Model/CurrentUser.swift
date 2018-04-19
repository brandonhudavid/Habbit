//
//  CurrentUser.swift
//  Habbit
//
//  Created by Brandon David on 4/15/18.
//  Copyright © 2018 IrisBrandon. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CurrentUser {
    
    var username: String!
    var id: String!
    var readPostIDs: [String]?
    
    init() {
        let currentUser = Auth.auth().currentUser
        username = currentUser?.displayName
        id = currentUser?.uid
    }
}
