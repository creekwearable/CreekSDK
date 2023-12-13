//
//  ParseJson.swift
//  CreekSDK
//
//  Created by bean on 2023/7/3.
//

import Foundation


class ParseJson {
    
     class func jsonToModel<T: Codable>(_ modelType: T.Type, _ response: Any) -> T? {
         
         if  let data = try? JSONSerialization.data(withJSONObject: response){
             do{
                 let info = try JSONDecoder().decode(T.self, from: data)
                 return info;
             }catch{
                 print("Error converting string to dictionary: \(error.localizedDescription)")
                 return nil;
             }
         }
         return nil;
     }
    
    

    
}
