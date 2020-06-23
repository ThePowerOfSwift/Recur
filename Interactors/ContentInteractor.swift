//
//  ContentInteractor.swift
//  Recur
//
//  Created by Allen Miao on 7/17/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import Foundation

class ContentInteractor: Interactor {

    func fetchCurriculumContent(completionHandler: @escaping ((Error?) -> Void)) {
        let query: [String: Any] = ["query": "{ curriculum { unit { lesson { checkpoint } } } } "]
        let request = NetworkRequest(method: .post, path: "/graph/get", params: query)
        Network.shared.send(request) { (data, error) in
            self.fetchOrCreateObjects(from: data)
            self.processEdges(from: data)
            DispatchQueue.main.async {
                completionHandler(error)
            }
        }
    }

    func fetchLessons(unit: Unit, completionHandler: @escaping ((Error?) -> Void)) {
        let query: [String: Any] = ["query": "{ unit(id: \"\(unit.id)\") { lesson } }" ]
        let request = NetworkRequest(method: .post, path: "/graph/get", params: query)
        Network.shared.send(request) { (data, error) in
            self.fetchOrCreateObjects(from: data)
            self.processEdges(from: data)
            unit.sortLessons()
            DispatchQueue.main.async {
                completionHandler(error)
            }
        }
    }
    
    func fetchPages(lesson: Lesson, completionHandler: @escaping ((Error?) -> Void)) {
        let query: [String: Any] = ["query": "{ lesson(id: \"\(lesson.id)\") { page } }" ]
        let request = NetworkRequest(method: .post, path: "/graph/get", params: query)
        Network.shared.send(request) { (data, error) in
            self.fetchOrCreateObjects(from: data)
            self.processEdges(from: data)
            lesson.sortPages()
            DispatchQueue.main.async {
                completionHandler(error)
            }
        }
    }
}
