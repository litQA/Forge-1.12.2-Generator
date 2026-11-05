# Forge 1.12.2 Generator for MCreator 2026.3

MCreator generator plugin for Minecraft Forge 1.12.2, targeting MCreator EAP
`2026.3.44621` (`EAP2026344621`).

| Property | Value |
| --- | --- |
| Plugin id | `generator-forge-1.12.2` |
| Generator id | `forge-1.12.2` |
| Plugin version | `2026.3-1.0.0-beta` |
| Minecraft / Forge | `1.12.2` / `14.23.5.2864` |
| Plugin build JDK | 25 |
| Generated mod JDK | 8 |
| Generated mod build | ForgeGradle 2.3 + Gradle 4.10.3 |
| License | CC BY-NC 4.0 (see `LICENSE`) |

This is the first development batch. It delivers the generator foundation and the
creative tab, item and recipe mod elements. The complete support overview is in
[docs/SUPPORT-MATRIX.md](docs/SUPPORT-MATRIX.md); known limitations and the
migration rationale are in [MIGRATION-REPORT.md](MIGRATION-REPORT.md).

## Requirements

1. **MCreator EAP 2026.3.44621** (the build number is part of the supported
   version list of the plugin).
2. **JDK 25** to build the plugin itself. The Gradle toolchain is pinned to 25.
3. **JDK 8** to build and run generated Forge 1.12.2 mods. Forge 1.12.2 and
   ForgeGradle 2.3 do not run on modern JDKs.
4. Local Gradle distributions:
   - plugin build: `Reference resources/gradle-9.8.0-bin.zip`
   - generated mods: `Reference resources/gradle-4.10.3-bin.zip`

## Build the plugin

The wrapper uses the local Gradle 9.8.0 distribution and keeps its caches inside
the project:

```bat
gradlew.bat build
```

The build runs the generator validator before `assemble`. The plugin archive is
written to:

```text
build/dist/generator-forge-1.12.2-2026.3-1.0.0-beta.zip
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
   **Forge for 1.12.2 (14.23.5.2864)**.
2. Before using the build button, point MCreator's Gradle Java home override to
   a **JDK 8** installation. MCreator 2026.3 runs on Java 25 and Gradle 4.10.3
   cannot start on that runtime.
3. Build the generated project either with MCreator or from the workspace
   folder with `gradlew.bat build` (the wrapper pins Gradle 4.10.3 and Java 8
   compilation).

## Local cache policy

- `gradlew` / `gradlew.bat` of this project and of the generated workspace set
  `GRADLE_USER_HOME` to `<project>/caches/gradle` when the variable is not
  already defined.
- `gradle-wrapper.properties` points to the local Gradle distributions in
  `Reference resources`, so no Gradle download is performed.
- The generated workspace contains a `caches/gradle` folder after the first
  build. No Gradle, ForgeGradle or MCP cache is written to `~/.gradle` by the
  wrapper.
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
4. Generated sources are compiled with the real ForgeGradle 2.3 / Gradle 4.10.3
   / JDK 8 toolchain (see `MIGRATION-REPORT.md` for the result of the latest
   run).

In-game verification is intentionally left to the user, as required by the
delivery specification.

## Attribution

- Generator architecture and 1.12.2 API templates are based on the Apache-2.0
  licensed `MCreator/Generator-Forge-1.12.2` project (tag `2021.1-v4.0.1`).
  The Apache license and NOTICE are included as `LICENSE-APACHE-2.0` and
  `NOTICE`.
- The 2026.3 generator format, mappings layout and feature baseline were derived
  from MCreator's `generator-26.3.x` and `forge-1.16.5` generators.
- All new files in this repository are licensed under CC BY-NC 4.0 unless a
  file states otherwise.
