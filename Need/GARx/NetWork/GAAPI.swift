//
//  GAAPI.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/9.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public enum GAAPI {
    case productinnovatelist([String : Any])
    case login([String : Any])
    case getNoticeList([String : Any])
}

extension GAAPI {
    public var path: String {
        switch self {
        case .productinnovatelist(_):
            return "/innovate/productinnovatelist"
        case .login(_):
            return "/employee/login"
        case .getNoticeList(_):
            return "/information/getNoticeList"
        }
    }
}

extension GAAPI {
    public var task: Task {
        switch self {
        case .productinnovatelist(let params), .login(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getNoticeList(let params):
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}

extension GAAPI: TargetType {
    
    public var baseURL: URL {
        #if DEBUG
        return URL(string: "http://px-cfpapp.zhengheht.com/cfpapp")!
        #elseif ZSC
        return URL(string: "https://cfpapp.puxinzichan.com/cfpapp")!
        #else
        return URL(string: "https://cfpapp.puxinasset.com/cfpapp")!
        #endif
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var headers: [String : String]? {
        return [
            "packageName" : Bundle.main.infoDictionary! ["CFBundleIdentifier"] as! String,
            "appName" : Bundle.main.infoDictionary! ["CFBundleName"] as! String,
            "version" : Bundle.main.infoDictionary! ["CFBundleShortVersionString"] as! String,
            "os" : "ios",
            "channel" : "appStore",
            "platform" : "\(CGFloat((UIDevice.current.systemVersion as NSString).floatValue))",
            "model" : UIDevice.current.model,
            "factory" : "apple",
            "screenSize" : ("\(UIScreen.main.bounds.size)"),
            "imei" : "",
            "mac" : "",
            "sign" : "",
            "pid" : "pid",
        ]
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
}

protocol GAPluginTargetType: TargetType {
    var needsAuth: Bool { get }
    var isShowLoading: Bool { get }
}

extension GAAPI: GAPluginTargetType {
    var needsAuth: Bool {
        switch self {
        case .login(_):
            return false 
        default:
            return true
        }
    }

    var isShowLoading: Bool {
        switch self {
        default:
            return true
        }
    }

}
