//
//  ImageInteractor.swift
//  Recur
//
//  Created by Sophie on 9/17/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit
import Novagraph
import Alamofire

class ImageInteractor: Interactor {

    func uploadImage(_ image: UIImage, completion: @escaping (Photo?, Error?) -> Void) {
        CognitoService.shared.currentAccessToken { (token, _) in
            guard let accessToken = token else { return }
            guard let imageData = image.pngData() else { return }

            let endpoint = "\(currentServerConfiguration().domain)/upload/photo"
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "file", fileName: "file", mimeType: "image/png")
                if let tokenData = accessToken.data(using: String.Encoding.utf8) {
                    multipartFormData.append(tokenData, withName: "token")
                }
            }, usingThreshold: UInt64.init(),
               to: endpoint,
               method: .post,
               headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let valueDict = response.value as? [String: Any] {
                            if let message = valueDict["message"] as? String {
                                if message == "File too large" {
                                    completion(nil, NSError(domain: message, code: 500, userInfo: valueDict))
                                    return
                                }
                            }
                        }
                        guard let data = response.data,
                            let jsonData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)),
                            let jsonDict = jsonData as? [String: Any] else {
                                completion(nil, response.error)
                                return
                        }
                        self.fetchOrCreateObjects(from: jsonData)
                        try? CoreDataManager.shared.context.save()
                        if let photoId = jsonDict["photo"] as? String {
                            Profile.currentProfile?.photoId = photoId
                            try? CoreDataManager.shared.context.save()
                            completion(Photo.fetch(with: photoId), response.error)
                        } else {
                            completion(nil, response.error)
                        }
                        Profile.currentProfile?.updateProfile()
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }

    func fetchPhoto(completionHandler:@escaping ((Photo?, Error?) -> Void)) {
        guard let id = Profile.currentProfile?.photoId else { return }
        let query: [String: Any] = ["query": "{ photo(id: \"\(id)\") }" ]
        let request = NetworkRequest(method: .post, path: "/graph/get", params: query)
        Network.shared.send(request) { (data, error) in
            let photos = self.fetchOrCreateObjects(from: data) as? [Photo]
            guard photos?.count == 1, let photo = photos?.first else {
                completionHandler(nil, error)
                return
            }
            DispatchQueue.main.async {
                completionHandler(photo, error)
            }
        }
    }
}
