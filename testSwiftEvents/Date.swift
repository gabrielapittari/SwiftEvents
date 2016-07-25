//
//  Date.swift
//  testSwiftEvents
//
//  Created by Gabriela Pittari on 21/07/2016.
//  Copyright © 2016 Gabriela Pittari. All rights reserved.
//
import Foundation
import Gloss

public struct Date: Decodable {
    
    public let timezone: String
    public let local: String
    public let utc: String
    
    public init?(json: JSON) {
        
        guard let timezone: String = "timezone" <~~ json
            else { return nil }
        guard let local: String = "local" <~~ json
            else { return nil }
        guard let utc: String = "utc" <~~ json
            else { return nil }
        
        self.timezone = timezone
        self.utc = utc
        self.local = local
    }
    

}
