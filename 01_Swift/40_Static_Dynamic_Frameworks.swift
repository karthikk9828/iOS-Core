
/**
    There are two types of frameworks on iOS: static and dynamic.

    Static frameworks are pre-compiled libraries that are linked to your app during the build process. 
    This means that the framework code is included in the final app binary and cannot be updated or changed at runtime.

    Dynamic frameworks, on the other hand, are compiled libraries that are loaded at runtime. 
    This means that the framework code is not included in the app binary and can be updated or changed at runtime.

    Static Framework:

        A static framework is a library that contains compiled code (usually in the form of object files) linked directly into the binary of your application at build time.
        When you use a static framework, the code is copied and embedded into your application's binary executable.
        Static frameworks increase the size of your application's binary, as all the code from the framework is included in the final executable.
        Static frameworks are suitable for cases where you want to ensure that the library's code is always included with your application and that there are no external dependencies.
        Static frameworks are less flexible in terms of updates, as you need to rebuild and redistribute your application every time the framework is updated.

    Dynamic Framework:

        A dynamic framework is a library that contains compiled code packaged as a separate binary file (typically a .framework directory) that is linked dynamically with your application at runtime.
        Dynamic frameworks are linked to your application's binary as separate libraries, and they are loaded into memory only when needed.
        Dynamic frameworks reduce the size of your application's binary, as the framework's code is stored in a separate file and only loaded into memory when required.
        Dynamic frameworks allow for easier updates, as you can update the framework separately from your application and distribute updates without rebuilding your application.
        Dynamic frameworks are suitable for cases where you want to share code across multiple applications or distribute updates independently from your application.

In summary, the choice between static and dynamic frameworks depends on factors such as the size of your application, 
the need for flexibility in updates, and the level of code reuse across multiple applications. 
Both static and dynamic frameworks have their advantages and disadvantages, 
and the choice depends on your specific requirements and preferences.
*/

/**
    Framework
        - is a directory containing a static or dynamic library and any files associated with that library.

    Dynamic Library (dylib) 
        - is a dependency that is linked to another module or the main executable (Application) in runtime when the application process is being initialized.
    
    Dynamic Linking 
        - is a relation between a module / main executable and its dependency. This relation is being resolved in runtime.
        - We can see it the build phase "Link Binary With Libraries" if there are any

    Static Library 
        - is a dependency, symbols (contents) of which are being attached to a module or the main executable, shall it depend on such library, during the project compilation.

    Static Linking 
        - is a relation between a module / main executable and its dependency. This relation is being resolved in compile time.
            Framework a directory containing a static or dynamic library and any files associated with that library.

    Cold Start 
        - is the situation when an application is being started from scratch. At these circumstances, no libraries were preloaded or cached by the system and it takes the maximum possible amount of time to start the process since all the dependencies need to be loaded over again.

    Warm Start 
        - is a situation when the system has cached some or all of the dependencies of an application during the Cold Start and it doesn't need to load those from scratch. This feature was introduced by Apple to speed up application launching process.
    
    dyld 
        -is a tool provided by Apple to work with dynamic libraries (dylibs). This tool allows OS performing such operations as loading specified dynamic libraries, calculating the ASLR offset, validation of code signature and so on.

    ASLR Address Space Layout Randomization
        - is a form of data security used to randomize data on the RAM to help prevent exploits from taking control of the system. It first appeared in iOS 4.3.
*/

/**
    We can change from Dynamic to static library by changing build settings 
    and ensure that MACH_O_TYPE is equal to a 'Dynamic Library'
*/