RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    code    script    render_priority 
   next_pass    shader    shader_parameter/color    shader_parameter/max_dist    shader_parameter/min_dist    shader_parameter/curve    shader_parameter/dp_curve    shader_parameter/tex    
   Texture2D 0   res://level/textures/structure/light_shafts.png pȍ�Nc   
   local://1          local://ShaderMaterial_fygtw /         Shader          �  shader_type spatial;

render_mode unshaded,depth_draw_never;

uniform sampler2D tex;
uniform vec4 color : source_color;
uniform float max_dist = 2.0;
uniform float min_dist = 5.0;
uniform float curve = 1.0;
uniform float dp_curve = 1.0;
void fragment() {
	float transparency = texture(tex,UV).r;
	float dp = pow(max(0.0,dot(NORMAL,vec3(0.0,0.0,0.1))),dp_curve);
	dp*=smoothstep(-VERTEX.z,max_dist,min_dist);
	ALBEDO = color.rgb;
	ALPHA = pow(transparency,curve) * color.a * dp;
	//ALBEDO = NORMAL;
}          ShaderMaterial 
                                            �?  �?  �?��d>         @	        �@
   )   {�G�z@   )   �Q����?                   RSRC