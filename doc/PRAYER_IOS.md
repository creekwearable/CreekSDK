# iOS 祈祷时间接入

更新：2026-11-17。Swift SDK 通过内置 Flutter 模块复用现有祈祷算法、城市数据库、自动时区和配置持久化。宿主不需要单独复制数据库。

## 接口

方法名称与 Flutter 保持一致，Swift 使用项目现有成功／失败回调风格。先按原流程初始化 SDK，等待通道就绪；配置与读取不要求连接手表。三个新增接口的回调在主线程执行。

| 方法 | 作用 |
|---|---|
| `configurePrayer(_:success:failure:)` | 持久保存计算设置，不传地点 |
| `getPrayerConfiguration(success:failure:)` | 获取用户保存的设置，供设置页回显 |
| `getPrayerTimes(location:startDate:success:failure:)` | 按保存设置读取目标地点连续七天时间 |
| `setPrayer(model:success:failure:)` | 沿用已有接口，将读取结果下发手表 |

首次无配置记录时为自动模式；保存后重启 App 自动恢复。不要每次启动都写入默认配置，否则会覆盖用户设置。配置存储属于当前 App，不按手表或账号区分；卸载或清除应用数据可能移除记录。

```swift
// 设置页读取，不修改配置。
CreekInterFace.instance.getPrayerConfiguration { config in
    print(config.automatic, config.method.rawValue, config.asrRule.rawValue)
} failure: { code, message in
    print(code, message)
}

// 设置页保存。恢复自动模式可传 CreekPrayerConfiguration()。
CreekInterFace.instance.configurePrayer(
    CreekPrayerConfiguration(automatic: false, method: .morocco, asrRule: .standard)
) {
    print("配置已保存")
} failure: { code, message in
    print(code, message)
}

// 业务页读取。无需先调用配置或获取配置。
let location = PrayerLocation.coordinates(
    latitude: 33.58831, longitude: -7.61138,
    countryCode: "MA", name: "Casablanca", altitude: 27
)
CreekInterFace.instance.getPrayerTimes(location: location) { result in
    print(result.configuration.location.timezoneId)
    for day in result.days {
        print(day.date, day.fajr, day.sunrise, day.dhuhr,
              day.asr, day.maghrib, day.isha, day.source.rawValue)
    }
    // 保存 result，用户点击下发时使用 result.operate。
} failure: { code, message in
    print(code, message)
}
```

坐标采用 WGS-84；纬度、经度、两位国家代码必传，英文城市名和海拔可选。城市名称用于在线时间表；名称为空仍可本地计算。也支持 `PrayerLocation.cityName(name:countryCode:)`，由内置数据库匹配；`city(id:)` 只接受内部数据库 ID。

时区、在线开关和额外分钟修正不开放输入。自动模式按国家选择计算方式和晡礼规则，手动模式使用保存规则。枚举名称与 Flutter 一致，共 16 种计算方式和 `standard`／`hanafi` 两种晡礼规则。

默认返回目标地点当地今天及后六天；可传 `PrayerDate(year: 2026, month: 11, day: 18)` 指定当地公历起始日。返回的 `day.date` 为公历 YYYY-MM-DD，各时间字段为当地 HH:mm；`utcOffsetMinutes` 为当日 UTC 偏移。不要叠加手机时差。每日 `source` 可区分服务器时间表和本地计算，HTTP 404 等情况由内部回退处理。

`result.configuration` 是本次实际生效的规则和地点；`getPrayerConfiguration()` 返回保存的用户偏好。自动模式下两者的 method/asrRule 可能不同。

## 下发与功能判断

功能表只在宿主／Demo 判断，SDK 的 `setPrayer` 直接发送指令。手表连接后获取 `getTable`，仅 `table.prayerOnline.isSupport` 为 true 才执行：

```swift
CreekInterFace.instance.setPrayer(model: result.operate) {
    print("手表确认成功")
} failure: { code, message in
    print(code, message)
}
```

不支持或缺少字段：提示“该设备不支持祈祷功能”；功能表读取失败单独提示读取失败。`result.operate` 已包含七天六项时间、城市名、朝向和固件所需回历日期，直接传入即可。修改地点／计算规则后应重新读取，避免发送旧结果。

## 原生 Demo

打开 `Example/CreekSDK.xcworkspace`，首页选择 `Prayer demo`：

1. 自动读取保存配置，可测试杀死 App 后再次打开的恢复。
2. 两个保存按钮分别保存自动模式、手动 Morocco / Hanafi。
3. 点击读取七天，显示日期、六项时间、实际规则、时区和数据来源。
4. 连接手表后点击下发；Demo 先检查 `prayerOnline`，再发送已读数据。

固定坐标为 Casablanca, MA（33.58831, -7.61138，海拔 27 m），不申请定位权限、不搜索城市。配置与读取无须连接设备，下发成功以设备回调为准。

## 构建与验证

先在 `creek_sdk_flutter` 运行 `flutter pub get` 和 `./buildios.sh`，更新 `Creek` 中的框架及 FlutterPluginRegistrant；然后构建原生 Demo。只更新 Swift 源码而不更新 App.framework 无法提供新增通道接口。`App.framework/flutter_assets/packages/creek_prayer` 内含数据库和地区资源；数据库复用 `sqflite: ^2.3.0`，当前解析版本对应 `sqflite_darwin.framework`，由 podspec 统一引用。已移除额外的 sqlite3 / sqlite3_flutter_libs 框架及旧 sqflite 框架引用；请使用本次构建的完整配套产物，勿混用旧的注册器或数据库框架。数据库文件与配置、读取、下发接口保持不变。

新增接口使用 MethodChannel 的直接结果，固定名称精确路由，避免被旧 `getPrayer` 匹配。旧 `getPrayer` 仍是读取手表协议，与 `getPrayerTimes` 的七天计算不同。Swift 模型解析失败、通道未初始化、旧框架未实现接口、参数错误和超时均通过 failure 返回。

本仓库 `scripts/test_prayer_models.sh` 使用已经安装的 SwiftProtobuf 源码做本机测试，无需下载测试依赖；验证真实 Dart 返回样本的七天时间与 protobuf 数据对应。样本由 `creek_sdk_flutter/test/creek_prayer_channel_test.dart` 生成。真机定位不在此 Demo 范围，手表接收与杀进程恢复仍应按上述步骤做实机验证。
