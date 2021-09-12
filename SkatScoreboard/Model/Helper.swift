//
//  Helper.swift
//  SkatScoreboard
//
//  Created by Olaf Neumann on 12.09.21.
//

import Foundation

func map<K,V>(_ keys: [K], to value: (K) -> V) -> [K:V] {
    keys.reduce([K:V](), { (dict, key) in
        var dict = dict
        dict[key] = value(key)
        return dict
    })
}

func map<K,V>(_ keys: [K], to value: V) -> [K:V] {
    map(keys, to: {key in 0 as! V})
}
