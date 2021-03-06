//
//  Model.swift
//  Metal_3Dmodel
//
//  Created by kris.wang on 2018/12/27.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

import MetalKit

/// 上色的model。 上一个项目是 上png 图片的model
class Model: Node, Textureable {
    //Textureable  的属性
    var texture: MTLTexture?
    var meshes: [MTKMesh] = []

    // Renderable  的
    var pipelineState: MTLRenderPipelineState!
    var vertexFunctionName: String = "vertex_shader"
    var fragmentFunctionName: String = "fragment_color"
    /// 模型矩阵
    private var modelConstants = ModelConstants()

    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()

        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0

        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3
        vertexDescriptor.attributes[1].bufferIndex = 0

        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7
        vertexDescriptor.attributes[2].bufferIndex = 0

        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0

        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12

        return vertexDescriptor
    }

    init(device: MTLDevice, modelName: String) {
        super.init()
        name = modelName
        loadModel(device: device, modelName: modelName)
        let imageName = modelName + ".png"
        if let texture = setTexture(device: device, imageName: imageName) {
            self.texture = texture
            fragmentFunctionName = "textured_fragment"
        }
        pipelineState = buildPipelineState(device: device)
    }

//    func loadModel(device: MTLDevice, modelName: String) {
//        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
//            fatalError("Asset \(modelName) does not exist.")
//        }
//        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
//
//        let attributePosition = descriptor.attributes[0] as! MDLVertexAttribute
//        attributePosition.name = MDLVertexAttributePosition
//        descriptor.attributes[0] = attributePosition
//
//        let attributeColor = descriptor.attributes[1] as! MDLVertexAttribute
//        attributeColor.name = MDLVertexAttributeColor
//        descriptor.attributes[1] = attributeColor
//
//        let attributeTexture = descriptor.attributes[2] as! MDLVertexAttribute
//        attributeTexture.name = MDLVertexAttributeTextureCoordinate
//        descriptor.attributes[2] = attributeTexture
//
//        let attributeNormal = descriptor.attributes[3] as! MDLVertexAttribute
//        attributeNormal.name = MDLVertexAttributeNormal
//        descriptor.attributes[3] = attributeNormal
//        // mesh缓存创建
//        let bufferAllocator = MTKMeshBufferAllocator(device: device)
//        let asset = MDLAsset(url: assetURL,
//                             vertexDescriptor: descriptor,
//                             bufferAllocator: bufferAllocator)
//
//        do {
//            meshes = try MTKMesh.newMeshes(asset: asset, device: device).metalKitMeshes//.newMeshes(from: asset,
////                                           device: device,
////                                           sourceMeshes: nil)
//        } catch {
//            print("mesh error")
//        }
//    }
    
    func loadModel(device: MTLDevice, modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            fatalError("Asset \(modelName) does not exist.")
        }
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)

        let attributePosition = descriptor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition
        descriptor.attributes[0] = attributePosition

        let attributeColor = descriptor.attributes[1] as! MDLVertexAttribute
        attributeColor.name = MDLVertexAttributeColor
        descriptor.attributes[1] = attributeColor

        let attributeTexture = descriptor.attributes[2] as! MDLVertexAttribute
        attributeTexture.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[2] = attributeTexture

        let attributeNormal = descriptor.attributes[3] as! MDLVertexAttribute
        attributeNormal.name = MDLVertexAttributeNormal
        descriptor.attributes[3] = attributeNormal
        // mesh缓存创建
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL,
                             vertexDescriptor: descriptor,
                             bufferAllocator: bufferAllocator)

        do {
            meshes = try MTKMesh.newMeshes(asset: asset, device: device).metalKitMeshes
        } catch {
            print("mesh error")
        }
    }
}

extension Model: Renderable {
    func doRneder(commandEncoder: MTLRenderCommandEncoder, modelViewmatrix: matrix_float4x4) {
        modelConstants.modelViewMatrix = modelViewmatrix
        modelConstants.materialColor = float4(1,0,1,1)
        commandEncoder.setVertexBytes(&modelConstants,
                                      length: MemoryLayout<ModelConstants>.stride,
                                      index: 1)
        if texture != nil {
            commandEncoder.setFragmentTexture(texture, index: 0)
        }
        commandEncoder.setRenderPipelineState(pipelineState)
        guard let meshes = meshes as? [MTKMesh],
            meshes.count > 0 else { return }
        for mesh in meshes {
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncoder.setVertexBuffer(vertexBuffer.buffer,
                                           offset: vertexBuffer.offset,
                                           index: 0)
            for submesh in mesh.submeshes {
                commandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                     indexCount: submesh.indexCount,
                                                     indexType: submesh.indexType,
                                                     indexBuffer: submesh.indexBuffer.buffer,
                                                     indexBufferOffset: submesh.indexBuffer.offset)
            }
        }
    }
}
