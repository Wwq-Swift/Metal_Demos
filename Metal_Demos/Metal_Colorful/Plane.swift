//
//  Plane.swift
//  Metal_Colorful
//
//  Created by kris.wang on 2018/12/20.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import UIKit
import MetalKit
import simd

/// 顶点
struct Vertex {
    // 位置
    var position: float3
    // 颜色信息
    var color: float4
}

class Plane: Node, Renderable {
    
    var pipelineState: MTLRenderPipelineState!
    
    var vertexFunctionName: String = "vertex_shader"
    var fragmentFunctionName: String = "fragment_shader"
    
    var vertexDescriptor: MTLVertexDescriptor = {
        
        /// 顶点描述
        let vertexDescriptor = MTLVertexDescriptor()
        /// 位置
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        /// 颜色
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }()
    
    // gpu
    private var device: MTLDevice!
    /// 三角形的三个顶点 （对应的四个角位置）
    private var vertices: [Vertex] = [
        Vertex(position: float3(-1,1,0), color: float4(1,0,0,1)),
        Vertex(position: float3(-1,-1,0), color: float4(0,1,0,1)),
        Vertex(position: float3(1,-1,0), color: float4(0,0,1,1)),
        Vertex(position: float3(1,1,0), color: float4(1,0,1,1))
    ]
    /// 顶点位置数组。 （取vertices 中任意三个点形成一个三角形）
    private var indexs: [UInt16] = [
        0,1,2,
        2,3,0
    ]

    /// 顶点缓存区
    private var vertexBuffer: MTLBuffer?
    /// 位置索引缓存区
    private var indexBuffer: MTLBuffer?
    
//    //    移动量
//    struct Constants {
//        var  animateBy: Float = 0.0
//    }
    
//    private var constants = Constants()
//    private var time: Float = 0
    
    init(device: MTLDevice) {
        super.init()
        self.device = device
        buildVertexBuffer()
        pipelineState = buildPipelineState(device: device)
    }
    
    // 处理顶点
    private func buildVertexBuffer() {
        ///创建顶点缓存区，   长度为顶点个数 * 每个顶点的大小
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        
        /// 创建索引 缓存区
        indexBuffer = device.makeBuffer(bytes: indexs, length: indexs.count * MemoryLayout<UInt16>.stride, options: [])
    }
    /// 重写渲染方法
    override func render(commandEnder: MTLRenderCommandEncoder, deltaTime: Float) {
        super.render(commandEnder: commandEnder, deltaTime: deltaTime)
        guard let indexBuffer = indexBuffer else { return }
//
//        time += deltaTime
//        let animateBy = abs(sin(time)/2 + 0.5)
//        constants.animateBy = animateBy
        commandEnder.setRenderPipelineState(pipelineState)
        commandEnder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        commandEnder.setVertexBytes(&constants,
//                                    length: MemoryLayout<Constants>.stride,
//                                    index: 1)
        commandEnder.drawIndexedPrimitives(type: .triangle,
                                           indexCount: indexs.count,
                                           indexType: .uint16,
                                           indexBuffer: indexBuffer,
                                           indexBufferOffset: 0)
    }
}
