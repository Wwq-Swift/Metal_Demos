//
//  Shader.metal
//  metal_triangle
//
//  Created by kris.wang on 2018/12/17.
//  Copyright © 2018年 王伟奇. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

//处理顶点， 两个参数 一个是顶点个数， 一个是顶点id
vertex float4 vertex_shader(const device packed_float3 * vertices[[buffer(0)]], uint vertexId[[vertex_id]]){
    
    return float4(vertices[vertexId],1);
}

// 上色
fragment half4 fragment_shader() {
    return half4(0,0,1,1);
}
