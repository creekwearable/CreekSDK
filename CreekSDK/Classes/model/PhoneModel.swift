//
//  PhoneModel.swift
//  CreekSDK
//
//  Created by bean on 2023/10/27.
//

import Foundation

public class PhoneModel:Codable{
    
    public var contactName:String?
    
    public var phoneNumber:String?
    
    public init(contactName: String? = nil, phoneNumber: String? = nil) {
        self.contactName = contactName
        self.phoneNumber = phoneNumber
    }
    
}
