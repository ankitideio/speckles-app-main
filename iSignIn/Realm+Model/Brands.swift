//
//  Brands.swift
//  iSignIn
//
//  Created by meet sharma on 22/07/23.
//

import Foundation
import RealmSwift

class Brand: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var brandId: Int = 0
    @Persisted var label: String = ""
    
    @Persisted var programTypes = List<ProgramType>()
    @Persisted var presentations = List<Presentation>()
    
    convenience init(json: NSDictionary) {
        self.init()
        self.brandId = json["id"] as? Int ?? 0
        self.label = json["label"] as? String ?? ""
        
        if let programTypes = json["active_program_types"] as? NSArray {
            for item in programTypes {
                guard let type = item as? NSDictionary else {
                    continue
                }
                let typeObject = ProgramType()
                typeObject.typeId = type["id"] as? Int ?? 0
                typeObject.label = type["label"] as? String ?? ""
                self.programTypes.append(typeObject)
                
//                print("program type id: \(type["id"]) title: \(type["label"])")
            }
        }
        
        if let presentations = json["presentations"] as? NSArray {
            for item in presentations {
                guard let presentation = item as? NSDictionary else {
                    continue
                }
                let presentationObject = Presentation()
                presentationObject.presentationId = presentation["id"] as? Int ?? 0
                presentationObject.label = presentation["label"] as? String ?? ""
                self.presentations.append(presentationObject)
//                print("presentations id: \(presentation["id"]) title: \(presentation["title"])")
            }
        }
        
    }
    
    func updateBrand (withSyncedBrand syncBrand: Brand) {
        self.label = syncBrand.label
        
        self.programTypes.removeAll()
        for item in syncBrand.programTypes {
            let type = ProgramType()
            type.typeId = item.typeId
            type.label = item.label
            self.programTypes.append(type)
        }
        
        self.presentations.removeAll()
        for item in syncBrand.presentations {
            let presentation = Presentation()
            presentation.presentationId = item.presentationId
            presentation.label = item.label
            self.presentations.append(presentation)
        }
    }
    
}

class ProgramType: EmbeddedObject {
    @Persisted var typeId: Int = 0
    @Persisted var label: String = ""
    let owner = LinkingObjects(fromType: Brand.self, property: "programTypes")
}

class Presentation: EmbeddedObject {
    @Persisted var presentationId: Int = 0
    @Persisted var label: String = ""
    let owner = LinkingObjects(fromType: Brand.self, property: "presentations")
}
