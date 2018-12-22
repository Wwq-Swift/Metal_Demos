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
    // 位置 （原点在正中心）
    var position: float3
    // 颜色信息
    var color: float4
    /// 纹理。（将点与position坐标对应。原点在左下角）
    var texture: float2
}

class Plane: Node, Renderable, Textureable {
    
    
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
        /// 纹理
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        return vertexDescriptor
    }()
    // 纹理
    var texture: MTLTexture?
    // gpu
    private var device: MTLDevice!
    /// 三角形的三个顶点 （对应的四个角位置）
    private var vertices: [Vertex] = [
        Vertex(position: float3( -1, 1, 0),
            color: float4(1, 0, 0, 1),
            texture: float2(0, 1)),
        Vertex(position: float3( -1, -1, 0),
            color: float4(0, 1, 0, 1),
            texture: float2(0, 0)),
        Vertex(position: float3( 1, -1, 0),
            color: float4(0, 0, 1, 1),
            texture: float2(1, 0)),
        Vertex(position: float3( 1, 1, 0),
            color: float4(1, 0, 1, 1),
            texture: float2(1, 1))
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
    
    init(device: MTLDevice) {
        super.init()
        self.device = device
        buildVertexBuffer()
        pipelineState = buildPipelineState(device: device)
    }
    
    /// 设备， 需要渲染上去的图片名称
    init(device: MTLDevice, imageName: String) {
        super.init()
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            /// metal 中写的纹理片段方法
            fragmentFunctionName = "textured_fragment"
        }
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

        commandEnder.setRenderPipelineState(pipelineState)
        commandEnder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEnder.setFragmentTexture(texture, index: 0)
        commandEnder.drawIndexedPrimitives(type: .triangle,
                                           indexCount: indexs.count,
                                           indexType: .uint16,
                                           indexBuffer: indexBuffer,
                                           indexBufferOffset: 0)
    }
}
