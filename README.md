# Forge 1.12.2 Generator for MCreator 2026.3

MCreator generator plugin for Minecraft Forge 1.12.2, targeting MCreator EAP
`2026.3.44621` (`EAP2026344621`).

| Property | Value |
| --- | --- |
| Plugin id | `generator-forge-1.12.2` |
| Generator id | `forge-1.12.2` |
| Plugin version | `2026.3-1.0.1-beta` |
| Minecraft / Forge | `1.12.2` / `14.23.5.2847` |
| Gradle for generated mods | Gradle 9.8.0 + RetroFuturaGradle 2.0.6 |
| Java for Gradle / MCreator | 25 (bundled MCreator JDK) |
| Java toolchain for the mod | 8 |
| License | CC BY-NC 4.0 (see `LICENSE`) |

This is the first development batch. It delivers the generator foundation and the
creative tab, item and recipe mod elements. The complete support overview is in
[docs/SUPPORT-MATRIX.md](docs/SUPPORT-MATRIX.md); known limitations and the
migration rationale are in [MIGRATION-REPORT.md](MIGRATION-REPORT.md).

## Why the build chain uses RetroFuturaGradle

MCreator 2026.3 is built with Java 25. Its Gradle synchronization action
(`net.mcreator.gradle.GradleSyncBuildAction`) is a Java 25 class file (major
version 69). Legacy Gradle versions used by ForgeGradle 2.3 (Gradle 4.10.3)
cannot parse or load this class: their ASM version cannot read major version 69,
and their daemon cannot run a Java 25 action class. This is the
`Unsupported class file major version 69` failure reported when a workspace was
built with the old ForgeGradle 2.3 / Gradle 4.10.3 wrapper.

The generated mod therefore uses **RetroFuturaGradle 2.0.6** on **Gradle 9.8.0**.
Gradle 9.8 runs on MCreator's Java 25 runtime and can host MCreator's
synchronization action. RetroFuturaGradle keeps the 1.12.2 build semantics
(MCP snapshot `20171003`, Forge `1.12.2-14.23.5.2847`) and compiles/runs the mod with a
**Java 8 toolchain**, so generated code remains Java 8 compatible.

No MCreator "Java home override" to a JDK 8 is required anymore. Leave the
Gradle JVM at MCreator's bundled JDK (Java 25) or any JDK supported by
Gradle 9.8.

## Requirements

1. **MCreator EAP 2026.3.44621** (the build number is part of the supported
   version list of the plugin).
2. **JDK 25** to build the plugin itself and to run Gradle 9.8. This is the JDK
   bundled with MCreator 2026.3.
3. **A Java 8 toolchain** for compiling and running the generated 1.12.2 mod.
   Gradle detects a locally installed JDK 8 automatically. If none is found, the
   Foojay toolchain resolver configured in the generated `settings.gradle`
   provisions one into the Gradle user home.
4. Local Gradle distribution for the plugin build:
   `Reference resources/gradle-9.8.0-bin.zip`. The generated workspace uses the
   same local Gradle 9.8.0 distribution.

## Build the plugin

The wrapper uses the local Gradle 9.8.0 distribution and keeps its caches inside
the project:

```bat
gradlew.bat build
```

The build runs the generator validator before `assemble`. The plugin archive is
written to:

```text
build/dist/generator-forge-1.12.2-2026.3-1.0.1-beta.zip
```

Run only the static generator validation with:

```bat
gradlew.bat validateGenerator
```

## Install

Copy the plugin archive into the MCreator plugins folder and restart MCreator:

```text
<MCreator installation>/plugins/
```

or the user plugins folder:

```text
%USERPROFILE%\.mcreator\plugins\
```

The plugin declares `weight: 100`, so its `forge-1.12.2` resources take
precedence over resources of the same generator name shipped by other plugins.

## Create a workspace

1. Create a new MCreator workspace, open the generator selection and choose
   **Forge for 1.12.2 (14.23.5.2847)**.
2. Keep MCreator's Gradle Java home override at the default Java 25 runtime (do
   not point it to JDK 8; Gradle 9.8 requires Java 17+). The Java 8 toolchain is
   handled by Gradle/RetroFuturaGradle.
3. Build the generated project with MCreator or from the workspace folder with
   `gradlew.bat build`.

If a workspace was created with an older plugin build, recreate it or replace
its `build.gradle`, `settings.gradle`, `gradle.properties` and wrapper files with
the new workspace base before retrying.

## Local cache policy

- `gradlew` / `gradlew.bat` of this project and of the generated workspace set
  `GRADLE_USER_HOME` to `<project>/caches/gradle` when the variable is not
  already defined.
- `gradle-wrapper.properties` points to the local Gradle 9.8.0 distribution, so
  Gradle itself is not downloaded.
- RetroFuturaGradle stores MCP, Forge userdev, vanilla jars, assets and the
  decompiled cache inside the Gradle user home, which is the workspace-local
  `caches/gradle` folder when the wrapper is used.
- MCreator's Tooling API removes `GRADLE_USER_HOME` from the child environment
  and does not expose a generator-level cache setting. Caches produced by a
  Gradle build started by MCreator itself are therefore controlled by MCreator,
  not by this generator. Use the project wrapper for strict local caching; see
  `MIGRATION-REPORT.md`.

## Project layout

```text
plugin-branch-2026.3/
  build.gradle, settings.gradle, gradle.properties
  gradlew, gradlew.bat, gradle/wrapper/
  LICENSE, NOTICE, LICENSE-APACHE-2.0
  README.md, CHANGELOG.md, MIGRATION-REPORT.md
  docs/SUPPORT-MATRIX.md
  tools/lib/                      bundled validator dependencies (Apache 2.0)
  src/validator/java/             static generator validator
  src/main/resources/
    plugin.json
    forge-1.12.2/
      generator.yaml
      *.definition.yaml           mod element definitions
      mappings/                   MCP name mappings and data lists
      templates/                  FreeMarker templates
      utils/                      shared template helpers
      workspacebase/              Gradle project template for generated mods
      workspace.gitignore
```

## Verification performed in this batch

1. `gradlew.bat build` with JDK 25: `BUILD SUCCESSFUL`.
2. Generator validator (YAML, mappings, FreeMarker syntax, template references):
   `VALIDATION PASSED`.
3. Headless MCreator renderer: the plugin is discovered and accepted by
   MCreator 2026.3.44621, a workspace is created, and the base, tab, item and
   recipe templates render without errors.
4. Generated sources are compiled with RetroFuturaGradle 2.0.6 / Gradle 9.8.0 /
   Java 8 toolchain: `BUILD SUCCESSFUL`, producing `build/libs/modid-1.0.jar`.
   The previous ForgeGradle 2.3 / Gradle 4.10.3 chain reproduced the
   `Unsupported class file major version 69` synchronization failure and has
   been replaced.

In-game verification is intentionally left to the user, as required by the
delivery specification.

## Attribution

- Generator architecture and 1.12.2 API templates are based on the Apache-2.0
  licensed `MCreator/Generator-Forge-1.12.2` project (tag `2021.1-v4.0.1`).
  The Apache license and NOTICE are included as `LICENSE-APACHE-2.0` and
  `NOTICE`.
- The 2026.3 generator format, mappings layout and feature baseline were derived
  from MCreator's `generator-26.3.x` and `forge-1.16.5` generators.
- The generated mod build chain uses RetroFuturaGradle 2.0.6 (LGPL-2.1), fetched
  as a build-time Gradle plugin from the GT New Horizons Maven repository. No
  RetroFuturaGradle code is bundled in this plugin archive.
- All new files in this repository are licensed under CC BY-NC 4.0 unless a
  file states otherwise.
