//
//  PopUpVC.swift
//  iSignIn
//
//  Created by meet sharma on 22/07/23.
//

import UIKit
import RealmSwift

protocol SelectBrandViewControllerDelegate: AnyObject {
    func selectBrand(_ selectBrand: SelectBrandViewController, didSelectId: Int, title: String, forType: String)
}

protocol SelectStateViewControllerDelegate: AnyObject {
    func selectState(_ selectBrand: SelectBrandViewController, didSelectId: String, title: String, forType: String)
}

class SelectBrandViewController: UIViewController {
    
    struct DatasourceItem {
        let id: Int
        let title: String
    }
    
    struct DatasourceItemState {
        let iSO: String
        let title: String
    }
    
    @IBOutlet private weak var tblVwList: UITableView!
    
    weak var delegate: SelectBrandViewControllerDelegate?
    weak var delegateState: SelectStateViewControllerDelegate?
    var selectionSource = "brand" //brand, type, presentationId, timezone
    var _tableDatasource = [DatasourceItem]()
    var stateTblDatasource = [DatasourceItemState]()
    var selectedBrandId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let realm = RealmManager.shared.getMainRealm() {
            if selectionSource == "brand" {
                let objects = realm.objects(Brand.self)
                for item in objects {
                    let data = DatasourceItem(id: item.brandId, title: item.label)
                    _tableDatasource.append(data)
                }
            }
            else if selectionSource == "type" {
                if let object = realm.objects(Brand.self).filter("brandId == %@", selectedBrandId).first {
                    for item in object.programTypes {
                        let data = DatasourceItem(id: item.typeId, title: item.label)
                        _tableDatasource.append(data)
                    }
                }
            }
            else if selectionSource == "presentationId" {
                if let object = realm.objects(Brand.self).filter("brandId == %@", selectedBrandId).first {
                    for item in object.presentations {
                        let data = DatasourceItem(id: item.presentationId, title: item.label)
                        _tableDatasource.append(data)
                    }
                }
            }
            else if selectionSource == "timezone" {
                let objects = realm.objects(TimeZone.self)
                for item in objects {
                    let data = DatasourceItem(id: item.tzId, title: item.label)
                    _tableDatasource.append(data)
                }
            }
            
            else if selectionSource == "Degree" {
                let objects = realm.objects(Degrees.self)
                for item in objects {
                    let data = DatasourceItem(id: item.degreeId, title: item.label)
                    _tableDatasource.append(data)
                }
            }
            else if selectionSource == "Speaciality" {
                let objects = realm.objects(Specialities.self)
                for item in objects {
                    let data = DatasourceItem(id: item.specId, title: item.label)
                    _tableDatasource.append(data)
                }
                
            }
            
            
            else if selectionSource == "State" {
                let objects = realm.objects(States.self)
                for item in objects {
                    let data = DatasourceItemState(iSO: item.iso, title: item.label)
                    stateTblDatasource.append(data)
                }
                var uniqueItems = [DatasourceItemState]()
                var uniqueISOs = Set<String>()

                stateTblDatasource.forEach { item in
                    if !uniqueISOs.contains(item.iSO) {
                        uniqueISOs.insert(item.iSO)
                        uniqueItems.append(item)
                    }
                }
                print(uniqueItems)
                stateTblDatasource = uniqueItems
               
            }
            else if selectionSource == "StateLicance" {
                let objects = realm.objects(States.self)
                for item in objects {
                    let data = DatasourceItemState(iSO: item.iso, title: item.label)
                    stateTblDatasource.append(data)
                }
                var uniqueItems = [DatasourceItemState]()
                var uniqueISOs = Set<String>()

                stateTblDatasource.forEach { item in
                    if !uniqueISOs.contains(item.iSO) {
                        uniqueISOs.insert(item.iSO)
                        uniqueItems.append(item)
                    }
                }
                print(uniqueItems)
                stateTblDatasource = uniqueItems
            }

        }
    }
   

}

extension SelectBrandViewController: UITableViewDelegate,UITableViewDataSource{
    //MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectionSource == "State" || selectionSource == "StateLicance"{
            return stateTblDatasource.count
        }else{
            return _tableDatasource.count
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectBrandTVC", for: indexPath)
        if selectionSource == "State" || selectionSource == "StateLicance"{
            let dataItem = stateTblDatasource[indexPath.row]
            var config = cell.defaultContentConfiguration()
            config.text = dataItem.title
            cell.contentConfiguration = config
        }else{
            let dataItem = _tableDatasource[indexPath.row]
            var config = cell.defaultContentConfiguration()
            config.text = dataItem.title
            cell.contentConfiguration = config
        }
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectionSource == "State" || selectionSource == "StateLicance"{
            let dataItem = stateTblDatasource[indexPath.row]
            delegateState?.selectState(self, didSelectId: dataItem.iSO, title: dataItem.title, forType: selectionSource)
        }else{
            let dataItem = _tableDatasource[indexPath.row]
            delegate?.selectBrand(self, didSelectId: dataItem.id, title: dataItem.title, forType: selectionSource)
        }
        
    }

}
