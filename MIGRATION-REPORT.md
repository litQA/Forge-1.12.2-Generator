# Migration Report: Forge 1.12.2 Generator for MCreator 2026.3

## Scope of this report

This report documents the migration from the community
`Generator-Forge-1.12.2-2025.3` snapshot to a generator plugin that loads in
MCreator EAP `2026.3.44621`, together with the decisions, verified behaviour and
known limitations of the first development batch.

## Baseline analysis

The supplied 2025.3 community baseline could not be used as a foundation for a
2026.3 generator without a full rework:

1. **Missing mod element definitions.** The baseline has no definition file for
   blocks, plants, fluids, features, structures, commands, functions, special
   entities or paintings, although the ICreator feature surface requires them.
   `gui.definition.yaml` and `livingentity.definition.yaml` were shipped with a
   `.wip` suffix and are not loaded at all.
2. **Mixed API generations in templates.** The baseline item and main templates
   contain 1.13+ API calls (`NetworkHooks`, `StringTextComponent`,
   `EntityEquipmentSlot` usage mixed with `ItemGroup`, `ModelRegistryEvent`,
   `CreativeTabs.CREATIVE_TAB_ARRAY` assumptions) while declaring 1.12.2 entry
   points. The templates cannot produce compilable 1.12.2 code.
3. **Broken template includes.** For example `templates/item/item.java.ftl`
   includes `../procedures.java.ftl`, which does not exist in that layout, so the
   template cannot even be rendered.
4. **Incompatible build chain.** The workspace base used ForgeGradle `7.0.40`
   with a Gradle 9.7.1 wrapper. Forge 1.12.2 cannot be built through that
   combination. The legacy alternative (ForgeGradle 2.3 with Gradle 4.10.3) is
   also fundamentally incompatible with MCreator 2026.3, because MCreator sends
   a Java 25 bytecode synchronization action to whatever Gradle distribution the
   workspace declares. Gradle 4.10.3 cannot parse class file major version 69
   and cannot load the action, so the workspace fails during synchronization.
   The 1.12.2 build chain must therefore run on a modern Gradle while still
   compiling and running the mod with Java 8.
5. **Modern-only mappings in data lists.** For example the baseline biome data
   list contains 1.19+ biomes (`mangrove_swamp`, `windswept hills`) that do not
   exist in 1.12.2.

The project therefore uses the Apache-2.0 licensed official
`MCreator/Generator-Forge-1.12.2` reference repository (tag `2021.1-v4.0.1`) as
the source of proven 1.12.2 API code, and re-applies the 2026.3 generator format
and mod element data model on top of it. The generated mod is built with
**RetroFuturaGradle 2.0.6 on Gradle 9.8.0**, with a Java 8 toolchain for
compilation and runtime. This is the only combination that satisfies both the
modern Gradle requirement of MCreator 2026.3 and the Java 8 requirement of
Forge 1.12.2.

## 2026.3 architecture adaptations

| 2026.3 change | Handling in this generator |
| --- | --- |
| Definitions are merged across plugins by YAML merge policy. | The plugin ships one self-contained `forge-1.12.2` generator. `plugin.json` uses `weight: 100` so its resources win over same-named resources from lower-weight plugins. |
| `types` is provided as an empty list when no element of a type exists. | All templates iterate `types.<plural>` and guard with `?has_content`; base templates use `condition: "${types.tabs?has_content}"` style conditions. |
| Mod element base types are declared by YAML (`base_types`). | Not required for the batch-1 element set (creative tab, item, recipe). The item registry is generated from `types.items` in `elementinits/items.java.ftl`. |
| Generator fragments (`*.fragment.yaml`). | The loader supports fragments, but the 1.12.2 build has no mixin/accesstransformer pipeline. This generator declares no fragments and therefore cannot accidentally emit 1.13+ mixin artefacts. The design allows adding fragments in later batches when a 1.12.2 use case exists. |
| Field availability is configured per generator (`field_inclusions` / `field_exclusions`). | The item and recipe definitions use `field_exclusions`. Exclusions are safer than inclusions here: inclusion cleanup hides every GUI component it cannot resolve, and grouped recipe controls are not plain GUI fields. Unsupported fields are hidden explicitly, and unsupported recipe types still stop generation. |
| Gradle task names and export path are configured in `generator.yaml`. | `runClient`, `runServer` and `build/libs/modid-1.0.jar` are used. The workspace wrapper pins Gradle 9.8.0 and RetroFuturaGradle handles the 1.12.2 build. |

## Mod element support

### Creative tab

Direct implementation. Tabs are generated in `<Mod>Tabs` as Forge 1.12.2
`CreativeTabs` instances with icon, search bar and background image support.
`hideTitle` has no 1.12.2 API and is excluded from the editor.

### Item

Direct implementation for:

- item name and texture;
- normal model and tool (handheld) model;
- rarity, stack size, durability, enchantability;
- use duration and use animation (`EnumAction`);
- destroy speed and destroy-any-block harvesting;
- melee attack damage and attack speed attribute modifiers;
- container item and recipe remainder;
- food value, saturation, meat flag, always-edible flag;
- creative tab selection, including membership in multiple tabs.

Degraded behaviour:

- Forge 1.12.2's `Item` API has a single `setCreativeTab` call. The generator
  sets the first selected tab as the item default and overrides `getSubItems`
  to expose the item in every selected tab, so both custom and vanilla tab
  selections are honoured.
- The `OP_BLOCKS` tab does not exist in 1.12.2 and falls back to
  `CreativeTabs.MISC`.

Explicitly unavailable in this batch (generation stops instead of producing an
unusable item):

- custom JSON, OBJ and Java models;
- item inventories, bound GUIs and GUI-opening logic;
- ranged items and projectiles;
- procedures, item triggers and special-information procedures;
- glow conditions, music discs, banner patterns, attribute modifier entries,
  repair items, fire immunity, piglin currency and the remaining modern fields.

### Recipe

Direct implementation for:

- shaped and shapeless crafting recipes as 1.12.2 JSON files;
- furnace smelting recipes, registered through
  `GameRegistry.addSmelting(ItemStack, ItemStack, float)` in the generated
  `<Mod>Recipes` class (1.12.2 furnace recipes are code-registered, not data
  driven);
- brewing recipes, generated as a per-element `IBrewingRecipe` implementation
  and registered through `BrewingRecipeRegistry.addRecipe(...)`. Potion inputs
  and outputs use `POTION:<PotionType>` values and are matched with
  `PotionUtils.getPotionFromItem`.

Explicitly unavailable (generation stops with a message naming the recipe
type): Blasting, Smoking, Campfire cooking, Stone cutting and Smithing. These
recipe types do not exist in Forge 1.12.2.

### Block (batch 3)

Direct implementation for these bases:

- basic cube: `block/cube`, `block/cross`, `block/crop` or a custom JSON model,
  generated from the six per-face texture fields (`texture`, `textureTop`,
  `textureFront`, `textureBack`, `textureLeft`, `textureRight`), with block state
  and block item model;
- stairs: `BlockStairs` with the complete facing/half/shape block state set and
  inner/outer models;
- slab: a dedicated bottom/top/double slab block with block state variants, top
  placement, double-slab merging on right click and two-item drops for the
  double state;
- fence: `BlockFence` with multipart post/side models and an inventory model;
- wall: `BlockWall` with multipart post/side models and an inventory model.

All bases support hardness, resistance, 1.12.2 `SoundType`, creative tabs, stack
size, rarity, optional `ItemBlock` registration with multi-tab support, self or
custom drops and XP ranges. Transparent blocks can set a cutout or translucent
`BlockRenderLayer` and disable full-cube rendering. Basic cubes support custom
boolean, integer and enum properties; state entries with their own texture set
generate per-state models, so property changes can also change the appearance.
Cross/crop models, custom JSON models and their inventory models are generated;
custom JSON models are copied to `models/custom`.

Leaves, trapdoors, panes, doors, fence gates, end rods, pressure plates,
buttons, flower pots and signs stop generation with an explicit message.
Multipart state editing, tile entities/inventories, energy, fluids, world
generation, redstone behavior, tool tiers, loot-table drops and vibration remain
unavailable.

### Procedures (batch 3 preview)

A minimal procedure element is implemented with a dependency-map entry point:

`public static void executeProcedure(Map<String, Object> dependencies)`.

Supported procedure block templates: world/entity chat, set block, remove block,
get current blockstate, get/set boolean and integer blockstate properties, play
sound, give item, call procedure, return value and print. Standard Blockly
flow/math/logic/text/variable blocks come from MCreator itself. Procedures with a
return value use the generated return type.

Block triggers that call procedures: right click, block added, destroyed by a
player, entity walk, scheduled tick, random tick and neighbour change. Values are
passed in the dependency map (`world`, `x`, `y`, `z`, `entity`, `blockstate`,
`direction`, `itemstack`). Global triggers are not implemented. A right-click
procedure on a slab is not generated because the slab uses its own activation
handler for double-slab merging. Other procedure blocks found in MCreator's
toolbox do not have 1.12.2 templates yet and fail generation explicitly.

### Tags and Ore Dictionary (batch 2)

### Tags and Ore Dictionary (batch 2)

Forge 1.12.2 has no tag registry, so MCreator's tag editor is kept as the user
interface while the generator emits Ore Dictionary registrations:

- `ITEMS` and `BLOCKS` tags are registered in the generated
  `<Mod>OreDictionary` class through
  `net.minecraftforge.oredict.OreDictionary.registerOre`.
- Managed entries referencing custom items/blocks resolve to the generated
  registry classes; registry-name entries (`minecraft:stone`) are resolved at
  runtime with null checks; external entries are resolved after stripping the
  `EXTERNAL:` prefix.
- Common tag paths are translated to conventional Ore Dictionary names:
  `forge:ores/<material>` -> `ore<Material>`,
  `forge:storage_blocks/<material>` -> `block<Material>`,
  `forge:ingots/<material>` -> `ingot<Material>`,
  `forge:nuggets/<material>` -> `nugget<Material>`,
  `forge:dusts/<material>` -> `dust<Material>`,
  `forge:gems/<material>` -> `gem<Material>`,
  `forge:planks` -> `plankWood`, `forge:logs` -> `logWood`.
  Other paths fall back to `<namespace>_<path>` in lower case with separators
  replaced by underscores.
- Nested tag entries (`#tag`/`TAG:`) are not expanded because Ore Dictionary
  has no nested tag concept.
- Other tag types (entities, biomes, structures, functions, enchantments,
  damage types, game events, etc.) have no 1.12.2 equivalent and are ignored by
  the Ore Dictionary generator.
- The declared `tags` specification keeps MCreator's tag workflow active and
  writes inert JSON files under the unused `data/` folder.

### Tools, armor, enchantments and attributes

Tools generate the native 1.12.2 pickaxe, axe, spade, hoe, sword, shears and
`ItemShield` subclasses. Tools in multiple creative tabs override `getSubItems`
so every selected tab is populated. In-hand attribute modifiers use deterministic
UUIDs, so 1.12.2 removes them when the tool is unequipped. Shields use the native
blocking use action and `isShield` contract, with a generated `blocking`
item-model predicate and `<registryname>_0` blocking model. Custom shield
blocking models are rejected explicitly instead of producing an invalid model;
shield GUI textures are hidden.

Armor, custom enchantments and custom attributes use the 1.12.2 material,
registry and entity-construction APIs. Enchantment `supportedItems` tags are
translated to native `EnumEnchantmentType` categories where possible; custom
tags fall back to Ore Dictionary entries. The invalid `TAG:` Java emission and
the missing `ArmorMaterial` argument separator from the previous batch are
fixed. Remaining limitations are listed in the support matrix and changelog.

### Item extensions, loot tables and potions

Item extensions use Forge 1.12.2's `FurnaceFuelBurnTimeEvent` for fuel values
and `BlockDispenser.DISPENSE_BEHAVIOR_REGISTRY` with `IBehaviorDispenseItem`
for dispenser behavior. Fixed and procedure fuel values, fuel conditions,
dispense conditions and returned itemstacks are supported. Composting has no
1.12.2 equivalent and is excluded.

Loot tables are native JSON under `assets/<modid>/loot_tables` and are
registered with `LootTableList`. Pools carry stable `pool_<index>` names required
by Forge 1.12.2; rolls, bonus rolls, item/empty entries, weights, count ranges
and enchant-with-levels are supported. Blocks can enable custom loot-table drops,
which resolve `assets/<modid>/loot_tables/blocks/<registryname>.json` through
the world loot table manager. Modern table types, silk-touch/fortune/explosion-
decay conditions and loot modifiers are excluded. The shared 2026.3 editor still
shows entry fortune/silk-touch controls; MCreator's field-exclusion traversal
cannot reach dynamically-created list-entry components, so 1.12.2 ignores those
values until the upstream GUI supports exclusion paths for list entries.

Potion effects generate `Potion` subclasses with category, color, icon,
attribute modifiers, instant/beneficial state and optional procedures. Attribute
modifiers are removed explicitly by their stable UUIDs when the effect expires
or is cured, including by milk. Potion items generate a registered `PotionType`
with multiple `PotionEffect` entries, vanilla potion item localization and
splash/lingering brewing conversions. Honey curing, custom particle rendering
and a dedicated potion item class are not available in 1.12.2.

### Dimensions and biomes (batch 4)

Biomes generate registered `Biome` subclasses with climate/rainfall, top and
filler blocks, colors, spawn entries, vanilla tree types, overworld placement,
stronghold/village placement and a `RegistryEvent.Register<Biome>` initializer.
A custom-tree subset generates `WorldGenAbstractTree` classes with configurable
trunk/branch/vine/fruit blocks and minimum height. Ambient/additions sounds use
a client tick handler. `spawnInCaves` and `spawnBiomeNether` drive a generated
Mixin `World#getBiome` injection: the cave biome is returned for Overworld
positions below y=50, and the Nether biome is returned for dimension -1. Five climate ranges (temperature, humidity, continentalness, erosion, weirdness)
are exposed as a 1.12.2 Overworld weight proxy: each maps `abs(max-min)/4` to
0..100, summed to 0..500 (minimum 1). They do not implement modern climate
semantics; `genDepth` remains hidden. True per-Y cave biome storage, custom
particles, mood/music fields and modern structure placement are hidden.

Forge 1.12.2 Mixin support uses embedded Mixin `0.7.11-SNAPSHOT`, a
`MixinTweaker` manifest/launch hook, a generated `mixins.modid.json` and an RFG
refmap. The generated build script enables Mixin through `modUtils.enableMixins`.
World-height extension remains out of scope: 1.12.2 chunk height is hard-coded
at 256 and would require broad `Chunk`, lighting, rendering and IO changes.

Dimensions generate a `WorldProvider`, a `DimensionType` registered through
Forge's `DimensionManager`, and a custom `BiomeProvider` over the selected
dimension biomes. Normal, Nether, End and Void chunk generators are supported;
Void uses a minimal empty `IChunkGenerator`. Fog, clouds, fixed time, ambient
light, sky light, respawn/bed/weather behavior and player enter/leave procedures
are mapped. Portals/igniters are generated with a custom `BlockPortal` subclass
and rectangular frame scan; custom skyboxes use a six-face client
`IRenderHandler`; portal and biome ambient/additions sounds use native sound
events. Non-void custom dimensions use a generated noise generator with configurable
main filler, fluid, sea level, a simplified aquifer and native
`MapGenCaves`/`MapGenRavine` carving; this is dimension-only and does not replace
main-world/vanilla-nether generation. Full 1.18 climate/spline terrain semantics,
custom sun/moon rendering and ore-vein generation remain unavailable. The
`genTemperature` range is used as a finite Overworld biome-weight proxy, not as
a true climate model.

### Localization keys

The generator now emits canonical 1.12.2 keys: item-like elements use
`item.<modid>.<registryname>.name`, blocks/plants use
`tile.<modid>.<registryname>.name`, and armor pieces append the piece name before
`.name`. Enchantments keep `enchantment.<modid>.<registryname>` because
`Enchantment.getName()` adds the `enchantment.` prefix and translates that exact
key. Fluids keep `fluid.<modid>.<registryname>` and are given a namespaced
unlocalized name so Forge's `fluid.` prefix produces the same key. Custom
attributes use `attribute.name.<modid>.<registryname>` because 1.12.2 item
tooltips prepend `attribute.name.`. This prevents raw localization keys from
appearing in item tooltips and shield names.

### Other mod elements

All other 2026.3 mod elements (dimensions, biomes, living entities, special
entities, projectiles, GUIs, overlays, global triggers, advancements, structures,
features, commands, functions, key bindings, particles, paintings, banner
patterns, armor trims, etc.) are planned for later batches. They are not silently
generated: MCreator reports that no definition exists for the type in this
generator, and the support matrix marks them as unavailable.

## Name mappings and MCP compatibility

- The `mappings/` folder contains the complete 1.12.2 MCP name lists used by
  the implemented elements. Blocks and items use the 2026.3-compatible
  two-column form: column 0 is the Java expression (`Blocks.STONE#1`), column 1
  is the registry/meta form (`stone#1`).
- Tabs, item types, sounds, particles, entities and other lists remain in the
  scalar form that `NameMapper` accepts.
- Values without a 1.12.2 equivalent are mapped to a valid approximate vanilla
  value (for example `OP_BLOCKS` to `CreativeTabs.MISC`) and the degradation is
  documented here and in the support matrix. Code generation never receives an
  unresolved `__unmapped__` placeholder.
- The `types.yaml` mapping is extended with the 2026.3 variable types
  (`logic`, `blockstate`, `actionresulttype`, `cmdcontext`, `damagesource`,
  `vector`, `advancement`) using their 1.12.2 MCP types.

## Build chain and runtime

- Plugin build: Gradle 9.8.0, Java 25 toolchain, local distribution URL, caches
  inside the project (`gradlew` sets `GRADLE_USER_HOME`).
- Generated mod: RetroFuturaGradle 2.0.6, Gradle 9.8.0, Java 8 toolchain, MCP
  snapshot `20171003`, Forge `1.12.2-14.23.5.2847`.
- Gradle 9.8 runs on MCreator's Java 25 runtime, so MCreator's Java 25 Gradle
  synchronization action can be parsed and loaded. RetroFuturaGradle then
  compiles and runs the mod with a Java 8 toolchain. The previous ForgeGradle
  2.3 / Gradle 4.10.3 chain failed with `Unsupported class file major version
  69` for exactly this reason.
- No MCreator Java home override to JDK 8 is needed. The Gradle JVM stays on
  Java 25 (or any Gradle 9.8 supported JDK). If no local JDK 8 is present, the
  Foojay toolchain resolver configured in the generated `settings.gradle`
  provisions one into the Gradle user home.
- `14.23.5.2847` is RetroFuturaGradle's supported 1.12.2 Forge version and the
  newest build that still publishes the legacy `-userdev` artifact. Build `2864`
  is not used by the RFG 2.0.6 1.12.2 defaults.

## Known Limitations

1. **Batch scope.** Creative tab, item, recipe, block and preview procedure
   definitions exist in this batch, together with the Ore Dictionary bridge for
   tags. The generator is marked `status: dev`; it does not claim full coverage
   of the 2026.3 feature surface yet.
2. **Item feature coverage.** Procedures, GUI inventories, ranged behaviour,
   custom models and the other item features listed above are unavailable and
   the corresponding editor fields are hidden.
3. **Creative tabs.** Multiple tab membership is implemented through
   `getSubItems` overrides for items and tools. Forge 1.12.2 still has a single
   default tab (`setCreativeTab`), so tab sorting and the "search" tab use the
   first selected tab.
4. **Unsupported recipe types.** Blasting, Smoking, Campfire cooking, Stone
   cutting and Smithing do not exist in Forge 1.12.2 and fail code generation
   explicitly. Crafting, furnace smelting and brewing are implemented.
5. **Workspace variables.** Global workspace variables have no WorldSavedData
   implementation in this batch. If variables exist, `variableslist.java.ftl`
   stops generation with an explicit error instead of emitting broken code.
6. **Procedure coverage.** Only the preview blocks listed above have 1.12.2
   templates. Global triggers are not implemented, and other procedure blocks
   fail generation explicitly. Right-click procedures on slabs are skipped.
7. **Block coverage.** Basic cubes, stairs, slabs, fences and walls are
   implemented. Other bases, custom/multipart states, inventories, world
   generation and tool tiers are hidden and belong to a later batch.
8. **Tag coverage.** Only `ITEMS` and `BLOCKS` tags are mapped to the Ore
   Dictionary. Nested tag references are ignored, and non-item/block tag types
   have no 1.12.2 equivalent.
9. **Shield rendering.** Forge 1.12.2 binds the vanilla `builtin/entity` shield
   renderer and banner-pattern decoration to `Items.SHIELD`; custom shields
   therefore use a generated flat blocking model. Custom shield blocking models
   (`blockingRenderType` 1 and 2) are rejected explicitly, and shield GUI
   textures are hidden. Shield attribute modifiers apply in either hand because
   per-slot attribute modifier entries are not fully mapped.
10. **Toolchain provisioning.** A Java 8 toolchain is required for compilation and
   runtime. It is auto-detected when installed, otherwise downloaded through the
   Foojay resolver. Machines without network access must install a JDK 8 and let
   Gradle detect it (or set `org.gradle.java.installations.paths`).
11. **Cache redirection under MCreator.** The wrapper-based builds created by
   this project keep all Gradle caches in `<project>/caches/gradle`. MCreator's
   Tooling API removes `GRADLE_USER_HOME` from the environment and does not
   provide a generator-level setting for the Gradle user home, so a build
   started by MCreator's own Gradle integration uses MCreator's cache location.
   No generator resource can override that without patching MCreator.
12. **Sound and language resources.** Sound definitions are only generated when
   sound elements exist; the sound element type itself belongs to a later
   batch. The language file is written by MCreator's localization system from
   the localization keys declared by the definitions, not by a template.
13. **No in-game verification in this batch.** Per the delivery specification,
    the generator stops after a zero-error compile/build and waits for the
    user's real-device test.
14. **Item extension coverage.** Fuel and dispenser behavior are implemented;
    composting is not available in 1.12.2 and is hidden. Procedure fuel and
    dispense values use the preview procedure runtime.
15. **Loot table coverage.** The generator emits native 1.12.2 JSON but does not
    support modern loot modifiers, top-level table types or entry
    silk-touch/fortune/explosion-decay conditions. The shared 2026.3 editor still
    displays the entry fortune/silk-touch controls; generator field exclusions
    cannot address dynamically-created list-entry components, so those values
    are ignored until an upstream GUI change.
16. **Potion effect coverage.** Honey curing and custom particle rendering are
    unavailable. Custom icons are rendered through the 1.12.2 potion HUD/
    inventory hooks.
17. **Potion item coverage.** Potion items are registered as `PotionType`
    entries on vanilla potion items, not as a new item class. Splash and
    lingering variants are added through custom brewing recipes.
18. **Dimension/biome coverage.** Non-void custom dimensions use a custom noise
    generator with filler/fluid/sea-level and simplified aquifer support; this is
    not the full 1.18 density/spline/climate engine, and it is not a main-world or
    vanilla-nether generation hook. Portals use a simplified rectangular frame
    scan and do not implement every vanilla `BlockPortal.Size` rule; custom
    portal conditions/particles and custom sun/moon textures remain hidden.
    Biome custom trees are a limited trunk/branch/vine/fruit subset, and modern
    climate/noise/structure features remain hidden. Mixin cave injection is
    column-based (`y < 50`) rather than true per-Y biome storage; Nether
    injection replaces dimension -1 globally. World-height extension is not
    implemented because 1.12.2 hard-codes 256-height chunk storage and client
    handling across many classes. Generated sources avoid
    `javax.annotation.Nullable` because that annotation is not on the generator's
    Java 8 compile classpath.

## Entities and client UI (2026.3-1.0.26.73-beta)

This batch adds living entities, projectiles, special entities, GUIs,
overlays, key bindings and particles.

### Implemented

- **Living entity**: native 1.12.2 base classes, attributes, equipment,
  drops, sounds, boss bars, spawn eggs, biome/dungeon spawns, spawn placement,
  ridable controls, flying/water movement, breeding/taming, entity data,
  immunities, spawn conditions, ranged attacks and custom projectiles.
- **Projectile**: `EntityArrow` subclass with item or Java-model rendering,
  damage/knockback/power, hit callbacks and flying-tick procedures.
- **Special entity**: boat subclass and custom item; chest variants expose a
  persisted 27-slot `IInventory` through vanilla `GuiChest`.
- **GUI**: `GuiContainer`/`Container` pair with optional slots, background,
  labels, images, sprites, buttons, image buttons, text fields, checkboxes,
  sliders, tooltips and entity previews, plus open/tick/close procedures and
  button/slider/slot messages.
- **Overlay**: in-game and screen-targeted `RenderGameOverlayEvent` /
  `GuiScreenEvent` rendering with priority and display conditions.
- **Key binding**: keyboard and mouse bindings with press/release procedures.
- **Particle**: custom `EnumParticleTypes` entries, texture stitching,
  animation frames, scale/rotation/gravity/collision/brightness controls.
- **Procedure blocks**: GUI open/close, text/checkbox/slider state and slot
  item/amount/set/remove/clear/damage operations.
- **AI tasks**: 1.12.2 implementations for the standard `EntityAI*` tasks and
  a shared condition macro.

### Known limitations

- `guiBoundTo` and embedded entity inventories are hidden; use GUI procedures
  to open a standalone generated GUI.
- `animations`, `boundingBoxScale` procedures, trident immunity, vibration and
  raid fields are hidden.
- Boat textures are the vanilla wood textures; rafts are generated as boats.
- GUI slot inventories are standalone and drop items when the screen closes.
- Overlay buttons and editable widgets are not supported.
- 1.12.2 has no fish model, so `Cod`/`Salmon` fall back to the squid model.
- Custom particle registration extends the enum's private maps via reflection
  because 1.12.2 has no particle registry.

## Worldgen, data and economy (2026.3-1.0.30.94-beta)

This batch adds advancement JSON, Java structure/feature worldgen, villager
professions/trades, commands, functions, game rules and music discs.

### Implemented

- **Advancement**: 1.12.2 advancement JSON with display, parent, rewards and
  the common JSON trigger templates.
- **Structure**: an `IWorldGenerator` that loads NBT templates from
  `assets/<modid>/structures` and places them with biome, spacing, separation
  and optional fixed-height controls.
- **Feature**: Java generators for simple block, random patch, ore and
  scattered ore features.
- **Villager profession/trade**: `VillagerRegistry` professions and
  `VillagerCareer` trades for the pre-village-update 1.12.2 system.
- **Command**: `CommandBase` registration with permission and side targeting.
- **Function**: 1.12.2 `.mcfunction` datapack files.
- **Game rule**: `GameRules` registration and get/set procedure blocks.
- **Music disc**: `ItemRecord` subclasses with record sound and description.

### Known limitations

- 2026.3 Brigadier command arguments are hidden; the generated 1.12.2 command
  exposes raw arguments only.
- Feature support is limited to simple block, random patch, ore and scattered
  ore; other feature types stop generation explicitly.
- Structure and feature data-driven placement chains, jigsaw pools, terrain
  adaptation and generation conditions have no 1.12.2 equivalent.
- Villager professions cannot use points of interest, work sounds or hats;
  wandering-trader trades are not available.
- Music disc length-in-ticks and comparator analog output are hidden; a custom
  record sound must still be present in `sounds.json`.
- Structures must be shipped manually under
  `assets/<modid>/structures/<name>.nbt`.

## Banner patterns, paintings and tag hardening (2026.3-1.0.30.94-beta)

### Implemented

- Banner patterns extend the `BannerPattern` enum and generate a pattern item,
  banner/shield textures and vanilla `RecipesBanners` matching.
- Custom paintings are deliberately unsupported: the 1.12.2 client renderer
  could not reliably display generated painting entities, so the definition
  and its item/entity/renderer templates were removed.
- Tag conversion now covers custom blocks/plants/fluids and custom
  item/tool/armor/dimension/special-entity items. Unsupported tag types and
  nested tags generate explicit comments.

### Known limitations

- 1.12.2 banner patterns require a pattern item, so `requireItem` is effectively
  always enabled.
- Painting dimensions must be positive multiples of 16 pixels.
- The 1.12.2 Ore Dictionary has no equivalent for function, structure, entity,
  biome or enchantment tags; those remain comments in generated code.
- Damage type remains planned for the procedure batch; armor trim is not
  available in 1.12.2.

## Verification log

| Step | Result |
| --- | --- |
| Plugin build (`gradlew build`, JDK 25) | `BUILD SUCCESSFUL` |
| Static validator | `VALIDATION PASSED` (65 YAML documents, 685 templates, 130 template references) |
| Plugin discovery in MCreator 2026.3.44621 | Plugin loaded, `compatible=true`, weight 100 |
| Workspace creation with `forge-1.12.2` | Succeeded in headless MCreator harness |
| Base and element template rendering | Succeeded; tab, item and recipe sources and JSON generated |
| RetroFuturaGradle 2.0.6 / Gradle 9.8.0 / Java 8 toolchain | `BUILD SUCCESSFUL`; `build/libs/modid-1.0.jar` (reobfuscated) and `modid-1.0-dev.jar` produced. Only deprecation notes for `setUnlocalizedName` (expected on 1.12.2). |
| Multi-tab item (`CUSTOM:ModTab` + `FOOD`) | `BUILD SUCCESSFUL`; generated item contains the `getSubItems` override and both tab entries. In-game membership is part of the user's real-device test. |
| Crafting + smelting + brewing recipe workspace | `BUILD SUCCESSFUL`; the generated `<Mod>Recipes` class registers a furnace recipe through `GameRegistry.addSmelting` and a brewing recipe through `BrewingRecipeRegistry`, with a potion-type aware `IBrewingRecipe` implementation. |
| Basic cube block + block item + Ore Dictionary tags | `BUILD SUCCESSFUL`; the generated `<Mod>Blocks`/`<Mod>Items` classes register a block and its item, and `<Mod>OreDictionary` registers `oreTest`/`ingotTest` entries from `BLOCKS`/`ITEMS` tags. |
| Stairs/slab/fence/wall bases and per-face textures | All block state/model JSON parses, and the generated block classes compile with RFG (`BUILD SUCCESSFUL`). |
| Block procedure triggers | Generated right-click/added/tick calls were compiled against a stub procedure class (`BUILD SUCCESSFUL`). The procedure block templates and MCreator-side procedure editor need the user test. |
| New elements (item extension, loot table, potion effect, potion item) | FreeMarker render + `javac --release 8` `PASSED`; loot table JSON parses with named pools/entries/functions. |
| Block custom loot table + potion attribute cleanup | Test workspace full `javac --release 8` `PASSED`; direct 1.12.2 attribute-map probe removes movement-speed/max-health modifiers by UUID. |
| Biome + dimension (Normal/Nether/End/Void/custom effects) | FreeMarker render + `javac --release 8` `PASSED`; generated biome, dimension, void chunk generator, biome provider, registries and combined mod class compile together. |
| Advancement, structure/feature, villager, command/function/game rule, music disc | FreeMarker render + `javac --release 8` `PASSED`; advancement JSON parses; generated worldgen, villager, command, game-rule and record classes compile against patched 1.12.2. |
| Legacy metadata block references | `Blocks.STONE#3` renders as `Blocks.STONE.getStateFromMeta(3)` and compiles; the same shared helper is used by biome and other block-state templates. |
| Biome entity spawn entries | `EntityZombie` and `EntityEnderman` spawn entries compile with fully-qualified classes from the `entityclasses` mapping; custom entities use `${package}.entity.<name>`. This avoids MCreator's import-formatter stripping wildcard imports. |
| Portal/igniter, skybox, biome sounds, custom tree | Templates render and compile; portal JSON models parse; generated block/item registries compile; sound branches and custom tree class compile. |
| Custom dimension terrain | Noise/filler/fluid/sea-level/aquifer generator renders and compiles with the dimension provider. |
| Custom dimension caves | `MapGenCaves`/`MapGenRavine` overrides for custom filler render and compile; biome weight uses the fixed test weight 100. |
| Mixin cave/Nether injection | Worldgen hooks and `World#getBiome` Mixin render and compile against Mixin 0.7.11; Mixin JSON parses. |
| Living entity + renderer + custom projectile | Representative built-in model, custom Java model, ranged, breeding/taming, boss, flying, ridable, data and layer variants render and compile. |
| Projectile + renderer | Default item and custom Java model variants render and compile. |
| Special entity + item | Chest boat and plain boat variants render and compile; chest inventory delegates compile against 1.12.2 `IInventory`. |
| GUI + overlay | Full-widget GUI, no-slot GUI, in-game overlay and vanilla-screen overlay variants render and compile. |
| Key binding + particle | Keyboard/mouse bindings, static and animated particles with angular motion render and compile. |
| AI tasks | All 27 AI task templates render together and compile against 1.12.2 AI classes. |
| GUI procedures | All generated GUI procedures render and compile against the generated GUI state/handler classes. |
| ForgeGradle 2.3 / Gradle 4.10.3 (superseded) | Failed during MCreator synchronization with `Unsupported class file major version 69`. The old chain cannot parse or load MCreator's Java 25 synchronization action. |

The generated-mod build used the exact workspace base, templates and generated
sources that are packaged in the plugin archive. The build was started through
the generated workspace wrapper with Gradle 9.8 running on Java 25 and a Java 8
toolchain for compilation; `GRADLE_USER_HOME` pointed to the workspace-local
`caches/gradle` folder. MCP mappings are the 1.12.2 snapshot `20171003`, which
is also what MCreator 1.12.2 uses (`setUnlocalizedName`, `getTabIconItem`). The
MCP `stable` channel is intentionally not used because it contains Mojang
official names (`setTranslationKey`, `createIcon`) that do not match the 1.12.2
API used by MCreator.

Remaining acceptance item: launch the Forge 1.12.2 client and verify item
extensions, loot tables, potion effects, potion items, biomes, dimensions,
living entities, projectiles, boats, GUIs, overlays, key bindings and custom
particles in game. Per the delivery specification this real-device test is
performed by the user before the next batch starts.




