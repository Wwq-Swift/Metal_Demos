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
    /// 节点位置
    var position = float3(0)
    /// 旋转
    var rotation = float3(0)
    /// 节点大小 进行缩放
    var scale = float3(1) 
    
    var name = "Unitled"
    var children: [Node] = []
    
    /// 一个变形矩阵 （来处理各种与变形相关的操作）
    var modelMatrix: matrix_float4x4 {
        
        var matrix = matrix_float4x4(translationX: position.x, y: position.y, z: position.z ) // 位移
        // 在 X 轴旋转
        matrix = matrix.rotatedBy(rotationAngle: rotation.x, x: 1, y: 0, z: 0)
        // 在 Y 轴旋转
        matrix = matrix.rotatedBy(rotationAngle: rotation.y, x: 0, y: 1, z: 0)
        // 在 Z 轴旋转
        matrix = matrix.rotatedBy(rotationAngle: rotation.z, x: 0, y: 0, z: 1)
        // 进行缩放
        matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
        return matrix
    }
    
    // 添加节点
    func addChildNode(_ node: Node) {
        children.append(node)
    }
    
    
    
//    /// 渲染节点。（编码命令）
//    func render(commandEnder: MTLRenderCommandEncoder, deltaTime: Float) {
//        for child in children {
//            child.render(commandEnder: commandEnder, deltaTime: deltaTime)
//        }
//    }
    
    /// 渲染节点。（编码命令）拿到外部几何的本身矩阵
    func render(commandEncoder: MTLRenderCommandEncoder, partentModelViewMatrix: matrix_float4x4) {
        //     拿到外部的模型矩阵
        let modelViewMatrix = matrix_multiply(partentModelViewMatrix, modelMatrix)
        //       遍历内部的所有矩阵
        for child in children {
            child.render(commandEncoder: commandEncoder, partentModelViewMatrix: modelViewMatrix)
        }
        
        if let renderable = self as? Renderable {
            //开始编码命令
            commandEncoder.pushDebugGroup(name)
            renderable.doRneder(commandEncoder: commandEncoder, modelViewmatrix: modelViewMatrix)
            // 结束编码命令
            commandEncoder.popDebugGroup()
        }
    }
}
