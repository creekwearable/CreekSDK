//
//  Log.swift
//  CreekSDK
//
//  Created by bean on 2023/7/24.
//

import Foundation

func SDKdebugLog<T>(message: T,//需要展示的信息
    showMore: Bool = false,//是够展示更多信息
    file: String = #file,//展示的文件名字 默认不展示
    method: String = #function,//展示的当前调用的方法 默认不展示
    line: Int = #line){//展示的当前执行的行数 默认不展示)
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
    #if DEBUG
    //获取文件名
    let fileName = (file as NSString).lastPathComponent
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    // 为日期格式器设置格式字符串
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    // 使用日期格式器格式化当前日期、时间
    let datestr = dformatter.string(from: Date())
    //打印日志内容
    print(datestr + " \(fileName)(#\(line))")
    print(message)
    #endif
}
