RSRC                    StandardMaterial3D            ��������                                            v      resource_local_to_scene    resource_name    code    script    render_priority 
   next_pass    shader    shader_parameter/grow_factor #   shader_parameter/electricity_color !   shader_parameter/emission_energy    shader_parameter/speed_scale !   shader_parameter/emission_cutout    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    disable_fog    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    
   Texture2D 6   res://enemies/red_robot/textures/red_robot_albedo.png x�,�*��6
   Texture2D 3   res://enemies/red_robot/textures/red_robot_orm.png i�>�Q[
   Texture2D 8   res://enemies/red_robot/textures/red_robot_emission.png ����@5
   Texture2D 6   res://enemies/red_robot/textures/red_robot_normal.png ㏸5&�d   
   local://1 ?      
   local://2 �      !   local://StandardMaterial3D_ovp22 Y         Shader          `
  shader_type spatial;
render_mode cull_disabled;

uniform float grow_factor = 0.05;
uniform vec4 electricity_color:source_color = vec4(0.0,1.0,1.0,1.0);
uniform float emission_energy = 1.0;
uniform float speed_scale = 0.2;
uniform float emission_cutout = 0.0;

varying vec3 vertex_local_coords;
varying vec3 vert_random;

// CODE FROM Nikita Miropolskiy
// https://www.shadertoy.com/view/XsX3zB
vec3 random3(vec3 c) {
	float j = 4096.0*sin(dot(c,vec3(17.0, 59.4, 15.0)));
	vec3 r;
	r.z = fract(512.0*j);
	j *= .125;
	r.x = fract(512.0*j);
	j *= .125;
	r.y = fract(512.0*j);
	return r-0.5;
}

/* skew constants for 3d simplex functions */
const float F3 =  0.3333333;
const float G3 =  0.1666667;

/* 3d simplex noise */
float simplex3d(vec3 p) {
	 /* 1. find current tetrahedron T and it's four vertices */
	 /* s, s+i1, s+i2, s+1.0 - absolute skewed (integer) coordinates of T vertices */
	 /* x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices*/

	 /* calculate s and x */
	 vec3 s = floor(p + dot(p, vec3(F3)));
	 vec3 x = p - s + dot(s, vec3(G3));

	 /* calculate i1 and i2 */
	 vec3 e = step(vec3(0.0), x - x.yzx);
	 vec3 i1 = e*(1.0 - e.zxy);
	 vec3 i2 = 1.0 - e.zxy*(1.0 - e);

	 /* x1, x2, x3 */
	 vec3 x1 = x - i1 + G3;
	 vec3 x2 = x - i2 + 2.0*G3;
	 vec3 x3 = x - 1.0 + 3.0*G3;

	 /* 2. find four surflets and store them in d */
	 vec4 w, d;

	 /* calculate surflet weights */
	 w.x = dot(x, x);
	 w.y = dot(x1, x1);
	 w.z = dot(x2, x2);
	 w.w = dot(x3, x3);

	 /* w fades from 0.6 at the center of the surflet to 0.0 at the margin */
	 w = max(0.6 - w, 0.0);

	 /* calculate surflet components */
	 d.x = dot(random3(s), x);
	 d.y = dot(random3(s + i1), x1);
	 d.z = dot(random3(s + i2), x2);
	 d.w = dot(random3(s + 1.0), x3);

	 /* multiply d by w^4 */
	 w *= w;
	 w *= w;
	 d *= w;

	 /* 3. return the sum of the four surflets */
	 return dot(d, vec4(52.0));
}

// END OF CODE FROM Nikita Miropolskiy

void vertex(){
	VERTEX += NORMAL * grow_factor;
	vertex_local_coords = VERTEX;
	vert_random = random3(VERTEX);
}

void fragment(){
	float noise1 = simplex3d(vertex_local_coords + vec3(0.0,TIME * speed_scale,0.0) + vert_random);
	float noise2 = simplex3d(vertex_local_coords * 0.6 + vec3(0.0,-TIME * speed_scale,0.0));
	// we take the intersection of the 2 noises by multiplying them
	// and max it between 0.0 and 0.001 using smoothstep
	ALPHA = 1.0 - smoothstep(0.002, 0.005 + emission_cutout, abs(noise1*noise2));
	ALPHA *= noise2 + emission_cutout;
	ALPHA = max(0.0, ALPHA) ;
	ALBEDO = electricity_color.rgb;
	EMISSION = ALBEDO * (emission_energy + emission_cutout * emission_energy) ;
//	ALPHA = noise2 * noise1;
}          ShaderMaterial 	                                       )   {�G�z�?            �?  �?  �?	        �?
   )   333333�?                   StandardMaterial3D          	   EvilRobo                                   ?                     !            "         #         %        �@(            )         +            7         9                  RSRC