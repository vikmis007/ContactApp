//
//  ListViewModel.swift
//  Contact
//
//  Created by vikas mishra on 19/10/19.
//  Copyright © 2019 vikas mishra. All rights reserved.
//

import Foundation
protocol ListViewModelProtocol: class {
    func reloadUI()
}

class ListViewModel {
    internal var persons:[Person]?
    internal var personsOgraniseDict:[String:[Person]] = [String:[Person]]()
    internal var personsSortedDictByKey: [(key: String, value: [Person])]?
    internal var apiErrorMessage: APIErrorEnum?
    internal let sectionTitles:[String] = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
                                           "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    weak var delegate: ListViewModelProtocol?
    private let listService = ListContactService()
    
    
    let letters = CharacterSet.letters
    
    func getContactList() {
        persons = nil
        apiErrorMessage = nil
        
        let users: [User] = CoreDataManager.shared.fetchObjectList()
        if users.count > 0 {
            persons = [Person]()
            for user in users {
                let person = Person(user: user)
                persons?.append(person!)
            }
            organiseDataToSortedDict()
        } else {
            listService.getContactList { (persons, errorEnum) in
                if let msg = errorEnum {
                    self.apiErrorMessage = msg
                    self.delegate?.reloadUI()
                } else {
                    CoreDataManager.shared.insertObjects(persons: persons!)
                    self.persons = persons
                    self.organiseDataToSortedDict()
                }
            }
        }
    }
    
    func organiseDataToSortedDict() {
        for person in persons! {
            let ch = String(person.firstName[person.firstName.startIndex]).uppercased()
            if letters.contains(UnicodeScalar(ch)!) {
                if let _ = personsOgraniseDict[ch] {
                    personsOgraniseDict[ch]?.append(person)
                } else {
                    personsOgraniseDict[ch] = [Person]()
                    personsOgraniseDict[ch]?.append(person)
                }
            } else {
                if let _ = personsOgraniseDict["#"] {
                    personsOgraniseDict["#"]?.append(person)
                } else {
                    personsOgraniseDict["#"] = [Person]()
                    personsOgraniseDict["#"]?.append(person)
                }
            }
        }
        personsSortedDictByKey = personsOgraniseDict.sorted { (obj1, obj2) -> Bool in
            obj1.key < obj2.key
        }
        self.delegate?.reloadUI()
    }
}
