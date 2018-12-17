//
//  Renderer.swift
//  metal_triangle
//
//  Created by kris.wang on 2018/12/17.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    // gpu
    private var device: MTLDevice!
    // 操作队列
    private var commandQueue: MTLCommandQueue!
    /// 三角形的三个顶点
    private var vertices: [Float] = [
        0,0,0,
        -1,-1,0,
        1,-1,0
    ]
    /// 管道状态
    private var pipelineState: MTLRenderPipelineState?
    /// 顶点缓存区
    private var vertexBuffer: MTLBuffer?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
        buildVertexBuffer()
        buildPipelineState()
    }
    
    // 处理顶点
    private func buildVertexBuffer() {
        ///创建顶点缓存区，   长度为顶点个数 * 每个顶点的大小
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.stride, options: [])
    }
    
    /// 构件管道状态
    private func buildPipelineState() {
        //   存储GPU 的事件
        let libary = device.makeDefaultLibrary()
        /// 调用metal 中处理顶点的方法
        let vertextFuncion = libary?.makeFunction(name: "vertex_shader")
        // 调用metal 中上色的方法
        let fragmentFuncion = libary?.makeFunction(name: "fragment_shader")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        /// 使用 metal 中的方法
        pipelineDescriptor.vertexFunction = vertextFuncion
        pipelineDescriptor.fragmentFunction = fragmentFuncion
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            ///画出三个顶点
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}

extension Renderer: MTKViewDelegate {
    /// 改变frame 大小的时候调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    /// 画面是 60 fps。也就是每 秒 调用这个方法 60 次
    func draw(in view: MTKView) {
        /// 当前view 可绘制    当前渲染描述符
        guard let drawable = view.currentDrawable,
            let pipelineState = self.pipelineState,
            let descriptor = view.currentRenderPassDescriptor else { return }
        /// 创建一个自动释放的操作缓存
        let commandBuffer = commandQueue.makeCommandBuffer()
        /// 渲染编码命令。编码到命令缓存区
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.setRenderPipelineState(pipelineState)
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        /// 绘制顶点
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        /// 呈现
        commandBuffer?.present(drawable)
        //命令中介
        commandBuffer?.commit()
    }
}
