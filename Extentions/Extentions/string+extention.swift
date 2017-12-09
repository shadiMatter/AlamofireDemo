//
//  string+extention.swift
//  AFSample
//
//  Created by Shadi Matter on 10/26/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import Foundation

extension String{
    var trimmed: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
