# Changelog

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
