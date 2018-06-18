# Invio.QueryProvider

[![Build Status](https://ci.appveyor.com/api/projects/status/57f44yxjmd8giynr/branch/master?svg=true)](https://ci.appveyor.com/project/invio/invio-queryprovider/branch/master)

The `Invio.QueryProvider` project is a combination of `Invio.QueryProvider.Core` and engine specific implementations maintained by Invio. This simplifies the process of developing, building, and packaging these projects in unison.

## Packages

### [Invio.QueryProvider.Core](https://github.com/invio/Invio.QueryProvider.Core)

[![NuGet](https://img.shields.io/nuget/v/Invio.QueryProvider.Core.svg)](https://www.nuget.org/packages/Invio.QueryProvider.Core/)



### [Invio.QueryProvider.MySql](https://github.com/invio/Invio.QueryProvider.MySql)

[![NuGet](https://img.shields.io/nuget/v/Invio.QueryProvider.MySql.svg)](https://www.nuget.org/packages/Invio.QueryProvider.MySql/)

## Cloning

This repository uses [git submodules](https://git-scm.com/docs/git-submodule) so after cloning this repository it is necessary to pull the submodule repositories as well by running:

```bash
git submodule update --init
```

## Building

### For Development

To build all the projects simultaneously, it is necessary to enable local project references (instead of package references). To do so create a local file called `User.props` with the following content:

```xml
<Project>
  <PropertyGroup>
    <UseProjectReferences>true</UseProjectReferences>
  </PropertyGroup>
</Project>
```

### For Deployment

For deployment purposes packages must be built and packaged one at a time. This can be done quickly using the [build.ps1](build.ps1) powershell script.