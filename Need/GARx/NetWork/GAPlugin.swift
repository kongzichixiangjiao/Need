//
//  GAPlugin.swift
//  GARxSwift
//
//  Created by houjianan on 2020/3/9.
//  Copyright © 2020 houjianan. All rights reserved.
//

import Foundation
import Moya
import Result

// MARK: - 自定义的网络提示请求插件
let kNetworkPlugin = GANetworkActivityPlugin { (state,target) in
    let api = (target as! MultiTarget).target as! GAPluginTargetType
    if state == .began {
        if api.isShowLoading {
            GAShowWindow.ga_showLoading()
        }
        
//        if !api.touch {
//            print("我可以在这里写禁止用户操作，等待请求结束")
//        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    } else {
        GAShowWindow.ga_hideLoading()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

public enum GANetworkActivityChangeType {
    case began, ended
}

public final class GANetworkActivityPlugin: PluginType {
    
    public typealias GANetworkActivityClosure = (_ change: GANetworkActivityChangeType, _ target: TargetType) -> Void
    let networkActivityClosure: GANetworkActivityClosure
    
    public init(networkActivityClosure: @escaping GANetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        networkActivityClosure(.began, target)
    }

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return b_prepare(request, target: target)
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        networkActivityClosure(.ended, target)
    }

    public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        return result
    }
}

extension GANetworkActivityPlugin {
    func b_prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = 60

        let t = (target as! MultiTarget).target as! GAPluginTargetType
        
        if t.needsAuth {
            // 001 直接获取token id 加到请求头
   
            return request
        }
        
        return request
    }
}
    