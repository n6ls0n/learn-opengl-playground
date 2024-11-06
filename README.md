# README

This is a clone of <https://github.com/JoeyDeVries/LearnOpenGL> that allows you to build and run each individual example w/ CMake.

You should have Visual Studio installed. Use this link (<https://code.visualstudio.com/docs/cpp/config-msvc#_prerequisites>) and complete steps 1 to 3 of the prerequisites.

2 weeks after I started seriously working through this book I could  write and debug custom shaders.

If you've ever tried learning this stuff on your own, you know just how insane that is.

Joey is the man!!!

Give him a follow on Twitter/X - <https://x.com/JoeyDeVriez>

Book Link: <https://learnopengl.com/>

Below are some notes I took, feel free to remove them.

## Table of Contents

- [Getting Started](#getting-started)
  - [What is OpenGL](#what-is-opengl)
  - [The connection between OpenGL and GLFW](#the-connection-between-opengl-and-glfw)
  - [Why we need GLAD and GLEW](#why-we-need-glad-and-glew)
  - [OpenGL and GLAD](#opengl-and-glad)
  - [Immediate Mode vs Core Profile Mode](#immediate-mode-vs-core-profile-mode)
  - [Extensions](#extensions)
  - [OpenGL is one big state machine](#opengl-is-one-big-state-machine)
  - [Objects](#objects)
  - [Graphics Pipeline](#graphics-pipeline)
  - [Vertex Information](#vertex-information)
  - [Shaders](#shaders)
  - [Textures](#textures)
  - [Transformations](#transformations)
  - [Coordinate Systems](#coordinate-systems)
  - [Camera](#camera)
- [Lighting](#lighting)
  - [Colors](#colors)
  - [Basic Lighting](#basic-lighting)
  - [Materials](#materials)
  - [Lighting maps](#lighting-maps)
  - [Light casters](#light-casters)
  - [Multiple lights](#multiple-lights)
- [Model Loading](#model-loading)
  - [Assimp](#assimp)
  - [Mesh](#mesh)
  - [Model](#model)
- [Advanced OpenGL](#advanced-opengl)
  - [Depth Testing](#depth-testing)
  - [Stencil Testing](#stencil-testing)
  - [Blending](#blending)
  - [Face culling](#face-culling)
  - [Framebuffers](#framebuffers)
  - [Cubemaps](#cubemaps)
  - [Advanced Data](#advanced-data)
  - [Advanced GLSL](#advanced-glsl)
  - [Geometry Shader](#geometry-shader)
  - [Instancing](#instancing)
  - [Anti Aliasing](#anti-aliasing)
- [Advanced Lighting](#advanced-lighting)
  - [Advanced Lighting Subsection](#advanced-lighting-subsection)
  - [Gamma Correction](#gamma-correction)
  - [Shadows_Shadow-Mapping](#shadows_shadow-mapping)
  - [Shadows_Point-Shadows](#shadows_point-shadows)
  - [Normal Mapping](#normal-mapping)
  - [Parallax Mapping](#parallax-mapping)
  - [HDR](#hdr)
  - [Bloom](#bloom)
  - [Deferred Shading](#deferred-shading)
  - [SSAO](#ssao)
- [PBR](#pbr)
  - [Theory](#theory)
  - [Lighting-PBR](#lighting-pbr)
  - [IBL_Diffuse Irradiance](#ibl_diffuse-irradiance)
  - [IBL_Specular IBL](#ibl_specular-ibl)
- [Helpful Links](#helpful-links)

### Getting Started

#### *What is OpenGL*

- OpenGL is a graphics API and not a platform of its own. OpenGL is mainly considered an API (an Application Programming Interface) that provides us with a large set of functions that we can use to manipulate graphics and images. However, OpenGL by itself is not an API, but merely a specification, developed and maintained by the Khronos Group. The OpenGL specification specifies exactly what the result/output of each function should be and how it should perform. It is then up to the developers implementing this specification to come up with a solution of how this function should operate. Since the OpenGL specification does not give us implementation details, the actual developed versions of OpenGL are allowed to have different implementations, as long as their results comply with the specification (and are thus the same to the user)

- The people developing the actual OpenGL libraries are usually the graphics card manufacturers. Each graphics card that you buy supports specific versions of OpenGL which are the versions of OpenGL developed specifically for that card (series).

#### *The connection between OpenGL and GLFW*

- OpenGL is a library that provides services like 3D rendering but doesn't do anything like creating a window that you can render into. OpenGL doesn't know anything about windows, or mouse events, or keyboards, or fonts and so on. It only knows about rendering. Because you probably want to render things visible on the screen you can't "use OpenGL on its own" because you wouldn't have anywhere to render. In fact, in order to do anything with OpenGL you need what is called an OpenGL context. The OpenGL library itself has no mechanism to create such contexts. Think of an OpenGL context as some internal data that represents the current state of the OpenGL system.

- Different platforms (such as Windows, Linux/X, OSX, iOS, Android) provide different mechanisms for creating contexts. For example Windows has its own function calls that allow the creation of OpenGL contexts that are very different from how OSX creates a context. Additionally Windows provides functions to support things like mouse events. This is where GLFW comes in: it provides a cross-platform library to handle the things that OpenGL doesn't handle, like creating contexts and handling mouse events. By and large it's not a wrapper library on top of OpenGL though it does provide some a small amount of functionality like this: like automatically building mip-map levels.

#### *Why we need GLAD and GLEW*

- GLFW: As you said this is a library to manage windows. It also manages mouse/keyboard input and has some other goodies in there. It is capable of handling windows for multiple operating systems and it is also able to be used with vulkan. It also handles surface creation which is related to windows and rendering. You aren't forced to use a window library, but I would highly recommend you use one instead of writing all that code yourself.

- GLEW and GLAD: These handle function pointers. You technically don't need to use those libraries to actually use OpenGL, but you would need to load the function pointers yourself which is very very annoying to do. It's not difficult per se, it's just a long and tedious process. Just look at the headers from those libraries and you'll see that they have a large amount of code. The reason why you need those function pointers is that the code is located in the driver (and some of it might even be on the gpu). OpenGL, Vulkan and DirectX are only specifications so Khronos (they make OpenGL and Vulkan) and Microsoft ( they make DirectX) do not provide an implementation for them; the GPU driver is charged with implementing all of the specification. You can see that a bit like Khronos is providing the OpenGL .h file and the driver provides the .cpp file.

- GLEW and GLAD also come with the OpenGL headers because you also need those along with the function pointers, but you can also get those headers from Khronos directly.Now onto your question of why are those separate libraries. There is no functional reason and it's more of "code quality". All those libraries want to have a specific purpose and their devs have a limited amount of time like all of us. GLFW could provide a loader for the function pointers, but then this would become redundant with GLEW and GLAD so they don't have a good reason to do it.There are a lot of other options for libraries for example you could use SFML which has a lot more stuff than GLFW and GLEW and I really liked it to learn. There is also SDL that i've seen used quite a lot and I think it's similar to SFML.

#### *OpenGL and GLAD*

- In order for OpenGL to successfully render stuff into the window, it needs to interface with the graphics drivers on the machine. For this to happen, the OpenGL functions need to be mapped to their corresponding operating system specific rendering functionality. This means a lot of checking if this is a windows operating system, map the OpenGL rendering function to this Windows specific graphics function and do XYZ functionality, else map the OpenGL rendering function to a different operating system rendering function and do ABC functionality.

- This introduces a lot of boilerplate code into the application and increases the chance of creating a bug. GLAD is what\rquote s called an extension loader but in simple English it\rquote s something you can import into your code that provides a function you can call which handles all of this mapping under the hood for you and reduces the amount of code you need to write.

#### *Immediate Mode vs Core Profile Mode*

- In the old days, using OpenGL meant developing in immediate mode (often referred to as the fixed function pipeline) which was an easy-to-use method for drawing graphics. Most of the functionality of OpenGL was hidden inside the library and developers did not have much control over how OpenGL does its calculations. Developers eventually got hungry for more flexibility and over time the specifications became more flexible as a result; developers gained more control over their graphics. The immediate mode is really easy to use and understand, but it is also extremely inefficient. For that reason the specification started to deprecate immediate mode functionality from version 3.2 onwards and started motivating developers to develop in OpenGL's core-profile mode, which is a division of OpenGL's specification that removed all old deprecated functionality.

- When using OpenGL's core-profile, OpenGL forces us to use modern practices. Whenever we try to use one of OpenGL's deprecated functions, OpenGL raises an error and stops drawing. The advantage of learning the modern approach is that it is very flexible and efficient. However, it's also more difficult to learn. The immediate mode abstracted quite a lot from the actual operations OpenGL performed and while it was easy to learn, it was hard to grasp how OpenGL actually operates. The modern approach requires the developer to truly understand OpenGL and graphics programming and while it is a bit difficult, it allows for much more flexibility, more efficiency and most importantly: a much better understanding of graphics programming.

#### *Extensions*

- A great feature of OpenGL is its support of extensions. Whenever a graphics company comes up with a new technique or a new large optimization for rendering this is often found in an extension implemented in the drivers. If the hardware an application runs on supports such an extension the developer can use the functionality provided by the extension for more advanced or efficient graphics. This way, a graphics developer can still use these new rendering techniques without having to wait for OpenGL to include the functionality in its future versions, simply by checking if the extension is supported by the graphics card. Often, when an extension is popular or very useful it eventually becomes part of future OpenGL versions.

- The developer has to query whether any of these extensions are available before using them (or use an OpenGL extension library). This allows the developer to do things better or more efficient, based on whether an extension is available.
- Sample Code:

    ```cpp
    if(GL_ARB_extension_name)
    {
        // Do cool new and modern stuff supported by hardware
    }
    else
    {
        // Extension not supported: do it the old way
    }

#### *OpenGL is one big state machine*

- OpenGL is by itself a large state machine: a collection of variables that define how OpenGL should currently operate. The state of OpenGL is commonly referred to as the OpenGL context. When using OpenGL, we often change its state by setting some options, manipulating some buffers and then render using the current context.

- Whenever we tell OpenGL that we now want to draw lines instead of triangles for example, we change the state of OpenGL by changing some context variable that sets how OpenGL should draw. As soon as we change the context by telling OpenGL it should draw lines, the next drawing commands will now draw lines instead of triangles.

- When working in OpenGL we will come across several **state-changing functions** that change the context and several **state-using functions** that perform some operations based on the current state of OpenGL. As long as you keep in mind that OpenGL is basically one large state machine, most of its functionality will make more sense.

#### *Objects*

- The OpenGL libraries are written in C and allows for many derivations in other languages, but in its core it remains a C-library. Since many of C's language-constructs do not translate that well to other higher-level languages, OpenGL was developed with several abstractions in mind. One of those abstractions are objects in OpenGL.

- An object in OpenGL is a collection of options that represents a subset of OpenGL's state. For example, we could have an object that represents the settings of the drawing window; we could then set its size, how many colors it supports and so on. One could visualize an object as a C-like struct:

    ```cpp
    struct object_name {
        float  option1;
        int    option2;
        char[] name;
    };
    ```

  - Whenever we want to use objects it generally looks something like this (with OpenGL's context visualized as a large struct):

    ```cpp
    // The State of OpenGL
    struct OpenGL_Context {
        ...
        object_name* object_Window_Target;
        ...
    };

    // create object
    unsigned int objectId = 0;
    glGenObject(1, &objectId);
    // bind/assign object to context
    glBindObject(GL_WINDOW_TARGET, objectId);
    // set options of object currently bound to GL_WINDOW_TARGET
    glSetObjectOption(GL_WINDOW_TARGET, GL_OPTION_WINDOW_WIDTH,  800);
    glSetObjectOption(GL_WINDOW_TARGET, GL_OPTION_WINDOW_HEIGHT, 600);
    // set context target back to default
    glBindObject(GL_WINDOW_TARGET, 0);
    ```

- This little piece of code is a workflow you'll frequently see when working with OpenGL. We first create an object and store a reference to it as an id (the real object's data is stored behind the scenes). Then we bind the object (using its id) to the target location of the context (the location of the example window object target is defined as GL_WINDOW_TARGET). Next we set the window options and finally we un-bind the object by setting the current object id of the window target to 0. The options we set are stored in the object referenced by objectId and restored as soon as we bind the object back to GL_WINDOW_TARGET.

- The code samples provided so far are only approximations of how OpenGL operates; throughout the book you will come across enough actual examples.

- The great thing about using these objects is that we can define more than one object in our application, set their options and whenever we start an operation that uses OpenGL's state, we bind the object with our preferred settings. There are objects for example that act as container objects for 3D model data (a house or a character) and whenever we want to draw one of them, we bind the object containing the model data that we want to draw (we first created and set options for these objects). Having several objects allows us to specify many models and whenever we want to draw a specific model, we simply bind the corresponding object before drawing without setting all their options again.

#### *Graphics Pipeline*

- In OpenGL everything is in 3D space, but the screen or window is a 2D array of pixels so a large part of OpenGL's work is about transforming all 3D coordinates to 2D pixels that fit on your screen. The process of transforming 3D coordinates to 2D pixels is managed by the graphics pipeline of OpenGL.

- The graphics pipeline can be divided into two large parts: the first transforms your 3D coordinates into 2D coordinates and the second part transforms the 2D coordinates into actual colored pixels.

- The graphics pipeline takes as input a set of 3D coordinates and transforms these to colored 2D pixels on your screen. The graphics pipeline can be divided into several steps where each step requires the output of the previous step as its input.

- All of these steps are highly specialized (they have one specific function) and can easily be executed in parallel. Because of their parallel nature, graphics cards of today have thousands of small processing cores to quickly process your data within the graphics pipeline. The processing cores run small programs on the GPU for each step of the pipeline. **These small programs are called shaders**.

- Some of these shaders are configurable by the developer which allows us to write our own shaders to replace the existing default shaders. This gives us much more fine-grained control over specific parts of the pipeline and because they run on the GPU, they can also save us valuable CPU time. Shaders are written in the OpenGL Shading Language (GLSL).

- Graphics Pipeline Stages:
  - Vertex Shader (Customizable)
  - Geometry Shader (Customizable)
  - Shape Assembly
  - Rasterization
  - Fragment Shader (Customizable)
  - Tests and Blending

- As input to the graphics pipeline we pass in a list of three 3D coordinates that should form a triangle in an array here called Vertex Data; this vertex data is a collection of vertices(singular vertex). A vertex is a collection of data per 3D coordinate (Vertex Data will have 3 entries or vertices). This vertex's data is represented using vertex attributes that can contain any data we'd like, but for simplicity's sake let's assume that each vertex consists of just a 3D position and some color value.

- **Vertex Shader**: This stage is customizable and it the first stage of the graphics pipeline. It takes as input a single vertex. The main purpose of the vertex shader is to transform 3D coordinates into different 3D coordinates (more on that later) and the vertex shader allows us to do some basic processing on the vertex attributes.

- **Geometry Shader**: The output of the vertex shader stage is optionally passed to the geometry shader. The geometry shader takes as input a collection of vertices that form a primitive and has the ability to generate other shapes by emitting new vertices to form new (or other) primitive(s). In this example case, it generates a second triangle out of the given shape.

- **Shape Assembly**: The primitive assembly stage takes as input all the vertices (or vertex if GL_POINTS is chosen) from the vertex (or geometry) shader that form one or more primitives and assembles all the point(s) in the primitive shape given; in this case two triangles.

- **Rasterization**: The output of the primitive assembly stage is then passed on to the rasterization stage where it maps the resulting primitive(s) to the corresponding pixels on the final screen, resulting in fragments for the fragment shader to use. Before the fragment shaders run, clipping is performed. Clipping discards all fragments that are outside your view, increasing performance. A fragment in OpenGL is all the data required for OpenGL to render a single pixel.

- **Fragment Shader**:  is to calculate the **final color** of a pixel and this is usually the stage where all the advanced OpenGL effects occur. Usually the fragment shader contains data about the 3D scene that it can use to calculate the final pixel color (like lights, shadows, color of the light and so on).

- **Alpha Tests and Blending**: This stage checks the corresponding depth (and stencil) value (we'll get to those later) of the fragment and uses those to check if the resulting fragment is in front or behind other objects and should be discarded accordingly. The stage also checks for alpha values (alpha values define the opacity of an object) and blends the objects accordingly. So even if a pixel output color is calculated in the fragment shader, the final pixel color could still be something entirely different when rendering multiple triangles.

- In modern OpenGL we are required to define at least a vertex and fragment shader of our own (there are no default vertex/fragment shaders on the GPU).

#### *Vertex Information*

- OpenGL is a 3D graphics library so all coordinates that we specify in OpenGL are in 3D (x, y and z coordinate). OpenGL doesn't simply transform all your 3D coordinates to 2D pixels on your screen; OpenGL only processes 3D coordinates when they're in a specific range between -1.0 and 1.0 on all 3 axes (x, y and z). All coordinates within this so called normalized device coordinates range will end up visible on your screen (and all coordinates outside this region won't).

- Below is a float array that contains the vertex information for a triangle. Each group of three floats represents one vertex of the triangle. Note that the z-coordinate (every third element) for each vertex is 0 since we are 2-D triangle

  ```cpp
  float vertices[] = {
      -0.5f, -0.5f, 0.0f,
      0.5f, -0.5f, 0.0f,
      0.0f,  0.5f, 0.0f
  };
  ```

- Normalized Device Coordinates (NDC) which is a small space where the x, y and z values vary from -1.0 to 1.0. Any coordinates that fall outside this range will be discarded/clipped and won't be visible on your screen. In this coordinate system, the point (0,0) is at the center of the screen unlike usual screen coordinates.

- Your NDC coordinates will then be transformed to screen-space coordinates via the viewport transform using the data you provided with glViewport. The resulting screen-space coordinates are then transformed to fragments as inputs to your fragment shader.

- The float array called vertices will be referred to as the vertex data from here on.

- **Vertex Attributes** are created and specified within the vertex shader

- With the vertex data defined, we'd like to send it as input to the first process of the graphics pipeline: the vertex shader. This is done by creating memory on the GPU where we store the vertex data, configure how OpenGL should  interpret the memory and specify how to send the data to the graphics card

- We manage this memory via **Vertex Buffer Objects (VBOs)** that can store a large number of vertices in the GPU's memory.

- The advantage of using VBOs is that you can send large batches of data all at once to the graphics card and keep it there if there's enough memory left without having to send data once vertex at a time.

- Sending data from the CPU to the graphics card is relatively slow, so when possible, it's best to send as much data as we can. Once the data is in the GPU's memory, the vertex shader has almost instant access to it.

- Each VBO has a unique ID corresponding to that buffer.

- OpenGL allow multiple buffers to be bound at once as long as all the buffers are off a different type.

- Once a buffer has been bound to a target via it's ID, any calls to that target will be used to configure the currently bound buffer.

- The vertex shader allows us to specify any input we want in the form of vertex attributes and while this allows for great flexibility, it does mean we have to manually specify what part of our input data goes to which vertex attribute in the vertex shader. This means we have to specify how OpenGL should interpret the vertex data before rendering.

- Recall that vertex attributes are created and specified within the vertex shader.

- Each vertex shader gets takes its data from memory managed by a VBO and which VBO it takes its data from is determined by the VBO currently boud to GL_ARRAY_BUFFER when calling glVertexAttribPointer.

- Once we have specified how OpenGl should intepret the vertex data, we should also enable the vertex attribute with glEnable VertexAttribArray giving the vertex attribute location as its argument

- Vertex attributes are disabled by default.

- Once the vertex attribute has been enabled, we have setup. In particular, we have initialized the vertex data ina buffer using a VBO, setup vertex and fragment shaders and also told OpenGl how to link the vertex data to the vertex shader's attributes (vertex attributes)

- At this point, it is possible to then draw the resultant object. The process can easily become tedious if we have a lot of items to draw.

- Why would it be tedious? It would be because binding the appropriate buffer objects and configuring all the vertex attributes for each of those objects quickly becomes a cumbersome process.

- To that end, we use **Vertex Array Objects (VAOs)**.

- VAOs can be bound just like VBOs and any subsequent vertex attribute calls from that point will be stored inside the VAO. This has the advantage that when configuring vertex attribute pointers you only have to make those calls once and whenever we want to draw the object, we can just bind the corresponding VAO.

- This make switching between different vertex data and attribute configurations as easy as binding a different VAO. All the state that was just set is stored inside the VAO.

- Core OpenGL requires that we use a VAO if not nothing will be drawn.

- The VAO stores three things:
  1. Calls to glEnableVertexAttribArray or glDisableVertexAttribArray
  2. Vertex attribute configurations via glVertexAttribPointer
  3. Vertex buffer objects associated with vertex attributes by calls to glVertexAttribPointer

- Element Buffer Objects (EBOs) is a buffer just like a VBO that store indices that OpenGL uses to decide what vertices to draw. This is called indexed drawing.

- VAOs can also keep track of EBO bindings

#### *Shaders*

- Shaders are little programs that rest on the GPU. These programs are run for each specific section of the graphics pipeline. In a basic sense, shaders are nothing more than programs transforming inputs to outputs.

- Shaders are also very isolated programs in that they're not allowed to communicate with each other; the only communication they have is via their inputs and outputs.

- Shaders are written in the C-like language GLSL. GLSL is tailored for use with graphics and contains useful features specifically targeted at vector and matrix manipulation.

- Shaders always begin with a version declaration, followed by a list of input and output variables, uniforms and its main function.

- Each shader's entry point is at its main function where we process any input variables and output the results in its output variables.

- A sample shader:

  ```cpp
  #version version_number
  in type in_variable_name;
  in type in_variable_name;

  out type out_variable_name;

  uniform type uniform_name;

  void main()
  {
  // process input(s) and do some weird graphics stuff
  ...
  // output processed stuff to output variable
  out_variable_name = weird_stuff_we_processed;
  }
  ```

- When we're talking specifically about the vertex shader each input variable is also known as a **Vertex Attribute**.

- There is a maximum number of vertex attributes we're allowed to declare limited by the hardware. OpenGL guarantees there are always at least 16 4-component vertex attributes available, but some hardware may allow for more which you can retrieve by querying GL_MAX_VERTEX_ATTRIBS. This often returns the minimum of 16 which should be more than enough for most purposes.

- GLSL has, like any other programming language, data types for specifying what kind of variable we want to work with. GLSL has most of the default basic types we know from languages like C: int, float, double, uint and bool.

- GLSL also features two container types that we'll be using a lot, namely vectors and matrices.

- A vector in GLSL is a 2,3 or 4 component container for any basic types just mentioned. they can take the following form(n represents the number of components)
  - vecn: default vector of n floats
  - bvecn: a vector of n booleans
  - ivecn: a vector of n integers
  - uvecn; a vector of n unsigned integers

- Components of a vector can be accessed via vec.x where x is the first component of the vector. You can use .x, .y, .z and .w to access the first, second, third and fourth component respectively.

- GLSL also allows you to use **rgba** for colors and **stqp** for texture coordinates, accessing the same components.

- Swizzling is a feature in GLSL (OpenGL Shading Language) and other shader languages that allows you to easily select and rearrange components of vectors.

- It allows us to use any combination of up to 4 letters to create a new vector as long as the original vector has those components. It is not allowed to access the .z component of a vec2.

- Vectors can also be passed as arguments to different vector constructor calls

- Some examples of swizzling below:

  ```cpp
  vec2 someVec;
  vec4 differentVec = someVec.xyxx;
  vec3 anotherVec = differentVec.zyw;
  vec4 otherVec = someVec.xxxx + anotherVec.yxzy;

  vec2 vect = vec2(0.5, 0.7);
  vec4 result = vec4(vect, 0.0, 0.0);
  vec4 otherResult = vec4(result.xyz, 1.0);
  ```

- Shaders form part of a whole and so each shader needs to have input(s) and output(s) so that data can be moved around.

- The **in** and **out** keywords are used to specifically for this movement.

- Each shader can specify inputs and outputs using those keywords and wherever an output variable matches with an input variable of the next shader they're passed along.

- There are a few differences between the vertex and the fragment shader

- For the vertex shader, it should receive some form of input otherwise it would be pretty ineffective. The vertex shader receives it's input straight from vertex data.

- To define how the vertex data is organized, we specify the input variables with location metadata so we can configure the vertex attributes on the CPU.

- Thus, the vertex shader requires an extra layout specification

  ```cpp
  layout (location = 0)
  ```

  for its inputs so we can link it with the vertex data.

- It is possible to omit the layout specifier and query for the attribute locations in your OpenGl code via glGetAttribLocation but it's preferable to set them in the vertex

- Vertex shaders have a built-in output variable called **gl_Position**. It is used to specify the final position of a vertex in the clip space. It's value is used by the OpenGL pipeline to determine he position of the vertex in the screen space.

- In the vertex shader, you typically assign a value to gl_Position using the vec4 data type, which represents a 4-component vector (x,y,z,w).

- gl_Position is a special variable because it is used directly by the OpenGl pipeline to determine the position of the vertex in the screen space. It doesn;t need to be declared as an output variable and it should not be used as an input variable in the fragment shader

- If you need to access the position of a vertex in the fragment shader, you will need to pass it as a seperate output variable from the vertex shader.

- For the fragment shaders, how they differ from vertex shaders is that the fragment shader requires a vec4 color output variable since the fragment shader needs to generate a final output color.

- If you fail to specify an output color in your fragment shaders, the color buffer output for those fragments will be undefined(which usually means OpenGl will render them either black or white)

- So if we want to send data from one shader to the other we'd have to declare an output in the sending shader and a similar input in the receiving shader.

- When the types and the names are equal on both sides, OpenGL will link those variables together and then it is possible to send data between shaders(this is done when linking a program object)

- Uniforms are another way to pass data from our application on the CPU to the shaders on the GPU

- Uniforms are slightly different compared to vertex attributes in two ways namely:
  1. They are global in the sense that a uniform is unique per shader program object and can be accessed from any shader at any stage in the shader program
  2. Whatever you set the uniform value to, uniforms will keep their values until they're either reset or updated

- If you declare a uniform that isn't used anywhere in your GLSL code, the compiler will silently remove the variable from the compiled version which is the cause of several frustrating errors.

#### *Textures*

- A texture is a 2D image (possibly 1D or 3D image) used to add detail to an object

- Because a lot of details can be inserted into a single image, we can give the illusion that the object is extremely detailed without having to specify extra vertices.

- In order to map a texture to the triangle we need to tel each vertex of the triangle which part of the texture it corresponds to.

- Thus, each vertex should have a **texture coordinate** associated with them that specifies what part of the texture image to sample from. The rest of the triangle is then filled in via fragment interpolation

- Texture coordinates can range from 0 to 1 in the x and y axis (assuming 2D images)

- **Sampling** is the act of retrieving the texture color using texture coordinates

- Texture coordinates start at (0,1) for the lower left corner of a texture image to (1,1) for the upper right corner of the a texture image

- Texture sampling has a loose interpretation and can be done in many different ways and thus its our job to tell OpenGl how it should sample its textures

- There are multiple ways for OpenGL to handle sampling a texture when we specify coordinates outside the default range

- Texture coordinates do not depend on the resolution but can be any floating point value, thus OpenGl has to figure out which texture pixel (**texel**) to map the texture coordinate to. This process is known as **texture filtering**

- Texture filtering is very important in cases where we have a very large object and a low resolution texture

- GL_NEAREST (also known as nearest neighbour or point filtering) is the default texture filtering method of OpenGL

- Texture filtering can be set for magnifying and minifying operations(when scaling up or downwards) so you could for example use nearest neighbour filtering when textures are scaled downwards and linear filtering for upscaled textures

- Mipmaps are a collection of texture images where each subsequent texture is twice as small compared to the previous one

- The idea behind mipmaps is that after a certain distance threshold from the viewer, OpenGL will use a different mipmap texture that best suits the distance to the object. Because the object is far away, the smaller resolution will not be noticeable to the user.

- OpenGL is then able to sample the correct texels and there's less cache memory involved when sampling that part of the mipmaps.

#### *Transformations*

- Transformations of vectors occur via the utilization of matrices

- Matrix multiplication is not commutative

- The matrices used to carry out these transformations are called transformation matrices

- If you have multiple transformation matrices, they will evaluated from right-to-left

- The recommended order of matrix transformations is:
  1. Scaling
  2. Rotation
  3. Translation

#### *Coordinate Systems*

- Recall that OpenGL expects all the vertices, that we want to be visible, to be in the Normalized Device Coordinates (NDC) after each vertex shader run.

- What we the users do is specify the coordinates in a range (or space) we determine ourselves and in the vertex shader, transform these coordinates to NDC

- These new NDC are then given to the Rasterizer to transform them to 2D coordinates/pixels on your screen

- Transforming coordinates to NDC is usually accomplished in a step-by-step fashion where we transform an object's vertices to several coordinate systems before finally transforming them to NDC.

- The advantage of transforming them to several intermediate coordinate systems is that some operations/ calculations are easier in certain coordinate systems.

- There are 5 coordinate systems that are important:
  1. Local Space( Object Space)
  2. World Space
  3. View Space
  4. Clip Space
  5. Screen Space

- These are all the states our vertices will be transformed to in before finally ending up as fragments

- To transform the coordinates from one space to the next coordinate space we'll use several transformation matrices of the which the most important are the model, view and projection matrix

- Our vertex coordinates first start in local space as local coordinates and are then further processed to world coordinates, view coordinates, clip coordinates and eventually end up as screen coordinates

- For **Local Space**, it is the coordinate space that is local to your object i.e. where your object begins in. Imagine we have a cube that was created in a modelling software package. The origin of the cube will probably be at (0,0,0) even though the cue may end in a different location in the final application.

- For **World Space**, these are the coordinates of all the vertices relative to a (game) world. This is the coordinate space where you want your objects transformed to in such a way that they're all scattered around the place. The **Model Matrix** is used to transform from local to world space

- For **View Space**, this is what is usually referred to as the camera of OpenGL (it is sometimes known as the camera space or eye space). THe view space is the result of transforming your world space coordinates to coordinates that are in front of the user's view. The View Space is thus the space seen as the camera's point of view. The **View Matrix** is used to achieve the transformation from the World Space to the View Space

- At the end of each vertex shader run, OpenGL expects the coordinates to be withing a specific range and any coordinates that fall outside that range are clipped. This is where the **Clip Space** gets its name from. The **Projection Matrix** is used to transform from the View Space to the Clip Space. Note that if only a part of a primitive (e.g triangle) OpenGL will reconstruct the triangle as one or more triangles to fit inside the clipping range.

- The viewing box that a Projection Matrix creates is called a frustum and each coordinate that ends ip inside this frustum will end up on the user's screen. The total process to convert coordinates within a specified range to NDC that can easily be mapped to 2D view-space coordinates is called **Projection** since the projection matrix projects the 3D coordinates to the 2D NDC coordinates

- Once all the vertices are converted to Clip Space, a final projection called perspective division is performed where we divide the x, y and z components of the position vectors by the vector's homogenous w component; perspective division is what transforms the 4D clip space coordinates to 3D NDC. This step is performed automatically at the end of the vertex shader step

- After this stage, the resulting coordinates are mapped to screen coordinates (using the settings of glViewPort) and turned into fragments

- The projection matrix to transform view coordinates to clip coordinates usually takes two different forms: **Orthographic Projection Matrix**  or  **Perspective Projection Matrix**

- **Orthographic Projection Matrix** defines a cube-like frustum box that defines the clipping space where each vertex outside this box is clipped . When creating an Orthographic Projection Matrix, we specify the width, height and length of the visible frustum. All the coordinates inside this frustum will end up withing the NDC range after transformed by its matrix and thus wont' be clipped

- The frustum defines the visible coordinates is specified by a width, a height and a near and far plane. Any coordinate in front of the near plane is clipped and the same applies to the coordinates behind the far plane. The orthographic frustum directly maps all the coordinates inside the frustum to NDC without any special side effects since it won't touch the w component of the transformed vector; if the w component remains equal to 1.0, perspective division won't change the coordinates

- The **Perspective Projection Matrix** is used to create the perspective effect. It maps a given frustum range to clip space but also manipulates the w value of each vertex coordinate in such a way that the further away a vertex coordinate is from the viewer, the higher the w component becomes

- Once the coordinates are transformed to clip space they are in the range -w to w (anything outside this range is clipped). OpenGL requires that the visible coordinates fall between range -1.0 to 1.0 as the final vertex shader output, thus once the coordinates are in clip space, perspective division is applied to the clip space coordinates. Each component of the vertex coordinate is divided by its w component  ( (x/w), (y/w), (z/w) ) giving smaller vertex coordinates the further away a vertex is from the viewer.

- This is another reason why the w component is important, since it helps us with perspective projection. The resulting coordinates are then in normalized device.

- The final calculation to get the clip space coordinates becomes: V_clip = M_projection . M_view . M_model . V_local

- The resulting vertex V_clip is then stored in gl_Position in the vertex shader and OpenGL will then automatically perform perspective division and clipping

- Recall that the the output of the vertex shader requires the coordinates to be in clip space which is what was done with the transformation matrices above. OpenGL then performs perspective division on the clip-space coordinates to transform them to NDC.

- OpenGL then uses the parameters from glViewPort to map the NDC to screen coordinates where each coordinate corresponds to a point on your screen. This process is called **Viewport Transform**

- OpenGL is a Right-Handed System

- OpenGL stores all its depth information in a z-buffer also known as a depth buffer. GLFW automatically creates such a buffer for you (just like it has a color-buffer that stores the colors of the output image)

- The depth is stored within each fragment (as the fragment's z value) and whenever the fragment wants to output its color, OpenGL compares its depth values with the z-buffer. If the current fragment is behind the other fragment, it is discarded, otherwise it is overwritten. This process is called **Depth Testing** and is done automatically by OpenGL

#### *Camera*

- When Camera/View Space is talked about, it means we're talking about all the vertex coordinates as seen from the camera's perspective as the origin of the scene. The View Matrix transforms all the world coordinates into the view coordinates that are relative to the camera's position and direction.

- To define a camera, we need its position in world space, the direction it's looking at, a vector pointing to the right and a vector pointing upwards from the camera.

- In effect, a coordinate system is being created with 3 perpendicular axes with the camera's position as the origin

- With matrices, if you define a coordinate space using 3 perpendicular axes, you can create a matrix with those 3 axes plus a translation vector and then you can transform any vector to that coordinate space by multiplying it with this matrix. That is exactly what the  **LookAt** matrix does

- Euler angles are 3 values that can represent any rotation in 3D

- They are:
  1. Pitch: This is the angle that depicts how much we're looking up or down
  2. Yaw: This represents the magnitude we are looking to the left or right
  3. Roll: This represents how much the body is rolling around a fixed axis

### Lighting

#### *Colors*

- The color of an object we see in real life is not the color it actually has but the color reflected from the object. The colors that aren't absorbed by the object is the color we perceive of it

- The same rules of color reflection apply in graphics land. When we define a light source in OpenGL, we want to give this light source a color.

- Assuming the light source has white color, if we then multiply the light source's color value with an object's color value, the resulting color would be the reflected color of the object (and thus it's perceived color)

#### *Basic Lighting*

- Lighting in OpenGl is based on approximations of reality using simplified models that are much easier to process and look relatively similar.

- These lighting models are based ont the physics of light as we understand it and one of such models is called the **Phong Lighting Model**.

- It consists of 3 components:
  1. **Ambient Lighting**: The ambient light is used to give the object some color. The idea behind this is that even when it is dark there is still some light somewhere is the universe that will land on the object in question.

  2. **Diffuse Lighting**: This simulates the directional impact that a light object has on an object. It is the most visually significant component of the lighting model. The more a part of an object faces the light source, the brighter it becomes

  3. **Specular Lighting**: This simulates the bright spot of a light that appears on shiny objects. Specular highlights are more inclined to the color of light than to the color of the object

#### *Materials*

- In the real world, different objects have a different reaction to light, as such more granular definitions must be created to account for the different components of the Phong Lighting Model being used.

#### *Lighting maps*

- Real-life objects are usually composed of multiple materials.

- To this end, rather than specifying a single color for all three components(ambient, diffuse and specular), a **diffuse maps** and **specular maps** are used to make the simulation more realistic

- These maps allow us to influence the diffuse and specular components with way more precision

- With **diffuse maps**, what we want is for some way to set the diffuse colors of an object for each individual fragment. A system that can retrieve a color value based on the fragment's position on the object.

- In effect diffuse maps are just textures. The underlying principle is the same. We are using an image wrapped around an object that we can index for unique color values per fragment. In lit scenes, we refere to them as a diffuse map since a texture image represents all of the object's diffuse colors

- Specular maps add another layer of realism to the object. Assuming we had a diffuse map (read texture) that contained "wood" and "steel". The diffuse map would lead to the the entire surface looking like light it being reflected off of it which would not be realistic. Adding a specular map would then lead to just the metallic part looking like light was being reflected off of it.

#### *Light casters*

- A light source that casts lights upon objects is called a light caster. Three types of light casters are:
  1. Directional Light
  2. Point Light
  3. Spot Light

- **Directional Light** is when the light source is modelled to be infinitely far away since all it's light rays have the same direction; the light rays can be thought of to be independent of the location of the light source.

- The sun is a great example of a directional light source.

- For light sources that are modelled as Directional Light, it does not matter how each object relates to the light source's position since the light direction remains the same for each object in the scene. Because the light's direction vector stays the same, the lighting calculations will be similar for each object in the scene

- In traditional lighting calculations, the light direction is defined from the fragment to the light source however, most people prefer to define the global light direction from the light source to the fragment. Therefore, a negation may be in order when dealing the light source vectors depending on their definition

- Some people prefer to define the light's position and direction vectors as vec4's instead of vec3's. When we define position vectors as a vec4 it is important to set the w component to 1.0 so that the translations and projections are properly applied. However, when defining a direction vector as a vec4, we don't want translations to have an effect so then we define the w component as 0.0

- A **Point Light** is a light source with a given position somewhere in a world that illuminates in all directions, where the light rays fade out over distance. Examples are light bulbs and torches.

- **Attenuation** is the act of reducing the intensity of light over the distance that it travels. One way to achieve this is to simply use a linear equation. Such an equation would linearly reduce the light intensity over the a distance this making sure that objects at a distance are less bright. While this works, it tends to look fake. In the real world, a quadratic equation is used that more closely mimics how light actually attenuates.

- The equation has multiple terms each of with it's own constant that is set to certain number based on a number of factors including the distance of the light source from the object

- A **Spot Light** is a light source that is located somewhere in the environment that, instead of shooting light rays in all directions, only shoots them in a specific direction. The result is that only the objects withing a certain radius of the spotlight's direction are lit and everything else is dark.

- In OpenGL, a spotlight is represented by a world-space position, a direction and a cutoff angle that specifies the radius of the spotlight. For each fragment, we calculate if the fragment is between the spotlight's cutoff directions (and thus in its cone) and if so, we lit the fragment accordingly.

- In practice, to  check if the fragment is withing the spotlight, the dot product between the direction vector of the from the fragment to the light and the direction of the light emanating from a spotlight and compare the result to the cutoff angle

- A flashlight is a special type of spotlight that is at the viewer's position and usually aimed straight ahead from the player's perspective. A flashlight is basically a normal spotlight but with it's position and direction continually updated based on the player's position and orientation

- To create the effect of a smoothly-edged spotlight we would want to simulate a spotlight having an inner and an outer cone. The idea would be to create an outer cone that gradually dims the light from the inner cone to the edges of the outer cone.

#### *Multiple lights*

- When using more than one light source, we encapsulate the lighting calculations into GLSL functions. The reason is because the code can quickly get complicated when lighting computations are done with multiple lighting types, where each requires different computations

- Functions in GLSL are just like C functions. We have a function name, a return type and we need to declare a prototype at the top of the code file if the function hasn't been declared yet before the main function.

- Each light type will have it's own set of functions.

- When using multiple light sources in a scene, the approach is as follows:
  1. There is a single color vector that represents the fragment's output color.
  2. For each light, the light's contribution to the fragment is added to this output color vector. In effect, each light will calculate its individual impact and contribute that to the final output color vector

### Model Loading

#### *Assimp*

- For simple objects, we can define vertices in order to create the object but for more complicated objects, this would be too cubersome. Instead, 3-D modelling software like Blender & 3DS Max are used to create models of the items we want to use. These are called **models**

- While these modelling programs obfuscate the low-level details of the models so that the designers can focus on designing , those details are important to us the programmers.

- These models are exported in various file formats which contain details about the model. Two of these formats are **Wavefront.obj** (not as extensive) and **Collada** (very extensive)

- **Assimp** (Open Asset Import Library) is a very popular model importing library. It can import dozens of different model file formats (and export some as well) by loading all the model's data into Assimp's generalized data structures

- Because the data structure of Assimp stays the same regardless of the type of file format imported, it abstracts us from all the different file formats out there.

- When importing a model via Assimp, it load's the entire model into a scene object that contains all the data of the imported model/scene. Assimp then has a collection of nodes where each node contains indices to data stored in the scene object. Each node can have any number of children

- A simplified Assimp model:

    1. All the data of the scene/model is contained in the Scene object including all the materials and meshes. It contains a reference to the root node of the scene
    2. The root node of the scene may contain children nodes (like all other nodes) and could have a set of indices that point to mesh data in the scene object's mMeshes array. The scene's mMeshes array contains the actual Mesh object, the values in the mMeshes array of a node are only indices for the scene's meshes array
    3. A mesh object contains all the relevant  data required for rendering, think of vertex positions, normal vectors, texture coordinates, faces and the material of the object
    4. A mesh contains several faces. A face represents a render primitive of the object(triangles, squares, points etc.). A face contains the indices of the vertices that form a primitive. Because the vertices and the indices are separated, this makes it easy for us to render via an index buffer
    5. Finally, a mesh also links to a Material object that hosts several functions to retrieve the  material properties of an object. Think of colors and/or texture maps

- The process of loading the model is as follows:
    1. Load an object into a Scene object
    2. Recursively retrieve the corresponding Mesh objects from each of the nodes( we recursively search each node's children)
    3. Process each Mesh object to retrieve the vertex data, indices and material properties
    4. The result is then a collection of mesh data that we want to contain in a single Model object

- A model usually consists of several meshes

#### *Mesh*

- With Assimp, we can load many different models into the application but once loaded, they are all stored in Assimp's data structures. What we eventually want is to transform that data to a format that OpenGl understands so that we can render the objects.

- Recall that a mesh represents a single drawable entity

#### *Model*

- Code Implementation section

- Helpful video for using our own models created in Blender: <https://www.youtube.com/watch?v=4DQquG_o-Ac>

### Advanced OpenGL

#### *Depth Testing*

- Depth Buffers have been used to prevent triangles rendering in the front when they are supposed to be behind other triangles

- The depth buffer is a buffer that, just like the color buffer (recall the color buffer stores all the fragment colors which become the visual output), stores information per fragment and has the same width and heights as the color buffer. The depth buffer is automatically created by the windowing system and stores its depth values as 16, 24 or 32 bit floats. Most systems have a depth buffer with a precision of 24 bits

- When depth testing is enabled, OpenGL tests the depth value of a fragment against the content of the depth buffer. OpenGL then performs a depth test and is the test passes, the fragment is rendered and the depth buffer is updated with the new depth value. If the depth test fails, the fragment is discarded

- Depth testing is done in screen space after the fragment shader has run (and after the stencil test)

- The screen space coordinates relate directly to the viewport defined by OpenGL's glViewPort function and can be accessed via GLSL's built-in gl_FragCoord variable in the fragment shader.

- The x and y components of the gl_FragCoord variable represent eh fragment's screen-space coordinates(with (0,0) being the bottom-left corner)

- The gl_FragCoord variable also contains a z-component which contains the depth value of the fragment. This z-value is the value that is compared to the depth buffer's content

- Most GPU's support a hardware feature called early depth testing. Earl depth testing allows the depth test to run before the fragment shader runs. Whenever it is clear a fragment isn't going to be visible(it is behind other objects) we can prematurely discard the fragment

- Fragment shaders are usually quite expensive so wherever we can avoid running them we should. A restriction on the fragment shader for early depth testing is that you shouldn't write to the fragment's depth value. If a fragment shader would write to its depth value, early depth testing is impossible; OpenGL won't be able to figure out the depth value beforehand.

- Depth testing is disabled by default

- Once enabled, OpenGL automatically stores fragments z-values in the depth buffer if they passed the depth test and discards fragments if they failed the depth test accordingly

- If depth testing is enabled,The depth buffer should also be cleared before each frame

- There are certain scenarios where you want to perform the depth test on all fragments and discard them accordingly, but not update the depth buffer. Basically, you're temporarily using a read-only depth buffer

- OpenGL allows us to modify the comparison operators it uses for the depth test

- The depth buffer contains depth values between 0.0 and 1.0 and it compares its content with the z-values of all the objects in the scene as seen from the viewer. These z-values in the view space can be any value between the projection-frustum's near and far plane.

- We thus need some way to transform these view-space z-values to the range of [0,1] and one way is to linearly transform them

- The following linear linear equation transforms them: (z - near)/(far - near), where "near" and "far" are the near and far values we provided to the projection matrix

- In practice, linear depth buffers are never used

- Because of the projection properties, a non-linear depth equation is used that is proportional to 1/z. The result is the we get enormous precision when z is small and much less precision when z is far away

- Since the non-linear function is proportional to 1/z, z-values between 1.0 and 2.0 would result in depth values between 1.0 and 0.5 which is half of the [0,1] range, giving us enormous precision at small z-values.

- Z-values between 50.0 and 100.0 would account for only 2% of the [0,1] range.

- The resultant equation: ((1/z) - (1/near))/((1/far) - (1/near))

- Z-fighting is a common visual artifact that may occur when two planes or triangles are so closely aligned ro each other that the depth buffer does not have enough precision to figure out which one of the two shapes is in front of the other
- The result is that the two shapes continually seem to switch order which causes weird glitchy patterns

- Tricks to prevent z-fighting:
    1. Never place objects too close to each other in a way that some of their triangles closely overlap. By creating a small offset between two objects you can completely remove z-fighting between the two objects.

    2. Set the near plane as far as possible. Recall that precision increases as the distance between the object and the near plane reduces, thus if we move the near plane farther away we get better precision on farther objects. Car emust be taken not to move it far back lest clipping of near-objects occur

    3. Another trick at the cost of performance is to use a higher precision depth buffer. The standard precision is 24 bits but it can be moved up to 32 bits to gain even more precision when depth testing

#### *Stencil Testing*

- Once the fragment shader has processed the fragment, a stencil test is executed that also has the option to discard fragments

- After that the remaining fragments are passed to the depth test where OpenGL could possibly discard even more fragments.

- The stencil test is based on the stencil buffer that we are allowed to update during rendering to achieve interesting effects

- A stencil buffer contains 8 bits per stencil-value that amounts to a total of 256 different stencil values per pixel. We can set these stencil values to values of our liking and we can discard or keep fragments whenever a particular fragment has a certain stencil value.

- Each windowing library needs to set up a stencil buffer for you. GLFW does this automatically so we don't have to tell it to create one, but other windowing libraries ,ay not create a stencil buffer by default so be sure to check the docs

- Stencil buffer operations allow us to set the stencil buffer at specific values wherever we're rendering fragments. By changing the content of the stencil buffer while we're rendering, we're writing to the stencil buffer.

- In the same (or following) frame(s) we can read these values    to discard or pass certain fragments.

- The general outline for using stencil buffers:
    1. Enable writing to the stencil buffer
    2. Render objects, updating the content of the stencil buffer
    3. Disable writing to the stencil buffer
    4. Render other objects, this time discarding certain fragments based on the contents of the stencil buffer

- By using the stencil buffer, we can thus discard certain fragments based on the fragments of other drawn objects in the scene

- Object outlining can be implemented with stencil testing alone

- Object outlining is the process by which, for each object in question, we create a small colored border around the objects(s)

- The process is:
    1. Enable stencil writing
    2. Set the stencil op to GL_ALWAYS before drawing the (to be outlined) objects, updating the stencil buffer with 1s wherever the object's fragments are rendered
    3. Render the objects
    4. Disable stencil writing and depth testing
    5. Scale each of the objects by a small amount
    6. Use a different fragment shader that outputs a single (border) color
    7. Draw the objects again, but only if their fragments' stencil values are not equal to 1
    8. Enable depth testing again and restore the stencil function to GL_KEEP

- This process sets the content of the stencil buffer to 1s for each of the object's fragments and when it's time to draw the borders, we draw scaled-up version of the objects only where the stencil test passes

- We'r effectively discarding all the fragments of the scaled-up version that are part of the original object's using the stencil buffer

#### *Blending*

- Blending in OpenGl is commonly known as the technique to implement transparency within objects

- Transparency is all about objects (or parts of them) not having a solid color but having a combination fo colors from the object itself and any other object behind it with varying intensity

- For example, a colored glass window is a transparent object; the glass has a color of its own,, but the resulting color contains the colors of all the objects behind the glass as well.

- This is where the name blending comes from, since we blend several pixel colors (from different objects) to a single color. Transparency thus allows us to see through the objects

- Transparent objects can be completely or partially transparent

- The amount of transparency of an object is defined by its color's alpha value.

- The alpha color value is the 4th component of the color vector

- An alpha value of 1.0 means an object is completely opaque while an alpha value of 0.0 means an object is completely transparent

- Some textures have an embedded alpha channel that contains an alpha value per texel. This alpha value tells us exactly which parts of the texture have transparency and by how much.

- Some effects do not care about partial transparency but either want to show something or nothing at all based on the color value of the texture

- This process is known as discarding whereby a comparison can be done to make sure that only fragments above a certain alpha value will be render and everything else will be discarded

- When sampling textures at their borders, OpenGl interpolates the border values with the next repeated value of the texture (because we set its wrapping parameters to GL_REPEAT by default)

- This is usually okay but since we're using transparent values, the top of the texture image gets its transparent value interpolated with the bottom border's solid color value. The result is a slightly semi-transparent colored border you may see wrapped around your textured quad. To prevent this,set the texture wrapping method to GL_CLAMP_TO_EDGE alpha textures are used that don;t need to be repeated

- Discarding fragments prevents us from being able to render semi-transparent images; we either render the fragment or completely discard it

- To render images with different levels of transparency wee have to enable blending

- Blending in OpenGL happens with the following equation: C_result = (C_source * F_source) + (C_destination * F_destination) where C and F stand for the color vector and factor scalar

- After the fragment shader has run and all the tests have passed, this blend equation is let loose on the fragment's color output and with whatever is currently in the color buffer

- The source and destination colors will automatically be set by OpenGL but the source and destination factor can be set to a value of our choosing

- When rendering multiple semi-transparent objects, the transparent parts of the objects in front may occlude the objects in the back

- The reason for this is that depth testing works a bit tricky when combined with blending. When writing to the depth buffer, the depth test does not care if the fragment has transparency or not, so the transparent parts are written to the depth buffer as any other value

- The result is that the background windows are tested on depth as any other opaque object would be, ignoring transparency. Even though the transparent parts should show the windows behind it, the depth test discards them

- The result is that we simply can't render the windows however we want and expect the depth buffer to solve all our issues for us

- To make sure the objects in the back of the scene show, we have to draw them first. This means we have to manually sort the windows from furthest to nearest and draw them accordingly ourselves

- Recall that with fully transparent objects, we have the option to discard the transparent fragments instead of blending them, saving us a few of these headaches

- To make blending work, as stated above, we have to draw the most distant objects first and the closest object last. The normal non-blended objects can still be drawn as normal using the depth buffer so they don't have to be sorted. We do have to make sure they are drawn first before drawing the sorted transparent objects.

- The general idea when you have both opaque and semi-transparent objects is to the draw the opaque objects first, sort the transparent objects and then the draw all the transparent objects in the sorted order

- One way of sorting the transparent objects is to retrieve the distance of an object from the viewer's perspective. The can be achieved by taking the distance between the camera's position vector and the object's position vector. We the store this distance together with the corresponding position vector in a map data structure from the STL library. A map automatically sorts its values based in its keys so once we've added all positions with their distance as the key, they're automatically sorted on their distance value.

- This sorting technique doesn't take into account rotations, scaling or any other transformations and also weirdly shaped objects need a different metric than simply a position vector

#### *Face culling*

- You can view a cube from any position and/or direction but you would never be able see more than 3 faces. It may be beneficial to not draw the 3 other faces of the cube if we can't see them.

- If we could discard the other 3 faces in some way, we would save more than 50% of this cube's total fragment shader runs. It could be >50% because from certain angles only 1 or 2 faces could be visible

- The problem becomes how do we know if a face of an object is visible from the viewer's point of view i.e. show the user only the side's that they can see

- The process of solving this issue in OpenGL is called face culling and it does this by doing a check for all the faces that are front facing towards the viewer and renders those while discarding all the faces that are back facing, thus saving fragment shader calls

- OpenGL has to be told which of the faces we use are actually the front faces and which faces are the back faces. It uses a clever trick for this by analyzing the winding order of the vertex data

- When we define a set of triangle vertices we're defining them in a certain winding order that is either clockwise or counter-clockwise. Each triangle consists of the 3 vertices and we specify those 3 vertices in a winding order

- Each set of 3 vertices that form a triangle primitive thus contain a winding order. OpenGL uses this information when rendering primitives to determine if a triangle is a front-facing or a back-facing triangle. By default, triangles defined with counter-clockwise vertices are processed as front-facing triangles

#### *Framebuffers*

- All the buffers we've used so far are stored in the GPU Memory as framebuffers

- OpenGL gives us the flexibility to define our own framebuffer and thus define our own color, depth and stencil buffer

- The rendering operations completed in previous example were done on top of the render buffers attached to the default framebuffer.

- The default framebuffer is created and configured when you create your window. By creating another framebuffer, we get an additional target to render to

- Rendering the scene to a different framebuffer allows us to use that result to create mirrors in a scene or achieve cool post-processing effects\

- A framebuffer is not complete until the following conditions are satisfied:
    1. We have to attach at least one buffer
    2. There should be at least one color attachment
    3. All attachments should be complete i.e. have reserved memory
    4. Each buffer should have the same number of samples

- Textures can be attached to framebuffers

- It is possible to render a scene into a color texture attached to a framebuffer object we created and then draw this texture over a simple quad that spans the whole screen

- If a depth or stencil buffer are omitted, then the corresponding testing for the buffer will not be completed

- The process to draw a scene to a single texture is as follows:
    1. Render the scene as usual with the new framebuffer bound as the active framebuffer
    2. Bind to the default framebuffer
    3. Draw quad that spans the entire screen with the new framebuffer's color buffer as its texture

- Another advantage of the doing post-processing on a single texture image is that we can sample color values from other parts of the texture not specific to that fragment

- It is possible to take a small area around the current texture coordinate and sample multiple texture values around the current texture value. We can then create interesting effects by combining them in creative ways

- A kernel or convolution matrix is small matrix-like array of values centered on the current pixel that multiplies surrounding pixel values by its kernel values and adds them all together to form a single value

- In effect, we ae adding a small offset to the texture coordinates in surrounding directions of the current pixel and then combine the results based on the kernel

- The individual values within the pixels are called weights and most weights in kernels all add up to one meaning that the resulting texture color ends up brighter or darker than the original texture value.

- Most kernels are either 3x3 or 5x5

#### *Cubemaps*

- A cubemap is a combination of multiple textures mapped into one

- A cubemap is a texture that contains 6 individual 2D textures that each form one side of a cube

- The benefit of using cubemaps is that they can be indexed/sampled using a direction vector residing at its center. The magnitude of the direction vector does not matter. As long as a direction is supplied, OpenGL retrieves the corresponding texels that the direction hits (eventually) and returns the properly sampled texture value

- If we imagine we have a cube shape that we attach such a cubemap to, this directions vector would be similar to the interpolated local vertex position of the cube. THis way we can sample the cubemap using the cube's actual position vectors as long as the cube is centered on the origin. We thus consider all vertex positions of the cube to be its texture coordinates when sampling a cubemap. The result is a texture coordinate that accesses the proper individual face texture of the cubemap

- A skybox is one interesting technique that is easy to implement with a cubemap. It is a large cube that encompasses the entire screen and contains 6 images of a surrounding environment, giving the player the illusion that the environment he's in is actually much larger that it actually is

- An optimization that could be performed during the code implementation of a skybox render is to render that skybox last

- If we render the skybox first we're running the fragment shader for each pixel on the screen even though a small part of the skybox will eventually be visible; fragments that could have easily been discarded using early depth testing which the saves valuable computing bandwidth

- To give a slight performance boost, the skybox should be rendered last. This way, the depth buffer is completely filles with all the scene's depth values so we only have to render the skybox's fragments wherever the early depth test passes which vastly reduces the number of fragment shader calls

- The problem then becomes that the skybox would then render on top of all other objects since its only a 1X1X1 cube which would allow it to pass most depth tests.

- Simply rendering it without depth testing is not a solution since the skybox will then still overwrite all the other objects in the scene as its rendered last. There needs to be a way to trick the depth buffer into believing that the skybox has the maximum depth value of 1.0 so that it fails the depth test wherever there's a different object in front of it

- Recall that perspective division is performed after the vertex shader has run, dividing the gl_Position's xyz coordinates by its w component. The z component of the resulting division is equal to the vertex's depth value

- The trick then becomes the set the z component of the output position equal to its w component which will result in a z component that is always equal to 1.0 because of the perspective division stated above

- The last change is the depth function whereby it should now be GL_LEQUAL (less than or equal) vs GL_LESS (less than). This is because the depth box will be filled with values of 1.0 so we need to make sure the depth test passes with values less than or equal to the depth buffer instead of just less than

- Using a cubemap with an environment, we could give objects reflective or refractive properties. Techniques that use an environment cubemap like this are called environment mapping techniques with reflection and refraction being the most popular operations

#### *Advanced Data*

- A buffer in OpenGL is, at its core, an object that manages a certain piece of GPU memory and nothing more. We give meaning to a buffer by binding it to a specific buffer target. A buffer is only a vertex array buffer when we bind it to GL_ARRAY_BUFFER but we could just as easily bind it to GL_ELEMENT_ARRAY_BUFFER. OpenGL internally stores a reference to the buffer per target and based on the target, processes the buffer differently

- So far we've been filling the buffers memory by calling glBufferData, which allocates a piece of the GPU memory and adds data to into this memory. If we were to pass NULL as its data argument, the function would only allocate memory and not fill it. This is useful if we want to reserve a specific amount of memory and later com back to this buffer

- Instead of filling the entire buffer with one function call we can also fill specific regions of the buffer by calling glBufferSubData. This function expects a buffer target, an offset, the size of the data and the actual data as its arguments. What's new with this function is that we can now give an offset that specifies from where we want to fill the buffer. This allows us to insert/update only certain parts of the buffers memory. Do note that the buffer should have enough allocated memory so a call to glBufferData is necessary before calling glBufferSubData

- Another method for getting data into a buffer is to ask for a pointer to the buffer's memory and directly copy the data in memory yourself. By calling glMapBuffer, OpenGL returns a pointer to the currently bound buffer's memory for us to operate on.

- We tell OpenGL we are finished with the pointer operations via glUnmapBuffer, by unmapping, the pointer becomes invalid and function returns GL_TRUE is OpenGL was able to map your data successfully to the buffer

- Using glMapBuffer is useful for directly mapping data to a buffer without first storing it in temporary memory. Think of directly reading data from file and copying it into the buffer;s memory

- Using glVertexAttribPointer we were able to specify the attribute layout of the vertex array buffer's content. Within the vertex array buffer we interleaved the attributes, we placed the position, normal and/or texture coordinates next to each other in memory for each vertex

- Another approach would be to batch all the vector data into large chunks per attribute type instead of interleaving them. Instead of an interleaved 123123123123 we take a batched approach of 111122223333

- When loading vertex data from file, you generally retrieve an array of positions, an array of normals and/or an array of texture coordinates. It may cost some effort to combine these arrays into one large array of interleaved data. Taking the batching approach is then an easier solution that can be easily implemented in glBufferSubData

- This is yet another approach of setting and specifying vertex attributes. Using either approach is feasible, it is mostly a more organized way to set vertex attributes. However, the interleaved approach is still the recommended approach as the vertex attributes for each vertex shader run are the closely aligned in memory

- Once you have filled your buffers with data, you may want ot share that data with other buffer or perhaps copy the buffer's contents into another buffer.

- The function glCopyBufferSubData allows us to copy data from one buffer to another buffer with relative ease

- The function prototype: void glCopyBufferSubData(GLenum readtarget, GLenum writetarget, GLintptr readoffset, GLintptr writeoffset, GLsizeiptr size);

- The readtarget and writetarget parameters expect to give the buffer targets that we want to copy from and to. We could for example vopy from a VERTEX_ARRAY_BUFFER to a VERTEX_ARRAY_ELEMENT_BUFFER buffer by specifying those buffer targets as the read and write targets respectively. The buffers currently bound to those targets would then be affected

- But what if we wanted to read and write data into two different buffers that are both vertex array buffers? We can't bind two buffers at the same time to the same buffer target. For this reason, and this reason alone, OpenGL gives us two more buffer targets called GL_COPY_READ_BUFFER and GL_COPY_WRITE_BUFFER. We then bind the buffers of our choice to these new buffer targets and set those targets as the readtarget and writetarget argument

#### *Advanced GLSL*

- Shaders are extremely pipelined, if we need data from any other source outside of the current shader we'll have to pass data around. We learned to do this via vertex attributes, uniforms and samplers

- There are a few extra varibles defined by GLSL prefixed wiht the "gl_" that gives us an extra means to gather and/or write data. Two examples that have been used are gl_Position which is the output vector of the vertex shader and the fragment shader's gl_FragCoord

- Recall that gl_Position is the clip-space output position vector of the vertex shader. Setting gl_Position in the vertex shader is a strict requirement if you want to render anything to the screen

- One of the render primitives that we are able to choose from is the GL_POINTS in which case each single vertex is primitive and rendered as a point. It is possible to set the size of the points being rendered via OpenGL's glPointSize function but we can also influence this value in the vertex shader

- One output variable defined by GLSL is called gl_PointSize that is a float variable where you can set the point's width and height in pixels. By setting the point's size in the vertex shader we get per-vertex control over this point's dimensions

- Influencing the point size in the vertex shader is disabled by default but if you want to enable this you'll have to enable OpenGL's GL_PROGRAM_POINT_SIZE

- Varying the point size per vertex is interesting for techniques like particle generation

- Te gl_Position and gl_PointSize are output variables since their value is read as output from the vertex shader; we can influence the result by writing to them. The vertex shader also gives us an interesting input variable that we can only read from called gl_VertexID

- The integer variable gl_VertexID holds the current ID of the vertex we're drawing. When doing indexed redering (with glDrawElements) this variable holds the current index of the vertex we're drawing. When drawing without indices (via glDrawArrays) this variable holds the number of currently processed vertex since the start of the render call

- Recall from depth testing gl_FragCoord that the z component of the gl_FragCoord vector is equal to the depth value of that particular fragment. However, the x and y components can also be used for interesting effects

- The gl_FragCoord's x and y component are the window  or screen space coordinates of the fragment, originating from the bottom-left of the window. Assuming a render window of 800x600 with glViewport, the screen space coordinates of the fragment will x values between 0 and 800 and y values between 0 and 600

- Using the fragment shader, we could calculate a different color value based on the screen coordinates of the fragment. A common usage for the gl_FragCoord variable is comparing visual output of different fragment calculations as ususally seen in tech demos. We could for example split the screen in two by rendering one output to the left side of the window and another output to the right side of the window

- Recall from the face culling chapter that OpenGL is able to figure out if a face is front or back facing due to the winding order of the vertices. The gl_FrontFacing variable tells us if the current fragment is part of a front-facing or a back-facing face. We could for example decide to output different colors for all back faces

- The gl_FrontFacing variable is a bool that is true if the fragment is part of a front face and false otherwise. For example we could create a cube that has different texture on the inside than on the

- The input variable gl_FragCoord is an input variable that allows us to read screen-space coordinates and get the depth value of the current fragment but it is a read-only variable. We can't influence the screen-space coordinates of the fragment but it is possible to set the depth value of the fragment. GLSL gives us an output variable called gl_FragDepth that we can use to manually set the depth value of the fragment within the shader

- Setting the depth value manually has a major disadvantage however. That is because OpenGL disables early depth testing as son  as we write to gl_FragDepth in the fragment shader.

- It is disabled because OpenGL cannot know what depth value the fragment will have before we run the fragment shader since the fragment shader may actually change this value

- By writing to gl_FragDepth this performance should be taken into consideration.

- From OpenGL 4.2 however, we can still sort of mediate between both sides by redeclaring the gl_FragDepth variable at the top of the fragment shader with a depth condition.

- The four conditions are any (defualt value. early depth testing is disabled), greater(you can only make the depth value larger compared to gl_FragCoord.z), less (you can only make the depth value smaller compared to gl_FragCoord.z) and unchanged (if you write to gl_FragDepth, you will write exactly gl_FragCoord.z)

- By specifying greater or less as the depth condition, OpenGL can make the assumption that you'll only write depth values larger or smaller than the fragment's depth value.

- This way OpenGL is still able to do early depth testing when the depth buffer value is part of the other direction of the gl_FragCoord.z

- The standard way to send data from the vertex to the fragmentr shader is to declare several matching input/output variables. Declaring these one at a time is the easiest way to send data from one shader to another but as applications become larger you probably want to send more than a few variables over

- This can be done with interface blocks that allows us to group variables together. The declaration of such an interafce block looks a lot like a struct declaration execept that it is now declared using an in or out keyword based on the block being an input or an output block

- These interface blocks helps organize your shader's inputs/outputs. It is also useful when we want to group shader input/output into arrays

- Assuming an output interface block has been declared in the vertex shader, we also need to declare an input interface block in the next shader (fragment shader). The block name should be same but the instance name can be anything

- An example of an interface block used in a fragment shader would be:

  ``` cpp
  in VS_OUT
  {
      vec2 TexCoords;
  } fs_in;
  ```

  "VS_OUT" is the block name which must be the same in whichever shader it is declared in and "fs_in" is the instance name which can change between shaders to enhance the readability of the code

- Recall that when using more than one shader we continuously have to set uniform variables where most of them are exactly the same for each shader

- Uniform buffer objects allow is to declare a set of global uniform variables that remain the same over any number of shader programs. When using uniform buffer objects we set the relevant uniforms once in fixed GPU memory. We do still have to manually set the uniforms that are unique per shader

- Creating and configuring a uniform buffer object requires because a uniform buffer object is buffer like any other buffer we can create one via glGenBuffers, bind it to the GL_UNIFORM_BUFFER buffer target and store all the relevant uniform data into the buffer

- The content of a uniform block is stored in a buffer object which is effectively nothing more than a reserved piece of global GPU memory. Because this piece of memory holds no information on what kind of data it holds, we need to tell OpenGL what parts of the memory correspond to which uniform variables in the shader

- By default GLSL uses a uniform memory layout called a shared layout- shared because once the offsets are defined by the hardware, they are consistently shared between multiple programs. With a shared layout GLSL is allowed to reposition the uniform variables for optimization as long as the variables order remains intact

- Because we dont know at what offset each uniform variable will be we don't know how to precisely fill our uniform buffer. One option would be to query this information with functions like glGetUniformIndices

- While a shared layout gives us some space saving optimizations, we'd neeed to query the offset for each uniform variable which translates to a lot of work

- The general practice is to use a std140 layout instead of a shared layout

The std140 explicitly states the memory layout for each variable and for each variable we calculate its aligned offset: the byte offset of a variable from the start of the block

- The aligned byte offset of a variable must be equal to a multiple of its base alignment

- With the calculated offset values and the rules of the std140 layout, we can fill the buffer with data at the appropriate offsets suing functions like glBufferSubData

- While not the most efficient, the std140 layout does gaurantee us that the memory layout remains the same over each program that declared this uniform block

- To uniform buffer, we first need to create a uniform buffer object which is done via glGenBuffers. Once we have a buffer object we bind it to the GL_UNIFROM_BUFFER target and allocate enough memory by calling glBUfferData

- Whenever we want to update or insert data into the buffer, we bind to the uboExampleBlock and use glBufferSubData to update it's memory

- We only have to update this unifrom buffer once and all shaders that use this buffer now use its updated data

- The question becomes how does OpenGL know what uniform buffers correspond to which uniform blocks?

- In OpenGL context there are a number of binding points defined where we can link a unifrom buffer to. Once we have created a unifrom buffer, we link it to one of those binding points and we also like the uniform block in the shader to the same binding point effectively linkng them together

- We can bind multiple uniform buffers to different binding points. Because shader A and shader B both have a uniform block linked to the same binding point 0, their uniform blocks share the same uniform data found in uboMatrices; a requirement being that both shaders defined the same Matrices uniform block

- To set a shader uniform block to a specific binding point we call glUniformBlockBinding that takes a program object, a uniform block index and the binding point to link to

- The uniform block index is a location index of the defined uniform block in the shader. This can be retrieved via a call to glGetUniformBlockIndex that accepts a program object and the name of the uniform block

- Uniform buffer objects have several advantages over single uniforms.
    1. Setting a lot of uniforms at once is faster than setting multiple uniforms one at a time
    2. If you want to change the same uniform over several shaders, it is much easier to change a uniform once in a uniform buffer
    3. We can use a lot more uniforms in shaders using uniform buffer objects

#### *Geometry Shader*

- Between the vertex and the fragment shader, there is an optional shader stage called geometry shader.

- A geometry shader takes as input a set of vertices that form a single primitive e.g. a point or a triangle and then it can transform these vertices as it sees fit before sending thme to the next shader stage

- It is able to convert the original primitive (set of vertices) to completely different primitives, possibly generating more vertices that were initially given

- At the start of a geometry shader we need to declare the type of primitive input we're receiving from the vertex shader

- Most render primitives contain more than one 1 vertex. The geometry shader recieves all vertices of a primitive as its input

- We can geometry shaders to dynamically generate new shapes on the fly

- A triangle strip is a more efficient way to draw triangles with fewer vertices. After the first triangle is drawn, each subsequent vertex generates another triangle next to the first triangle: every 3 adjacent vertices will form a triangle. If we have a total of 6 vertices that form a triangle. If we have a total of 6 vertices that form a triangle strip we'd get the following triangles (1,2,3), (2,3,4), (3,4,5), (4,5,6); forming a total of 4 triangles. A triangle strip needs at least N >=3 vertices and will generate N-2 triangles

#### *Instancing*

- Assuming we have a scene where we draw the same model multiple times with different world transformations

- Drawing each of these individually would lead to a performance bottle neck because of the numerous draw calls

- Compared to rendering the actual vertices, telling the GPU to render your vertex data with functions like glDrawArrays or glDrawElelments eats up quite some performance since OpenGL must make necessary preparations before it can draw your vertex data (like telling the GPU which buffer to read data from, where to find vertex attributes and all this over the the relatively slow CPU to GPU bus). So even though rendering the vertices is super fast, giving the GPU the commands to render them isn't

- The solution to this problem is instancing which would allow us to send the data over to the GPU once and then tell OpenGL to draw multiple objects using this data with a single drawing call

- Instancing is technique where we draw many (equal mesh data) objects at once with a single render call saving us all the CPU -> GPU communications each time we need to render an object

- When rendering a lot of instances, a limit will eventually be hit in terms of the number of uniform data that can be sent to the shaders

- An alternative is instanced arrays which are defined as a vertex attribute that are updated per instance instead of per vertex thus allowing us to store much more data

- With vertex attributes, at the start of each run of the vertex shader, the GPU will retrieve the next set of vertex attributes that belong to the current vertex. When defining a vertex attribute as an instanced array however, the vertex shader only updates the content of the vertex attribute per instance. This allows us to use the standard vertex attributes for data per vertex and use the instanced array for storing data that is unique per instance

#### *Anti Aliasing*

- Some renderings may end up having jagged edges. This is because of how the rasterizer transforms the vertex data into actual fragments behind the scene

- The effect of clearly seeing the pixel formations that an edge is composed of is called aliasing. There are quite a few techinques out there called anti-aliasing techniques that fight this aliasing behaviour by producing smoother edges

- There a few techinques that have been invented to address this but one that we will focus on is super sample anti-aliasing (SSAA). It temporarily uses a much higher resolution render buffer to render the scene in (super sampling). Then when the full scene is rendered, the resolution is downsampled back to the normal resolution. This extra resolution was used to prevent these jagged edges.

- While it did provide us with a solution to the aliasing problem, it came with a major performance drawback since we have to draw a lot more fragments than usual. This technique was therefore not used for an extended period

- It did however give birth to a more modern technique call multisample anti-aliasing (MSAA) that borrows from the concepts behind SSAA while implementing a much more efficient approach. It is a technique that is built into OpenGL

- To understand what multisampling is and how it works into solving the aliasing problem, we first need to understand the OpenGL rasterizer

- The rasterizer is the combination of all algorithms and processes that sit between our final processed vertices and the fragment shader

- The rasterizer takes all the vertices belonging to a single primitive and transforms this to a set of fragmnets. Vertex coordinates can theoretically have any coordinate but fragments cant since they are bound by the resolution of the screen

- There will almost never be a one-on-one mapping between vertex coordinates and fragments, so the rasterizer has to determine in some way what fragment/screen-coordinate each specific vertex will end up at

- The way MSAA works under the hood is not by using a single sample point to determine the coverage of a primitive defined by a group of vertices but instead using multiple sample points

- Instead of a single point at the center of each pixel, you place 4 subsamples in a general pattern and use those to determine pixel coverage

- Assuming that 2 subsamples were covered and thus would run the fragment shader, the next step is to determine a color for this specific pixel. Our initial guess would be that we run the fragment shader for each covered subsample and later average the colors of eahc subsample per pixel

- In this case, we would run tje fragment shader twice on the interpolated vertex data at each subsample and store the resulting color in those sample points. This isn't how it works because this would mena we need to run a lot more fragment shaders than without multisampling drastically reducing performance

- How MSAA really works is that the fragment shader is only run once per pixel (for eahc primitive) regardless os how many subsamples are covered (by a triangle). The fragment shader runs with the vertex data interpolated to the center of the pixel. MSAA then uses a larger depth/stencil buffer to determine subsample coverage. the number of subsamples covered determines how much pixel color contributes to the framebuffer

- From the example, since only 2 of the 4 samples were covered, half of the triangle's color is mixed with the framebuffer color

- The result is a higher resolution buffer (with higher resolution depth/stencil) where all the primitive edges now produce a smoother pattern

- Depth and stencil values are stored per subsample and even though we only run the fragment shader once, color values are stored per subsample as well for the case of multiple triangles overlapping a single pixel. For depth testing, the vertex's depth value is interpolated to each subsample before running the depth test. For stencil testing we store the stencil valies per subsample. This does mean that the size of the buffers are now increased by the amount of subsamples per pixel

- If we want to use MSAA in OpenGL we need to use a buffer that is able to store more than one sample value per pixel. We need a type of buffer that can store a given amount of multisamples and this is called a multisample buffer

- Most windowing systems are able to provide us a multisample buffer instead of a default buffer. GLFW also gives this functionality and all we need to do is hint GLFW that we'd like to use a multisample buffer with N samples instead of a normal buffer by calling glfwWindowHint before creating the window

    ```cpp
    glfwWindowHint(GLFW_SAMPLES, 4);
    ```

- When we now call glfwCreateWindow, we create a rendering window, but this time with a buffer containing 4 subsamples per screen coordinate. This also means that the size of the buffer is increased by 4

- Now that we asked GLFW for multisampled buffers we need to enable multisampling by calling glEnable with GL_MULTISAMPLE

- The actual multisampling algos are implemented in the rasterizer in the OpenGL driver of your system so there isn't much else to do

- Because GLFW takes care of creating the multisampled buffers, enabling MSAA is east. If we want to use our own framebuffers however, we have to generate the multisampled buffers ourselves; now we do need to take carte of creating multisampled buffers

- There are two ways we can create multisampled buffers to act as attachments for framebuffers: texture attachments and renderbuffer attachments.

- To create a texture that supports storage of multiple sample points we use glTexImage2DMultisample instead of glTexImage2D that accepts GL_TEXTURE_2D_MULTISAPLE as its texture target

- Like textures, creating a multisampled renderbuffer object isn't difficult. It is even quite easy since all we need to change is glRenderbufferStorage to glRenderbufferStorageMultisample when we configure the (currently bound) renderbuffer's memory storage

- Rendering to a multisampled framebuffer is straightforward. Whenever we draw anything while the framebuffer object is bound, the rasterizer will take care of all the multisample operations. However, because a multisampled buffer is a bit special, we can't directly use the buffer for other operations like sampling it in a shader

- A multisampled image contains much more information than a normal image so what we need ro do is downscale or resolve the image. Reoslving a multisampled framebuffer is generally done through glBitFrameBuffer that copies a region from one framebuffer to the other while also resolving any multisampled buffers

- If we wanted to use the result of a multisampled framebuffer to do stuff like post-processing, we can' directly use the multisampled textures in the fragment shader. What can done is to blit the multisampled buffer to a different FBO with a non-multisampled texture attachment

- We then use this ordinary color attahcment texutre for post-processing, effectively post-processing an image rendered via multisampling.

- This does mean we have to generate a new FBO that acts solely as an intermediate framebuffer object to resolve the multisampled buffer into; a normal 2D texture we can use in the fragment shader

- Combining multisampling with off-screen rendering we need to take care of some extra steps. The steps are worth the extra effort though since multisampling significantly boosts the visual quality of the scene. Do note that enabling multisampling can noticeably reduce performance the more samples you use

### Advanced Lighting

#### Advanced Lighting Subsection

- Recall that Phong lighting is a great and very efficient approximation of lighting, but its specular reflections break down in certain conditions, specifically when the shininess property is low resulting in a large (rough) specular area

- In a case like this, the edges of the specular area are immediately cut off. The reason this happens is because the angle between the view and reflection vector doesn't go over 90 degrees. If the angle is larger than 90 degrees, the resulting dot product becomes negative and this results in a specular exponent of 0.0 assuming it was 1.0 to being with

- We could think won't be a problem since we shouldn't get any light with angles higher than 90 degrees

- That line of thinking only applies to the diffuse component where an angle higher than 90 degrees between the normal and light source means the light source is below the lighted surface and thus the light's diffuse contribution should be equal to 0.0

- However, wiht specular lighting we're not measuring the angle between the light source and the normal, but between the view and reflection vecor

- The issue then becomes apparent because when the angle between the view and reflection vector is larger than 90 degrees, the specular contribution gets nullified

- This generally isn't a problem since the view direction is far from the reflection direction, but if we use a low specular component, the specular radius is large enough to have a contribution under these conditions. Since we're nullifying this contribution at angles larger than 90 degrees, an artifact occurs

- In 1977, the Blinn-Phong shading model was introduced by James F. Blinn as an extension to the Phong shading model that has been previously used

- The Blinn-Phong shading model is largely similar but approaches the specular model slightly differently which results in a solution to the problem highlighted above.

- Instead of relying on a reflection vector we're using a so called halfway vector that is a unit vector exactly halfway between the view direction and the light direction. THe close this halfway vector aligns with the surface's normal vector, the higher the specular contribution

- When the view direction is perfectly aligned with the (now imaginary) reflection vector, the halfway vector aligns perfectly with the normal vector. The closer the view direction is to the original reflection direction, the stronger the specular highlight

- Another subtle difference between the Phong and Blinn-PHong shading is that the angle between the halfway vector and the surface normal is often shorter than the angle between the view and reflection vector

- As a result, to get visuals similat to Phong shading, the specular shininess exponent has to be set a bit higher

- A general rule of thumb is to set it between 2 and 4 times the Phong shininess exponent

#### Gamma Correction

- As soon as we compute the final pixels colors of the scene, we will have to display them on a monitor. In the old days of digital imaging most monitors were CRT monitors

- These monitors had the physical property thatv twice the input voltage did not result in twice the amount of brightness

- Doubling the input voltage resulted in a brightness equal to an exponential relationship of roughly 2,2 known as the gamma of the monitor

- This happens to coincidentally match how human beings measure brightness as brightness is also displayed with a similar inverse power relationship

- Because the human eyes prefer to see brightness colors according to the top scale, monitors (still today) use a power relationship for displaying the output colors so that the original physical brightness colors are mapped to the non-linear brightness colors in the top scale

- This non-linear mapping of monitors does output more pleasing berightness results for our eyes but when it come to rendering graphics there is one issue: all the color and brightness options we configure in out applications are based on what we percieve from the monitor and this all the options are actually non-linear brightness/color options

- If we double a color in linear space, its result is indeed double the value. For instance, take a light's color vector (0.5, 0.0, 0.0) which represent a semi-dark red light. If we would double this light in linear space, it would become (1.0,0.0,0.0). However, the original color gets displayed on the monitor as (0.218, 0.0, 0.0). Here's where the issue starts to rise: once we sdouble the drak-red light in linear space, it actually becomes more than 4.5 times as bright on the monitor

- Previously we have assumd that we working in linear space, but we've actually been working in the monitor's output space so all colors and lighting variables we configured weren't physically correct, but merely looked (sort of) right on our monitor

- For this reason, we (and artists) generally set lighting values way brighter than they should be (since the monitor darkens them) which as a result makes most linear-space calculations incorrect. Note that the monitor and linear graph both start and end at the same position; it is the intermediate values that are darkened by the display

- Because colors are configured based on the display's output, all intermediate lighting calculations in linear space are physically incorrect. This becomes more obvious as more advanced lighting algorithms are in place

- Without properly correcting this monitor gamma, the lighting looks wrong and artists will have a hard time getting realistic and good-looking results. The solution is apply gamma correction

- The idea of gamma correction is to apply the inverse of the monitor's gamma to the final output color before displaying to the monitor

- Basically, we multiply each of the linear output colors by the inverse gamma curve (making them brighter) and as soon as the colors are displayed on the monitor, the monitor's gamma curve is applied and the resulting colors become linear. We effectively brighten the intermediate colors so that as soon as the monitor darkens them, it balances out

- A gamma value of 2.2 is a default gamma value that roughly estimates the average gamma of most displays. The color space as a result of this gamma of 2.2 is called the sRGB color space (not 100% exact but close)

- Each monitor has their own gamma curves, but a gamma value of 2.2 gives good results on most monitors. For this reason games often allow players to change the game's gamma setting as it varties slightly per monitor

- There are two ways to apply gamma correction to your scene:
  1. By using OpenGL's built-in sRGB framebuffer support
  2. By doing the gamma correction ourselves in the fragment shaders

- The first option is probably the easiest but also gives you less control. By enabling GL_FRAMEBUFFER_SRGB you tell OpenGl that each subsequent drawing command should first gamma correct colors (from the sRGB color space) before storing them in color buffers

- The sRGB is a color space that roughly corresponds to a gamma of 2.2 and a standard for most devices

- After enabling GL_FRAMEBUFFER_SRGB, OpenGL automatically performs gamma correction after each fragment shader run to all subsequent framebuffers, including the default framebuffer

- Something to keep in mind with this approach and the other approach is that gamma correction (also) transforms the colors from linear space to non-linear space so it is very important you only do gamma correction at the last and final step

- If you gamma correct your colors before the final output, all subsequent oprations on those colors will operate on incorrect values. For instance, if you use multiple framebuffers you probably want intermediate results passed in between the framebuffers to remain to remain in linear space and only have the last framebuffer apply gamma correction before being sent to the monitor

- The second approach requires a bit more work but also gives complete control over the gamma operations. We apply gamma correction at the end of each relevant fragment shader run so the final colors end up gamma corrected before being sent out to the monitor

- An issue with this approach is that in order to be consistent you have to apply gamma correction to each fragment shader that contributes to the final output. If you have a dozen frgament shaders for multiple objects, you have to add the gamma correction code to each of these shaders. An easier solution would be to introduce a post-processing stage in your render loop and apply gamma correction on the post-processed quad as a final step which you'd only have to do once.

- Moving on the subjec to of sRGB textures, because monitors display colors with gamma applied, whenever you draw, edit or paint a picture on your computer, you are picking colors based on what you see on the monitor

- This effectively means all the pictures you create or edit are not in linear space but in sRGB space e.g  doubling a dark-red color on your screen based on percieve brightness, does not equal double the red component

- As a result, when texture artists create art by eye, all the textures' values are in sRGb space so if we use thise texutres as they are in out rendering application we have to take this into account

- Before we knew about gamma correction this wasn't really an issue because the textures looked good in sRGB space which is the same space we worked in; the textures were displayed exactly as they are which was fine, However, now that we're displaying everything in linear space, the texture colors will lokk off

- This is because the image gets gamma corrected twice. The reason being that when we create an image based on what we see on the monitor, we effectviely gamma correct the color values of an image so that it looks right on the monitor. Because we then gamma correct in the renderer, the image usually ends up way to bright

- To fix this issue, we have to make sure texture artists work in linear space. However, since it's easier to work in sRGB space and most tools don't even support linear texturing, this is probably not the preferred solution

- The other solution is the re-correct or transform these sRGB textures to linear space before doing any calculations on their color values

- To do this for each texture in sRGB space is quite troublesome though. Luckily OpenGL gives us yet another solution to our porblems by giving us the GL_SRGB and GL_SRGB_ALPHA internal texture formats

- If we create a texture in OpenGL with any of these two sRGB texture formats, OpenGL will automatically correct the colors to linear space as soon as we use them, allowing us to propely work in linear space

- You should be careful when specifying your textures in sRGB space as not all textures will actually be in sRGB space. Textures used for retrieving lighting parameters (like specular maps and normal maps) are almost always in linear space, so if you were to  configure these as sRGB textures, the lighting will look odd. Be careful which textures you specify as sRGB

- Lighting attenuation is also different with gamma correction. In the real physical world, lighting attenuates inversely and proportional to the squared distance from a light source. In normal English it simply means that the light strength is reduced over the distance to the light source squared.

  ```cpp
  float attenuation = 1.0 / (distance * distance)
  ```

- However, when using this equation the attenuation effect is usually too strong, giving lights a small radius that doesn't look physically right. For that reason other attenuation are  used or the linear equivalent is used where we divide by just the distance rather than the distance squared

- The linear equivalent gives more plausible results compared to its quadratic variant without gamma correction, but when we enable gamma correction, the linear attenuation looks too weak and the physically correct quadratic attenuation suddenly gives the better results

- The cause of this difference is that light attenuation functions change brightness and as we weren't visualizing our scene in linear space we chose the attenuation functions that looked best on our monitor, but weren't physically correct

- Let's revisit the squared attenuation function. If we were to use this function without gamma correction, the attenuation function becomes (1/distance^2)^2.2 when displayed on a monitor. This creates a much larger attenuation from what we originally anticipated. This also explains why the linear equivalent makes much more sense without the gamma correction as this effectively becomes (1/distance)^2.2 = 1/distance^2.2, which is a lot similar to the physical equivalent

- In summary, gamma correction allows us to do all our shader/lighting calculations in linear space. Because linear space makes sense in the physical world, most physical equations now actually give good results (like real light attenuation). The more advanced the lighting becomes, the easier it is to get good looking (and realistic) results with gamma correction. That is also why it's advised to only really twewak your lighting parameters as soon as you have gamma correction in place

#### Shadows_Shadow-Mapping

- Shadows are a result of the abscence of light due to occlusion. When a light source's light rays do not hit an object because it get occluded by some other object, the object is in shadow. Shadows add a great deal of realism to a lit scene and make it easier for a viewer to observe spatial relationships. They give a great sense of depth to our scene and objects

- Shadows are a bit tricky to implement though, specifically because in current real-time (rasterized graphics) research a perfect shadow algorithm hasn't been developed yet. There are several good shadow approximation techniques but they all have little quirks and annoyances which we have to take into account

- One technique used by most videogames that gives decent results and is relatively easy to implement is shadow mapping

- Shadow mapping is not too difficult, doesn't cost too much in performance and quite easily extends into more advanced algorithms

- The idea behind shadow mapping is quite simple: we render the scene from the light's point of view and everything we see from the light's perspective is lit and everything we can't see must be in shadow.

- We want to get the point on the ray where it first hit and object and compare this closest point to the other points on this ray. We then do a basic test to see if a test point's ray is further down the ray than the closest point and if so, the test point must be in shadow

- Iterating through possibly thousands of light rays from such a light source is an extremely inefficient approach and doesn't lend itself too well for real-time rendering. We can so something similar but without casting light rays.

- Instead we use something familiar: the depth buffer

- Recall from depth testing that a value in the depth buffer corresponds to the depth of a fragment clamped [0,1] from the camera's point of view

- What if we were to render the scene from the light's perspective and store the resulting depth values in texture?

- This way, we can sample the closest depth values as seen from the light's perspective. After all, the depth values show the first fragment visible from the light's perspective

- We store all these depth values in a texture that we call a depth map or shadow map

- We create the depth map by rendering the scene (from the light's perspective) using a view and projection matrix specific to that light source.

- This projection and view matrix together form a transformation T matrix that transforms any 3D position to the light's visible coordinate space

- A directional light doesn't have a position as it's modelled to be infinitely far away. However, for the sake of the shadow mapping we need to render the scene from a light's perspective and thus render the scene from a position somewhere along the lines of the light direction

- Shadow mapping therefore consists of two passes: first we render the depth map and in the second pass we render the scene as normal and use the generated depth map to calculate whether fragments are in shadow

- The code to check if fragment is in shadow is executed in the fragment shader but the light space transformation in the vertex shader. This light space transformation is done on the world-space vertex position

- Note that shadows are rarely dark, due to light scattering, we leave usually leave the ambient component  out of the shadow multiplications

- The first thing to do to check whether a fragment is in shadow, is transform the light-space fragment position in clip-space to NDC. When we output a clip-space vertex position to gl_Position in the vertex shader, OpenGL automatically does a perspective divide e.g. transform clip-space coordinates in the range [-w,w] to [-1,1] by dividing the x,y and z component's by the vector's w component (Note also this is how the depth buffer is populated)

- When we implement shadow mapping, there are usually a few artifacts that we need to resolve as a result of implementing the algorithm detailed above

- One artifact we usually run into is called shadow acne. This a scenario where a surface is rendered with obvious black lines in an alternating fashion

- This occurs because the shadow map is limited by resolution and so multiple fragments can sample the same value from the depth map when they're relatively far away from the light source

- While this is generally okay, it becomes an issue when the light source looks at an angle towards the surface and in that case, the depth map is also rendered from an angle. Several fragments then access the same tilted depth texel while some are above and some are below the floor. This leads to a shadow discrepancy. Because of this, some fragments are considered to be in shadow and some are not; giving the striped pattern alluded to earlier

- We can solve this issue with a small little hack called a shadow bias where we simply offset the depth of the surface (or the shadow map) by a small bias amount such that the fragments are not incorrectly considered above the surface

- With the bias applied, all the samples get a depth smaller that the surface's depth and thus the entire surface is correctly lit without any shadows. We can implement such a bias as follows:

  ```cpp
  float bias = 0.005;
  float shadow = currentDepth - bias > closestDepth  ? 1.0 : 0.0;
  ```

- The bias value is highly dependent on the angle between the light source and the surface. If the surface would have a steep angle to the light source, the shadows may still display shadow acne

- A more solid approach would be to change the amount of bias based on the surface anfle towards the light: something we can solve with the dot product

  ```cpp
  float bias = max(0.05 * (1.0 - dot(normal, lightDir)), 0.005);
  ```

- Here we have a maximum bias of 0.05 and a minimum of 0.005 based on the surface's normal and light direction. This way, surfaces like the floor that are almost perpendicular to the light source get a small bias, while surfaces like the cube's side-faces get a much larger bias

- A disadvantage of using shadow bias is that you're applying an offset to the actual depth of objects. As a result, the bias may become large enough to see a visible offset of shadows compared to the actual object locations

- This shadow artifact is called Peter Panning since objects seem slightly detached from their shadows

- We can use a little trick to solve most of the Peter Panning issue by using front face culling when rendering the depth map. Recall, that by default OpenGL culls back-faces. By telling OpenGL we want to cull front faces during the shadow map stage, we're switching that order around

- Because we only need depth values for the depth map it shouldn't matter for solid objects whether we take the depth of their front faces or their back faces. Using their back face depths doesn't give wrong results as it doesn't matter if we have shadows inside objects; we can't see there anyways

- This trick effectively solve the peter panning issues but ony for solid objects that actually have an inside without any openings

- If you try to use peter panning on a single plane object, culling the front face of the object completely removes it

- Another consideration is that objects that are close to the shadow reciever (like the distant cube) may still give incorrect results

- Another visual discrepancy is the regions outside the light's visible frustum are considered to be in shadow while they're usually not. This happens because projected coordinates outside the light's frustum are higher than 1.0 and will thus sample the depth texture outsidee its default range of [0,1]. Based on the texture's wrapping methods, we will get incorrect depth results not based on the real depth values from the light source

- What we would rather have is that all the coordinates outside the depth map's range have a depth of 1.0 which as a result measn these coordinates will never be in shadow (as no object will have a dpeth larger than 1.0)

- We will also notice that the coordinates outside the far plane of the light's orthographic frustum. You can see that this dark region always occurs at the far end of the light source's frustum by looking at the shadow directions

- By checking the far plane and clamping the depth map to a manually specified border color, we solve the over-sampling of the depth map

- The result of all this means that we only have shadows where the projected fragment coordinates sit inside the depth map range so anything outside the light frustum will have no visible shadows

- Because depth maps have a fixed resolution, the dpeth frequently spans more than one fragment per texel. As a result multiple fragments sample the same depth value from the depth map and come to the same shadow conclusions , which produces these jagged blocky edges

- You can reduce these blokcy shadows by increasing the depth map resolution or by trying to fit the light frustum as closely to the scene as possible

- Another partial solution to these jagged edges is called PCF or percentage-closer filtering which is a term that hosts many differen filtering function that produce softer shadows, making them appear less blokcy or hard

- The idea is to sample more than once from the depth map, each time with slightly different texture coordinates. For each individual sample, we check whether it si in shadow or not. All the sub-results are then combined and averaged and we get a nice soft looking shadow.

- One simple implementation of PCF is to simply sample the surrounding texels of the depth map and average the results

- There is a difference between rendering the depth map with an orthographic or a perspective projection matrix

- An orthographic projection matirce does not deform the scene with perspective so all view/light rays are parallel. This makes it a great projection matrix for directional lights

- On the other hand, a perspective projection matrix does deform all vertices based on perspective which gives different results

- Perspective projections make most sense for light sources that have actual location, unlike directional lights. Perspective      projections are most often used with spotlights and points lights, while orthographic projections are used for directional lights

- Another subtle difference with using a perspective projection matrix is that visualizing the depth buffer will often give an almost completely white result. This happens because with perspective projection, the depth is transformed to non-linear depth values with most of its noteceable range close to the near plane. To be able to properly view the depth values as we did with the orthographic projection, you first want to transform the non-linear depth values to linear

#### Shadows_Point-Shadows

- We have created dynamic shadows with shadow mapping but this is mostly suited for directional (or spot) lights as the shadows are generated only in the direction of the light source. It is therefore known as directional shadow mapping as the depth (or shadow) map is generated from only the direction the light is looking at

- In this section, we will focus on the generation of dynamic shadows in all surrounding directions. The technique we're using is perfect for point lights as a real point light would cast shadows in all directions. This technique is known as point (light) shadows or more formaly as omnidirectional shadow maps

- The technique is mostly similar to directional shadow mapping: we generate a depth map from the light's perspective(s), sample the depth map based on the current fragment position, and compare each fragment with the stored depth value to see whether it is in shadow. The main differenc between directional shadow mapping and omnidirectional shadow mapping is the depth map we use

- The depth map we need requires rendering a scene from all surrounding directions of a point light and as such a normal 2D depth map won't work; what if we were to use a cubemap instead? Because a cubemap can store full environment data with only 6 faces, it is possible to render the entire scene to each of the faces of a cubemap and sample these as the point light's surrounding depth values

- The generated depth cubemap is then passed to the lighting fragment shader that samples the cubemap with the direction vector to obtain the closest depth (from the light's perspective) at that fragment

- The hardest part of this technique is the depth cubemap generation

- To create a cubemap of a light's surrounding depth vlaues we have to render the scene 6 times; one for each face of the cube. One obvious way to do this is render the scene 6 times with 6 different view matrices, each time attaching a different cubmap face the framebuffer object

- However, this is quite expensive as a lot of render calls are necessary for this single depth map

- A nifty workaround trick would be to use a geometry shader instead that allows us to build the depth cubemap with just a single render pass

- Since omnidirectional shadow maps are based on the same principles of traditional shadow mapping, it also leads to the same resolution dependent artifacts. PCF (Percentage-closer filtering) allows us to smooth out these jagged edges by filtering multiple samples around the fragment position and average the results

- One difference from the PCF algo in the previous section is that a third dimension is added

- We may run into an issue where a lot of the samples we take are redundant in that they sample close to the original direction vector and so it may make more sense to only sample in perpendicular directions of the sample direction vector

- However as there is no easy way to figure out which sub-directions are redundant this becomes difficult

- One trick we can use is to take an array of offset directions that are all roughly seperable e.g. each of them points in completely different directions. This would significantly reduce the number of sub-directions that are close together

- One thing to note is that using geometry shaders to generate a depth map isn't necessarily faster than rendering the scene 6 times for each face. Using a geometry shader like this has its own performance penalties that may outweig the gain of using one in the first place. This of course depends on the type of environment, the specific video card drivers and plenty of other factors. We would then have to profile the system to figure out which method is more efficient for the scene

#### Normal Mapping

- All our scenes are filled with meshes, each consisting of hundreds or maybe thousands of triangles. We have already boosted their realism by  wrapping 2D textures on these flat triangles which hides the fact that the polygons are just tiuny flat triangles

- Textures help but when you take a good close look at the meshes it is quite easy to see that underlying falt surfaces. Most real-life surfaces aren't flat however and exhibit a lot of bumpy details

- For instance, take a brick surface. A brick surface is quite a rough surface and obviously not completely flat: it contains sunken cement stripes a lot of detailed little holes and cracks. if we were to view such a brick surface in a lit scene the immmersion gets easily broken

- One solution to partially remedy fix the flat look is by using a specular map to pretend some surfaces are less lit due to depth or toher details but that's more of a hack than a real solution. What we need is some way to infrom the lighting system about all the little depth-like details of the surface

- If we think about this from a light's perspective, how come the surface is lit as a completely flat surface? The answer is the surface's normal vector. From the lighting technique's point of view, the only way it determines the shape of an object is by its perpendicular normal vector

- The brick surface from the earlier example only has a single normal vector and as a result the surafce is uniformly lit based on this normal vector's direction

- What if, instead of a per-surface normal that is the same for each fragment, use a per-fragment normal that is different for each fragment

- This way, we can slightly deviate the normal vector based on a surface's little details; this gives the illusion that the surface is a lot more complex

- Byn using per-fragment normals we can trick the lighting into believing a surface consits of tiny little planes (perpendicular to their normal vectors) giving the surface and enormous boost in detail

- This technique to use per-fragment normals compared to per-surface normals is called normal mapping or bump mapping. The tehcinque is relatively low cost

- Since we only change the normal vectors per fragment there is no need to change the lighting equation. We now pass a per-fragment normal instead of an interpolated surface normal to the lighting and the lighting then does the rest

- To get normal mapping to work we're going to need a per-fragment normal. Similar to what we did with diffuse and specular maps, we cna use a 2D texture to store per-fragment normal data. This way we can sample a 2D texture to get a normal vector for that specific fragment

- While normal vectors are geometric entities and texture are generally only used for color information, storing normal vectors in a texture may not be immediately obvious. If you think about color vectors in texture they are represented as a 3D vector with an r,g and b component. We can similiar store a normal's vector's x, y and z component in the respective color components. Normal vectors range between -1 and 1 os they're first mapped to [0,1]

- When the normal vectors have been transformed to an RGB color component like this, we can store a per-fragment normal derived from the shape of a surface onto a 2D texture

- Most normal maps will have a blue-ish tint. This is because the normals are all closely pointing outwarsds towards the positive z-axis (0,0,1): a blue-ish color. he deviations in color represent normal vectors that are slightly offset from the general positive z direction, giving a sense of depth to the texture

- For example, the top of each brick the color tends to be more greenish, which make sense as the top side of a brick would have normals pointing more in the positive y direction which happens to be the color

- There is one issue that greatly limits the use of normal maps. If the normal map and the and the surface normal vector don't point in the same direction, this can lead to incorrect lighting

- One solution for this issue would be to define a normal map for each possible direction of the surface; in the case of a cube this would lead to 6 normal maps. However, with advanced meshes that can have more than hundreds of possible surface directions this becomes an infeasible approach

- A different solution exists that does all the lighting in a different coordinate space: a coordinate space where the normal map vectors always point towards the positive z direction; all other lighting vectors are then transformed relative to this positive z direction. This way we can always use the same normal map, regardless of orientation. This coordinate space is called tangent space

- Normal vectors in a normal map are expressed in tangent space where normal always point roughly in the positive z direction

- Tangent space is a space that's local to the surface of a triangle: the normals are relative to the local reference frames of the individual triangles

- Think of it as the local space of the normal map's vectors; they're all defined pointing in the positive z direction regardless of the final transformed direction. Using a specific matrix we can then transform normal vectors from this local tangent space to world or view coordinates, orienting them along the final mapped surface's direction

- Let's say we have an incorrect normal mapped surface looking in the positive y direction. The normal map is defined in the tangent space, so one way to solve the problem is to calculate a matrix to transform normals from tangent space to a different space such that they're aligned with the surface's normal direction: the normal vectors are then all pointing roughly in the positive y direction. The great thing about tangent space is that we can calculate this matrix for any type of suraface sot hat we can properly aling the tangent space's z direction to the surface's normal direction

- Such a matric is called a TBN matrix where the letters depict a Tangent, Bitangent and Normal vector. These are the vectors we need to construct this matrix. To construct such a change-of-basis matrix, that transforms a tangent-space vector to a different coordinate space, we need three perpendicular vectors that are aligned along the surface of a normal map: an up, right and forward vector

- The up vector is the surface's normal vector. The right and forward vector are the tangent and bitangent vector respectively

- Calculating the tangent and bitangent vectors is not as straightforward as the normal vector. The direction of the normal map's tangent and bitangent vector align with the direction in which we define a surface texture's coordinates. We'll use this fact to calculate the tangent and bitangent vectors for each surface

- Utilizing a triangle's two edges and it's texture coordiantes allows us to derive a formula that we can then use to calculate the tangent and bitangent vector

- In effect, we can calculate tangents and bitangents from a triangle's vertices and its texture coordinates, since texture coordinates are in the same space as tangent vectors

- After creating a TBN matrix, there are two ways to use it:
  1. We take the TBN matrix that transforms any vector from tangent to world space, give it to the fragment shader and the transform the sample normal from tangent space to world space using the TBN matrix
  2. We take the inverse of the TBN matrix that transforms any vector from world space to tangent space, and use this matrix to transform not the normal but the other relevant lighting variables to tangent space; the normal is then again in the same space as the other lighting variables

- The second approach looks like more work and also requires matrix multiplication in the fragment shader, so why would we do it?

- Well transforming vectors from world to tangent space has an added advantage in that we can transform all the relevant lighting vectors to tangent space in the vertex shader instead of the fragment shader

- There is effectively no reason to transform a vector to tangent space in the fragment shader while it is necessary with the first approach as sample normal vectors are specific to each fragment shader run

- So instead of sending the inverse of the TBN matrix to the fragment shader, we send a tangent-space light position, view position and vertex position to the fragment shader. This saves us from having to do matrix multiplications in the fragment shader. This is also the reason why this approach is often the preferred approach

- Normal mapping boosts the detail of an object by an incredibale amount without too much extra cost

- Normal mapping can also be used as a tool to replace high-vertex meshes with low-vertex meshes without losing too much detail

- When tangent vectors are calculated on larger meshes tha share a considerable amount of vertices, the tangent vectors are generally averaged to give nice and smooth results. A problem with this approach is that the three TBN vectors could end up non-perpendicular which means the resulting TBN matrix would no longer be orthogonal. Normal mapping would only be slightly off with a non-orthogonal TBN matrix, but it's still something that we can improve

- Using a mathematical trick called thr Gram-Schmidt process, we can re-orthogonalize the TBN vectors such that each vector is again perpendicular to the other vectors

#### Parallax Mapping

- Parallax mapping is a technique similar to normal mapping but based on different principles. Just like normal mapping, it is a technique that significantly boosts a textured surface's detail and gives it a sense of depth

- While it is also an illusion, parallax mapping is a lot better in conveyiong a sense of depth and together with normal mapping gives incredibly realistic results

- Parallax mapping is closely related to the family of displacement mapping techinques that displace or offset vertices based on geometrical information stored inside a texture. One way to do this is to take a plane with roughly 1000 vertices and displace each of these vertices base dona value in a texture that tells us the height of the plane of that specific area

- Such a texture that contains height values per texel is called a height map

- When spanned over a plane, eahc vertex is displaced based on the sampled height value in the height map, transforming a flat plane to a rough bumpy surface based on a material's geometric properties

- A problem with displacing vertices this way is that a plane needs to contain a huge amount of triangles to get a realistic displacement, otherwise the displacement looks too blocky

- As each flat surface may then require over 1000 vertices this quickly becomes computationally infeasible

- What if we could somehow achieve similar realism without the need of extra vertices?

- This can be done with parallax mapping

- The idea behind parallax mapping is to alter the texture coordinates in such a way that it looks like a fragment's surface is higher or lower than it actually is, all based on the view direction and a heightmap

- This little trick gives good results most of the time but it is still a really crude approximation. When heights change rapidly over a surface the results tend to look unrealistic

- Another issue with parallax mapping is that it's difficyult to figure out which coordinates to retrieve from the when the surface is arbitrarily rotated in some way. We'd rather do this in a different coordinate space where the x and y components of the vecotr used always align with the texture's surface i.e. we would like to do this in tangent space

- By transforming the fragment-to-view direction vector to tangent space, the transformed vector will have its x and y component aligned to the surface's tangent and bitangent vectors

- As the tangent and bitangent vectors are pointing in the same direction as the surface's texture coordinates, we can take the x and y components of the utilized vector as the texture coordinate offset regardless of the surface's orientation

- Because parallax mapping gives the illusion of displacing a surface, the illusion breaks when the lighting doesn't match. As normal maps are often generated from heightmaps, using a normal map together with the heightmap makes sure the lighting is in place with the displacement

- Displacement maps are the inverse of heightmaps

- With parallax mapping it makes more sense to use the inverse of the heightmap as it's easier to fake depth than height on flat surfaces

- Assuming we perform parallax mapping on a plane, we may still see some weird border artifacts at the edge of the parallax mapped plane. This happens because at the edges of the plane, the displaced texture coordinates can oversample outside the range [0,1]. This gives unrealistic results based on the texture's wrapping mode(s)\

- A cool trick to solve this issue is to discard the fragment whenver it samples outside the default texture coordinates range

- This trick doesn't work on all types of surfaces but when applied to a plane, it gives great results

- In general, parallax mapping looks great and is quite fast as well as we only need a single extra texture smaple for parallax mapping to work. It does come with a few issues though as it sort of breaks down when looking at it from an angle (similar to normal mapping) and gives incorrect results with steep height changes

- The reason that it doesn't work properly at times is that it's just a crude approximation of displacement mapping. There are some extra tricks however that still allows us to get almost perfect results with steep height changes, even when looking at an angle. For instance, what if we instead of one sample take multiple samples

- Steep parallax Mapping is an extension on top of Parallax mapping in that it uses the same principles but instead of 1 sample it takes multiple samples. This gives much better results, even with steep height changes, as the accuracy of the technique is improved by the number of samples

- The general idea of Steep Parallax Mapping is that it divides the total depth range into multiple layers of the same height/depth. For each of these layers we sample the depthmap, shifting the texture coordinates until we find a sampled depth value that is less than the depth value of the current layer

- We cna improve the current algorithm a bit by exploiting one of Parallax Mapping's properties which is that when looking straight onto a surface there isn't much texture displacement going on while there is a lot of displacement when looking at a surface from an angle. By taking less samples when looking straight at a surface and more samples when looking at an angle we only sample the necessary amount

- Steep Parallax Mapping comes with its own problems though. Because the technique is baed ona finite number of samples, we get aliasing effect and the clear distinction between layers can easily be spotted

- We can reduce the issue by taking a larger number of samples but this quickly become too heavy a burden on performance. There are several approaches that aim to fix this issue by not taking the first first position that's belwow the displaced surface but by interpolating between the position's two closest depth layers to find a much closer match

- Two more popular of these approaches are called Relief Parallax Mapping and Parallax Occlusion Mapping of which the Relief Parallax Mapping gives the most accurate results, but is also more performance heavy compared to Parallax Occlusion. Because Parallax Occlusion Mapping gives almost the same results as Relief Parallax Mapping and is also more effcient, it is often the preferred approach

- Parallax Occlusion Mapping is based on the same principles as Steep Parallax Mapping but instead of taking the texture coordinates of the first depth layer after a collision, we're going to interpolate between the depth layer after and before the collision

- We base the weight of the linear interpolation on how far the surface's height is from the depth layer's value of both layers

#### HDR

- Brightness and color values by default are clamped between 0.0 and 1.0 when stored in a framebuffer

- This statement caused us to always specify light and color values somewhere in this range, trying to make them fit into the scene

- This works ok and gives decent results but what happens if we walk in a really bright area with multiple bright light sources that as a total sum exceed 1.0

- The answer is that all fragments that have a brightness or color sum over 1.0 get clamped to 1.0, which isn't pretty to look at

- In such cases due to a large number of fragments' color values getting clamped to 1.0, each of the bright fragments have the same exact white color value in large regions, losing a significant amount of detail and givin   g it a false look

- A solution to this problem would be to reduce the strength of the light sources and ensure no area of fragments in your scene ends up brighter than 1.0; this is not a good solution as this forces you to use unrealistic lighting parameters. A better approach is to allow color values to temporarily exceed 1.0 and transform them back to the original range of 0.0 to 1.0 as a final step without losing any detail

- Monitors (non-HDR) are limited to display colors in the range of 0.0 to 1.0 but there is not such limitation in lighting equations. By allowing fragment colors to exceed 1.0 we have a much higher range of color values available to work in known as high dynamic range (HDR). With HDR, bright things can be reallty bright, dark things can be really dark and details can be seen in both

- HDR was originally only used for photogtaphy where a photographer takes multiple pictures of the same scene with varying exposure levels, capturing a large range of color values. Combining these forms a HDR image where a large range of details are visible based on the combined exposure levels or a specific exposure it is viewed with

- This high/low exposure phenonenom is also how the human eye works and is the basis of high dynamic range rendering

- When there is little light, the human eye adapts itself so the darker parts become more visible and similarly for bright areas. It's like the human eye has an automatic exposure slider based on the scene's brightness

- HDR rendering works in a similar way. We allow a much larger range of color values to render to, collecting a large range of dark and bright detials of a scene and at the edn we transform all the HDR values back to the low dynamic range (LDR) of [0.0,1.0]

- This process of converting HDR values to LDR values is called tone mapping and a large collection of tone mapping algorithms exist that aim to preserve most HDR details during the conversion process. These tone mapping algorithms often involve an exposure parameter that selectively favors dark or bright regions

- When it comes to real-time rendering, high dynamic range allows us to not only exceed the LDr range of [0.0, 1.0] and preserve more detail, but also gives us the ability to specify a light source's intensity by their real intensities

- For instance, the sun has a much hihgher intensity rhan something like a flashlight so why not configure the sun as such (e.g. a diffuse brightness of 100). This allows us to more properly configure a scene's lighting with more realistic lighting, something that wouldn't be possible with LDR rendering as they'd then directly get clamped to 1.0

- As non-HDR monitors only display colors in the range between 0.0 and 1.0, we do need to transform the currently high dynamic range of color values back to the monitor's range. Simply re-transforming colors back wiht a simple average wouldn't do us much good as brighter areas then become a lot more dominant. What we can do is use different equations and/or curves to transform the HDR values back to LDR that give us complete control over the scene's brightness. This is the process earlier denoted as tone mapping and the final step of HDR rendering

- To implement high dynamic range rendering, we need some way to prevent color values getting clamped after each fragment shader rub. When framebuffers use a normalized fixed-point color format like GL_RGB as their color buffer's internal format, OpenGL automatically clamps the values between 0.0 and 1.0 befores storing them in the framebuffer

- THis operation holds for most types of framebuffer formats except for floating point formats

- When the internal format of a framebuffer's color buffer is specified as GL_RGB16F, GL_RGBA16F, GL_RGB32F or GL_RGBA32F the frambuffer is known as a floating point framebuffer that can store floating point values outside the default range of [0.0,1.0]. This is perfect for rendering HDR

- To create a floating point framebuffer the only thing we need to change is its color buffer's internal format

- One of the more simple tone mapping algorithms is Reinhard tone mapping that involves dividing the entire HDR color values to LDR color values. The Reinhard tone mapping algorithm evenly balances out all brightness values onto LDR

- Note that it is possible to directly tone map at the end of our lighting shader, not needing any floating point framebuffer at all. However, as scenes get more complex you'll frequently find the need to store intermediate HDR results as floating point buffers so it is a good exercise to using floating point framebuffers

- Another interesting use of tone mapping is to allow the use of an exposure parameter. Recall that HDR images contain a lot of details visible at different exposure levels. If we have a scene that features a day and night cycle it makes sense to use a lower exposure at daylight and a hgiher exposure at night time, smiliar to how the human eye adapts. Wiht such an exposure parameter it allwos us to configure the lighting parameters that work both at day and at night under different lighting conditions as we only have to change the exposure parameter

- Some tone mapping algorithms favor certain colors/intensities above others and some algorithms display both the low and high exposure colors at the same time to create more colorful and detailed images. There is also a collection of techniques known as automatic exposure adjustment or eye adaption techniques that determine the brightness of the scene in the previous frame and slowly adapt the exposure parameter such that the scene gets brighter in dark areas and vice versa

- The real benefit of HDR rendering reallys shows itself in large and complex scenes with heavy lighting algorithms

#### Bloom

- Bright light sources and brightly lit regions are often difficult to convey to the viewer as the intensity range of a monitor is limited. One way to distinguish bright light sources on a monitor is by making them glow; the light then bleeds around the light source. This effectively gives the viewer the illusion these light sources or bright regions are intensely bright

- This light bleeding or glow effect is achieved with a post-processing effect called Bloom. Bloom gives all brightly lit regions of a scene a glow-like effect

- Bloom gives noticeable visual cues about the brightness of the objects. When done in a subtle fashion, it significantly boosts the lighting of your scene and allows for a large range of dramatic effects

- Bloom works best in combination with HDR rendering. A common misconception is that HDR is the same as Bloom as many people use the terms interchangeably. They are however completely different techniques used for different purposes

- It is possible to implement Bloom with default 8-bit precision framebuffers, just as it is possible to use HDR without the Bloom effect. It is simply that HDR makes Bloom more effective to implement

- To implement Bloom, we render a lit scene as usual and extract both the scene's HDR color buffer and an image of the scene with only its bright regions visible. This extracted brightness image is then blurred and the result added on top of the original HDR scene image

- A simple way to blur the image would be to take the average of all surrounding pixels of an image. While it does give us an easy blur, It doesn't give the best results

- A gaussian blur is based on the Gaussian curve which is commonly described as a bell-shaped curve giving high values close to its center that gradually wear off over distance

- As the Gaussian curve has a larger area close to its center, using its values as weights to blur an image give more natural results as samples close by have a higher precedence. If we for instance sample a 32x32 box around a fragment, we use progressively smaller weights the larger the distance to the fragment; this gives a better and more realistic blur which is known as Gaussian Blur

- To implement a Gaussian blur filter, we'd need a two-dimensional box of weights that we can obtain from a 2 dimensional Gaussian curve equation. The problem with this approach is that it quickly becomes heavy on performance. Take a blur kernel of 32 by 32 for example, this would require us to sample a texture a total of 1024 times for each fragment

- Luckily, the gaussian equation has a very neat property that allows us to seperate the two-dimensional equation into two smaller one-dimensional equations: one that describes the horizontal weights and the other that describes the vertical weights

- We'd then first do a horizontal blur with the horizontal weights on the scene texture and then on the resulting texture do a vertical blur

- Due to this property, the results are exactly the same but this time saving us an incredible amount of performance as we'd now only have to do 32 + 32 samples compared to 1024. This is known as two-pass Gaussian Blur

- This does mean we need to blur an image at least two times and this works best with the use of framebuffer objects

- Specifically for the two-pass Gaussian blur we're going to implement ping-pong framebuffers. That is a pair of framebuffers where we render and swap, a given number of times, the other framebuffer's color buffer into the current framebuffer's color buffer with an alternating shader effect

- We basically continuosly switch the framebuffer to render to and the texture to draw with. This allows us to first blur the scene's texture in the first framebuffer then blur the first framebuffer's color buffer into the second framebuffer, and then the second framebuffer's color buffer into the first and so on

#### Deferred Shading

- The way we've done lighting so far is called forward rendering or forward shading. A straightforward approach where we render an object and light it according to all light sources in a scene

- We do this for individually for every object scene. While it is quite easy to understadn and implement it is also quite heavy on performance as each rendered object has to iterate over each light source for every rendered fragment

- Forward rendering also tends to wast a lot of fragment shader runs in scenes with a high depth complexity (multiple objects cover the same screen pixel) as fragment shader outputs are overwritten

- Deferred shading or deferred rendering aims to overcome these issues by drastically changing the way we render objects. This gives us several new options to significantly optimize scenes with large number of lights, allwing us to render hundreds (or even) thousands of lights with an acceptable frame rate

- It is based on the idea that we defer or postpone most of the heavy rendering (like lighting) to a later stage. Deferred shading consists of two passes: in the first pass, called the geometry pass, we render the scene once and retrieve all kinds of geometrical information from the objects that we store in a collection of textures called the G-buffer; think of position vectors, color vectors, normal vectors and/or specular values

- The geometric information of a scene stored in the G-buffer is then later used for more complex lighting calculations

- We use the textures from the G-buffer in a second pass called the lighting pass where we render a screen-filled quad and calculate the scene's lighting for each fragment using the geometrical information stored in the G-buffer; pixel by pixel, we iterate over the G-buffer

- Instead of taking each object all the way from the vertex shader to the fragment shader, we decouple its advanced fragment process to a later stage

- The lighting calculations are exactly the same but this time we take all required input variables from the corresponding G-buffer textures instead of the vertex shader (plus some uniform variables)

- A major advantage of this approach is that whatever fragment ends up in the G-buffer is the actual fragment information that ends up as a screen pixel

- The depth test already concluded this fragment to be the last and top-most fragment. This ensures that for each pixel we process in the lighting pass, we only calculate lighting once

- Furthermore, deferred rendering opens up the possibility for further optimizations that allow us to render a much larger amount of light sources compared to forward rendering

- It also comes with some disadvantages though as the G-buffer requires us to store a relatively large amount of scene data in its texture color buffers

- This eats memory, especially since scene data like position vectors require a high precision

- Another disadvantage is that it doesn't support blending ( as we only have information of the top-most fragment) and MSAA no longer works

- Filling the G-buffer in the geometry pass isn't too expensive as we directly store object information liek position, color or normals into a framebuffer with a small or zero amount of processing

- By using multiple rendered targets we can even do all of this in a single render pass

- The G-buffer is the collective term of all textures used to store ligiting relevant data for the final lighting pass

- All the data we need to light a fragment with forward rendering is as follows:
  1. A 3D world space position vecotor to calucate the interpolated fragment position variable used for the lightDir and viewDir
  2. An RGB diffuese color vector known as an albedo
  3. A 3D normal vecotr for determining a surface's slope
  4. A specular intensity float
  5. All light source positions and color vectors
  6. The player or viewer's position vector

- With these per-fragment variables at our disposal, we are able to calculate the (Blinn) Phong lighting we're accustomed to. The light source positions and colors and the player's view position can be configured using uniform variable but the other variables are all fragment specific

- If we can somehow pass the exact same data to the final deferred lighting pass we can calculate the same lighting effects, even though we're rendering fragments on a 2D quad

- There is no limit in OpenGL to what we can store in a texture so it makes sense to store all per-fragment data in one or multiple screen-filled textures of the G-buffer and use these later in the lighting pass

- As the G-buffer textures will have the same size as the lighting pass's 2D quad, we get the exact same fragment data we'd had in a forward rendering setting but this time in the lighting pass; there is a one on one mapping

- One of the disadvantages of deferred shading is that it is not possible to do blending as all values in the G-buffer are from single fragments and blending operates on the combination of multiple fragments. Another disadvantage is that deferred shading forces you to use the same lighting algorithm for most of your scenes lighting; you can somehow alleviate this a bit by including more material-specfic data in the G-buffer

- To overcome these disadvantages (especially blending) we often split the renderer into two parts: one deferred rendering part and the other a forward rendering part specifically meant for blending or special shader effects not suited for a deferred rendering pipelin

- What deferred rendering is often praised for is its ability to render an enormous amount of light sources without a heavy cost on performance

- Deferred rendering by itself doesn't allow for a very large amount of light sources as we'd still have to calculate each fragment's lighting component for each of the scene's light sources

- What makes a large amount of light sources possible is a very neat optimization we can apply to the deferred rendering pipeline called light volumes

- Normally when we render a fragment in a large lit scene, we'd calculate the contribution of each light source in a scene, regardless of their distance from the fragment. A large portion of these light sources will never reach the fragment so wht waster all these lighting computations

- The idea behind light volumes is to calculate the radius or volume of a light source i.e. the area where its light is able to reach fragments. As most light sources use some form of attenuation, we can use that to calculate the maximum distance or radius this light is able to reach, We then only do the expensive lighting calculations is a fragment is inside one or more of these light volumes. This can save us a considerable amount of computation as we now only calculate lighting where it's necessary

- The trick to this approach is mostly figuring out the size or radius of the light volume of a light source

- To obtain a light's volume radius we have to solve the attenuation equation for when its light contribution becomes 0.0 ( or in practive very close such as 5/256)

- A naive utilization of light volume's would lead to code that contained loops and branches. However the reality if the GPUs and GLSL are pretty bad at optimizing loops and branches

- The reason for this is that shader execution on the GPU is highly parallel and most architectures have a requirement that for large collection of threads they need to run the exact same shader code for it to be effcient. This often means that a shader is run that executes all branches of an if stateme4nt to ensure the shader runs are the same for that group of threads maqking our previous radius check optimization completely useless as we'd still be calculation lighting for all light sources

- The appropriate approach to using light volumes is to render actual spheres, scaled by the light volume radius. The centers of these spheres are positioned at the light source's position and as it is scaled by the light volume radius the sphere exactly encompasses the light's visible volum

- This is where the trick comes in: we use the deferred lighting shader for rendering the spheres. As a rendered sphere produces fragment shader invocations that exactly match the pixels the light source affects, we only render the relevant pixels and skip all other pixels

- This done for each light source in the scene and the resulting fragments are additively blended together. This effectively reduces the computations from nr_objects * nr_lights to nr_objects + nr_lights which makes it incredibly efficient in scenes with large number of lights

- There is still an issue with the approach: face culling should be enabled (otherwise we'd render a light's effect twice) and when it is enabled the user may enter a light source's volume after which the volume isn't rendered anymore (due to back-face culling), removing the light source's influence; we can solve that by only rendering the sphere's back face

- Render light volumes does take its toll on performance and while it is generally much faster than normal deferred shading for a rendering a large number of lights, there is still more that can be optimized

- Two other popular (and more efficient) extensions on top of deferred shading exist called deferred lighting and tile-based deferred shading. These are even more efficient for rendering large amounts of light and also allow for relatively efficient MSAA

- When you have a small scene and not too many lights, deferred rendering is not necessarily faster and sometimes even slower as the overhead then outweighs the benefits of deferred rendering. In more complex scenes, deferred rendering quickly becomes a significant optimization; especially more advanced optimization extensions. In addition, some render effect, especially post-processing effects become chaper on a deferred render pipeline as a lot of scene inputs are already available from the g-buffer

- All effects that can be accomplished with forward rendering can also be implemented in a deferred rendering context; this often only requires a small translation step. For instance, if we want to use normal mapping in a deferred renderer, we'd change the geometry pass shaders to output a world-space normal extracted from a normal map using a TBN matrix instead of a surface normal; the lighting calculations in the lighting pass don't need to change at all

- If you want parallax mapping to work, you'd want to first displace the texture coordinates in the geometry pass before sampling an object's diffuse, specular and normal textures

#### SSAO

- Ambient lighting is a fixed constant light we add to the overall lighting of a scene to simulate the scattering of light

- In reality, light scatters in all kinds of directions with varying intensities so the indirectly lit parts of a scene should also have varying intensities

- One type of indirect lighting approximation is called ambient occlusion that tries to approximate indirect lighting by darkening creases, holes and surfaces that are close to each other

- These areas are largely occluded by surrounding geometry and thus light rays have fewer places to escape to, hence the areas appear darker

- Ambient occlusion techinques are expensive as they have to take surrounding geometry into account. One could shoot a large number of rays for each point in space to determine its amount of occlusion but that quickly becomes computationally infeasible for real time solutions

- In 2007, Cytrek published a technique called screen-space ambient occlusion (SSAO) for use in their title Crysis. The technique uses a scene's depth buffer in screen-space to determine the amount of occlusion instead of real geometrical data

- This approach is incredibly fast compared to real ambient occlusion and gives plausible results making it the de-facto standard for approximating real-time ambient occlusion

- The basics behind screen-space ambient occlusion are simple; for each fragment on a screen-filled quad we calculate an occlusion factor based on the fragment's surrounding depth values.

- The occlusion factor is then used to reduce or nullify the fragment's ambient lighting component

- The occlusion factor is obtained by taking multiple depth samples in a sphere sample kernel surrounding the fragment's position and comparing each of the samples with the current fragment's depth value. The number of samples that have a higher depth value than the fragment's depth represents the occlusion factor

- It's clear that the quality and precision of the effect directly relates to the number of surrounding samples we take. If the sample count it too low, the precision drastically reduces and we get an artifact called banding; if it is too high, we lose performance

- We can reduce the amount of samples we have to test by introducing some randomness into the sample kernel

- By randomly rotating the sample kernel eahc fragment we can get high quality results with a much smaller number of samples. This does come at a price as the randomness introduces a noticeable noise pattern that we'll have to fix by blurring the results

- The orignal method developed by Crytek ghad a certian visual style. Since the sample kernel used was a sphere, it caused flat walls to look gray as halkf the kernel samples end up being in the surrounding geometry

- A more appropriate sample kernel is a hemisphere oriented along the surface's normal vector

- By sampling aorund this normal-oriented hemisphere, we do not consider the fragment's underlying geometry to be a contribution to the occlusion factor. This removes the gray feel of ambient occlusion and generally produces more realistic results

- SSAO requires geometrical info as we need some way to determine the occlusion factor of a fragment. For each fragement, we're going to need the following data;
  1. A per-fragment position vector
  2. A per-fragment normal vector
  3. A per-fragment albedo color
  4. A sample kernel
  5. A per-fragemnt random rotation vector used to rotate the sample kernel

- Using a per-fragment view-space position, we can orient a sample hemisphere kernel around the fragment's view-space surface normal and use this kernel to sample the position buffer texture at varying offsets. For each per-fragment kernel sample, we compare its depth in the position buffer to determine the amount of occlusion.

- The resulting occlusion factor is then used to limit the final ambient lighting component. By also including a per-fragment rotation vector we can significantly reduce the number of samples we'll need to take

- As SSAO is a screen-space technique, we calculate its effect on each fragment on a screen-filled 2D quad. This does mean we have no geometrical information of the scene

- What we could do is render the geometrical per-fragment data into screen-space textures that we then later sent to the SSAO shader so we have access to the per-fragment geometrical data. This ends up looking a lot like the deferred renderer's g-buffer setup. For that reason, SSAO is perfectly suited in combination with deferred rendering as we already have the position and normal vectors in G-buffer

- Since SSAO is a screen-space technique where occlusion is calculated from the visible view, it makes sense to implement the algorithm in view-space

- Recall that we need to generate a number of samples oriented along the normal of a surface.We would need to generate samples that form a hemisphere as previously stated

- As it is difficult nor plausible to generate a sample kernel for each surface normal direction, we're going to generate a sample kernel in tangent space, with the normal vector pointing in the +ve z-direction

- Each of the kernel samples will be used to offset the view-space fragment position to smaple surrounding geometry

- We do need quite a lot of samples in view-space in order to get realistic results, which may be too heavy on performance. However, if we can introduce some semi-random rotation or noise per-frgament basis, we can significantly reduce the number od f samples required

- By introducing some randomness onto the sample kernels, we largely reduce the number of samples necessary to get good results. We could create a random rotation vector for each fragment of a scene, but that quickly eats up memory

- It makes more sense to create a small texture of random rotation vectors that we tile over the screen

### PBR

#### Theory

- Physically Based Rendering (PBR) is a collection of render techniques that are more or less based on the same underlying thoery that more closely matches that of the physical world

- As PBR aims to mimic light in a physically plausible way, it generally looks more realistic compared to out original lighting algorithms like Phong and Blinn-Phong

- Not only does it look better, as it closely approximates actual physics, we (and especially the artists) can author surface materials based on physical parameters without having to resort to cheap hacks and tweaks to make the lighting looks right

- One of the bigger advantages of authoring materials based on physical parameters is that these materials will look correct regardless of lighting conditions; something not true in non-PBR pipelines

- PBR is still nonetheless an approximation of reality which is why it's not called physical shading but rather physically based shading

- For a PBR lighting model to be considered physically based, it has to satisy the following 3 conditions:
  1. Be based on the microfacet surface model
  2. Be energy conserving
  3. Use a physically based BRDF

- All PBR techniques are based on the theory of micro facets

- The theory describes that any surfacea at a microscopic scale can be described by tiny little perfectly reflective mirrors called microfacets. Depending on the roughness of the surface, the alignment of these tiny little mirrors can differ a lot

- The rougher the surface is, the more chaotically aligned each microfacet will be along the surface

- The effect of these tiny-like mirror alignments is that when specifically talking about specular lighting/reflection, the incoming light rays are more likely to scatter along completely differen directions on rougher surfaces, resulting in a more widespread specular reflection

- In contrast, on a smooth surface the light rays are more likely to reflect in roughly the same direction, giving us smaller and sharper reflections

- No surface is completely smooth on a microscopic level, but seeing as these microfacets are small enough that we can't make a distinction between them on a per-pixel basis, we statistically approximate the surface's microfacet roughness with a roughness parameter

- Based on the roughness of a surface, we can calculate the ratio of microfacets roughly aligned to some vector h. This vector "h" is the halfway vector that sits halfway between the light "l" and view "v" vector

- The more the microfacets are aligned to the halfway vector, the sharper and stronger the specular reflection. Together with a roughness parameter that varies between 0 and 1, we can statistically approximate the alignment of the microfacets

- Higher roughness values display a much larger specular reflection shape, in contrast with the smaller and sharper specular reflection shape of smooth surfaces

- The microfacet approximation employs a form of energy conservation: outgoing light energy should never exceed incoming light energy (excluding emissive surfaces)

- This is why we see specular reflections more intensely on smooth surfaces and more dimly on rough surfaces

- For energy conservation to hold, we need to make a clear distinction between diffuse and specular light. The moment a light ray hits a surface, it gets split in both a refraction and a reflection part

- The reflection part is light that directly gets reflected and doesn't enter the surface ; this is what we know as specular lighting. The refraction part is the remaining light that enters the surface and gets absorbed; this is what we know as diffuse lighting

- There are some nuances here as refracted light doesn't immediately get absorbed by touching the surface. From physics we know that light can be modelled as a beam of energy that keeps moving forward until it loses all of its energy

- The way a light beam loses energy is by collision

- Each material consists of tiny little particles that can collide with the light ray. The particle absorb some or all of the light's energy at each collision which is converted into heat

- Generally not all energy is absorbed and the light will continue to scatter in a mostly random direction at which point it collides with other particles until its energy si depleted or it leaves the surface again. Light rays re-emerging out of the surface contribute to the surface's observed (diffuse) color

- In PBR we make the simplifying assumption that all refracted light gets absorbed and scattered at a very small area of impact, ignoring the effect of scattered light rays that would've exited the surface at a distance

- Specific shader techniques that do take this into account are known as subsurface scattering techniques that significantly improve the visual quality of materials like skin, marble or wax but come at the price of performance

- An additional subtlety when it comes to reflection and refraction are surfaces that are metallic. Metallic surfaces react different to light compared to non-metallic surfaces (also known as dielectrics)

- Metallic surfaces follow the same principles of reflection and refraction but all refracted light gets directly absorbed without scattering. This means metallic surfaces only leave reflected or specular light; metallic surfaces show no diffuse colors. This leads to both materials being treated differently in the PBR pipeline

- The distinction between reflected and refracted light brings us to another observation regarding energy preservation: they're mutually exclusive. Whatever light energy gets reflected will no longer be abosorbed by the material itself. Thus, the energy left to enter the surface as refracted light is directly resulting energy after we've taken reflection into account

- We preserve this energy conserving relation by first calculating the specular fraction that amounts to the percentage the incoming light's energy is reflected. The fraction of the refracted light is then directly calculated from the specular fraction but subtracting the previously calculated number for from 1.0

- This ensures that all the light values sum up to 1.0

- The render equation is an elaborate equation used to simulate the visuals of light. PBR strongly follows a more specialized version of the render equation known as the reflectance equation. To properly understand PBR, having a strong understading of the reflectance equation is important

- The reflectance equation:
  - Lo(p,ωo)=∫Ω fr(p,ωi,ωo) ⋅ Li(p,ωi)n ⋅ ωidωi

- To understand the reflectance equation, we need to understand radiometry

- Radiometry is the measurement if electromagnetic radiation including visible light. There are several radiometric quantities we can use to measure light over surfaces and directions but will focus on one that relevant to the reflectance equation known as radiance denoted as "L"

- Radiance is used to quantify the magnitude or strength of light coming from a single direction. It is the combination of multiple physical quantities:

  - Radiant Flux

    - radiant flux (Φ) is the transmitted energy of a light source measured in Watts. Light is a collective sum of energy over multiple different wavelengths, each wavelength associated with a particular visible color

    - The emitted energy of a light source can therefore by thought of as a function of all its different wavelengths. Wavelengths between 390nm to 700nm are considered part of the visible light spectrum i.e. wavelengths the human eye is able to percieve

    - The radiant flux measures the total area of this function of different wavelengths. Directly taking this measure of wavelengths as input is slightly impractical so we often make the simplification of representing radiant flux not as a function of varying wavelength strengths but as a light color tripplet encoded as RGB ( or as we'd commonly call it: light color). This encoding does come at quite a loss of information but this is generally negligible for visual aspects

  - Solid Angle

    - The solid angle denoted as ω, tells us the size or area of a shape projected onto a unit sphere. The area of the projected shape onto this unit sphere is known as the solid angle; you can visualize the solid angle as a direction with volume. Think of being an observer at the center of this unit sphere and looking in the direciton of the shape; the size of the silhouette you make out is the solid angle

  - Radiant Intensity

    - Radiant intensity measures the amount of radiant flux per solid angle or the strength of a light source over a projected area onto the unit sphere. For instance, given an omnidirectional light that radiates equally in all directions, the radiant intensity can give us its energy over a specific area (solid angle)

    - The equations to describe the radiant intensity is: I=dΦ/dω, where I is the radiant flux Φ over the solid angle ω

- With the knowledge of radiant flux, radiant intensity and the solid angle, we can finally describe the equation for radiance

- Radiance is described as the total observed energy in an area A over the solid angle ω of a light of radiant intensity Φ

  - L = (d^2) * Φ / dA*dω*cosθ

  - Radiance is a radiometric measure of the amount of light in an area scaled by the incident (or incoming) angle θ of the light to the surface's normal as cosθ

- Light is weaker the less it directly radiates onto the surface and strongest when it is directly perpendicular to the surface. This is similar to our perception of diffuse lighting as cosθ directly corresponds to the dot product between the light's direction vector and the surface normal

- The radiance equation is quite useful as it ocntians most physcial quantities we're interested in. If we consider the solid angle ω and the area A to be infinitely small, we can use radiance to measure the flux of a single ray of light hitting a single point in space.

- This relation allows us to calculate the radiance of a single light ray influencing a single (fragment) point; we effectively translate the solid angle ω into a direction vector ω and A into a point p. This way we can directly use radiance in our shaders to calculate a single light ray's per-fragment contribution

- In fact when it comes to radiance, we generally care about all incoming light onto a point p, which is the sum of all radinace known as irradiance

- With knowledge knowledge of radiance and irradiance, we can get back to the reflectance equation:

  - Lo(p,ωo)=∫Ωfr(p,ωi,ωo)Li(p,ωi)n⋅ωidωi

- We know that L in the render equation represents the radiance of some point p and some incoming small solid angle ωi which can be thought of as an incoming direction vector ωi

- Remember that cosθ  scales the energy based on the light's incident angle to the surface, which we find in the reflectance equation n ⋅ ωi

- The relfectance equation calculates the sum of reflected radiance Lo(p,ωo) of a point p in the direction ωo which is the outgoing direction to the viewer

- Or to put it differently, Lo measures the reflected sum of the lights' irradiance into point p as viewed from ωo

- The reflectance equation is based on irradiance, which is the sum of all incoming radiance we measure light of. Not just of a single incoming light direction, but of all incoming light directions within a hemisphere Ω centered around point p. A hemisphere can be described as half a sphere aligned around a surface's normal n

- To calculate the total of values inside an area or in the case of the hemisphere, inside the volume, we use an integral ∫ over all incoming directions dωi within the hemisphere Ω

- An integral measures the area of a function which can either be calculated analytically or numerically. As there is no analytical solution to both the render and reflectance equation, we'll want to numericlly solve the integral discretely

- This translates to taking the result of small discrete steps of the reflectance equation over the hemisphere Ω and averaging their results over the step size. This is known as the Riemann sum

- Taking discrete steps will always give us an approximation over the function and we can increase the accuracy of the sum by increasing the number of steps

- The reflectance equation sums up the radiance of all incoming light directions ωi
over the hemisphere Ω scaled by fr that hit point p and returns the sum of reflected light Lo in the viewer's direction. The incoming radiance can come from light sources, or from an environment map measuring the radiance of every incoming direction

- The final symbol to analyze in the equation is the fr symbol known as the BRDF or bidirectional reflective distribution function that scales or weighs the incoming radiance based on the surface's material properties

- The bidirectional reflective distribution function (BRDF) is a function that takes as input the incoming light direction "wi", the outgoing view direction "wo", the surface normal "n", and a surface parameter "a" that represents the microsurface's roughness

- The BRDF approximates how each individual light ray "wi" contributes to the final reflected light of an opaque surface given its material properties. For instance, if the surface has a perfectly smooth surface (~like a mirror), the BRDF function would return 0.0 for all incoming light rays "wi" except the one ray that has the same reflected angle as the outgoing ray "wo" at which the function returns 1.0

- A BRDF approximates the material's reflective and refractive properties based on the previously discussed microfacet theory. For a BRDF to be physically plausible it has to respect the law of energy conversion i.e. the sum of reflected light should never exceed the amount of incoming light

- Technically, Blinn-Phong is not considered physically based as it doesn't adhere to the energy conservation principle

- There are several physically based BRDFs out there to approximate the surface's reaction to light. However, almost all real-time PBR render pipelines use a BRDF known as Cook-Torrance BRDF

- The Cook-Torrance BRDF contains both a diffuse and a specular part:

  - fr = (kd . f_lambert) + (ks . f_cook−torrance)

- Here "kd" is the ealier mentioned ratio of incoming light energy that gets refracted with "ks" being the ratio that gets reflected. The left side of the BRDF states the diffuse part of the equation denoted here as f_lambert

- This is known as Lambertian diffuse similar to what we used for diffuse shading, which is constant factor denoted as : f_lambert = c/pi, with c being the albedo or surface color (think the diffuse surface texture). The divide by pi is there to normalize the diffuse light as the earlier denoted integral that contains the BRDF is scaled by pi

- The way the Lambertina diffuse relates to the diffuse lighting that we've been using is that it is the surface color multiplied by the dot prodcut between the surface's normal and light direction. The dot product is still there but moved out of the BRDF as we find n . wi at the end of the Lo integral

- There exist different equations for the diffuse part of the BRDF which tend to look more realistic but are also more computationaly expensive. As concluded by Epic Games however, the Lambertian diffuse is sufficient enough for most real-time rendering purposes

- The specular part of the BRDF is a bit more advanced and is described as:

  - f_CookTorrance = DFG / 4(ωo⋅n)(ωi⋅n)

- The Cook-Torrance specular BRDF is composed of three functions and a normalization factor in the denominator. Each of the D, F and G symbols represent a type of function that approximates a specific part of the surface's reflective properties

- These are defined as the normal Distribution Function (D), the Fresnel equation (F) and the Geometry function:

  - Normal Distribution function: this approximates the amount the surface's microfacets are aligned to the halfway vector, influenced by the roughness of the surface; this is the primary fucntion approximating the microfacets

  - Geometry function: describes the self-shadowing property of the microfacets. When a surface is relatively rough, the surface's microfacets can overshadow other microfacets reducing the light surface reflects

  - Fresnel equation: The Fresnel equation describes the ratio of surface reflection at different surface angles

- Each of these functions is an approximation of their physics equivalent and there'll be more than one version of each that aims to approximate the underlying physics in different ways; some more realistic, others more efficient

- The functions that will be used are

  - Trowbridge-Reitz GGX for D

    $$a^2 / \pi (((\mathbf{n} \cdot \mathbf{h})^2 * a^2 - 1) + 1)^2$$

    - Here h is the halfway vector to measure against the surface's microfacets, with "a" being a measure of the surface's roughness.

    - The normal distribution function D statistically approximates the relative surface area of microfacets exactly aligned to the halfway vector "h". The Trowbridge-Reitz GGX is used in our studies. When the roughness is low (thus the surface is smooth), a highly concentrated number of microfacets are aligned to the halfway vectors over a small radius.

    - Due to this high concentration, the NDF displays a very bright spot. On a rough surface however, where the microfacets are aligned in much more random directions, you'll find a much larger number for halfway vectors "h" somewhat aligned to the microfacets (but will be less concentrated)

  - Smith's Schlick-GGX for G

    - The geometry function statistically approximates the relative surface area where its mirror surface details overshadow each other causing light rays to be occluded

    - Similar to the NDF, the geometry function takes a materials roughness parameter as input with rougher surfaces having a higher probability of overshadowing microfacets

    - The geometry function we'll use:
        $$ GSchlickGGX(n,v,k) = \frac{n \cdot v}{(n \cdot v)(1-k) + k}$$

      - Here "k" is a remapping of "a" based on whether we're using the geometry function for either direct lighting or IBL:

        $$ kdirect=(α+1)^2/8$$

        $$ kIBL=α^2/2$$

      - Note that the value of "a" may differ based on how your engine translates roughness to "a"

      - TO effectively approximate the geometry, we need to take account of both the view direction (geometry obstruction) and the light direction vector (geometry shadowing)

      - We take both into account using Smith's method:
          $$G(n,v,l,k)=Gsub(n,v,k)Gsub(n,l,k)$$

  - Fresnel-Schlick approximation for F

    - The Fresnel equation describes the raio of light that gets reflected over the light thaat get refracted, which varies over the angle we're looking at a surface

    - The moment light hits a surface, based on the surface-to-view angle, the Fresnel equation tells us the percentage of light that gets reflected

    - From this ratio of reflection and the energy conservation principle, we can directly obtain the refracted portion of the light

    - Every surface or mateiral has a level of base reflectivity when looking straight at its surface, but when looking at the surface from an anlge all relfection become more apparent comapared to the surface's base reflectivity

    - All surfaces theoretically reflect light if seen from perfect 90-degree angles. This phenomenom is known as Fresnel and is described by the Fresnel equation

    - The Fresnel equation:

        $$FSchlick(h,v,F0)=F0+(1−F0)(1−(h⋅v))^5$$

    - F0 represents the base reflectivity of the surface, which we calculate using something called the indices of refraction or IOR

    - There are a few subtelities involved with the Fresnel equation

    - One is that the Fresnel-Schllick approximation is only really defined for dielectric or non-metal surfaces. For conductor surfaces (metals), calculating the based reflectivity with the indices of refreaction doesn't properly hold and we need to use a different Fresnel Equation for conductors altogether

    - As this is incovinient, we further approximate by pre-computing the surface's response at normal incidence (F0) at a 0 degree angle as if looking directly onto a surface

    - We interpolate this value based on the view angle, as per the Fresnel-Schlick approximation such that we can use the same equation for both metals and non-metals

    - What is interesting to observe here is that for all dielectric surfaces the base reflectivity never gets above 0.17 which is the exception rather than the rule, while for conductors the base reflectivity starts much higher and mostly varies between 0.5 and 1.0

    - Furthermore, for conductors (or metallic surfaces) the base reflectivity is tinted. This is why F0 is presented as RGB triplet (reflectivity at normal incidence can vary per wavelength). This is something we only see at metallic surfaces

    - These specific attributes of metallic surfaces compared to dielectric surfaces gave rise to something called the metallic workflow

    - In the metallic workflow, we author surface materials with an extra parameter known as the "metalness" that describes whether a surface is either metallic or a non-metallic surface

    - Theoretically, the metalness of a material is binary: it's either a metal or it isn't; it can't be both. However, most render pipelines allow configuring the metalness of a surface linearly between 0.0 and 1.0. This is mostly because of the lack of material textrure precision. For instance, a surface having small (non-metal) dust/sand-like particles/scratches over a metallic surface is difficult to render with binary metalness values

    - By pre-computing F0 for both dielectrics and conductors, we can use the same Fresnel-Schlick approximation for both types of surfaces but we do have to tint the base reflectivity if we have a metallic surface

    - We defne a base reflectivity that is approximated for most dielectric surfaces. This is yet another approximation as F0 is averaged aroundf most common dielectrics. A base relfectivity of 0.04 holds for most dielectrics and produces physically plausible results without having to author an additional surface parameter

    - Then, based on how metallic a surface is, we either take the dielectric based reflectivity or take F0 authored as the surface color. Because metallic surfaces absorb all refracted light they have no diffuse reflections and we can directly use the surface color texture as their base reflectivity

- The Final Cook-Torrance equation then becomes

    $$Lo(p,\omega_o)=\int_\Omega\left(k_d\frac{c}{\pi}+DFG/4(\omega_o\cdot n)(\omega_i\cdot n)\right)L_i(p,\omega_i)n\cdot\omega_id\omega_i$$

- This equation now completely describes a PBR render model

- Each of the surface parameters we need for a PBR pipeline can be defined or modeled by textures

- Using textures gives us a per-fragment control over how each specific surface should react to light: whether that point is metallic, rough or smooth, or how the surface responds to different wavelengths of light

- The list of textures found in a PBR pipeline include:

  - Albedo
    - The albedo texture specifies for each texel the color of the surface, or the base reflectivity if that texel is metallic. This is largely similar to the diffuse texture in non-PBR rendering done earlier but all lighting information is extracted from the texture

    - Diffuse textures often have slight shadows or darkened crevices inside the image which is something you don't want in an albedo texture; it should only contain the color ( or refracted absoprtion coefficients) of the surface

  - Normal

    - The normal map allows use to specify, per fragment, a unique normal to give the illusion that a surface is bumpier than its flat counterpart

  - Metallic

    - The metallic map specifies per texel whether a texel is either metallic or it isn't. Based on how the PBR engine is set up, artists can author metalness as either grayscal values or as binary black or white

  - Roughness

    - The roughness map specifies how rough a surface is on a per texel basis. The sampled roughness value of the roughness influences the statistical microfacet orientations of the surface. A rougher surface get wider and blurrier reflection while a smooth surface gets focused and clear reflections. Some PBR engines expect a smoothness map instead of a roughness map which some artists find more intuitive. These values are then translated (1.0 - smoothness) to roughness the moment they are sampled

  - Ambient Occlusion:

    - The AO map specifies extra shadowing factor of the surface and potentially surrounding geometry. If we have a brick surface for instance, the albedo texture should have no shadowing information inside the brick's crrevices. The AO map however does specify these darkened edges as it's more difficult for light to escape. Taking AO in account at the end of the lighting stage can significantly boost the visual quality of your scene. The ambient occlusion map of a mesh/surface is either manually generated or pre-caculated in in 3D modelling programs

#### Lighting-PBR

- Having derived the full reflectance equation, we now know mostly what's going on but what still remains a big unknown is how exactly we're going to represent irradiance, the total radiance L of the scene.

- We know that radiance L (as interpreted in computer graphics land) measures the radiant flux ϕ or light energy of a light source over a given solid angle ω. In our case we assumed the solid angle ω to be inifinitely small in which case radiance measures the flux of a light source over a single light ray

- Given this knowledge, how do we translate this into some of the lighting knowledge we've previously accumulated?

- Imagine we have a single point light (a light source that shine equally bright in all directions) wiht a radiant flux of (23.47, 21.31, 20.79) as translated to an RGB triplet.

- The radiant intensity of this light source equals its radiant flux at all outgoing direction rays. However, when shading a specific point "p" on a surface, of all possible incoming light directions over its hemisphere Ω, only one incoming direction vecotor wi directly comes from the point light source

- As we only have a single light source in our scene, assumed to be a single point in space, all other possible incoming light directions have zero radiance observed over the surface point "p"

- If at first we assume that light attenuation (dimming of light over a distance) does not affect the point light source, the radiance of the incoming light ray is the same regardless of where we position the light (excluding scaling the radiance by the incident angle cosθ)

- This is because the point light has the same raidant intensity regardless of the angle we look at it, effectively modeling its radiant intensity as its radiant flux: a constant vector (23.47, 21.31, 20.79)

- However, radiance also takes a position "p" as input and as any realistic point light source takes light attenuation into account, the radiant intensity of the point light source is scaled by some measure of the distance between point p and the light source

- Then, as extracted from the original radiance equation, the result is scaled by the dot product between the surface normal n and the incoming light direction wi

- In more practical terms: in the case of a direct point light, the radiance function L measures the light color attenuated over its distance to p and scaled by n*wi, but only over the single light ray wi that hit p which equals the light's direction vector from p

- When it comes to direct lighting, radiance is calculated similiarly to how we've calculated lighting before as only a single ligfht direction vector contributes to the surface's radiance

- Note that this assumptions holds as point light are inifinitely small and only a single point in space. If we were to model a light that has area or volume, its radiance would be non-zero in more than one incoming light direction

- For other types of light sources originating from a single point we calculate the radiance similarly. For instance, a directional light source has a constant wi, without an attenuation factor. And a spotlight would not have a constant radiant intensity but one that is scaled by the forward direction vector of the spotlight

- This also brings us back to the integral over the surface's hemisphere. As we know beforehand the single locations of all the contributing light sources while shading a single surface point, it is not required to try and solve the integral

- We can directly take the known number of light sources and calculate their total irradiance, given that each light source ahs onlyu a single light direction that influences the surface's irradiance

- This makes PBR on direct light source relatively simple as we effectively only have to loop over the contributing light sources. When we later take environment lighting into account, we do have to take the integral into account as light can come from any direction

#### IBL_Diffuse Irradiance

- Image based lighting or IBL is a collection of techniques to light objects not by direct analytical lights but by treating the surrounding environment as one big light source

- This is generally accomplished by manipulating a cubemap environment map (taken from the real world or generated from a 3D scene) such that we can directly use it in our lighting equations: treating each cubemap texel as a light emitter

- This way we can effectively capture an environment's global lighting and general feel, giving objects a better sense of belonging in a environment

- As image based lighting algorithms capture the lighting of some global environment, its input is considered a more precise form of ambient lighting, even a crude approximation of global illumination

- This makes IBL interesting for PBR as objects look signifincantly more physically accurate when we take the environment's lighting into account

- Recall from the reflectance equation study and derivation, that main goal of that exercise is to solve the integral of all incoming light directions wi over the hemisphere. Solving the integral is easy when we have a discrete number of light directions that contribute to the integral

- In the case of IBL however, every incoming light direction wi from the surrounding environment could potentially have some radiance making it less trivial to solve the integral

- This gives us two main requirements to solve the integral
  1. We need some way to retrieve the scene's radiance given any direction wi
  2. Solving the integral needs to be fast and real-time

- The first requirement is relatively easy because one way to represent an environment or scene's irradiance is in the form of a processed environment cubemap. Given such a cubemap, we can visualize every texel of the cubemap as one single emitting light source

- By sampling this cubemap with any direction vector wi, we retrieve the scene's radiance from that direction

- Solving this integral requires us to sample the environment map from not just one direction but all possible directions wi over the hemisphere which is far too expensive for each fragment shader invocation

- To solve the integral in a more efficient fashion we'll want to pre-process or pre-compute most of the computations

- Recall from the reflectacne equation that the diffuse and specular components are independent of each other and so the integral can be split in two parts (diffuse part and specular part)

- Extracting the constant terms from the diffuse integral, we realize that the integral only depends on wi (assuming p is in the center of the environment map). With this knowledge, we can calculate or pre-compute a new cubemap that stores in each sample direction (or texel) wo the diffuse integral's reuslt by convolution

- Convolution is applying some computation to each entry in a data set considering all other entries in the data set; the data set being the scene's radiance or environment map. Thus for every sample direction in the cubemap, we take all other sample directions over the hemisphere into account

- To convolute an environment map we solve the integral for each output wo sample direction by discretely sampling a large number of directions wi over the hemisphere and averaging the radiance. The hemisphere we build the sample directions wi from is oriented towards the output "wo" sample direction we're convoluting

- This precomputed cubemap that for each sample direction wo stores the integral result can be thought of as the pre-computed sum of all indirect diffuse light of the scene hitting some surface aligned along direction "wo"

- Such a cubemap is known as an irradiance map seeing as the convoluted cubemap effectively allows us to directly sample the scene's (pre-computed irradiance) from any direction "wo"

- The radiance equation also depends on position p, which we've assumed to be the center of the irradiance map. This does mean all diffuse indirect light must come from a single environment map which may break the illusion of reality especially indoors

- Render engines solve this by placing reflection probes all over the scene where each relfection probe calculates its own irradiance map of its surroundings

- This way, the irradiance and radiance at position p is the interpolated irradiance between its closest reflection probes

- By storing the convoluted result in each cubemap texel (in the direction of wo), the irradiance map displays somewhat like an average color or lighting display of the environment. Sampling any direction from this environment map will give us the scene's irradiance in that particular direction

- In a PBR pipeline, it's incredibly important to take the high dynamic range of your scene's lighting into account

- As PBr bases most of its inputs on real physical properties and measurements it makes sense to closely match the incoming light values to their physical equivalents. Whether we make educated guesses on each light's radiant flux or use their direct physical equivalent, the difference between a simple light bulb or the sun is significant either way

- Without working in an HDR environment, its impossible to correctly specify each light's relative intensity

- For IBL, since we base the environment's indirect light intensity on the color values of an environment cubemap we need some way to store the lighting's high dynamic range into an environment map

- Standard environment maps used for cubemaps are in LDR. We directly use their color values from the individual face images, ranged between 0.0 and 1.0, and processed them as is. While this may work fine for visual output, when taking them as physical input parameters it's not going to work

- This leads us to the radiance file format

- The radiance file format stores a full cubemap with all 6 faces as floating point data. This allows us to specify color values outside the 0.0 to 1.0 range to give lights their correct color intensities

- The file format also uses a clever trick to store each floating point value, not as a 32 bit value per channel but 8 bits per channel using the color's alpha channel as an exponent (this does come with a loss of precision)

- This works quite well but requires the parsing program to re-convert each color to their floating point equivalent

- The environment map is projected from a sphere onto a flat plane such that we can more easily store the environment into a single image known as an equirectangular map

- This does come with a small caveat as most of the visual resolution is stored in the horizontal view direction while less is preserved in the bottom and top directions

- In most cases this is a decent compromise as with almost any renderer you'll find most of the interesting light and surroundings in the horizontal viewing directions

- As described earlier, the main goal is to solve the integral for all diffuse indirect lighting given the scene's irradiance in the form a cubemap environment map. We know that we can get the radiance of the scene in a particular direction by sampling an HDR environment in direction wi. To solve the integral, we have to sample the scene's radiance from all possible directions within the hemisphere

- It is however computationally impossible to sample the environment's lighting from every possible direction in the hemisphere, the number of possible directions is theoretically infinite

- We can however approximate the number of directions by taking a finite number of directions or samples spaced uniformly or taken randomly from within the hemisphere to get a fairly accurate approximation of the irradiance effectively solving the integral discretely

- It is however still too expensive to do this for every fragment in real-time as the number of samples needs to be significantly large for decent results, so we want to pre-compute this. Since the orientation of the hemisphere decides where we capture the irradiance, we can pre-calculate the irradiance for every possible hemisphere orientation oriented around all outgoing directions "wo"

- Givne any direction vector "wi" in the lighting pass, we can then sample the pre-computed irradiance map to retrieve the total diffuse irradiance from direction "wi". To determine the amount of indirect diffuse (irradiant) light at a fragment surface, we retrieve the total irradiance from the hemisphere oriented around its surface normal

- To generate the irradiance map, we need to convolute the environment's lighting as converted to a cubemap. Given that for each fragment the surface's hemisphere is oriented along it's surface normal vector, convoluting a cubemap equals calculating the total averaged radiance of each direction wi in the hemisphere oriented along the surface normal

- There are many ways to convolute the environment map but one way is to generate a fixed amount of sample vectors for each cubemap texel along a hemisphere oriented around the sample direction and average the results

- The fixed amount of sample vectors will be uniformly spread inside the hemisphere. Note that this will be an approximation since an integral is continous and we are discretely sampling its function given a fixed amount of sample vectors. The more sample vectors we use, the better we approximate the integral

- The integral of the reflectance equation revolves around the solid angle "dw" which is rather diffcult to work with. Instead of integrating over the solid angle we'll integrate over its equivalent spherical coordinates θ and ϕ

- We use the polar azimuth ϕ angle to sample around the ring of the hemisphere between 0 and 2π , and use the inclination zenith θ angle between 0 and 12π to sample the increasing rings of the hemisphere

- This will give us the updated reflectance integral

$$ Lo(p, \phi_o, \theta_o) = k_d\frac{c}{\pi} \int\limits_{\phi=0}^{2\pi} \int\limits_{\theta=0}^{\frac{\pi}{2}} L_i(p, \phi_i, \theta_i) \cos(\theta) \sin(\theta) d\phi d\theta $$

- Recall from earlier in the notes that this is only for the diffuse portion

- Solving the integral requires us to take a fixed number of discrete samples within the hemisphere and averaging the results. This translates the integral to the following discrete version based on the Reimann sum given n1 and n2 discrete samples each spherical coordinate respectively
  $$ Lo(p,\phi_o,\theta_o) = k_d\frac{c}{\pi}\sum\limits_{\phi=0}^{n_1} \sum\limits_{\theta=0}^{n_2} L_i(p, \phi_i, \theta_i) \cos(\theta) \sin(\theta) d\phi d\theta $$

#### IBL_Specular IBL

- Recall, that we split the reflectance equation into the diffuse and specular portions

- The reflectance equation stated again:
    $$Lo(p,\omega_o) = \int_\Omega \left(k_d\frac{c}{\pi} + k_s \frac{DFG}{4} (\omega_o \cdot n)(\omega_i \cdot n)\right)L_i(p, \omega_i) n \cdot \omega_i d\omega_i$$

- The Cook-Torrance specular portion (multipled by k_s) isn't constant over the integral and is dependent on the incoming light direction, but also the incoming view direction. Trying to solve the integral for all incoming light direction including all possible view directions is a combinatorial overload and way too expensive to calculate on a real-time basis

- Epic Games proposed a solution where they were able to pre-convolute the specualr part for real-time purposes, given a few compromises, known as the split-sum approximation

- The split sum approximation splits the specular part of the reflectance equation into two seperate parts that we can individually convolute and later combine in the PBR shader for specular indirect image based lighting

- Similar to how we pre-convolute the irradiance map, the split sum approximation requires an HDR environment map as its convolution input

- To understand the split sum approximation we'll look again at the reflectance equation but this time focus on the specular part

    $$Lo(p,\omega_o)=\int_\Omega\left(k_s\frac{DFG}{{4}(\omega_o\cdot n)(\omega_i\cdot n)}\right)L_i(p,\omega_i)n\cdot\omega_id\omega_i=\int_\Omega f_r(p,\omega_i,\omega_o)L_i(p,\omega_i)n\cdot\omega_id\omega_i$$

- For the same performance reasons as the irradiance convolution, we can't solve the specular part of the integral in real time and expect a reasonable performance

- So preferably we'd pre-compute this integral to get something like a specular IBL map, sample this map with the fragment's normal and be done with it

- However, this is where it gets a bit tricky. We were able to pre-compute the irradiance map as the integral only depended on "wi" and we could move the constant diffuse albedo terms out of the integral

- This time, the integral depends on more than just "wi" as evident form the BRDF:
  $$ fr(p,\omega_i,\omega_o)=\frac{DFG}{4}(\omega_o \cdot n)(\omega_i \cdot n) $$

- The integral is also depends on "wo" and we can't really sample a pre-computed cubemap with two direction vectors

- The position "p" is irrelevant due to assuming that it will be located at the center of the hemisphere

- Precomputing this integral for every combination of "wi" and "wo" isn't practical in a real-time setting

- The split-sum approximation solves this by splitting the pre-computation into 2 individual parts that we can later combine to get the resulting pre-computed result we're after

- The split-sum approximation splits the specular integral into two seperate integrals as follows:
    $$Lo(p,\omega_o)=\int_\Omega L_i(p,\omega_i)d\omega_i \ast \int_\Omega f_r(p,\omega_i,\omega_o)n\cdot\omega_id\omega_i$$

- The first part when pre-convoluted is known as the pre-filtered environment map which is (similar to the irradiance map) a pre-computed environment convolution map, but this time taking roughness into account

- For increasing roughness levels, the environment map is convoluted with mare scattered smaple vectors creating blurrier reflections

- For each roughness level we convolute, we store the sequentially blurrier results in the pre-fiktered map's mipmap levels

- We generate the sample vectors and their scattering amount using the normal distribution function (NDF) of the Cook-Torrance BRDF that takes as input both a normal and a view direction. As we don't know beforehand the view direction when convoluting the environment map, Epic Games makes a further approximation by assuming the view direction (and thus the specular reflection direction) to be equal to the output sample direction "wo"

- This way, the pre-filtered environment convolution doesn't need to be aware of the view direction. This does mean we don't get nice grazing specualr reflections when looking at specular surface reflections from an angle

- The second part of the split sum equation equals the BRDF part of the specular integral

- If we pretend the incoming radiance is completely white for every direction  (thus L(p,x)=1.0) we can pre-calculate the BRDF's response given an input roughness and an input angle between the normal n and light direction wi or "n * wi"

- Epic Games stores the pre-computed BRDF's response to each normal and light direction combination on varying roughness values in a 2D lookup texture (LUT) known as the BRDF integration map. The 2D lookup textures outputs a scale (red) and a bias value (green) to the surface's Fresnel response giving us the second part of the split specular integral

- We egenrate the lookup texture by treating the horizontal texture coordinate (ranged between 0.0 to 1.0) of a plane as the BRDF's input "n*wi" and its vertical texture coordinate as the input roughness value

- Pre-filtering an environment map is quite similar to how we convoluted an irradiance map. The difference being that we now account for roughness and store the sequentially rougher reflections in the pre-filtered maps mip's level

- First we need to generate a new cubemap to hold the pre-=filtered environment data. To make sure we allocate enough memeory for its mip level we call glGenerateMipmap as an easy way to allocate the required amount of memory

- We store the pre-filtered specular resolutions in a per-face resolution of 128 by 128 at its base mip level. This is likely to be enough for most reflections , but if you have a large number of smooth materials (think car reflections) you may want to increase the resolution

- Recall that we convoluted the environment map by generating sample vectors uniformaly spread over the hemisphere using spherical coordinates

- While this works just fine for irradiance, for specular reflections, it's less effcient

- When it comes to specular reflections, based on the roughness of the surface, the light relfects closely or roughly around a relfection vector "r" over a normal "n" but (unless the surface is extremely rough) around the reflection vector

- The general shape of possible outgoing light reflections is known as the specular lobe. As roughness increases, the specular lobe's size increases and the shape of the specular lobe changes on varying incoming light directions. The shape of the specular lobe is this highly dependent on the material

- When it comes to the microsurface model, we can imagine the specular lobe as the reflection orientation about the microfacet halfway vectorsgiven some incoming light direction

- Seeing as most light rays end up in a specular lobe relfected around the microfacet halfway vectors, it makes sense to generate the sample vectors in a similar fashion as most would otherwise be wasted. This proces is known as importance sampling

- To get a full grasp of importance sampling, it's relevant we first delve into the mathematical construct known as Monte Carlo integration

- Monte Carlo integration revolves mostly around a combination of statistics and probability theory

-It helps us in discretely solving the problem of figuring out some statistic or value of a population without having to take all of the population into consideration

- For  instance, let's say you want to count the average height of all citizens of a country. To get your result, you could measure eveyr citizen and average their height which will give you the exact answer you're looking for

- However, since most countries have a considerable population this isn't a realistic approach as it would take too much time and effort

- A different approach is to pick a much smaller completely random (unbiased) subset of this population, measure their height and average the result. This population could be as small as a 100 people

- While not as accurate as the exact answer, you'll get an answer that is relatively close to the ground truth. This is known as the law of large numbers

- The idea is that if you measure a smaller set of size N of truly random samples from the total population, the result will be relatively close to the true answer and gets close as the number of samples N increases

- Monte Carlo integration builds on this law of large numbers and takes the same approach in solving an integral. Rather than solving an integral for all possible (theoretically inifinite) sample values x, simply generate N sample values randomly picked from the total population and average

- As N increases, we're gauranteed to get a result closer to the exact answer of the integral

    $$ O=\int_{a}^{b}f(x)dx=\frac{1}{N}\sum_{i=0}^{N-1}f(x)\frac{pdf(x)}{p} $$

- To solve the integral, we take N random samples over the population from a to b, add them together and divide by the total number of samples to average them

- The pdf stands for the probability density function that tells us the probability a specific sample occurs over the total sample set

- When it comes to Monte Carlo integration, some samples may have a higher probability of being generated than others. This is why for any general Monte Carlo estimation, we divide or multiply the sampled value by the sample probability according to a pdf

- So far, in each of the cases of estimating an integral, the smaples we've generated were unifomr, having the exact same chance of being generated

- Our estimations so far were unbiased, meaning that given an ever-increasing amount of samples we will eventually converge to the exact solution of the integral

- However, some Monte Carlo estimators are biased, meaning that the generated samples aren't completely random, but focused towards a specific value or direction

- These biased Monte Carlo estimators have a faster rate of convergence, meaning they converge to the exact solution at a much faster, but due to their biased nature it's likely they won't ever converge to the exact solution

- This is generally an acceptable tradeoff, especially in computer graphics, as the exact solution isn't too important as long as the results are visually acceptable

- Importance sampling, which uses a biased estimator, has generated samples that are biased towards a specfic direction in which case we account for this by multiplying or dividing each sample by the pdf

- Monte Carlo integration is quite prevalent in computer graphics as it's a fairly intuitive way to approximate continuous integrals in a discrete and efficient fashion: take any area/volume to sample over (like the hemisphere Ω), generate N amount of random samples within the area/volume, and sum and weigh every sample contribution to the final result

- There are multiple ways of generating random samples.By default, each sample is completely (pseudo)random as we're used to, but by utilizing certain properties of semi-random sequences we can generate sample vectors that are still random, but have interesting properties. For instance, we can do Monte Carlo integration on something called low-discrepancy sequences which still generate random samples, but each sample is more evenly distributed

- When using a low-discrepancy sequence for generating the Monte Carlo sample vectors, the process is known as Quasi-Monte Carlo integration. Quasi-Monte Carlo methods have a faster rate of convergence which makes them interesting for performance heavy applications

- Given the newly obtained knowledge of Monte Carlo and Quasi-Monte Carlo integration, there is an interesting property we can use for an even faster rate of convergence known as importance sampling

- Recall that when it comes to specular reflections, the reflected light vectors are constrained in a specular lobe with its size determined by the roughness of the surface

- Seeing as any quasi-randomly generated sample outside of the specular lobe isn't relevant to the specular integral it make sense to focus the sample generation to sample within the specular lobe at the cost of the making the Monte Carlo estimator biased

- This is in essence what importance sampling is about: generate sample vectors in some region constrained by the roughness oriented aorund the microfacet's halfway vector

- By combining Quasi-Monte Carlo sampling with a low-discrepancy sequence and biasing the sample vectors using importance sampling, we geta high rate of convergence

- Because we reach the solution at a faster rate, we'll need significantly fewer samples to reach an approximation that is sufficient enough

- In applying the knowledge from the notes above, we'll precompute the specular portion of the indirect reflectance equation using importance sampling given a random low-discrepancy sequence based on the Quasi-Monte Carlo methods

- The sequence we'll be using is known as the Hammersley Sequence. It is based on the Van Der Corput sequence which mirrors a decimal binary representation around its decimal point

- Not all OpenGL related drivers support bit operators (WebGL and OpenGL ES 2.0 for instance) in which case we'll have to use and alternative version of the Van Der Corput Sequence that doesn't rely on bit operators

- Instead of uniformly or randomly (Monte Carlo) generating sample vectors over the integral's hemisphere we'll generate samnlple vectors biased towards the general reflection orientation of the microsurface halfway vector based on the surface's roughness

- There are several render artifacts that are directly related to the pre-filter convolution:
  - Cubemap seams at high roughness

    - Sampling the pre-filter map on surfaces with a rough surface means sampling the pre-filter map on some of its lower mips levels

    - When sampling submaps, OpenGL by default doesn't linearly interpolate across cubemap faces. Because the lower mip levels are both of a lower resolution and the pre-fileter map in convoluted with a much larger sample lobe, the lack between-cube-face filtering becomes quite apparent

    - OpenGL gives us the option to properly filter across cubemap faces by enabling GL_TEXTURE_CUBE_MAP_SEAMLESS

  - Bright spots in the pre-filter convolution

    - Due to high frequency details and wildly varying light intensities in specular reflections, convoluting the specular reflections requires a large number of samples to properly account for the widly varying nature of the HDR environmental reflections

    - We already take a very large number of samples but on some environments it may still not be enouigh at some of the rougher mip levels in which casse you'll start seeing dotted patterns emrge around bright areas

    - One option is to further increase the sample count but this won't be enough for all environments

    - Another option is that we can reduce this artifact by (during the pre-filter convolution) not directly sampling the environment map but sampling a mip level of the environment map based on the integral's PDF and the roughness

- With the pre-filtered environment up and running, we can focus on the second part of the split-sum approximation: the BRDF

- Recall the specular split sum approximation
  $$Lo(p,\omega_o)=\int_\Omega L_i(p,\omega_i)d\omega_i \ast \int_\Omega f_r(p,\omega_i,\omega_o)n\cdot\omega_id\omega_i$$

- We've pre-computed the left part of the split sum apporximation in the pre-filter map over different roughness levels. The right side requires us to convolute the BRDF equation over the angle "n*wo", the surface roughness and Fresnel's F0

- This is similar to integrating the specular BRDF with a solid-white environment or a constant radiance "Li" of 1.0

- Convoluting the BRDF over 3 variables is a bit much, but we can try to move "F0" out of the specular BRDF equation

  $$ \int_\Omega f_r(p,\omega_i,\omega_o) n \cdot \omega_i d\omega_i = \int_\Omega \frac{f_r(p,\omega_i,\omega_o)}{F(\omega_o,h)}F(\omega_o,h)n \cdot \omega_i d\omega_i $$

- With F being the Fresnel equation. Moving the Fresnel denominator to the BRDF gives us the following equivalent equation

  $$\int_\Omega \frac{f_r(p,\omega_i,\omega_o)}{F(\omega_o,h)}F(\omega_o,h)n\cdot\omega_id\omega_i$$

- Substituting the right-most F wiht the Fresnel-Schlick approximation gives us:

  $$\int_\Omega \frac{f_r(p,\omega_i,\omega_o)}{F(\omega_o,h)}(F_0+(1-F_0)(1-\omega_o\cdot h)^5)n\cdot\omega_id\omega_i$$

- Let's replace (1−ωo⋅h)^5 by α to make it easier to solve for F0

  $$\int_\Omega \frac{f_r(p,\omega_i,\omega_o)}{F(\omega_o,h)}(F_0+(1-F_0)\alpha)n\cdot\omega_id\omega_i$$

  $$\int_\Omega f_r(p,\omega_i,\omega_o)\frac{F_0+\alpha-F_0*\alpha}{F(\omega_o,h)}n\cdot\omega_id\omega_i$$

  $$\int_\Omega f_r(p,\omega_i,\omega_o) \frac{F_0(1-\alpha) + \alpha}{F(\omega_o,h)} n \cdot \omega_i d\omega_i$$

- Then we split the Fresnel Function over two integrals

  $$\int_\Omega \frac{f_r(p,\omega_i,\omega_o)}{F(\omega_o,h)}(F_0\ast(1-\alpha))n\cdot\omega_id\omega + \int_\Omega \frac{f_r(p,\omega_i,\omega_o)}{F(\omega_o,h)}(\alpha) n\cdot\omega_id\omega_i$$

- This way, F0 is constant over the integral and we cna take F0 out of the integral. Next, we substitute α back to its original form giving up the final split sum BRDF equation

$$ F0 \int_\Omega f_r(p,\omega_i,\omega_o) (1 - (1 - \omega_o \cdot h)^5) n \cdot \omega_i d\omega_i + \int_\Omega f_r(p,\omega_i,\omega_o) (1 - \omega_o \cdot h)^5 n \cdot \omega_i d\omega_i $$

- The tow resulting integrals rperesent a scale and bias to F0 respectively. Note that as fr(p,ωi,ωo) already contains a term for F, they both cancel out , removing F from fr

- In a similar fashion to the earlier convoluted environment maps, we can convolute the BRDF equations on their inputs: the angle between n and wo, and the roughness

- We store the convoluted results in a 2D lookup texture (LUT) known as a BRDF integration map that we later us ein out PBR lighting shader to ge the final convoluted indirect specula result

- The BRDF convolution shader operates on a 2D plane, using its 2D textute coorindates directly as inputs to the BRDF convolution

### Helpful Links

- Another OpenGL tutorial series: <https://antongerdelan.net/opengl/>

- Link to the book for this repo: <https://learnopengl.com/>

- Another OpenGL Tutorial Series: <https://open.gl/introduction>

- OpenGL Documentation: <https://docs.gl/>

- GLFW Documentation: <https://www.glfw.org/docs/latest/>

- Calculating the Perspective and Orthographic Projection Matrixes <https://www.songho.ca/opengl/gl_projectionmatrix.html>

- Lightweight, cross-platform & full-featured shader IDE: <https://github.com/dfranx/SHADERed>

- Shader Toy: <https://www.shadertoy.com/>

- Understanding the Normal Matrix - <http://www.lighthouse3d.com/tutorials/glsl-12-tutorial/the-normal-matrix/>

- How-To Texture Wavefront (.obj) Models for OpenGL - <https://www.youtube.com/watch?v=4DQquG_o-Ac>

- Short Article on Image Kernels - <https://setosa.io/ev/image-kernels/>

- GLSL Built-in Variables - <https://www.khronos.org/opengl/wiki/Built-in_Variable_(GLSL)>

- OpenGL Wiki - <https://www.khronos.org/opengl/wiki/Main_Page>

- Gamma Correction Links:
  1. In-depth article from John Novak - <http://blog.johnnovak.net/2016/09/21/what-every-coder-should-know-about-gamma/>
  2. Another article from Cambridge in Color - <http://www.cambridgeincolour.com/tutorials/gamma-correction.htm>
  3. Article from David Rosen - <http://blog.wolfire.com/2010/02/Gamma-correct-lighting>
  4. Extra practical considerations - <http://renderwonk.com/blog/index.php/archive/adventures-with-gamma-correct-rendering/>

- Learning Modern 3D Graphics Programming - <https://paroj.github.io/gltut/>

- Learn Vulkan - <https://vulkan-tutorial.com/Introduction>

- Ray Tracing in One Weekend Book Series - <https://raytracing.github.io/>

- Physically Based Rendering Book- <https://www.pbr-book.org/>

- Shadow Mapping Links:
  1. Microsoft article with lots of techniques to improve the quality of shadow maps - <https://learn.microsoft.com/en-us/windows/win32/dxtecharts/common-techniques-to-improve-shadow-depth-maps?redirectedfrom=MSDN>
  2. Another shadow mapping tutorial by ogldev - <http://ogldev.atspace.co.uk/www/tutorial23/tutorial23.html>
  3. Opengl-tutorial shadow mapping - <https://www.opengl-tutorial.org/intermediate-tutorials/tutorial-16-shadow-mapping/>
  4. Ogldev Multi-pass shadow mapping with point light - <https://ogldev.org/www/tutorial43/tutorial43.html>

- Normal Mapping Links:
  1. Normal Mapping tutorial by ogldev - <http://ogldev.atspace.co.uk/www/tutorial26/tutorial26.html>
  2. TheBennyBox Normal Mapping Video Explanation - <https://www.youtube.com/watch?v=LIOPYmknj5Q>
  3. TheBennyBox Normal Mapping Video Mathematics Explanation - <https://www.youtube.com/watch?v=4FaWLgsctqY>
  4. Another normal mapping tutorial - <http://www.opengl-tutorial.org/intermediate-tutorials/tutorial-13-normal-mapping/>

- Video Tutorial of how Parallax Mapping Displacement works - <https://www.youtube.com/watch?v=xvOT62L-fQI>

- Efficient Gaussian blur with linear sampling - <https://www.rastergrid.com/blog/2010/09/efficient-gaussian-blur-with-linear-sampling/>

- How to do good bloom for HDR rendering - <https://kalogirou.net/2006/05/20/how-to-do-good-bloom-for-hdr-rendering/>

- OLDDev Deferred Shading Tutorial - <https://ogldev.org/www/tutorial35/tutorial35.html>

- Forward vs Deferred vs Forward+ Rendering with DirectX 11 (HLSL) - <https://www.3dgep.com/forward-plus/>

  - Github repo for GLSL implementation of the code above - <https://github.com/bcrusco/Forward-Plus-Renderer?tab=readme-ov-file>

- Jon Chapman graphics blog - <https://john-chapman-graphics.blogspot.com/>

- SSAO Articles:
  - Jon Chapman SSAO Tutorial - <https://john-chapman-graphics.blogspot.com/2013/01/ssao-tutorial.html>

  - Reconstructing position from depth

  - OGLDev tutorial on SSAO - <https://ogldev.org/www/tutorial46/tutorial46.html>

  - Another SSAO article - <https://mtnphil.wordpress.com/2013/06/26/know-your-ssao-artifacts/>

  - Getting position from depth - <https://mynameismjp.wordpress.com/2010/09/05/position-from-depth-3/>

- BRDF Specular Functions article - <https://graphicrants.blogspot.com/2013/08/specular-brdf-reference.html>

- PBR Links:

  - Site for the base reflectivity of materials - <https://refractiveindex.info/>

  - Background: Physics and Math of Shading - <https://blog.selfshadow.com/publications/s2013-shading-course/hoffman/s2013_pbs_physics_math_notes.pdf>

  - Real Shading in Unreal Engine 4 - <https://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf>

  - PBR Shader toy dem - <https://www.shadertoy.com/view/4sSfzK>

  - PBR introduction for artists - <https://marmoset.co/resources/>

  - Article on PBR - <http://www.codinglabs.net/article_physically_based_rendering.aspx>

  - Article on Cook-Torrance BRDF - <http://www.codinglabs.net/article_physically_based_rendering_cook_torrance.aspx>

  - Another PBR article - <http://blog.wolfire.com/2015/10/Physically-based-rendering>

  - Good Website for Graphics and PBR fundamentals - <https://www.scratchapixel.com/>

  - Short article on PBR - <http://www.codinglabs.net/article_physically_based_rendering.aspx>

  - Another article on PBR - <https://seblagarde.wordpress.com/2011/08/17/hello-world/>

  - Points on a hemisphere article - <http://holger.dammertz.org/stuff/notes_HammersleyOnHemisphere.html>

- PBR IBL links:
  - Light probe generation and BRDF authoring for physically based shading - <https://github.com/dariomanesku/cmftStudio> & <https://github.com/derkreature/IBLBaker>

  - Real Shading in Unreal Engine 4 - <https://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf>

  - Chetan Jags Image Based Lighting - <https://chetanjags.wordpress.com/2015/08/26/image-based-lighting/>

  - Moving Frostbite to Physically Based Rendering 3.0 - <https://seblagarde.wordpress.com/wp-content/uploads/2015/07/course_notes_moving_frostbite_to_pbr_v32.pdf>

  - Implementation Notes: Runtime Environment Map Filtering for Image Based Lighting - <https://placeholderart.wordpress.com/2015/07/28/implementation-notes-runtime-environment-map-filtering-for-image-based-lighting/>
