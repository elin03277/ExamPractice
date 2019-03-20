#version 300 es

precision highp float;
in vec4 v_color;
in vec3 v_normal;
in vec2 v_texcoord;
out vec4 o_fragColor;

uniform sampler2D texSampler;

uniform mat3 normalMatrix;
uniform bool passThrough;
uniform bool shadeInFrag;
uniform bool fogActive;

/*
struct  Light {
    vec3 position;
    vec3 direction;
    float cutOff;
};
*/
void main()
{
    if (!passThrough && shadeInFrag) {
        vec3 eyeNormal = normalize(normalMatrix * v_normal);
        vec3 lightPosition = vec3(0.0, 0.0, 1.0);
        vec4 diffuseColor = vec4(0.0, 0.0, 1.0, 1.0); // * Ambient intensity
        
        float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
        
        float dist = (gl_FragCoord.z / gl_FragCoord.w);
        vec4 FogColour = vec4(1.0,1.0,1.0,1.0);
        float FogFactor = (10.0 - dist) / (10.0 - 1.0);
        FogFactor = clamp(FogFactor, 0.0, 1.0);
        if (fogActive) {
            o_fragColor = mix(FogColour, diffuseColor * nDotVP * texture(texSampler, v_texcoord), FogFactor); //1.0 = No Fog
        } else {
            o_fragColor = diffuseColor * nDotVP * texture(texSampler, v_texcoord);
        }
        //float theta = dot(vec(0.0,0.0,1.0), normalize(-gl_FragCoord));
        //o_fragColor = diffuseColor * nDotVP * texture(texSampler, v_texcoord);
        /*
        if(theta > light.cutOff)
        {
            // do lighting calculations
            o_fragColor = diffuseColor * nDotVP * texture(texSampler, v_texcoord);
        }
        else  // else, use ambient light so scene isn't completely dark outside the spotlight.
           o_fragColor = diffuseColor * nDotVP * texture(texSampler, v_texcoord);
        */
        
    } else {
        o_fragColor = v_color;
    }
}
