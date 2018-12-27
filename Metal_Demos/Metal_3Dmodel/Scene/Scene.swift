//
//  Scene.swift
//  Metal_Colorful
//
//  Created by kris.wang on 2018/12/20.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import UIKit
import MetalKit

class Scene: Node {
    var device: MTLDevice
    var size: CGSize
    
    var camera = Camera()
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        super.init()
        
        buildCamera()
    }
    
    private func buildCamera() {
        camera.aspect = Float(size.width / size.height)
        camera.position.z = -6
        addChildNode(camera)
    }
    
    /// 更新场景状态
    func update(deltaTime: Float) {}
    
    /// 专门用于渲染场景 渲染节点。（编码命令）
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        update(deltaTime: deltaTime)
        sceneConstants.projectionMatris = camera.projectionMatrix
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0 , z: -4)
        commandEncoder.setVertexBytes(&sceneConstants,
                                      length: MemoryLayout<SceneConstants>.stride, index: 2)
        for child in children {
            child.render(commandEncoder: commandEncoder, partentModelViewMatrix: camera.viewMartrix) // 对视角中的所有矩阵进行渲染
        }
    }
}
