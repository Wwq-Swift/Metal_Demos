//
//  Renderer.swift
//  Metal_animate
//
//  Created by kris.wang on 2018/12/17.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import Foundation
import MetalKit
/// 通过索引缓存来绘制三角形
class Renderer: NSObject {
    // gpu
    private var device: MTLDevice!
    // 操作队列
    private var commandQueue: MTLCommandQueue!
    /// 管道状态
//    private var pipelineState: MTLRenderPipelineState?
   //  场景
    var scene: Scene?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
//        buildPipelineState()
    }
    
//    /// 构件管道状态    (被抽取进行封装)
//    private func buildPipelineState() {
//        //   存储GPU 的事件
//        let libary = device.makeDefaultLibrary()
//        /// 调用metal 中处理顶点的方法
//        let vertextFuncion = libary?.makeFunction(name: "vertex_shader")
//        // 调用metal 中上色的方法
//        let fragmentFuncion = libary?.makeFunction(name: "fragment_shader")
//
//        let pipelineDescriptor = MTLRenderPipelineDescriptor()
//        /// 使用 metal 中的方法
//        pipelineDescriptor.vertexFunction = vertextFuncion
//        pipelineDescriptor.fragmentFunction = fragmentFuncion
//        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
//
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
//        pipelineDescriptor.vertexDescriptor = vertexDescriptor
//
//
//        do {
//            ///画出三个顶点
//            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
//        } catch let error as NSError {
//            print("error: \(error.localizedDescription)")
//        }
//    }
}

extension Renderer: MTKViewDelegate {
    /// 改变frame 大小的时候调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    /// 画面是 60 fps。也就是每 秒 调用这个方法 60 次
    func draw(in view: MTKView) {
        /// 当前view 可绘制    当前渲染描述符
        guard let drawable = view.currentDrawable,
//            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else { return }
        /// 创建一个自动释放的操作缓存
        let commandBufferer = commandQueue.makeCommandBuffer()
        guard let commandBuffer = commandBufferer else { return }
        /// 渲染编码命令。编码到命令缓存区
        let commandEncoderer = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        guard let commandEncoder = commandEncoderer else { return }
//        commandEncoder.setRenderPipelineState(pipelineState)
        
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene?.render(commandEnder: commandEncoder,
                      deltaTime: deltaTime)

        commandEncoder.endEncoding()
        /// 呈现
        commandBuffer.present(drawable)
        //命令中介
        commandBuffer.commit()
    }
}
