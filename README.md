# README

This is a clone of <https://github.com/JoeyDeVries/LearnOpenGL> that allows you to build and run each individual example w/ CMake.

You should have Visual Studio installed. Use this link (<https://code.visualstudio.com/docs/cpp/config-msvc#_prerequisites>) and complete steps 1 to 3 of the prerequisites.

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
  - [Shaders](#shaders)

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

- Vertex Shader: This stage is customizable and it the first stage of the graphics pipeline. It takes as input a single vertex. The main purpose of the vertex shader is to transform 3D coordinates into different 3D coordinates (more on that later) and the vertex shader allows us to do some basic processing on the vertex attributes.

- Geometry Shader: The output of the vertex shader stage is optionally passed to the geometry shader. The geometry shader takes as input a collection of vertices that form a primitive and has the ability to generate other shapes by emitting new vertices to form new (or other) primitive(s). In this example case, it generates a second triangle out of the given shape.

- Shape Assembly: The primitive assembly stage takes as input all the vertices (or vertex if GL_POINTS is chosen) from the vertex (or geometry) shader that form one or more primitives and assembles all the point(s) in the primitive shape given; in this case two triangles.

- Rasterization: The output of the primitive assembly stage is then passed on to the rasterization stage where it maps the resulting primitive(s) to the corresponding pixels on the final screen, resulting in fragments for the fragment shader to use. Before the fragment shaders run, clipping is performed. Clipping discards all fragments that are outside your view, increasing performance. A fragment in OpenGL is all the data required for OpenGL to render a single pixel.

- Fragment Shader:  is to calculate the **final color** of a pixel and this is usually the stage where all the advanced OpenGL effects occur. Usually the fragment shader contains data about the 3D scene that it can use to calculate the final pixel color (like lights, shadows, color of the light and so on).

- Alpha Tests and Blending: This stage checks the corresponding depth (and stencil) value (we'll get to those later) of the fragment and uses those to check if the resulting fragment is in front or behind other objects and should be discarded accordingly. The stage also checks for alpha values (alpha values define the opacity of an object) and blends the objects accordingly. So even if a pixel output color is calculated in the fragment shader, the final pixel color could still be something entirely different when rendering multiple triangles.

- In modern OpenGL we are required to define at least a vertex and fragment shader of our own (there are no default vertex/fragment shaders on the GPU).

- Add notes related to VBO and VAO etcs.

#### *Shaders*

- Shaders are little programs that rest on the GPU. These programs are run for each specific section of the graphics pipeline. In a basic sense, shaders are nothing more than programs transforming inputs to outputs. Shaders are also very isolated programs in that they're not allowed to communicate with each other; the only communication they have is via their inputs and outputs.

- Shaders are written in the C-like language GLSL. GLSL is tailored for use with graphics and contains useful features specifically targeted at vector and matrix manipulation.

- Shaders always begin with a version declaration, followed by a list of input and output variables, uniforms and its main function.

- Each shader's entry point is at its main function where we process any input variables and output the results in its output variables.

- When we're talking specifically about the vertex shader each input variable is also known as a **vertex attribute**. There is a maximum number of vertex attributes we're allowed to declare limited by the hardware. OpenGL guarantees there are always at least 16 4-component vertex attributes available, but some hardware may allow for more which you can retrieve by querying GL_MAX_VERTEX_ATTRIBS. This often returns the minimum of 16 which should be more than enough for most purposes.

- GLSL has, like any other programming language, data types for specifying what kind of variable we want to work with. GLSL has most of the default basic types we know from languages like C: int, float, double, uint and bool. GLSL also features two container types that we'll be using a lot, namely vectors and matrices.

- Swizzling is a feature in GLSL (OpenGL Shading Language) and other shader languages that allows you to easily select and rearrange components of vectors.

### Lighting

### Model Loading

### Helpful Links

- <https://antongerdelan.net/opengl/>

- <https://learnopengl.com/>

- <https://open.gl/introduction>
