<img width="1000" alt="forge generator banner 1 12 2" src="https://github.com/user-attachments/assets/147e8a32-d5cf-4a7d-88be-e4475f840045" />

# Forge 1.12.2 Generator for MCreator 2026.3

MCreator generator plugin for Minecraft Forge 1.12.2, targeting MCreator EAP
`2026.3.44621` (`EAP2026344621`).

| Property | Value |
| --- | --- |
| Plugin id | `generator-forge-1.12.2` |
| Generator id | `forge-1.12.2` |
| Plugin version | `2026.3-1.0.30.94-beta` |
| Minecraft / Forge | `1.12.2` / `14.23.5.2847` |
| Gradle for generated mods | Gradle 9.8.0 + RetroFuturaGradle 2.0.6 |
| Java for generated Gradle / MCreator | 25 (bundled MCreator JDK) |
| Java for plugin source build | 25 (Gradle 9.8 toolchain) |
| Java toolchain for the mod | 8 |
| License | CC BY-NC 4.0 (see `LICENSE`) |

Current snapshot: `2026.3-1.0.30.94-beta`. It includes the generator
foundation, creative tabs, items, recipes, blocks, plants, fluids, tools,
armor, enchantments, attributes, item extensions, native loot tables, potion
effects/items, procedures, dimensions, biomes, custom trees, portals/igniters,
skyboxes, sounds, custom dimension terrain with caves/aquifers, five-range
biome weight mapping, self-contained Mixin 0.7.11 worldgen injection,
advancements, Java structure/feature worldgen, villager professions/trades,
commands, functions, game rules, music discs, banner patterns, damage types,
native procedure triggers and the 1.12.2 procedure block baseline.
The complete, implementation-oriented support overview is in
[docs/SUPPORT-MATRIX.md](docs/SUPPORT-MATRIX.md); trigger levels are in
[docs/TRIGGER-CLASSIFICATION.md](docs/TRIGGER-CLASSIFICATION.md); known
limitations and the migration rationale are in
[MIGRATION-REPORT.md](MIGRATION-REPORT.md).

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

The generator supports these block bases:

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
Right-click procedures on slabs are not generated because the slab uses its own
activation handler for double-slab merging.

## Plants and fluids

Plants support normal, sapling, growable and double-plant modes with cross,
crop and custom JSON models, independent item textures, tooltips, drops,
placement restrictions, bonemeal procedures, light and flammability. Saplings
currently use normal plant placement and do not grow trees yet; world
generation is not implemented.

Fluids support still/flowing textures, `Fluid` registration,
`BlockFluidClassic`, bucket generation, bucket models and client fluid state
mapping. Fog, overlays, custom flow conditions and fluid block procedures are
not implemented yet.

## Tool limitations

Shields are generated as a Forge 1.12.2 `ItemShield` subclass. Blocking uses the
native use action, `isShield` damage handling, shield block/break sounds,
durability, repair items, enchantability, rarity, tooltips, tool triggers and
attribute modifiers. A `blocking` item-model predicate selects the generated
`<registryname>_0` model while the shield is raised.

Tools with multiple creative tabs override `getSubItems`, so every selected tab
is populated. Attribute modifiers use deterministic UUIDs, allowing 1.12.2 to
remove an in-hand bonus when the tool is unequipped.

Custom shield blocking models (`blockingRenderType` 1 and 2) are rejected
explicitly, and shield GUI textures are hidden by the generator definition. Custom shields cannot use
the vanilla `builtin/entity` shield renderer or banner-pattern rendering,
because Forge 1.12.2 binds those to the vanilla shield item. Shield attribute
modifiers currently apply in both hands, since per-slot attribute modifier
entries are not fully mapped yet.

Fishing rods are intentionally not adapted for the current 1.12.2 tool
implementation.

## Localization keys

Generated keys follow the exact 1.12.2 lookup paths:

| Element | Generated key |
| --- | --- |
| Item | `item.<modid>.<registryname>.name` |
| Block / plant / fluid block | `tile.<modid>.<registryname>.name` |
| Tool / shield | `item.<modid>.<registryname>.name` |
| Armor piece | `item.<modid>.<registryname>_<piece>.name` |
| Fluid | `fluid.<modid>.<registryname>` |
| Fluid bucket | `item.<modid>.<registryname>_bucket.name` |
| Enchantment | `enchantment.<modid>.<registryname>` |
| Creative tab | `itemGroup.<modid>.<registryname>` |
| Attribute | `attribute.name.<modid>.<registryname>` |

Items, blocks, plants, tools, shields and armor use a `.name` suffix because
1.12.2 `Item`/`Block` display-name lookups append it. Enchantments and fluids do
not use `.name`: their APIs add the `enchantment.`/`fluid.` prefix and translate
the resulting key directly. Attribute names are the exception that keeps
`attribute.name.` as the complete tooltip lookup prefix. Generated code and
definition keys must be kept in this form together.

## Item extensions, loot tables and potions

**Item extension** supports furnace fuel values through Forge's
`FurnaceFuelBurnTimeEvent` and custom dispenser behavior through
`BlockDispenser.DISPENSE_BEHAVIOR_REGISTRY`. Fixed and procedure-based fuel
values, fuel success conditions, dispense success conditions and returned
itemstack procedures are generated. A returned-itemstack procedure is emitted
only when its return type is actually an itemstack; void procedures fall back
to consuming one item instead of producing an invalid cast. Composting has no
1.12.2 equivalent and is excluded.

**Loot table** emits native 1.12.2 JSON under
`assets/<modid>/loot_tables/<name>.json`, registers the table through
`LootTableList`, and supports pools, rolls, bonus rolls, item/empty entries,
weights, count ranges and enchant-with-levels functions. Modern top-level table
types, entry silk-touch/fortune/explosion-decay conditions and loot modifiers
are excluded rather than emitted as invalid JSON. Block elements can enable "use
custom loot table"; the block then resolves
`assets/<modid>/loot_tables/blocks/<registryname>.json`, so a Loot table element
must be named `blocks/<registryname>`. The 2026.3 shared editor still displays
the fortune and silk-touch controls for individual entries; the 1.12.2
generator ignores those two values because its loot-table JSON template has no
equivalent conditions. MCreator generator field exclusions cannot reach
dynamically-created entry components, so hiding those controls needs an upstream
GUI change.

**Potion effect** generates a `Potion` subclass with category, color, custom
status icon, attribute modifiers, instant/beneficial flags and optional
start/tick/expire/hurt/death procedures. Attribute modifiers are removed by
their stable UUIDs when the effect expires or is cured, including milk.
Honey curing and custom particle rendering are hidden because 1.13+ APIs are
unavailable. Modern effect entries not present in 1.12.2 fall back to
`MobEffects.SPEED` through the mapping default.

**Potion item** generates a registered `PotionType` with multiple effects and
vanilla potion item localization. Custom potion types appear in the brewing
creative tab and can be converted to splash/lingering variants through generated
brewing recipes. The element uses vanilla potion, splash potion, lingering
potion and tipped-arrow items; it does not create a new item class.

## Dimensions and biomes

**Biome** generates a registered 1.12.2 `Biome` with climate, rainfall, top and
filler blocks, water/grass/foliage/sky colors, spawn entries, vanilla tree
types and optional overworld biome placement. Stronghold and village placement
are supported. Custom trees use a high-value Java generator subset: trunk,
branches, vines, fruits and minimum height. `spawnInCaves` and
`spawnBiomeNether` drive generated Mixin-based global cave/Nether biome lookup
injection. Five climate rows (`genTemperature`, `genHumidity`,
`genContinentalness`, `genErosion`, `genWeirdness`) are exposed as a 1.12.2
biome-weight proxy: each maps `abs(max-min)/4` to `0..100`, summed to `0..500`
(minimum 1). Full modern tree features, modern climate/noise semantics, custom
particles, mood/music sound fields and modern structure placement remain
hidden.

**Dimension** generates a `WorldProvider`, a `DimensionType` registration, a
custom biome provider and optional portal/igniter assets. All non-Void custom
dimensions use the generated custom noise terrain generator; Void uses a minimal
empty chunk generator. Sky light, fog/cloud height, fixed time, ambient light,
coordinate scale, respawn/bed/weather behavior and player enter/leave procedures
are mapped. Custom six-face skyboxes use a client `IRenderHandler` and workspace
textures under `assets/<modid>/textures`; biome ambient/additions sounds use a
client tick handler. Portals use a custom `ITeleporter` that finds a safe
standing position and creates a fallback platform in void dimensions. The
terrain generator supports configurable main filler, fluid, sea level,
simplified aquifers, `MapGenCaves` and `MapGenRavine`. This is dimension-only;
no main-world or vanilla Nether generation hooks are created. Custom sun/moon
rendering remains hidden.

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

## Verification performed for the current snapshot

1. `gradlew.bat build` with Gradle 9.8.0 and the Java 25 toolchain:
   `BUILD SUCCESSFUL`, producing
   `build/dist/generator-forge-1.12.2.zip` version `2026.3-1.0.30.94-beta`.
2. Generator validator (YAML, mappings, FreeMarker syntax, template references):
   `VALIDATION PASSED` (65 YAML documents, 685 FTL templates, 130 template
   references).
3. The full `test_workspaces/test-1/src/main/java` source tree was compiled
   against the 1.12.2 classes with `javac --release 8`: `PASSED`. This includes
   the custom block loot-table drop path and potion attribute cleanup path.
4. The enchantment and armor templates were rendered with FreeMarker using the
   test element data, then compiled with `javac --release 8`: `PASSED`.
5. The generated shield class shape was compiled against the test workspace's
   1.12.2 classes with `javac --release 8`: `PASSED`.
6. The generated `blocking` item-model override and `<registryname>_0` model
   were validated as JSON and checked for the `minecraft:blocking` predicate and
   generated model path.
7. The test workspace language file was checked for every canonical item, block,
   tool, shield, armor, fluid and enchantment key; no expected key is missing.
8. Item extension, loot table, potion effect and potion item templates were
   rendered with FreeMarker using mock element data, then compiled with
   `javac --release 8`: `PASSED`.
9. The rendered loot table JSON parsed successfully and contains native 1.12.2
   pool names, roll/entry/function fields.
10. A void dispense-result procedure was rendered and compiled with
    `javac --release 8`: `PASSED`; no `void`-to-`ItemStack` cast is emitted.
11. A direct 1.12.2 attribute-map probe confirmed that the generated potion
    effect applies and removes both movement-speed and max-health modifiers by
    UUID.
12. MCreator's actual fixed-value `NumberProcedure` object was rendered through
    `elementinits/fuels.java.ftl` and compiled with `javac --release 8`:
    `PASSED`; the fuel class is generated without treating the fixed value as a
    callable procedure.
13. A generated multi-tab pickaxe was rendered and compiled with
    `javac --release 8`; a direct 1.12.2 attribute-map probe confirmed its
    deterministic movement-speed modifier is removed on unequip
    (`0.7 -> 3.7 -> 0.7`).
14. Biome and dimension templates were rendered with FreeMarker and compiled
    with `javac --release 8` for Normal, Nether, End, Void and custom-effects
    variants; the combined biome/dimension/mod templates also compile.
15. A metadata block reference (`Blocks.STONE#3`) was rendered as
    `Blocks.STONE.getStateFromMeta(3)` and compiled successfully.
16. Biome spawn entries using `EntityZombie` and `EntityEnderman` were rendered
    with fully-qualified vanilla entity classes and compiled successfully.
17. Portal/igniter, skybox, biome sound, custom-tree and custom-teleporter
    templates were rendered and compiled with `javac --release 8`; portal JSON
    models parsed, and the generated block/item registries compiled.
18. The custom terrain generator's noise, filler/fluid/sea-level and aquifer
    path was rendered and compiled with `javac --release 8`.
19. Worldgen hooks and the `World#getBiome` Mixin class were rendered and
    compiled with `javac --release 8` against Mixin 0.7.11 and the patched
    Minecraft classes; the generated Mixin JSON parsed successfully.
20. The built zip was copied to
    `MCreatorEAP2026344621/plugins/generator-forge-1.12.2.zip`; source and
    installed SHA-256 hashes match.
21. Living entity, projectile, boat, GUI, overlay, key binding and particle
    templates were rendered with representative data and compiled with
    `javac --release 8` against the patched 1.12.2 client and Forge.
22. All 27 AI task templates, the GUI procedure templates and custom Java
    model renderers were rendered and compiled with zero errors.
23. The next-batch advancement, structure/feature, villager trade/profession,
    command/function, game-rule and music-disc templates were rendered with
    representative data and compiled with `javac --release 8`: `PASSED`.
24. The plugin build reported `VALIDATION PASSED` and `BUILD SUCCESSFUL` for
    `2026.3-1.0.30.94-beta`.

The latest user tests confirmed custom dimension portals, skyboxes, terrain,
cave/Nether Mixin basics, custom biome/weight behavior and chunk seam fixes.
The `1.0.25.64` cave `y=0` exclusion remains a pending regression test:
verify vanilla tree restoration and custom surface-biome generation in a new
world/new chunks. The entity, GUI, overlay, key-binding and particle batch in
`1.0.26.73` has passed user testing; the advancement/structure/feature,
villager, command/function/game-rule and music-disc batch in `1.0.30.94`
requires real-client testing before further development.

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




