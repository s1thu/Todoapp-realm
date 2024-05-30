//
//  TaskLocalDatasource.swift
//  Todo
//
//  Created by Sithu Win on 30/05/2024.
//

import Foundation
import RealmSwift

class TaskLocalDatasource{
    
    private let realm:Realm
    
    static let shared = TaskLocalDatasource.init()
    
    private init(){
        realm = try! Realm()
    }
    
    //Create Tasks
    // *** Write & Delete function in realm can throw errors
    // *** Entity should not be used in UILevel not safe ( weak point of realm )
    func addTask(for task:TaskVO ) throws{
        try realm.write {
            realm.add(task.toEntity(), update: .all)
        }
    }
    
    //Get Tasks
    func getAllTasks() -> [TaskVO]{
        Array(realm.objects(TaskEntity.self)).map { TaskEntity in
            TaskEntity.toVO()
        }
    }
    
    //Get Specific Task
    //When fetch with Id, ID can exist or not that's why add optional.
    //If Id is exist return VO. If not return nil
    func getTaskById(id:String) -> TaskVO? {
        realm
            .object(ofType: TaskEntity.self, forPrimaryKey: id)?.toVO()
    }
    
    //Soft Delete -> isActive Flag -> False
    func deleteTask(id:String) throws{
       let task = realm
            .object(ofType: TaskEntity.self, forPrimaryKey: id)
        if let task = task {
            try realm.write {
                //Update Query
                //that's why we use VO in UILevel
                task.isActive = false
            }
        }
    }
}