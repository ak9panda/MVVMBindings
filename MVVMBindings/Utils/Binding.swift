//
//  Binding.swift
//  MVVMBindings
//
//  Created by admin on 26/09/2021.
//

import Foundation

// Observable
class Observable<T> {
    var value: T? {
        didSet {
            listeners.forEach({
                $0(value)
            })
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listeners: [((T?) -> Void)] = []
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listeners.append(listener)
    }
}
