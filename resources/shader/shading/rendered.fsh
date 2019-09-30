#version 330 core
out vec4 FragColor;

struct Material {
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;

    float shininess;
};
//struct Material {
//    sampler2D diffuse;
//    sampler2D specular;
//    float shininess;
//};

struct DirLight {
    vec3 direction;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct PointLight {
    vec3 position;

    float constant;
    float linear;
    float quadratic;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

struct SpotLight {
    vec3 position;
    vec3 direction;
    float cutOff;
    float outerCutOff;

    float constant;
    float linear;
    float quadratic;

    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};


in vec3 FragPos;
in vec3 Normal;
in vec2 TexCoords;

uniform sampler2D texture_diffuse1;
uniform sampler2D texture_specular1;
uniform Material material;

uniform vec3 viewPos;
#define MAX_DIR_LIGHTS 5
uniform DirLight dirLight[MAX_DIR_LIGHTS];
uniform int nbDirLight;
#define NR_POINT_LIGHTS 4
uniform PointLight pointLights[NR_POINT_LIGHTS];
uniform SpotLight spotLight;

uniform bool userColor = false;
uniform vec4 color;
uniform bool hasTexture = false;

// function prototypes
vec3 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir);
vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir);
vec3 CalcSpotLight(SpotLight light, vec3 normal, vec3 fragPos, vec3 viewDir);

void main()
{
//    FragColor = vec4(dirLight[0].ambient * material.specular, 1.0);
    if (userColor) {
        FragColor = color;
        return;
    }

//    FragColor = vec4(dirLight[0].ambient * vec3(texture2D(texture_diffuse1, TexCoords)), 1.0);
//    return;


//    vec4 texColor = texture2D(texture_diffuse1, TexCoords);
//    if (texColor.a < 0.1)
//        discard;
//    FragColor = texColor;

    // properties
    vec3 norm = normalize(Normal);
    vec3 viewDir = normalize(viewPos - FragPos);

//    FragColor = vec4(viewDir, 1.0);
//    return;
    // == =====================================================
    // Our lighting is set up in 3 phases: directional, point lights and an optional flashlight
    // For each phase, a calculate function is defined that calculates the corresponding color
    // per lamp. In the main() function we take all the calculated colors and sum them up for
    // this fragment's final color.
    // == =====================================================
    // phase 1: directional lighting
    vec3 result = vec3(0.0f, 0.0f, 0.0f);
//    for (int i =0; i <nbDirLight; ++i) {
//            result += CalcDirLight(dirLight[i], norm, viewDir);
//    }
            result += CalcDirLight(dirLight[0], norm, viewDir);
    // phase 2: point lights
//    for(int i = 0; i < NR_POINT_LIGHTS; i++)
//        result += CalcPointLight(pointLights[i], norm, FragPos, viewDir);
//    // phase 3: spot light
//    result += CalcSpotLight(spotLight, norm, FragPos, viewDir);

    FragColor = vec4(result, 1.0);
//    FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}

// calculates the color when using a directional light.
vec3 CalcDirLight(DirLight light, vec3 normal, vec3 viewDir)
{
    vec3 lightDir = normalize(-light.direction);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), 2.0f);
//    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // combine results
    vec3 ambient;
    vec3 diffuse;
    if (hasTexture) {
            vec4 texColor = texture2D(texture_diffuse1, TexCoords);
            if (texColor.a < 0.1)
                    discard;

            ambient = light.ambient * vec3(texColor);
            diffuse = light.diffuse * diff * vec3(texColor);
//            diffuse = light.diffuse * diff * material.diffuse;
//            ambient = vec3(diff);
    }
    else {
            ambient = light.ambient * material.ambient;
//            ambient = vec3(1.0, 0.0, 0.0);

            diffuse = light.diffuse * diff * material.diffuse;
//            diffuse = vec3(1.0, 0.0, 0.0);
    }

//    vec3 diffuse = light.diffuse * diff * material.diffuse;
//    vec3 specular = light.specular * spec * vec3(texture2D(texture_specular1, TexCoords));
//    vec3 specular = light.specular * spec * material.specular;
    vec3 specular = light.specular * spec * vec3(0.2, 0.2, 0.1);
//    return ambient;
//    return diffuse;
//    return specular;
    return (ambient + diffuse + specular);
//    return vec3(0.0, 1.0, 0.0);
}

// calculates the color when using a point light.
vec3 CalcPointLight(PointLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - fragPos);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));
    // combine results
    vec3 ambient = light.ambient * vec3(texture2D(texture_diffuse1, TexCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture2D(texture_diffuse1, TexCoords));
    vec3 specular = light.specular * spec * vec3(texture2D(texture_specular1, TexCoords));
    ambient *= attenuation;
    diffuse *= attenuation;
    specular *= attenuation;
    return (ambient + diffuse + specular);
}

// calculates the color when using a spot light.
vec3 CalcSpotLight(SpotLight light, vec3 normal, vec3 fragPos, vec3 viewDir)
{
    vec3 lightDir = normalize(light.position - fragPos);
    // diffuse shading
    float diff = max(dot(normal, lightDir), 0.0);
    // specular shading
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // attenuation
    float distance = length(light.position - fragPos);
    float attenuation = 1.0 / (light.constant + light.linear * distance + light.quadratic * (distance * distance));
    // spotlight intensity
    float theta = dot(lightDir, normalize(-light.direction));
    float epsilon = light.cutOff - light.outerCutOff;
    float intensity = clamp((theta - light.outerCutOff) / epsilon, 0.0, 1.0);
    // combine results
    vec3 ambient = light.ambient * vec3(texture2D(texture_diffuse1, TexCoords));
    vec3 diffuse = light.diffuse * diff * vec3(texture2D(texture_diffuse1, TexCoords));
    vec3 specular = light.specular * spec * vec3(texture2D(texture_specular1, TexCoords));
    ambient *= attenuation * intensity;
    diffuse *= attenuation * intensity;
    specular *= attenuation * intensity;
    return (ambient + diffuse + specular);
}
