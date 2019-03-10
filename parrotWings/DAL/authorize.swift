//
//  Common.swift
//  parrotWings
//
//  Created by seva on 10/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

enum AuthorizeStatus {
    case success
    case incorrectAuthData
    case emptyAuthData
    case unknowError
}

class AuthorizeResult {
    let status: AuthorizeStatus;
    let token: String?;
    
    init(status: AuthorizeStatus, token: String? = nil) {
        self.status = status
        self.token = status == .success && token != nil ? token : nil
    }
}

extension DAL {
    func authorize(login: String, password: String) -> Observable<AuthorizeResult> {
        let params = [
            "email": login,
            "password": password,
            ]
        
        return Observable<AuthorizeResult>
            .create({observer in
                request("http://193.124.114.46:3001/sessions/create", method: .post, parameters: params)
                    .response(completionHandler: {result in
                        let utf8Text = String(data: result.data ?? Data(), encoding: .utf8)
                        let response = (result.response?.statusCode ?? 0, utf8Text)
                        switch response {
                        case (201, _):
                            let data: Data = result.data ?? Data()
                            let json = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let dictionary = json as? [String: Any] {
                                if let token = dictionary["id_token"] as? String {
                                    observer.onNext(AuthorizeResult(status: .success, token: token))
                                    break;
                                }
                            }
                            observer.onNext(AuthorizeResult(status: .unknowError))
                            break;
                        case (400, "You must send email and password."):
                            observer.onNext(AuthorizeResult(status: .emptyAuthData))
                            break;
                        case (401, "Invalid email or password."):
                            observer.onNext(AuthorizeResult(status: .incorrectAuthData))
                            break;
                        case (_, _):
                            observer.onNext(AuthorizeResult(status: .unknowError))
                            break;
                        }
                        observer.onCompleted()
                    })
                
                return Disposables.create()
            })
    }
}
