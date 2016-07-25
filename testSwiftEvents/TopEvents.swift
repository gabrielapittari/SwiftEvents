//
//  Events.swift
//  testSwiftEvents
//
//  Created by Gabriela Pittari on 21/07/2016.
//  Copyright © 2016 Gabriela Pittari. All rights reserved.
//
import Foundation
import Gloss

public struct TopEvents: Decodable {
    
    public let events: [Event]?
    
    public init?(json: JSON) {
        events = "events" <~~ json
    }
}
