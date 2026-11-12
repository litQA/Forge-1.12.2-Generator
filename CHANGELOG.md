# Changelog

# 2026.3-1.0.30.95-beta

## New Content

- Advancement JSON generation, including parent, frame, background, toast,
  chat announcement, hidden state, rewards and the 1.12.2 JSON trigger set.
- Java-based structure generation from NBT templates, with biome restrictions,
  spacing and optional fixed start-height range.
- Java-based feature generation for simple block, random patch, ore and
  scattered ore definitions.
- Villager professions and trades for the pre-village-update 1.12.2
  `VillagerRegistry`/`VillagerCareer` system.
- Command registration with permission and singleplayer/multiplayer/client
  targeting, plus datapack function files.
- Game rule registration and game-rule get/set procedure blocks.
- Music disc items based on 1.12.2 `ItemRecord`, including record sound,
  description and creative-tab handling.
- Banner pattern generation through a 1.12.2 `BannerPattern` enum extension,
  generated pattern item, banner/shield textures and vanilla
  `RecipesBanners` integration.
- 61 native Forge 1.12.2 procedure triggers, including block, entity, player,
  world and mod-lifecycle triggers.
- A 1.12.2 `DamageSource` adapter for the Damage Type element and damage-source
  procedure blocks.
- The Forge 1.12.2 baseline procedure template set (442 templates) for broad
  procedure-block coverage.

## Changes

- Added global trigger/procedure registration and lifecycle dispatch.
- Added `docs/TRIGGER-CLASSIFICATION.md` with the complete 2026.3 trigger
  classification.
- Custom painting generation was removed; custom paintings are marked
  unavailable because the 1.12.2 client renderer could not reliably display
  generated painting entities.

- Added common `item.record.<name>.desc` localization generation for music
  discs.
- Added `jsontriggers` templates and the related MCItem JSON helper.
- Added worldgen registration through `GameRegistry.registerWorldGenerator`.
- Added villager profession and game-rule data mappings.
- Expanded Ore Dictionary tag conversion to custom plants, fluids, tools,
  armor, dimensions and special-entity items; unsupported tag types and
  nested tags now emit explicit generated comments.

## Fixes

Fixed 12 bug(s).
- Villager profession skin resource locations now include the `.png`
  extension required by 1.12.2 `SimpleTexture`.
- The villager profession mapping now honours the `CUSTOM:` prefix, so
  custom trade tables attach to the generated custom career instead of the
  farmer career.
- Custom profession trades now resolve the generated career symbol directly
  from the workspace element, avoiding a mapping fallback to the farmer.
- Added the missing `_mcitem` JSON trigger helper and fluid-bucket icon
  mapping, restoring advancement criteria generation and custom icons.
- Stripped whitespace from the JSON trigger item helpers so item ids no longer
  contain a trailing newline and fail `ItemPredicate.deserialize`.
- Added the 1.12.2 `cmdargs/_call_procedure.java.ftl` template and emit
  `argscode` inside the generated command's `execute` method.
- Command registration now uses the mod's `FMLServerStartingEvent` handler
  instead of an invalid `@SubscribeEvent` on the FML lifecycle event.
- Painting renderer generation was moved to a global template; the previous
  per-element template referenced `types` and aborted generation of the
  painting item and entity.
- Custom painting entities now initialize their `EnumArt` in the client-side
  default constructor and drop the custom painting item instead of the vanilla
  painting item.
- Banner pattern items now use a visible vanilla paper item model and include
  a shaped paper recipe so they are obtainable in survival.
- Banner/shield pattern textures are mirrored into the `minecraft` namespace
  and resized to 64x64 during `processResources`, matching 1.12.2
  `BannerTextures` lookups.
- Custom painting entities now register a fallback renderer for the base
  `EntityPainting` type in addition to the custom painting entity class.

## Known Limitations

- 2026.3 command arguments are Brigadier-based; the 1.12.2 backend registers
  the command and exposes raw arguments only, so the argument editor is hidden.
- Feature support is limited to simple block, random patch, ore and scattered
  ore; other feature types stop generation with an explicit error.
- Structure/feature placement steps, jigsaw pools, terrain adaptation and
  data-driven generation conditions are not available in 1.12.2.
- Villager professions cannot use points of interest, work sounds or hats;
  wandering-trader trades are not generated in 1.12.2.
- Structure NBT files must be present at
  `assets/<modid>/structures/<name>.nbt`.
- Music disc length-in-ticks and comparator analog output have no 1.12.2
  `ItemRecord` equivalent and are hidden.
- The music disc plays through a constructed `SoundEvent`; custom sounds must
  still be present in the generated `sounds.json`.
- 1.12.2 banner patterns require a pattern item; `requireItem` is therefore
  always treated as true and the generated item is used for recipe matching.
- Custom painting generation was removed; the element is marked unavailable
  because the 1.12.2 client renderer could not reliably display generated
  painting entities.
- 2026.3 trigger support is split into 61 native triggers and four deferred
  Mixin/adapter triggers; see `docs/TRIGGER-CLASSIFICATION.md`.
- Damage-type exhaustion cannot be applied because 1.12.2 `DamageSource`
  exposes no hunger-damage setter.
- The procedure baseline is the Forge 1.12.2 reference set; modern-only blocks
  not represented there still require follow-up work.

# 2026.3-1.0.26.73-beta

## New Content

- Living entity generation with built-in and Java models, renderer layers,
  spawn eggs, biome/dungeon spawning, attributes, equipment, drops, sounds,
  boss bars, ridable controls, flying/water movement, breeding/taming,
  entity data, immunities, spawn conditions, ranged attacks and custom
  projectiles.
- Projectile generation based on `EntityArrow`, including default or Java
  renderers, item rendering, damage/knockback/power, gravity/fire/particle
  flags, hit/block/player callbacks and flying-tick procedures.
- Special entity generation for 1.12.2 boats, including a custom item,
  chest-boat inventory and vanilla chest GUI opening.
- GUI generation with background rendering, labels, images, sprites, buttons,
  image buttons, text fields, checkboxes, sliders, tooltips, entity previews
  and custom/player inventory slots.
- Overlay generation for the in-game HUD and vanilla screens, including
  priority, target screen, display conditions, labels, images, sprites and
  entity previews.
- Key binding generation with keyboard and mouse bindings, press/release
  callbacks and a server-bound message channel.
- Particle generation with custom `EnumParticleTypes` registration, texture
  atlases, animation frames, scale/rotation/gravity/collision controls,
  full-bright rendering and expiry conditions.
- GUI procedure blocks for opening/closing screens, reading/writing text
  fields, checkboxes, sliders and slot contents, plus slot change/take/transfer
  callbacks.
- AI task templates for the core 1.12.2 `EntityAI*` behaviors and custom
  `EntityAIBase` conditions.

## Changes

- Added entity, projectile and special-entity registries, client renderer
  registration and a shared `SimpleNetworkWrapper` channel.
- Added `IGuiHandler` registration, a lightweight GUI state channel and
  client-safe reflective GUI construction.
- Added GUI, overlay, key-binding and particle definitions, mappings and
  localization keys.
- Added Java model copying through `sources_setup_tasks` and
  `javamodel.java.ftl`.
- Reworked AI task include paths and added `aiconditions.java.ftl`.

## Fixes

Fixed 12 bug(s).
- Overlay component positions now resolve `GUIComponent.AnchorPoint.name()`
  instead of the localized `toString()` value. The previous comparison never
  matched, so anchors such as `BOTTOM_LEFT`/`BOTTOM_RIGHT` rendered empty
  coordinates.
- Living entity renderers now read `mobModelTexture` as the string field used by
  the 2026.3 element model, instead of calling `TextureHolder` methods.
- Special entity templates now use the standard `REGISTRYNAME` token for the
  boat item instead of an undefined `specialentity` variable.
- Custom MCItem mapping now emits `_ITEM` for plant block items and
  `_BUCKET` for fluid bucket references; unresolved custom items fall back to
  `ItemStack.EMPTY` instead of failing template rendering.
- Projectile renderers are always generated and branch internally between
  `RenderSnowball` and the Java-model renderer; this removes the invalid
  `entityModel != "Default"` definition condition.
- Entity spawn placement uses `IN_AIR` for unrestricted spawning because
  1.12.2 `EntityLiving.SpawnPlacementType` has no `NO_RESTRICTIONS`; monsters
  and creatures use `ON_GROUND`.
- Living entity sources now import the complete set of 1.12.2 `EntityAI*`
  classes and `Vec3d` used by the generated AI task snippets. This fixes the
  missing `EntityAILookIdle`/similar symbols in generated entity classes.
- Spawn eggs now have the additional `entity.<registryname>.name` localization
  key used by 1.12.2 `ItemMonsterPlacer`; entity data/NBT names remain the
  registry name.
- Custom creative tabs now append the spawn eggs of living entities that
  selected that tab, because the vanilla spawn-egg item cannot change its
  default tab.
- Armor and special-entity items now override `getSubItems` when multiple
  creative tabs are selected, matching the existing item/tool behavior.
- GUI widget state is now applied directly on the network thread and seeded
  with the element's initial slider/checkbox/text values. The close path also
  sends the final widget values before `closeScreen`, so `onClosed` procedures
  no longer read zero/default values.
- Particle factories are now registered both during `TextureStitchEvent.Pre`
  and from the client initialization event, so a custom particle ID is never
  decoded without a factory if texture stitching runs before the effect
  renderer is ready.

## Known Limitations

- `guiBoundTo`/embedded entity inventories are hidden; entity GUIs are opened
  through the generated GUI procedures instead.
- `boundingBoxScale`, modern vibration/raid fields, animations and trident
  immunity are hidden or ignored.
- Custom boat textures are not applied: 1.12.2 boats use the vanilla
  `RenderBoat` wood textures. Rafts and chest rafts are generated as boats;
  chest variants expose a 27-slot inventory through `GuiChest`.
- Entities are column/height independent; 1.12.2 has no per-Y or synced entity
  data component registry beyond the generated `DataParameter` values.
- Custom particle registration extends the enum and its private lookup maps
  through reflection, because 1.12.2 has no particle registry.
- GUI slot inventories are standalone `InventoryBasic` instances; they are
  not bound to tile entities or item stacks.
- Overlay tooltips, buttons and editable widgets are not rendered; overlay
  content is limited to labels, images, sprites and entity previews.
- `Cod`/`Salmon` models do not exist in 1.12.2 and fall back to the squid
  model.

## Verification

- `gradlew validateGenerator` reports `VALIDATION PASSED`.
- Representative FreeMarker renders for every new element compile with
  `javac --release 8` against the patched 1.12.2 client and Forge.
- AI task, GUI procedure and custom-model render probes compile with zero
  errors.
- `gradlew clean build` reports `BUILD SUCCESSFUL` and produces
  `build/dist/generator-forge-1.12.2.zip`.

# 2026.3-1.0.25.64-beta

## Fixes

- Cave-biome injection no longer applies at `y=0`. 1.12.2 biome decoration
  commonly calls `World#getBiome` with a y=0 position, so the previous
  `y < 50` rule made surface decoration use the cave biome. That caused:
  - the cave biome's custom tree to appear in vanilla biomes such as extreme
    hills
  - vanilla biomes to lose their normal tree decoration
  - the custom surface biome to appear absent/incorrect during decoration
- The cave biome now applies only to `0 < y < 50`; the Nether injection is
  unchanged.

## Verification

- Worldgen hook/Mixin templates compile.
- Weighted biome registration and the five-range weight proxy are unchanged.


# 2026.3-1.0.24.63-beta

## Changes

- Exposed five Biome climate rows for a 1.12.2 weight proxy:
  `genTemperature`, `genHumidity`, `genContinentalness`, `genErosion`,
  `genWeirdness`.
- Each row maps `abs(max-min)/4` to `0..100`; the five values are summed to a
  final `0..500` weight, with a minimum of 1.
- `genDepth` remains hidden and is not part of the weight sum.
- The test biome now has all five ranges set to `[-2,2]`, producing weight 500.

## Evaluation

- This is safe and easy to implement because all five ranges are already stored
  in the Biome element and `BiomeManager.BiomeEntry` accepts an integer weight.
- It remains a proxy: the five climate fields do not drive modern climate/noise
  in 1.12.2; they only produce the Overworld surface biome weight.
- Custom dimension biome selection and the Mixin cave/Nether injections do not
  use this weight.


# 2026.3-1.0.23.62-beta

## Changes

- Exposed the Biome climate row `genTemperature` in the editor and use its
  range as a 1.12.2 weight proxy:
  `weight = clamp(abs(max - min) / 4, 0, 1) * 100`, minimum 1.
  - `[-2, 2]` -> 100
  - `[-0.5, 0.5]` -> 25
- The other modern climate rows remain hidden; 1.12.2 has no use for them.

## Evaluation

- This is feasible and implemented for Overworld `BiomeManager.BiomeEntry`
  registration.
- It is a proxy only: the field remains a modern climate interval in the
  element model; in this 1.12.2 generator it does not affect climate/noise.
- Custom-dimension biome selection uses the dimension's own biome provider and
  is not controlled by this weight. Cave/Nether Mixin injection is global and
  also weight-independent.


# 2026.3-1.0.22.61-beta

## Changes

- Custom non-void dimensions now carve caves and ravines with
  `MapGenCaves`/`MapGenRavine` after terrain generation. The carvers are adapted
  to the configured main filler block and run unconditionally, so Caves are no
  longer dependent on the hidden `defaultFeatures` UI.
- Increased the default Overworld `BiomeManager.BiomeEntry` weight from 10 to
  100 to make custom biomes easier to find without `/locatebiome`.

## Weight Evaluation

- 1.12.2 `BiomeManager.BiomeEntry` supports numeric weights, but the MCreator
  26.3 Biome element has no weight field. Generator definitions only hide/show
  existing fields, so a per-biome weight slider cannot be added from this
  generator alone.
- The generated code uses a fixed weight of 100 as a practical test workaround.
  A real user-configurable weight requires an upstream Biome element/UI field or
  a separate workspace configuration.
- Cave and Nether biome injection is global through the Mixin `World#getBiome`
  hook and does not depend on the surface biome weight.

## Known Limitations

- `defaultFeatures` remains hidden; caves are generated for all non-void custom
  dimensions in this batch.
- Weight is not user-configurable; it is a fixed test-oriented default.


# 2026.3-1.0.21.60-beta

## Fixes

- Moved `WorldgenHooks` from `<package>.mixin` to `<package>.worldgen`.
  Mixin treats classes in the configured mixin package as mixin classes, so
  directly calling a helper in that package crashed with
  `NoClassDefFoundError: ...WorldgenHooks is a mixin class and cannot be
  referenced directly`. The Mixin class now imports the helper from the normal
  `worldgen` package.
- The generated Mixin JSON now contains only the actual Mixin class.

## Migration

- Delete the old generated file
  `src/main/java/<package>/mixin/<Mod>WorldgenHooks.java` after regenerating.
  The new file is
  `src/main/java/<package>/worldgen/<Mod>WorldgenHooks.java`.


# 2026.3-1.0.20.59-beta

## Fixes

- Fixed the generated Mixin config filename: it now uses the actual mod id
  (`mixins.<modid>.json`) instead of the literal `mixins.modid.json`.
- Fixed missing generated Mixin sources: base templates now query
  `types.biomes` instead of the unavailable `biomes` variable.
- Build script now reads the mod id from `src/main/resources/mcmod.info` and
  derives the config/refmap/manifest names dynamically.
- Removed the stale `mixins.modid.json` from the test workspace; the next
  regeneration should write `mixins.test.json` and the two Mixin source files.


# 2026.3-1.0.19.58-beta

## Fixes

- Avoid a missing `TestModBiomes` class when a workspace has no biomes: the
  worldgen hook and Mixin source are generated only when biomes exist, while
  the Mixin config remains present and contains an empty mixin list.
- Keep the Mixin config manifest name stable (`mixins.modid.json`) so the build
  script and generated config always match.

## Known Limitations

- Workspaces created before 1.0.18.57 need the updated `build.gradle` (or a
  recreated workspace) for Mixin bootstrap/refmap/embedding support.
- Mixin cave injection remains column-based below y=50; Nether injection is
  global for dimension -1.


# 2026.3-1.0.18.57-beta

## Changes

- Added Forge 1.12.2 Mixin infrastructure:
  - bundled Mixin `0.7.11-SNAPSHOT`
  - `MixinTweaker` launch bootstrap
  - `MixinConfigs`/`ForceLoadAsMod` jar manifest
  - RFG refmap generation
  - generated `mixins.modid.json`
- Added global biome injection:
  - cave biome injected below `y=50` in the Overworld via a `World#getBiome`
    Mixin
  - Nether biome injected globally in dimension `-1`
  - selection comes from the Biome element's `spawnInCaves` and
    `spawnBiomeNether` fields, now visible in the editor
- Added generated `worldgen_hooks` helper and Mixin class.

## Height Extension Evaluation

- A true 320+64 world generation range is **not implemented**. Forge 1.12.2
  hard-codes chunk height/section storage and client height handling at 256.
  Extending it requires broad Mixin changes across `Chunk`, `ChunkPrimer`,
  world height queries, lighting, rendering, saving and third-party mod
  compatibility. The current custom terrain remains clamped at 252 and uses
  tanh compression to avoid 256 cut faces.
- Height extension is deferred until it can be treated as a separate,
  compatibility-focused feature rather than a small patch.

## Known Limitations

- Cave injection is column-based through `World#getBiome`; it is not a separate
  per-Y biome storage layer.
- The configured cave biome applies to all Overworld positions below y=50,
  including non-cave underground areas.
- Nether injection replaces the biome lookup for dimension -1 globally.
- Mixin 0.7.11 is embedded in the output jar; this increases jar size and may
  conflict with packs that force another Mixin version.


# 2026.3-1.0.17.56-beta

## Fixes

Fixed 2 bug(s).

- Portal teleportation now searches for a safe two-block-high standing position
  around the destination spawn point and creates a small fallback platform if
  the target is void. This prevents spawning inside walls.
- Custom terrain heights are clamped below the 1.12.2 256-block world ceiling,
  and the noise contribution is tanh-shaped/capped so large vertical-noise
  settings no longer create broad 256-block cut surfaces.

## Known Limitations

- 1.12.2 has a hard 256-block chunk/world height (`ChunkPrimer`/`Chunk`).
  Raising the usable terrain ceiling to 320+64 requires a Mixin/coremod that
  changes chunk section storage and client height handling; it is not possible
  through the current non-Mixin generator path.
- The safe-spawn search uses a bounded radius and a stone fallback platform in
  void dimensions.


# 2026.3-1.0.16.55-beta

## Fixes

Fixed 1 bug(s).

- Removed chunk-edge terrain cliffs. The custom generator previously sampled
  `NoiseGeneratorOctaves` with per-chunk offsets; adjacent chunks received
  mismatched noise samples and generated independent plateaus. Height and detail
  are now sampled from stateless `NoiseGeneratorPerlin` fields at absolute world
  coordinates, so heights and aquifer pockets continue across chunk borders.

## Verification

- Boundary probe: x=15/x=16 heights are 53/54 with a 0.05 noise delta instead
  of a chunk-size cliff.
- Custom terrain template compiles with `javac --release 8`.


# 2026.3-1.0.15.54-beta

## Changes

- Added a custom `IChunkGenerator` for dimensions:
  - configurable main filler block
  - configurable fluid block
  - configurable sea level
  - multi-octave noise heightmap with horizontal/vertical noise scales
  - simplified aquifer pockets using a second 2D noise field
  - biome top/filler surface generation and biome decoration
- Custom terrain is only used by custom dimensions; no main-world or vanilla
  Nether generation hook is generated.

## Known Limitations

- This is a 1.18-style approximation, not a full density/spline/climate engine.
  Climate is still selected through the dimension's biome provider, and the
  aquifer uses a simplified noise field rather than the full 1.18 aquifer
  scheduler.
- `worldGenType == Void gen` keeps the empty void generator; custom filler/fluid
  fields apply to the non-void custom generator.
- `generateOreVeins` remains hidden because no compatible ore-vein engine is
  generated in this batch.


# 2026.3-1.0.14.53-beta

## Fixes

Fixed 2 bug(s).

- Skybox texture paths now append `.png` and use the workspace texture root
  (`assets/<modid>/textures/<name>.png`). The previous path omitted `.png` and
  incorrectly inserted `skybox/`, causing every face to fail loading.
- Portal teleportation now uses a generated custom `ITeleporter` that places the
  entity directly at a target/spawn position. It no longer invokes vanilla
  `Teleporter.placeInExistingPortal`, which threw a `NullPointerException` for
  custom dimensions.

## Known Limitations

- The custom teleporter uses the destination spawn point rather than generating
  a return portal at the exact entry point.
- Skybox textures must already exist under `assets/<modid>/textures`; missing
  textures now fail with the correct path in the log but do not crash.


# 2026.3-1.0.13.52-beta

## Fixes

Fixed 1 bug(s).

- The custom-tree template no longer uses the invalid numeric condition
  `treeType %= 1`. MCreator's condition parser tried to cast the integer to a
  string, skipped the template and left `TestBiomeTreeFeature` missing. The tree
  class is now always generated; the biome only references it when
  `treeType == 1`.

## Known Limitations

- Every biome now emits a tree generator class even when vanilla tree types are
  selected. The unused class is harmless and avoids a fragile numeric template
  condition.


# 2026.3-1.0.12.51-beta

## Changes

- Added native 1.12.2 dimension **portals and igniters**: a custom
  `BlockPortal` subclass, simplified frame scanning, teleporter entry/return,
  portal blockstate/models, igniter item/model and block/item registration.
- Added custom dimension **skybox**: a client `IRenderHandler` with six
  selectable skybox textures, installed through `WorldProvider#setSkyRenderer`.
- Added native **sounds**: portal ambient sound playback and periodic biome
  ambient/additions sounds through a client tick handler.
- Added a **custom tree** subset for biome elements: configurable trunk/branch
  blocks, vines, fruits and minimum height, generated as a
  `WorldGenAbstractTree` and selected by `Biome#getRandomTreeFeature`.

## Known Limitations

- Portal frames use a simple rectangular scan and do not implement the complete
  vanilla `BlockPortal.Size` rules; custom portal particles, portal-use
  procedures and custom portal sound conditions remain hidden.
- Skybox textures are client-side resources and must be supplied in
  `assets/<modid>/textures/skybox`; custom sun/moon textures remain hidden.
- Biome ambient/additions sounds are periodic client playback, not full
  high-version biome sound-event semantics.
- Custom tree support is a high-value subset, not the full modern tree feature
  system (no arbitrary root placers, decorator chains or multi-layer constraints).


# 2026.3-1.0.11.50-beta

## Fixes

Fixed 1 bug(s).

- Biome spawn entries now emit fully-qualified vanilla entity classes from a
  new `entityclasses` mapping instead of relying on wildcard imports. MCreator's
  import formatter strips the wildcard entity imports, which left both
  `EntityLiving` and the spawn class unresolved. Fully-qualified references are
  immune to import cleanup.

## Known Limitations

- Custom entities are emitted as `${package}.entity.<name>`; custom entity
  packages must follow the generator's standard package layout.


# 2026.3-1.0.10.49-beta

## Fixes

Fixed 1 bug(s).

- Biome spawn entries now import the 1.12.2 entity packages. Simple MCreator
  entity names such as `EntityZombie` and `EntityEnderman` no longer fail with
  `cannot find symbol`; custom entities import `${package}.entity.*` when the
  workspace contains entity elements.

## Known Limitations

- Spawn entries use wildcard imports for vanilla entity packages. This is
  intentional so all vanilla biome spawn classes resolve without a large
  per-entity package mapping.


# 2026.3-1.0.9.48-beta

## Fixes

Fixed 1 bug(s).

- Block references with metadata, such as `Blocks.STONE#3` (diorite), now emit
  `Blocks.STONE.getStateFromMeta(3)` instead of invalid
  `Blocks.STONE#3.getDefaultState()`. This affects biome top/filler blocks and
  every template using the shared block-state mapping helper.

## Known Limitations

- Metadata is emitted through `Block.getStateFromMeta(metadata)`; block-state
  properties that cannot be reconstructed from legacy metadata still depend on
  the 1.12.2 block implementation.


# 2026.3-1.0.8.47-beta

## Changes

- Added the 1.12.2 **Biome** element: biome registration, climate/rainfall,
  top/filler blocks, water/grass/foliage/sky colors, spawn lists, vanilla tree
  types and optional overworld biome placement. Stronghold and village
  placement are supported.
- Added the 1.12.2 **Dimension** element: `WorldProvider` and `DimensionType`
  registration, custom biome provider, Normal/Nether/End/Void chunk generators,
  fog/cloud/fixed-time/ambient-light settings, sky light and bed/respawn/weather
  behavior, plus player enter/leave procedures.

## Known Limitations

- Dimension portals, portal igniters, custom skyboxes, custom sun/moon textures,
  modern dimension JSON, aquifers, noise settings, raids/piglin settings and
  custom filler/fluid/sea-level terrain are hidden or ignored in this batch.
  Dimensions can be reached through another mod/command using the registered
  dimension id.
- Biome custom tree generators, climate/noise parameters, cave/nether biome
  injection, ambient sounds/particles and modern structure placement are hidden.
- Raw `javax.annotation.Nullable` is avoided in generated sources because it is
  not present in the generator's Java 8 compile classpath.


# 2026.3-1.0.7.46-beta

## Fixes

Fixed 2 bug(s).

- Tool and armor attribute modifiers now use deterministic UUIDs. The old
  `AttributeModifier(String, ...)` constructor generated a random UUID on every
  call, so unequipping could not remove the modifier and in-hand bonuses stayed
  active permanently.
- Tools selected in multiple creative tabs now generate `getSubItems` for every
  selected tab, matching item behavior. Previously only the first tab was used.

## Known Limitations

- MCreator 2026.3's shared loot-table editor creates the fortune and silk-touch
  controls directly inside dynamically generated entry panels. Generator
  `field_exclusions` can only address component fields, not those list entries;
  the 1.12.2 generator ignores both values. Hiding the controls requires an
  upstream MCreator GUI change.


# 2026.3-1.0.6.45-beta

## Fixes

Fixed 1 bug(s).

- Fixed-value `NumberProcedure` objects are no longer mistaken for callable
  procedures when their name is null. MCreator exposes these beans as both hash
  and string models, so `hasProcedure` now checks the hash/name path before the
  string path. This prevents `elementinits/fuels.java.ftl` from failing with a
  null `procedureToRetvalCode` name and restores automatic generation of
  `<Mod>Fuels`.

## Known Limitations

- Fixed fuel values are emitted as integer burn times; procedure fuel values
  still require a number-returning procedure.


# 2026.3-1.0.5.43-beta

## Changes

- Block editing now exposes "use custom loot table". When enabled, generated
  `getDrops` resolves `assets/<modid>/loot_tables/blocks/<registryname>.json`
  through the world loot table manager; the matching Loot table element must use
  the `blocks/<registryname>` name.
- Loot table JSON pools now include stable `pool_<index>` names required by
  Forge 1.12.2's pool reader.

## Fixes

Fixed 2 bug(s).

- Custom potion effects now explicitly remove their attribute modifiers by UUID
  when the effect ends, so milk removes movement-speed and health bonuses.
- Loot tables no longer fail with `Missing name entry for pool #0`.

## Known Limitations

- A block using a custom loot table must reference an existing Loot table
  element named `blocks/<block registry name>`; otherwise it drops nothing.
- Slab custom-loot-table drops generate one table roll regardless of double-slab
  state.


# 2026.3-1.0.4.42-beta

## Fixes

Fixed 2 bug(s).

- Item extension dispense result procedures are now emitted only when the
  selected procedure returns an itemstack; void procedures no longer produce an
  invalid `void`-to-`ItemStack` cast.
- Item extension global templates are generated for every item extension
  element, so `<Mod>Fuels` is present whenever the base mod registers it.

## Known Limitations

- The dispense result procedure must explicitly use an itemstack return type;
  void procedures fall back to consuming one item.
- Fuel and dispense procedure dependency maps must use the available
  `itemstack`, `world`, `x`, `y`, `z` and `direction` variables.


# 2026.3-1.0.3.41-beta

## New Content

- Item extension element: Forge 1.12.2 `FurnaceFuelBurnTimeEvent` fuel values
  and `IBehaviorDispenseItem` dispenser behavior, including fixed/procedure
  fuel values and dispense conditions/returned itemstacks.
- Loot table element: native 1.12.2 JSON in `assets/<modid>/loot_tables`, with
  `LootTableList` registration, pools, rolls, bonus rolls, item/empty entries,
  weights, count ranges and enchant-with-levels.
- Potion effect element: custom `Potion` subclasses with category, color, icon,
  attribute modifiers, instant/beneficial flags and optional
  start/tick/expire/hurt/death procedures.
- Potion item element: registered `PotionType` entries with multiple effects,
  vanilla potion localization and splash/lingering brewing conversions.

## Changes

- Added 1.12.2 `MobEffects.*` mappings and custom potion-effect/potion-type
  mapping templates.
- Added base-mod initialization hooks for fuel events, dispenser behavior,
  loot table registration and potion/potion-effect registration.
- Added `procedureOBJToNumberCode` and `procedureOBJToItemstackCode` helpers for
  item-extension procedures.

## Known Limitations

- Composting is unavailable in 1.12.2 and is hidden.
- Loot modifiers, top-level table types and silk-touch/fortune/explosion-decay
  entry conditions are hidden.
- Honey curing and custom potion particle rendering are unavailable.
- Potion items use vanilla potion/splash/lingering/tipped-arrow items; no custom
  potion item class is generated.


# 2026.3-1.0.2.40-beta

## Changes

- Localization keys are normalized against the actual 1.12.2 lookup paths:
  tools/shields and armor use `.name`, item and block/plant keys remain
  `<type>.<modid>.<registryname>.name`, enchantment keys remain
  `enchantment.<modid>.<registryname>`, and fluid names are namespaced while
  keeping the Forge `fluid.<name>` lookup.
- The test workspace language file was updated to the same canonical keys.

## Fixes

Fixed 5 bug(s).

- Added the missing `.name` suffix to tool and shield localization keys.
- Added the missing `.name` suffix to all four armor piece localization keys.
- Removed the duplicate `enchantment.` prefix from generated enchantment names.
- Added the namespaced unlocalized name to generated fluids so the language key
  matches Forge's `fluid.<name>` lookup.
- Aligned custom attribute names with the `attribute.name.<name>` tooltip
  lookup and updated the definition key accordingly.

## Known Limitations

- Enchantment and fluid localization keys intentionally do not end in `.name`;
  1.12.2 appends the type prefix and uses the resulting key directly.
- Existing workspaces must regenerate their language file, and resource packs or
  manual language overrides must migrate the old key names.


# 2026.3-1.0.1.38-beta

## Changes

- Enchantment `supportedItems` tags are translated to 1.12.2
  `EnumEnchantmentType` categories where an equivalent exists, and to
  `OreDictionary` lookups for custom tags. `TAG:` identifiers are no longer
  emitted as Java expressions.
- Enchantment rarity is derived from the weight because 1.12.2 exposes weight
  through `Enchantment.Rarity`, not through an overridable `getWeight()` method.

## Fixes

Fixed 3 bug(s).

- Added the missing separator between the armor equip sound and toughness
  arguments in `EnumHelper.addArmorMaterial`.
- Removed the invalid `getWeight()` override from generated enchantments.
- Removed the `TAG:`-based `canApply(ItemStack)` emission that caused javac
  syntax errors.

## Known Limitations

- `minecraft:enchantable/weapon` maps to the 1.12.2 `WEAPON` category, which
  covers swords but not modern axes; custom tag entries fall back to Ore
  Dictionary names and may be empty when no matching ore entry exists.
- Build number 38 is a one-time continuation of the persisted build sequence;
  subsequent builds resume normal incrementing.


# 2026.3-1.0.0.1-beta

## New Content

- Shield tool mode now generates a real Forge 1.12.2 `ItemShield` subclass with
  blocking use action, durability, repair items, enchantability, rarity,
  tooltips, tool triggers and attribute modifiers.
- Shield items generate a `blocking` item-model predicate and the
  `<registryname>_0` blocking model with first-person and third-person display
  transforms.

## Changes

- Versioning now follows
  `major.minor.patch.build-type` under the fixed MCreator branch prefix
  (`2026.3-1.0.0.1-beta`).

## Known Limitations

- Custom shield blocking models (`blockingRenderType` 1 and 2) and GUI
  textures remain unavailable; the generator explicitly stops instead of
  emitting an invalid custom blocking model.
- Banner-pattern rendering and the vanilla shield's `builtin/entity` model are
  unavailable because Forge 1.12.2 binds that renderer to the vanilla shield
  item only. Custom shields use the generated flat blocking model.
- Shield attribute modifiers apply in both hands because 1.12.2 generator
  support for per-slot attribute modifier entries is still incomplete.


# 3.2.1-beta

## New Content

- Enchantment effect blocks are partially adapted to 1.12.2: damage/armor
  effectiveness, knockback, mob/block experience and prevent-equipment-drop
  components generate event handlers. Conditional requirements and value
  expressions are currently level-scaled fallbacks rather than a full
  Blockly-value interpreter.

## Fixes

- Armor template macro parameters accept null tick/tooltip inputs.
- Tool and armor attribute modifiers use `IAttribute.getName()`.
- Tool material damage is emitted as a float.
- Attribute initialization is registered once manually instead of relying on
  automatic event-bus discovery.

## Known Limitations

- Shields are planned for the next batch; fishing rods are intentionally not
  adapted for the current 1.12.2 tool implementation.


# 3.2.0-beta

## New Content

- Armor support for helmet, chestplate, leggings and boots: custom armor
  material, textures/item models, durability, protection, enchantability,
  toughness, knockback resistance, repair items, armor ticks, tooltips and
  attribute modifiers.
- Tool support for pickaxe, axe, spade, hoe, sword, shears, special and
  multi-tool modes: tool material, durability, efficiency, damage, attack speed,
  enchantability, repair items, right-click/hit/block-destroy triggers,
  tooltips and attribute modifiers.
- Custom enchantment elements with max level, weight, incompatibility,
  supported items and registry integration.
- Custom attribute elements with min/max/default values and registration on
  players, selected entities or all living entities.

## Known Limitations

- Armor layer textures and custom armor model parts still need to be supplied
  by the project.
- Fishing rod and shield tool modes are not generated in this batch.
- Enchantment effects XML, treasure/curse flags and 1.12.2 enchantment
  categories are not mapped because they are data-driven in newer versions.


# 3.1.8-beta

## Fixes

- Generate `blockstates/<fluid>.json` with Forge fluid variants for every
  fluid level; this satisfies the blockstate load that occurs before model
  rendering.
- Removed the custom fluid state mapper that caused the loader to look for a
  missing `test_fluid` blockstate.


# 3.1.7-beta

## New Content

- Fluid elements expose density, viscosity, temperature, luminosity and flow
  rate; viscosity/temperature are applied to `Fluid`, and flow rate/tick rate
  to `BlockFluidClassic`.

## Fixes

- Fluid custom state mapping is registered during `ModelRegistryEvent`, so it
  is active when models load.
- Restored the Forge fluid model, which provides fluid-height/flow rendering
  instead of a static cube.
- Growable plant growth is delayed and probabilistic, preventing instant growth.


# 3.1.6-beta

## Fixes

- Growable plants no longer grow to maximum height immediately; growth is
  random and scheduled with a delay.
- Fluid blocks generate a normal blockstate and cube model instead of relying
  on the unavailable custom fluid state mapper.
- Bucket models fall back to the fluid still texture.


# 3.1.5-beta

## New Content

- Growable plants can stack on themselves and grow upward up to
  `growapableMaxHeight` while force ticking.

## Fixes

- Growable plants genuinely use `BlockBush` placement rules.
- Fluid state mapping points at the generated `test:<fluid>` model and its
  `<fluid>` variant, avoiding the `blocks/<texture>#fluid` lookup.
- Bucket models use the vanilla bucket texture when no custom bucket texture is
  configured.


# 3.1.4-beta

## Fixes

- Growable plants now actually extend `BlockBush` (the earlier template change
  was not written to the shipped template), so normal soil placement works.
- Fluid client state mapping points back to the fluid still resource, the
  format expected by Forge 1.12.2 fluid model loading.
- Bucket models use the fluid still texture as a fallback when no custom bucket
  texture is configured, avoiding a missing vanilla texture.


# 3.1.3-beta

## Fixes

- Growable plants use normal plant placement instead of the water-only
  `BlockReed` placement rules.
- Double-plant blockstates now include all six vanilla double-plant variants
  and valid separators.
- Fluid bucket models fall back to the vanilla bucket texture when no custom
  bucket texture is supplied.
- Fluid blockstate mapping points at the generated fluid model.


# 3.1.2-beta

## Fixes

- Fluid blocks no longer set their registry name in the constructor; the
  generated block registry assigns it once, preventing a crash during
  `TestModBlocks` static initialization.


# 3.1.1-beta

## New Content

- Plant elements can opt into block NBT through a generated TileEntity and
  registration.
- Plant elements can force scheduled tick updates (`forceTicking`).

## Fixes

- Plant model selection no longer compares the GUI render-type model object
  directly with an integer; cross/crop/custom selection falls back to the model
  name.
- Fluid client registration uses a 1.12.2 `StateMapperBase` instead of the
  unavailable `FluidStateMapper` class.


# 3.1.0-beta

## New Content

- Plant mod element: normal, sapling, growable and double-plant modes,
  cross/crop/custom models, block item textures, independent item texture,
  tooltip text/procedure, drops, XP, light, sound, creative tabs, placement
  restrictions, bonemeal procedure and flammability.
- Fluid mod element: still/flowing `Fluid` resources, `BlockFluidClassic`,
  fluid block registration, bucket generation, bucket model and client fluid
  state mapper.
- Plant and fluid blocks are registered through the generated block/item
  initialization classes.

## Known Limitations

- Saplings use the normal plant block behavior and do not grow trees yet.
- Plant world generation and fluid fog/overlay/flow-condition procedures are
  not implemented in this batch.


# 3.0.17-beta

## New Content

- Item mod element supports fixed-text and procedure-driven special
  information (tooltips) through `addInformation`.

# 3.0.16-beta

## Fixes

- Fixed the block item tooltip template crashing when the special-information
  procedure exposed a null name. This aborted block, block item and tile entity
  generation.
- Boolean-returning procedures now return `false` in generated guard paths
  instead of `null`.

# 3.0.15-beta

## New Content

- Configurable harvest tool and level (`setHarvestLevel`) plus a
  requires-correct-tool check.
- Placement-condition procedures used by `canPlaceBlockAt` and `canBlockStay`.
- Optional basic TileEntity generation and registration through the inventory
  opt-in.
- Independent block item textures.
- Fixed-text and procedure-driven item tooltips for block items.

## Fixes

- Fixed tooltip generation null handling so block, item and tile entity classes
  are generated together.

# 3.0.14-beta

## New Content

- Pass-through (`isNotColidable`) blocks with null collision and `isPassable`.

## Fixes

- Restored transparency render-layer and culling overrides that were lost when
  custom block properties were added.
- Crop/cross models no longer render with opaque cube lighting.

# 3.0.13-beta

## Fixes

- Fixed missing commas between outer property groups in multi-property
  blockstate JSON.

# 3.0.12-beta

## New Content

- Full blockstate variant generation for three custom properties
  (boolean/integer/enum).

## Fixes

- Property combinations resolve against defined state models instead of only
  the first state map key.

# 3.0.11-beta

## Fixes

- Custom-property blocks now override `getMetaFromState`, preventing a crash
  during Forge block registration.

# 3.0.10-beta

## Fixes

- Enum property setters use Guava `Optional`, matching 1.12.2
  `PropertyEnum.parseValue`.

# 3.0.9-beta

## Fixes

- State models are generated from `getDefinedStates()` so partial state sets
  (for example integer values 1-3 with a default 0) work.
- State model texture lookup no longer crashes when particle textures are
  absent.

# 3.0.8-beta

## New Content

- Cross, crop and custom JSON block model support.
- Custom JSON models are copied into `models/custom`.

## Fixes

- Fixed state-model generation aborting block and item class generation.

# 3.0.7-beta

## New Content

- Integer and enum custom block properties.
- Per-state block models and textures based on property combinations.

# 3.0.6-beta

## New Content

- Custom boolean block properties are generated in the block class and
  blockstate.

# 3.0.5-beta

## Fixes

- Blockstate property lookup uses
  `IBlockState.getBlock().getBlockState()` as required by 1.12.2.

# 3.0.4-beta

## Fixes

- Block property setters emit statements instead of invalid value expressions.
- Blockstate property lookup no longer loses the blockstate receiver.

# 3.0.3-beta

## Fixes

- Blockstate model paths no longer contain a duplicated `block/` segment.

# 3.0.2-beta

## Fixes

- Procedure classes import `World` and other dependency types.
- Block/item mapping preserves `CUSTOM:` element identities.

# 3.0.1-beta

## Fixes

- Blocks without a stored `blockBase` no longer fail block class/blockstate
  generation.

# 3.0.0-beta

## New Content

- Stairs, slab, fence and wall block bases.
- Per-face block textures and cutout/translucent render layers.
- Minimal procedure element and block interaction triggers (no global
  triggers).

# 2.0.0-beta

## New Content

- Basic cube blocks, block items, custom drops and XP.
- Ore Dictionary bridge for the MCreator tag editor (`ITEMS` and `BLOCKS`).

# 1.0.3-beta

## New Content

- Furnace smelting registration through `GameRegistry.addSmelting`.
- Brewing recipes through `IBrewingRecipe` and
  `BrewingRecipeRegistry.addRecipe`.
- Blasting, Smoking, Campfire cooking, Stone cutting and Smithing fail
  generation explicitly.

## Fixes

- Registered the missing recipe initialization class and added required block
  imports.

# 1.0.2-beta

## New Content

- Creative tabs, items, crafting recipes, food/durability/tool item properties
  and multi-tab item membership.
- Tag editor mapped to the 1.12.2 Ore Dictionary.
- Plugin validator and headless render harness.

## Fixes

- Recipe editor controls are no longer hidden by field inclusions.
- Plugin archive name is fixed to `generator-forge-1.12.2.zip`.

# 1.0.0-beta

## New Content

- Initial MCreator 2026.3 Forge 1.12.2 generator foundation.
- RetroFuturaGradle 2.0.6 / Gradle 9.8.0 / Java 8 toolchain workspace base.
- Plugin metadata, MCP mappings and documentation.



