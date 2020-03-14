//
//  RxObjectMapper.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/5.
//  Copyright © 2020 houjianan. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import Moya

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func mapObject<T: BaseMappable>(type: T.Type) -> Single<T> {
        return self.map{ response in
            return try response.mapObject(type: type)
        }
    }
    
    func mapArray<T: BaseMappable>(type: T.Type) -> Single<[T]> {
        return self.map{ response in
            return try response.mapArray(type: type)
        }
    }
}
public extension ObservableType where E == Response {
    func mapObject<T: BaseMappable>(type: T.Type) -> Observable<T> {
        return self.map{ response in
            return try response.mapObject(type: type)
        }
    }
    
    func mapArray<T: BaseMappable>(type: T.Type) -> Observable<[T]> {
        return self.map{ response in
            return try response.mapArray(type: type)
        }
    }
}

public extension Response{
    func mapObject<T: BaseMappable>(type: T.Type) throws -> T {
        let text = String(bytes: self.data, encoding: .utf8)
        if self.statusCode < 400 {
            return Mapper<T>().map(JSONString: text!)!
        }
        do{
            let serviceError = Mapper<ServiceError>().map(JSONString: text!)
            let a = Mapper<ServiceError>().map(JSON: ["":""])
            throw serviceError ?? a!
        }catch{
            if error is ServiceError {
                throw error
            }
            let serviceError = ServiceError()
            serviceError.message = "服务器开小差，请稍后重试"
            serviceError.error_code = "parse_error"
            throw serviceError
        }
    }
    
    func mapArray<T: BaseMappable>(type: T.Type) throws -> [T] {
        let text = String(bytes: self.data, encoding: .utf8)
        if self.statusCode < 400 {
            return Mapper<T>().mapArray(JSONString: text!)!
        }
        do{
            let serviceError = Mapper<ServiceError>().map(JSONString: text!)
            throw serviceError!
        }catch{
            if error is ServiceError {
                throw error
            }
            let serviceError = ServiceError()
            serviceError.message = "服务器开小差，请稍后重试"
            serviceError.error_code = "parse_error"
            throw serviceError
        }
    }
}

class ServiceError:Error,Mappable{
    var message:String = ""
    var error_code:String = ""
    var localizedDescription: String{
        return message
    }
    
    required init?(map: Map) {}
    
    init() {
        
    }
    
    func mapping(map: Map) {
        error_code <- map["error_code"]
        message <- map["error"]
    }
}
