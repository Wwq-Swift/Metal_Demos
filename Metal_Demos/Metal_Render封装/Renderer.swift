//
//  Renderer.swift
//  Metal_Demos
//
//  Created by kris.wang on 2018/12/14.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    // gpu
    var device: MTLDevice!
    // 操作队列
    var commandQueue: MTLCommandQueue!

    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        super.init()
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
            let descriptor = view.currentRenderPassDescriptor else { return }
        /// 创建一个自动释放的操作缓存
        let commandBuffer = commandQueue.makeCommandBuffer()
        /// 渲染编码命令。编码到命令缓存区
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)

        commandEncoder?.endEncoding()
        /// 呈现
        commandBuffer?.present(drawable)
        //命令中介
        commandBuffer?.commit()
    }
} 
