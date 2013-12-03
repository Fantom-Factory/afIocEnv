# Ioc Env

Ioc Env is a [Fantom](http://fantom.org/) library for determining the application environment; dev, test or prod.



## Install

Download from [status302](http://repo.status302.com/browse/afIocEnv) and copy to `%FAN_HOME/lib/fan/` or install via [fanr](http://fantom.org/doc/docFanr/Tool.html#install):

    $ fanr install -r http://repo.status302.com/fanr/ afIocEnv

To use in a [Fantom](http://fantom.org/) project, add a dependency in your `build.fan`:

    depends = ["sys 1.0", ..., "afIocEnv 0+"]



## Quick Start

`Example.fan`:

    using afIoc
    using afIocConfig
    using afIocEnv
    
    class Example {
        @Inject IocEnv iocEnv             // --> Inject IocEnv service
    
        @Config { id="afIocEnv.isProd" }  // --> Inject Config values
        @Inject Bool isProd
    
        new make(|This| in) { in(this) }
    
        Void wotever() {
            echo("The environment is '${iocEnv.env}'")
    
            if (isProd) {
                echo("I'm in Production!")
            } else {
                echo("I'm in Development!!")
            }
        }
    }
    
    // ---- Standard afIoc Support Classes ----
    
    class Main {
        Void main() {
            registry := RegistryBuilder().addModules([AppModule#, IocEnvModule#, IocConfigModule#]).build.startup
            example  := (Example) registry.dependencyByType(Example#)
            example.wotever()
        }
    }
    
    class AppModule {
        static Void bind(ServiceBinder binder) {
            binder.bindImpl(Example#)
        }
    }



## Documentation

Full API & fandocs are available on the [status302 repository](http://repo.status302.com/doc/afIocEnv/#overview).

Also see this [Fantom-Factory Blog Article](http://fantom-factory.blogspot.co.uk/2013/12/dev-test-or-prod-what-is-your-machine.html).
