<img width="1000" alt="forge generator banner 1 12 2" src="https://github.com/user-attachments/assets/8ea8bc7f-0b7d-4069-9e63-9cf6a08d9e41" />

# Forge 1.12.2 Generator for MCreator 2026.3

MCreator generator plugin for Minecraft Forge 1.12.2, targeting MCreator EAP
`2026.3.44621` (`EAP2026344621`).

| Property | Value |
| --- | --- |
| Plugin id | `generator-forge-1.12.2` |
| Generator id | `forge-1.12.2` |
| Plugin version | `2026.3-3.0.9-beta` |
| Minecraft / Forge | `1.12.2` / `14.23.5.2847` |
| Gradle for generated mods | Gradle 9.8.0 + RetroFuturaGradle 2.0.6 |
| Java for Gradle / MCreator | 25 (bundled MCreator JDK) |
| Java toolchain for the mod | 8 |
| License | CC BY-NC 4.0 (see `LICENSE`) |

This is the third development batch. It delivers the generator foundation, the
creative tab, item and recipe mod elements, blocks (basic cubes, stairs, slabs,
fences and walls, with per-face textures and transparent render layers), the
Ore Dictionary-backed tag editor, and a minimal procedure system with block
interaction triggers. The complete support overview is in
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

## Block support

The third batch supports these block bases:

- **Basic cube**: per-face textures (top/bottom/front/back/left/right), cube,
  cross, crop and custom JSON models, custom boolean/integer/enum properties,
  state-specific models and block state JSON;
- **Stairs**: `BlockStairs` with the full facing/half/shape block state set;
- **Slab**: bottom/top/double slab block with full block state variants, top
  placement, double-slab merging and correct double drops;
- **Fence**: `BlockFence` with multipart post/side models and an inventory model;
- **Wall**: `BlockWall` with multipart post/side models and an inventory model.

All bases support hardness, resistance, step sound, creative tabs, stack size,
rarity, optional block items with multi-tab support, self/custom drops and XP
ranges. Transparent cubes can select Cutout or Translucent render layers.

Basic cubes support custom boolean, integer and enum properties. The block
editor's state entries can assign a texture set per property combination; the
generator emits one block model per state and maps each combination to it, so
changing a property can also change the block appearance (the 2026.1 block-state
texture feature).

Block bases that are not implemented yet (leaves, trapdoors, panes, doors,
fence gates, end rods, pressure plates, buttons, flower pots and signs) stop
generation with an explicit message instead of generating a wrong model.
Multipart state editing, tile entities, inventories, energy, fluids, world
generation and tool tiers remain unavailable.

## Procedures (preview)

A minimal procedure element is available. Supported procedure blocks are:

- world/entity chat messages;
- set block and remove block;
- get the current blockstate and get/set boolean or integer blockstate
  properties (for testing trigger contexts and block state changes);
- play sound;
- give an item to a player;
- call another procedure and return values.

Standard Blockly flow, math, logic, text and local-variable blocks are provided
by MCreator itself. Procedures with return values use
`executeProcedure(Map<String, Object>)`.

The following block interaction triggers can call a procedure: right click,
block added, block destroyed by a player, entity walks on the block, scheduled
tick, random tick and neighbour block change. Trigger context values are passed
through a dependency map (`world`, `x`, `y`, `z`, `entity`, `blockstate`,
`direction`, `itemstack`). Global triggers are intentionally not implemented.
Right-click procedures on slabs are not generated in this batch because the slab
uses its own activation handler for double-slab merging.

## Tags and the Ore Dictionary

Forge 1.12.2 has no tag registry. The generator keeps MCreator's tag editor
workflow, but generates Ore Dictionary registrations instead of functional tag
files:

- `ITEMS` and `BLOCKS` tags are registered through
  `net.minecraftforge.oredict.OreDictionary.registerOre` in the generated
  `<Mod>OreDictionary` class.
- Common tag paths are translated to conventional Ore Dictionary names, for
  example `forge:ores/copper` -> `oreCopper`,
  `forge:storage_blocks/copper` -> `blockCopper`,
  `forge:ingots/copper` -> `ingotCopper`, `forge:planks` -> `plankWood`.
  Other paths fall back to `<namespace>_<path>` with non-alphanumeric characters
  replaced by underscores.
- Tag JSON files are still written for MCreator compatibility but are inert in
  1.12.2; they are placed under the unused `data/` folder.
- Other tag types (entities, biomes, structures, functions, enchantments, ...)
  have no 1.12.2 equivalent and are not registered.

## Recipe support

- Crafting (shaped and shapeless) is generated as 1.12.2 JSON.
- Furnace smelting is registered in Java through `GameRegistry.addSmelting`.
- Brewing is generated as a per-element `IBrewingRecipe` and registered through
  `BrewingRecipeRegistry.addRecipe`; potion inputs and outputs use
  `POTION:<PotionType>` values.
- Blasting, Smoking, Campfire cooking, Stone cutting and Smithing do not exist
  in Forge 1.12.2 and stop generation with an explicit message.

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
build/dist/generator-forge-1.12.2.zip
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
   MCreator 2026.3.44621, a workspace is created, and the base, tab, item,
   recipe, basic/stairs/slab/fence/wall block and Ore Dictionary templates
   render without errors.
4. Generated sources are compiled with RetroFuturaGradle 2.0.6 / Gradle 9.8.0 /
   Java 8 toolchain: `BUILD SUCCESSFUL`, producing `build/libs/modid-1.0.jar`.
   The test workspace contains a two-tab item, five block bases with block
   items and custom drops, crafting/smelting/brewing recipes, `ITEMS`/`BLOCKS`
   tags mapped to Ore Dictionary entries, and block procedure triggers compiled
   against a stub procedure. The procedure editor and generated procedure code
   need the user real-device test.

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
