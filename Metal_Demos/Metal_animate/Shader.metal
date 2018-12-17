//
//  Shader.metal
//  Metal_animate
//
//  Created by kris.wang on 2018/12/17.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//跟 Renderer 里结构体的命名要一致
struct Constants {
    float animateBy;
};

//处理顶点， 两个参数 一个是顶点个数， 一个是顶点id
//constant 告诉 CPU 现在这个数据是恒定的空间
vertex float4 vertex_shader(const device packed_float3 * vertices[[buffer(0)]],
                            constant Constants &constants [[buffer(1)]],
                            uint vertexId[[vertex_id]]){
    
    //    修改位置
    float4 postion = float4(vertices[vertexId], 1);
    postion.x += constants.animateBy;
    
    return postion;
    return float4(vertices[vertexId],1);
}

// 上色
fragment half4 fragment_shader() {
    return half4(0,1,0,1); //红色
}
