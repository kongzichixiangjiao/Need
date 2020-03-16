//
//  GANetWork.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/4.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper


let provider = MoyaProvider<MultiTarget>(plugins: [
    kNetworkPlugin
])

struct GANetWork {
    let disposeBag = DisposeBag()
    typealias SuccessHandler = (_ json: Any) -> ()
    typealias ErrorHandler = (_ stateCode: Int, _ json: Any?) -> () // 服务连接成功
    typealias FailureHandler = (_ error: MoyaError) -> () // 服务连接失败
    
    static func rx_request<T>(api: GAAPI, type: T.Type) -> Observable<T> where T: Mappable {
        request(api: api, success: { (json) in
            print(json)
        }, error: { (code, json) in
            print(code, json ?? "")
        }) { (error) in
            print(error)
        }
        
        return provider.rx.request(MultiTarget(api)).mapObject(type: type).asObservable()
    }
    
    static func request(api: GAAPI,
                        success successHandler: @escaping SuccessHandler,
                        error errorHandler: @escaping ErrorHandler,
                        failure failureHandler: @escaping FailureHandler) {
        provider.request(MultiTarget(api)) { result in
            switch result {
            case .success(let response):
                let stateCode = response.statusCode
                
                switch stateCode {
                case 200:
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        do {
                            let json = try response.mapJSON()
                            successHandler(json)
                        } catch {
                            errorHandler(stateCode, nil)
                        }
                    } catch {
                            errorHandler(stateCode, nil)
                    }
                    break
                default:
                    do {
                        let json = try response.mapJSON()
                        errorHandler(stateCode, json)
                    } catch {
                        errorHandler(stateCode, nil)
                    }
                    break
                }
                break
            case let .failure(error):
                failureHandler(error)
                switch error {
                case .imageMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .jsonMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .statusCode(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .stringMapping(let response):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print(response)
                case .underlying(let error, let response):
                    print(error)
                    print(response as Any)
                case .requestMapping:
                    print("错误原因：\(error.errorDescription ?? "")")
                    print("nil")
                case .objectMapping(_, _):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print("nil")
                case .encodableMapping(_):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print("nil")
                case .parameterEncoding(_):
                    print("错误原因：\(error.errorDescription ?? "")")
                    print("nil")
                }
            }
        }
    }
    
}
