#IoC Env v1.0.18
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v1.0.18](http://img.shields.io/badge/pod-v1.0.18-yellow.svg)](http://www.fantomfactory.org/pods/afIocEnv)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

`Ioc Env` is a library for determining the application environment, be it *development*, *test* or *production*.

It sniffs environment variables and program arguments, and offers a manual override option - useful for testing.

## Install

Install `IoC Env` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afIocEnv

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afIocEnv 1.0+"]

## Documentation

Full API & fandocs are available on the [Status302 repository](http://repo.status302.com/doc/afIocEnv/).

## Quick Start

**Example.fan**:

```
using afIoc
using afIocConfig
using afIocEnv

class Example {
    @Inject
    IocEnv iocEnv                     // --> Inject IocEnv service

    @Config { id="afIocEnv.isProd" }  // --> Inject Config values
    Bool isProd

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

// ---- Standard IoC Support Classes ----

class Main {
    Void main() {
        registry := RegistryBuilder().addModulesFromPod("afIocEnv").addModule(AppModule#).build.startup
        example  := (Example) registry.dependencyByType(Example#)
        example.wotever()
    }
}

class AppModule {
    static Void defineServices(ServiceDefinitions defs) {
        defs.add(Example#)
    }
}
```

Run the **Example.fan** script from the command line:

```
C:\> fan Example.fan -env PRODUCTION
[info] [afIocEnv] Setting from environment variable 'env' : development
[info] [afIocEnv] Overriding from cmd line argument '-env' : PRODUCTION
The environment is 'PRODUCTION'
I'm in Production!
```

## Usage - IocEnv Injection

The [IocEnv](http://repo.status302.com/doc/afIocEnv/IocEnv.html) class is the main [IoC](http://www.fantomfactory.org/pods/afIoc) service with handy utility methods. Inject it as usual:

```
using afIoc::Inject
using afIocEnv::IocEnv

@Inject IocEnv iocEnv

...

Void wotever() {
   if (iocEnv.isDev) {
      ... // dev only stuff
   }
}
```

## Usage - Config Injection

You can also inject [IoC Config](http://www.fantomfactory.org/pods/afIocConfig) values. See [IocEnvConfigIds](http://repo.status302.com/doc/afIocEnv/IocEnvConfigIds.html) for a complete list of injectable values:

```
using afIoc::Inject
using afIocConfig::Config

@Config { id="afIocEnv.isDev" }
Bool isDev

...

Void wotever() {
   if (isDev) {
      ... // dev only stuff
   }
}
```

## Setting the Environment

To determine your environment, `IoC Env` checks the following:

- **Environment Variables** - if an environment variable named `env` or `environment` if found, it is taken to be your environment.
- **Program Arguments** - if an option labelled `-env` or `-environment` if found, the environment is taken to be the argument following. Example, `-env prod`. This convention follows [@Opt](http://fantom.org/doc/util/Opt.html) from [util::AbstractMain](http://fantom.org/doc/util/AbstractMain.html).
- **Manual Override** - the environment may be set / overridden when the [IocEnv](http://repo.status302.com/doc/afIocEnv/IocEnv.html) instance is created.

The ordering of checks mean program arguments override environment variables and a manual override trumps everything.

Note if no environment setting is found, it defaults to `Production`. This is because it's usually easier to configure dev and test boxes than it is to configure production ones. So it is one less thing to worry about!

> **ALIEN-AID:** Because the environment default is `production` you need to set the environment on your dev machine. The easiest way to do this is to set a new environment variable called `ENV` to the value `dev`.

## Overriding the Environment

Should you need to programmatically override the environment, do it by overriding the [IocEnv](http://repo.status302.com/doc/afIocEnv/IocEnv.html) service in your `AppModule`:

```
using afIoc
using afIocEnv

class AppModule {

	static Void defineServices(ServiceDefinitions defs) {
		defs.overrideById(IocEnv#.qname).withCtorArgs(["MoFo"])
	}
    ....
}
```

