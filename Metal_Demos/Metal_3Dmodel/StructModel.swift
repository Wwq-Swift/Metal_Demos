//
//  StructModel.swift
//  Metal_2D~3D
//
//  Created by 王伟奇 on 2018/12/23.
//  Copyright © 2018 王伟奇. All rights reserved.
//

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

//模型的常量 （代表模型本身的矩阵）
struct ModelConstants {
    /// 代表自身模型
    var modelViewMatrix = matrix_identity_float4x4
}
/// 场景的
struct SceneConstants {
    /// 代表场景矩阵模型
    var projectionMatris = matrix_identity_float4x4
}
