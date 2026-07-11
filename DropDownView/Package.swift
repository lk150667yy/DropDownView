//
//  Package.swift
//  DropDownView
//
//  Created by 刘凯 on 2026/7/10.
//

import PackageDescription

let package = Package(
    name: "DropDownView",
    platforms: [
        .iOS(.v13),    // 最低支持系统
        .macOS(.v13)
    ],
    products: [
        // 对外暴露Framework产品，别人import用MySDK
        .library(
            name: "DropDownView",
            targets: ["DropDownView"]
        ),
    ],
    targets: [
        .target(
            name: "DropDownView",
            sources: ["Sources/DropDownView/"],
            // 资源文件在这里配置
            resources: [
                .process("Resources/")
            ]
        ),
    ]
)

