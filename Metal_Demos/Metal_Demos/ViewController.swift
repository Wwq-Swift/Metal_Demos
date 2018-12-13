//
//  ViewController.swift
//  Metal_Demos
//
//  Created by 王伟奇 on 2018/12/13.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    private var metalView: MTKView!
    /// 设备 (GPU)
    private var device: MTLDevice!
    // 每一个gpu 对应一个操作队列
    private var commadnQueue: MTLCommandQueue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mView = view as? MTKView else {
            return
        }
        metalView = mView
        metalView.delegate = self
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0)
        device = MTLCreateSystemDefaultDevice()
        metalView.device = device
        commadnQueue = device.makeCommandQueue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension ViewController: MTKViewDelegate {
    /// 改变frame 大小的时候调用
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    /// 画面是 60 fps。也就是每 秒 调用这个方法 60 次
    func draw(in view: MTKView) {
        /// 当前view 可绘制    当前渲染描述符
        guard let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor else { return }
        /// 创建一个自动释放的操作缓存
        let commandBuffer = commadnQueue.makeCommandBuffer()
        /// 渲染编码命令。编码到命令缓存区
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder?.endEncoding()
        /// 呈现
        commandBuffer?.present(drawable)
        //命令中介
        commandBuffer?.commit()
    }
}

