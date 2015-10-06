    using afIoc
    using afIocConfig
    using afIocEnv

    const class Example {
        @Inject                           // --> Inject IocEnv service
        const IocEnv iocEnv

        @Config { id="afIocEnv.isProd" }  // --> Inject Config values
        const Bool isProd

        new make(|This| in) { in(this) }

        Void print() {
            echo("The environment is '${iocEnv.env}'")

            if (isProd) {
                echo("I'm in Production!")
            } else {
                echo("I'm in Development!!")
            }
        }
    }

    class Main {
        Void main() {
            registry := RegistryBuilder() {
                addModulesFromPod("afIocEnv")
                addService(Example#)
            }.build()

            example  := (Example) registry.dependencyByType(Example#)
            example.print()
        }
    }
