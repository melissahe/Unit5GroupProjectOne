//
//  FileManagerHelper.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation

class FileManagerHelper {
    private init() {}
    
    static let manager = FileManagerHelper()
    
    //stores the names of the collections
    private var collectionNamesFilePath = "CollectionNames.plist"
    
    //stores the venues of each collection
    private var collectionsFilePath = "Collections.plist"
    
    private var collectionNames: [String] = [] {
        didSet {
            saveCollectionNames()
        }
    }
    
    private var collections: [[VenueTipModel]] = [] {
        didSet {
            saveCollections()
        }
    }
    
    private let encoder = PropertyListEncoder()
    
    private let decoder = PropertyListDecoder()

//MARK: - File Manager Helper Functions
    //document directory
    func documentDirectory() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[0]
    }
    //data file path
    func dataFilePath(_ fileName: String) -> URL {
        return documentDirectory().appendingPathComponent(fileName)
    }
    //save
    private func saveCollectionNames() {
        let filePath = dataFilePath(collectionNamesFilePath)
        
        do {
            let data = try encoder.encode(collectionNames)
            try data.write(to: filePath, options: .atomic)
            print("saved collection names!")
        } catch {
            print("could not save collection names")
            print()
            print(error)
        }
    }
    private func saveCollections() {
        let filePath = dataFilePath(collectionsFilePath)
        
        do {
            let data = try encoder.encode(collections)
            try data.write(to: filePath, options: .atomic)
            print("saved collections!")
        } catch {
            print("could not save collections")
            print()
            print(error)
        }
    }
    //load
    public func loadCollectionNames() {
        let filePath = dataFilePath(collectionNamesFilePath)
        
        do {
            let data = try Data.init(contentsOf: filePath)
            let savedCollectionNames = try decoder.decode([String].self, from: data)
            collectionNames = savedCollectionNames
            print("loaded collection names!")
        } catch {
            print("could not load collection names!")
            print()
            print(error)
        }
    }
    public func loadCollections() {
        let filePath = dataFilePath(collectionsFilePath)
        
        do {
            let data = try Data.init(contentsOf: filePath)
            let savedCollections = try decoder.decode([[VenueTipModel]].self, from: data)
            collections = savedCollections
            print("loaded collections!")
        } catch {
            print("could not load collections!")
            print()
            print(error)
        }
    }
    //add
    public func addNewEmptyCollection(withName name: String) -> Bool {
        if !collectionNames.contains(name) {
            self.collectionNames.append(name)
            self.collections.append([])
            print("added new collection with name \(name)!!")
            return true
        }
        return false // should present message saying "A collection with this name already exists; please use a different name"
    }
    public func addNewCollection(_ newCollection: [VenueTipModel], withCollectionName newName: String) -> Bool {
        if collectionNames.contains(newName) {
            print("could not add new collection")
            return false // should present message saying "A collection with this name already exists; please use a different name"
        }
        self.collectionNames.append(newName)
        self.collections.append(newCollection)
        print("added new collection!!")
        return true
    }
    public func addVenueToExistingCollection(venue newVenue: VenueTipModel, withCollectionIndex index: Int) -> Bool {
        var existingCollection = collections[index]
        
        if existingCollection.contains(newVenue) {
            print("could not add venue to existing collection")
            return false // should present message saying "this venue is already in this collection", etc
        }
        
        existingCollection.append(newVenue)
        collections[index] = existingCollection
        print("added venue to existing collection")
        
        return true
    }
    //get
    public func getCollectionNames() -> [String] {
        print("got collection names!")
        return collectionNames
    }
    public func getCollections() -> [[VenueTipModel]] {
        print("got collections")
        return collections
    }

    //TODO: Extra Credit
    //update - extra credit
    public func updateCollectionName(atIndex index: Int, withName newName: String) {
        self.collectionNames[index] = newName
        print("update collection name!!")
    }
    //TODO: should be able to update tip!!! - need to create new view controller
    //remove - extra credit
    public func removeCollection(atIndex index: Int) {
        self.collectionNames.remove(at: index)
        self.collections.remove(at: index)
        print("removed collection!!")
    }
    public func removeVenue(atVenueIndex venueIndex: Int, fromCollectionIndex collectionIndex: Int) {
        collections[collectionIndex].remove(at: venueIndex)
        print("removed venue!!")
    }
}

