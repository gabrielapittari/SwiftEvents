//
//  Event.swift
//  testSwiftEvents
//
//  Created by Gabriela Pittari on 19/07/2016.
//  Copyright © 2016 Gabriela Pittari. All rights reserved.
//
import Foundation
import Gloss

public struct Event: Decodable {
    
    public let name: String
    public let description: String
    public let start: Date?
    public let end: Date?
    public let iconURL: String
    public let city: String
    public let id: String
    
    public init?(json: JSON) {

        guard let name: String = "name.text" <~~ json
            else { return nil }
        
        guard let description: String = "description.text" <~~ json
            else { return nil }
        
        guard let start: Date = "start" <~~ json
            else { return nil }
        
        guard let end: Date = "end" <~~ json
            else { return nil }
        
        guard let iconURL: String = "logo.url" <~~ json
            else { return nil }
        
        guard let id: String = "id" <~~ json
            else { return nil }
        
        self.name = name
        self.description = description
        self.start = start
        self.end = end
        self.iconURL = iconURL
        self.city = ""
        self.id = id

    }

}
