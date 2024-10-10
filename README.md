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
- [PBR](#pbr)
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

#### *Stencil Testing*

#### *Blending*

#### *Face culling*

#### *Framebuffers*

#### *Cubemaps*

#### *Advanced Data*

#### *Advanced GLSL*

#### *Geometry Shader*

#### *Instancing*

#### *Anti Aliasing*

### Advanced Lighting

### PBR

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
