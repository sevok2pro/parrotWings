//
//  createUser.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum CreateUserStatus {
    case success
    case emptyUserData
    case duplicateEmail
    case unknowError
}

class CreateUserResult {
    let status: CreateUserStatus
    let token: String?
    
    init(status: CreateUserStatus, token: String? = nil) {
        self.status = status
        self.token = status == .success && token != nil ? token : nil
    }
}

extension DAL {
    func createUser(login: String, password: String) -> Observable<CreateUserResult> {
        let params = [
            "username": login,
            "email": login,
            "password": password,
        ]
        
        return Observable<CreateUserResult>
            .create({observer in
                request("\(self.serverPath)/users", method: .post, parameters: params)
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        
                        switch response {
                        case (201, _):
                            let data: Data = result.data ?? Data()
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            
                            guard let dictionary = json as? [String: Any] else {
                                observer.onNext(CreateUserResult(status: .unknowError))
                                break;
                            }
                            
                            guard let token = dictionary["id_token"] as? String else {
                                observer.onNext(CreateUserResult(status: .unknowError))
                                break;
                            }
                            observer.onNext(CreateUserResult(status: .success, token: token))
                            break;
                        case (400, "A user with that email exists"):
                            observer.onNext(CreateUserResult(status: .duplicateEmail))
                            break;
                        case (400, "You must send username and password"):
                            observer.onNext(CreateUserResult(status: .emptyUserData))
                            break;
                        case (_, _):
                            observer.onNext(CreateUserResult(status: .unknowError))
                            break;
                        }
                        observer.onCompleted()
                    })
                
                return Disposables.create()
            })
    }
}
