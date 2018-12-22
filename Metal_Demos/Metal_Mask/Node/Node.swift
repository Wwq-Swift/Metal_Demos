//
//  Node.swift
//  Metal_Colorful
//
//  Created by kris.wang on 2018/12/20.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import Foundation
import MetalKit

class Node {
    var name = "Unitled"
    var children: [Node] = []
    
    // 添加节点
    func addChildNode(_ node: Node) {
        children.append(node)
    }
    
    /// 渲染节点。（编码命令）
    func render(commandEnder: MTLRenderCommandEncoder, deltaTime: Float) {
        for child in children {
            child.render(commandEnder: commandEnder, deltaTime: deltaTime)
        }
    }
}
