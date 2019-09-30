#version 330 core
out vec4 FragColor;

//in vec2 TexCoords;

float near = 0.01;
float far  = 50.0;

float LinearizeDepth(float depth)
{
    float z = depth * 2.0 - 1.0; // back to NDC
    return (2.0 * near * far) / (far + near - z * (far - near));
}

uniform bool userColor = false;
uniform vec4 color;
void main()
{
    if (userColor) {
        FragColor = color;
        return;
    }



    float depth = LinearizeDepth(gl_FragCoord.z) / far; // division par far pour la démonstration
    FragColor = vec4(vec3(depth), 1.0);
}
