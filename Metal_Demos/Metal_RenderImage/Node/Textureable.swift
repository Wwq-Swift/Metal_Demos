//
//  Textureable.swift
//  Metal_RenderImage
//
//  Created by 王伟奇 on 2018/12/22.
//  Copyright © 2018 王伟奇. All rights reserved.
//

import MetalKit

protocol Textureable {
    var texture: MTLTexture? { get set }
}
//MARK: - 设置纹理的扩展方法
extension Textureable {
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture? = nil
        let textureLoaderOptions: [MTKTextureLoader.Option: Any]
        /// ios 10 以后原点是从左下角开始的
        let origin = MTKTextureLoader.Origin.bottomLeft
        textureLoaderOptions = [MTKTextureLoader.Option.origin: origin]
        if let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) {
            do {
                texture = try textureLoader.newTexture(URL: textureURL, options: textureLoaderOptions)
            } catch {
                print("texture not created")
            }
        }
        return texture
    }
}
