//
//  KeyValueStorageAssembly.swift
//  Pods
//
//  Created by Andrew Rolya on 7/30/20.
//

import UIKit
import EasyDi
import KeychainSwift

public class StoragesAssembly: Assembly {
    public var keyValueStorage: IKeyValueStorage {
        return define(scope: .lazySingleton, init: Defaults())
    }
    
    public var keychainStorage: KeychainSwift {
        return define(scope: .lazySingleton, init: KeychainSwift())
    }	
}
