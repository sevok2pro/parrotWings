//
//  getUsers.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class PublicUser {
    public let name: String
    public let id: Int
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
}

enum GetUserResultStatus {
    case success
    case emptyPharse
    case unknowError
}

class GetUsersResult {
    public let data: [PublicUser]
    public let status: GetUserResultStatus
    
    init(data: [PublicUser], status: GetUserResultStatus) {
        self.data = data
        self.status = status
    }
}

extension DAL {
    func getUsers(filterPharse: String?) -> Observable<GetUsersResult> {
        guard let filter: String = filterPharse else {
            return Observable.just(GetUsersResult(data: [], status: .emptyPharse))
        }
        guard let authToken: String = self.userData.getAuthToken() else {
            return Observable.just(GetUsersResult(data: [], status: .unknowError))
        }
        let authHeader = ["Authorization": "Bearer " + authToken]
        return Observable<GetUsersResult>
            .create({observer in
                request(
                    "\(self.serverPath)/api/protected/users/list",
                    method: .post,
                    parameters: ["filter": filter],
                    headers: authHeader
                    )
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        
                        switch response {
                        case (200, _):
                            let jsonArray = try? JSONSerialization.jsonObject(with: result.data ?? Data(), options: [])
                            
                            guard let array = jsonArray as? [Any] else {
                                observer.onNext(GetUsersResult(data: [], status: .unknowError))
                                break;
                            }
                            
                            guard let arrayOfUsers: Array<[String: Any]> = array as? Array<[String: Any]> else {
                                observer.onNext(GetUsersResult(data: [], status: .unknowError))
                                break;
                            }
                            var userData: Array<PublicUser> = []
                            for user in arrayOfUsers {
                                userData.append(PublicUser(name: user["name"] as! String, id: user["id"] as! Int))
                            }
                            observer.onNext(GetUsersResult(data: userData,status: .success))
                            break;
                        case (401, "No search string."):
                            observer.onNext(GetUsersResult(data: [], status: .emptyPharse))
                            break;
                        case (_, _):
                            print(response)
                        }
                        
                        observer.onCompleted()
                    })
                return Disposables.create()
            })
    }
}
