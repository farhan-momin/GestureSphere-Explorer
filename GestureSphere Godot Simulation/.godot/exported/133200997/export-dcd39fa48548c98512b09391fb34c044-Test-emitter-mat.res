RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    code    script    render_priority 
   next_pass    shader    shader_parameter/albedo    shader_parameter/point_size    shader_parameter/roughness *   shader_parameter/metallic_texture_channel    shader_parameter/specular    shader_parameter/metallic    shader_parameter/normal_scale $   shader_parameter/ao_texture_channel !   shader_parameter/ao_light_affect    shader_parameter/uv1_scale    shader_parameter/uv1_offset    shader_parameter/uv2_scale    shader_parameter/uv2_offset     shader_parameter/texture_albedo "   shader_parameter/texture_metallic #   shader_parameter/texture_roughness     shader_parameter/texture_normal +   shader_parameter/texture_ambient_occlusion    
   Texture2D :   res://level/textures/structure/reactor_emitter_albedo.png ���ˢ^5M
   Texture2D 7   res://level/textures/structure/reactor_emitter_orm.png 7�{�._�4
   Texture2D :   res://level/textures/structure/reactor_emitter_normal.png z3P��OU_      local://Shader_uk8v0 �         local://ShaderMaterial_mybax �         Shader            // NOTE: Shader automatically converted from Godot Engine 4.0.rc1's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_linear_mipmap,repeat_enable;
uniform float specular;
uniform float metallic;
uniform sampler2D texture_normal : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16);
uniform sampler2D texture_ambient_occlusion : hint_default_white, filter_linear_mipmap,repeat_enable;
uniform vec4 ao_texture_channel;
uniform float ao_light_affect;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
}






void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(0.0,1.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	NORMAL_MAP = texture(texture_normal,base_uv).rgb;
	NORMAL_MAP_DEPTH = normal_scale;
	AO = dot(texture(texture_ambient_occlusion,base_uv),ao_texture_channel);
	AO_LIGHT_AFFECT = ao_light_affect;
}
          ShaderMaterial             reactor_emitter                                          �?  �?  �?  �?      	        �?
   2             �?             ?         ?         2     �?               )   ffffff�?        �?  �?  �?              �?  �?  �?                                                                         RSRC