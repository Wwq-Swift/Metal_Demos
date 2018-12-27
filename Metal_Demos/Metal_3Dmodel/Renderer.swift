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
    
    /// 采样状态。  可以设置为线性的，图片的 网格就被虚化了
    private var samplerState: MTLSamplerState?
    // 深度状态
    private var depthStencilState: MTLDepthStencilState?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
//        buildPipelineState()
        buildSamplerState()
        buildDepthStencilState()
    }
    
    private func buildSamplerState() {
        /// 采样器描述符
        let descriptor = MTLSamplerDescriptor()
        /// 遇到拉伸做线性处理
        descriptor.minFilter = .linear
        /// 遇到压缩时候也做线性处理
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
    
    /// 用于处理深度状态
    private func buildDepthStencilState(){
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
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
//            let pipelineState = pipelineState,
            let descriptor = view.currentRenderPassDescriptor else { return }
        /// 创建一个自动释放的操作缓存
        let commandBufferer = commandQueue.makeCommandBuffer()
        guard let commandBuffer = commandBufferer else { return }
        /// 渲染编码命令。编码到命令缓存区
        let commandEncoderer = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        guard let commandEncoder = commandEncoderer else { return }
//        commandEncoder.setRenderPipelineState(pipelineState)
        /// 让cpu 采用这个采样器进行处理
        commandEncoder.setFragmentSamplerState(samplerState, index: 0)
        /// 让GPU 采用这个深度处理器
        commandEncoder.setDepthStencilState(depthStencilState)
        let deltaTime = 1 / Float(view.preferredFramesPerSecond)
        scene?.render(commandEncoder: commandEncoder,
                      deltaTime: deltaTime)

        commandEncoder.endEncoding()
        /// 呈现
        commandBuffer.present(drawable)
        //命令中介
        commandBuffer.commit()
    }
}
