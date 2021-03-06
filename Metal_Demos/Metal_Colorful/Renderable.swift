//
//  Renderable.swift
//  Metal_Colorful
//
//  Created by kris.wang on 2018/12/20.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import MetalKit

protocol Renderable {
    var pipelineState: MTLRenderPipelineState! { get set }
    // metal 中顶点处理方法
    var vertexFunctionName: String { get }
    // metal 中 片段方法
    var fragmentFunctionName: String { get }
    var vertexDescriptor: MTLVertexDescriptor { get }
}

extension Renderable {
    /// 构件管道状态
    func buildPipelineState(device: MTLDevice) -> MTLRenderPipelineState {
        //   存储GPU 的事件
        let libary = device.makeDefaultLibrary()
        /// 调用metal 中处理顶点的方法
        let vertextFuncion = libary?.makeFunction(name: vertexFunctionName)
        // 调用metal 中上色的方法
        let fragmentFuncion = libary?.makeFunction(name: fragmentFunctionName)
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        /// 使用 metal 中的方法
        pipelineDescriptor.vertexFunction = vertextFuncion
        pipelineDescriptor.fragmentFunction = fragmentFuncion
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
//        /// 顶点描述
//        let vertexDescriptor = MTLVertexDescriptor()
//        /// 位置
//        vertexDescriptor.attributes[0].format = .float3
//        vertexDescriptor.attributes[0].offset = 0
//        vertexDescriptor.attributes[0].bufferIndex = 0
//        /// 颜色
//        vertexDescriptor.attributes[1].format = .float4
//        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
//        vertexDescriptor.attributes[1].bufferIndex = 0
//
//        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        
        let pipelineState: MTLRenderPipelineState
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            fatalError("error: \(error.localizedDescription)")
        }
        return pipelineState
    }
}
