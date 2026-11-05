# Changelog

## New Content

- Generator plugin foundation for MCreator EAP 2026.3.44621 with plugin id
  `generator-forge-1.12.2`, plugin weight 100 and EAP build-number aware version
  support.
- 2026.3-format `generator.yaml` for the `forge-1.12.2` generator, including
  mod base templates, language file configuration, resource folders and the
  Java model key for the legacy 1.12.2 renderer.
- Self-contained Gradle 9.8.0 build for the plugin with a Java 25 toolchain,
  local wrapper distribution URL and project-local Gradle caches.
- RetroFuturaGradle 2.0.6 / Gradle 9.8.0 / Java 8 toolchain workspace base for
  generated mods, including local wrapper distribution URL, workspace-local
  Gradle caches and a guarded `mcreator.gradle` include.
- Foojay toolchain resolver configuration in the generated workspace, so a
  Java 8 toolchain is provisioned automatically when no local JDK 8 is present.
- Creative tab mod element: name, icon and search bar rendering through the
  generated `<Mod>Tabs` class.
- Item mod element: normal and tool models, rarity, creative tabs, stack size,
  durability, enchantability, use duration, use animation, destroy speed,
  melee damage and attack speed, container item / recipe remainder, food
  properties, block harvesting and localized name.
- Recipe mod element: shaped and shapeless crafting JSON, furnace smelting
  registered through `GameRegistry.addSmelting`, and brewing recipes generated
  as per-element `IBrewingRecipe` implementations with potion-type aware
  inputs and outputs.
- Block mod element for the default basic cube: per-face textures, custom boolean\n  block properties, cube model,
  block state, block item model, hardness, resistance, step sound, creative
  tabs, stack size, rarity, self/custom drops and XP range.
- Stairs, slab, fence and wall block bases, including full block state/model
  sets, slab double placement/drops and multipart fence/wall models.
- Cutout and translucent render layer support for transparent cubes.
- Minimal procedure element with world/entity chat, set/remove block, get/set block state properties, play
  sound, give item, call-procedure and return-value blocks.
- Block interaction triggers that call procedures: right click, block added,
  destroyed by player, entity walk, scheduled tick, random tick and neighbour
  change. No global triggers are provided.
- Block item generation with optional auto-generated `ItemBlock`, multi-tab
  creative tab membership and automatic model registration.
- Ore Dictionary bridge for MCreator tags: `ITEMS` and `BLOCKS` tags generate
  `OreDictionary.registerOre` entries, with conventional names for common
  `forge:` tag paths and a fallback for custom tags.
- Inert tag JSON output keeps MCreator's tag editor workflow available while
  the actual 1.12.2 registration uses the Ore Dictionary.
- Complete 1.12.2 MCP name mappings for the implemented elements, including a
  two-column blocks/items mapping used by both Java code and JSON generation.
- Static generator validator that parses all YAML documents, parses all
  FreeMarker templates, verifies template references and include paths, checks
  plugin metadata and validates the two-column blocks/items mapping.
- Headless MCreator render harness used for development verification of the
  plugin discovery, workspace creation and template rendering pipeline.
- Project documentation: README, changelog, migration report and support matrix.

## Changes

- The generator architecture was rebuilt on the Apache-2.0 `2021.1-v4.0.1`
  Forge 1.12.2 reference generator instead of the incomplete 2025.3 community
  snapshot, whose templates and workspace base mixed 1.13+ APIs into 1.12.2
  code and could not be rendered.
- Creative tabs are created in a dedicated generated initialization class, so
  item initialization always runs after the custom tab fields are populated.
- The generated plugin uses a single `<Mod>Items` registry class rather than the
  ASM-tag based element registry of the 2021.1 reference generator, which has no
  deterministic initialization order for creative tab dependencies.
- The Forge build is locked to `14.23.5.2847`, the 1.12.2 Forge version
  supported by RetroFuturaGradle 2.0.6 and the newest build that still
  publishes the legacy `-userdev` artifact.
- The generated workspace build chain moved from ForgeGradle 2.3 / Gradle
  4.10.3 to RetroFuturaGradle 2.0.6 / Gradle 9.8.0. MCreator 2026.3 sends a
  Java 25 bytecode Gradle synchronization action (class file major version 69)
  that Gradle 4.10.3 cannot parse or load; Gradle 9.8 runs on MCreator's Java 25
  runtime and RetroFuturaGradle supplies the Java 8 compile/run toolchain.
- The generated mod no longer requires MCreator's Gradle Java home override to
  point at a JDK 8 installation.
- Generated mod folders use the 2026.3 default `src/main/java` and
  `src/main/resources` layout and the 1.12.2 asset paths
  (`textures/items`, `textures/blocks`, `recipes`).
- Item creative tab membership is implemented through a generated
  `getSubItems(CreativeTabs, NonNullList<ItemStack>)` override, so an item can
  appear in all selected vanilla and custom tabs on Forge 1.12.2.
- Item and recipe definitions now use `field_exclusions` instead of
  `field_inclusions`. Inclusion cleanup hides every GUI component it cannot
  resolve by reflection, which broke grouped controls such as the recipe slot
  grid.
- The exported plugin archive is always named `generator-forge-1.12.2.zip`
  instead of embedding the plugin version in the file name.
- Furnace smelting and brewing recipes are now generated in the `<Mod>Recipes`
  initialization class, which is registered in `generator.yaml` and called from
  the generated mod `init` event.
- Blasting, Smoking, Campfire cooking, Stone cutting and Smithing are rejected
  at generation time with an explicit message because these recipe types do not
  exist in Forge 1.12.2.
- `potions.yaml` now maps potion types to the 1.12.2 `PotionTypes` constants used
  by brewing recipes.
- The blocks/items mapping declares the `CUSTOM:` mapping prefix, so procedure
  block inputs keep their workspace element identity.

## Fixes

Fixed 24 bug(s).

- Creative tab selections after the first entry were ignored for items.
- Recipe elements could not be created because the recipe slot grid, result and
  input selectors were hidden by the previous field inclusion configuration.
- The plugin export file name changed with every version instead of staying
  `generator-forge-1.12.2.zip`.
- Furnace smelting recipes were never registered because the recipes
  initialization template was not part of the base templates and was not called
  from the mod init event.
- Generated recipe and brewing classes did not import `net.minecraft.init.Blocks`,
  so recipes using vanilla blocks failed to compile.
- Basic blocks ignored the per-face texture fields and always rendered the
  `texture` field as a single `cube_all` texture.
- Block elements without a stored `blockBase` value failed FreeMarker rendering,
  so their block class and blockstate were not generated.
- The `block_add` procedure block crashed when the block input exposed only its
  mapped value; MCItem mapping now falls back between unmapped and mapped
  values.
- Generated procedure classes did not import `net.minecraft.world.World` (and
  other dependency types), so every generated procedure failed to compile.
- Blockstate JSON referenced block models as `<modid>:block/<name>`, which
  resolves to `models/block/block/<name>` in 1.12.2 and produced missing models.
- Blockstate property procedure templates required a block input; when MCreator
  supplied no block input they failed generation instead of using the current
  trigger blockstate.
- The block property setter template emitted a BlockState value expression as a
  statement and did not understand `blockstate_from_deps` inputs, producing
  broken ternary/parenthesis code.
- Blockstate property templates called `getProperty(String)` on `IBlockState`;
  in 1.12.2 the lookup must go through `IBlockState.getBlock().getBlockState()`
  (the block state container).
- Custom boolean block properties from the block editor were not generated in
  the block class or blockstate, so procedures toggling them had no effect.
- State model generation crashed when a state had no particle texture; the
  model template now falls back to the state face texture.
- State models were generated from combinations that carry no textures; models
  now use `getDefinedStates()` and blockstate variants resolve their model by
  property name/value, so partial integer state sets and a default value work.
- Enum property setters used `java.util.Optional`; 1.12.2 `PropertyEnum.parseValue`
  returns Guava `com.google.common.base.Optional`.
- Blocks with custom properties did not override `getMetaFromState`, so Forge
  crashed during block registration while enumerating block states.
- Blockstates for multiple custom properties only covered the first state map
  key, leaving bool/enum variants without models; all property combinations are
  now generated and resolved against defined state models.
- The multi-property blockstate variant list omitted commas between outer
  property groups, producing invalid JSON and missing models for every variant.
- Custom-property blocks lost their transparency render layer/culling overrides;
  crop/cross models were rendered with opaque cube lighting.
- Added the pass-through (`isNotColidable`) option with null collision and
  `isPassable` support.
- Added configurable harvest tool/level with `setHarvestLevel` and a
  requires-correct-tool check.
- Added placement-condition procedures in `canPlaceBlockAt`/`canBlockStay`.
- Added optional TileEntity generation and registration for blocks with
  inventory opt-in.
- Added independent block item textures and fixed/procedure item tooltips.
- Fixed the block item tooltip template crashing when the special-information
  procedure object exposed a null name; this aborted block, item and tile entity
  generation.
- Fixed boolean-returning procedures using a null default value in generated
  guard returns.
- Integer block properties were missing from generated block classes, so the
  integer property procedure always read `-1`.

## Known Limitations

See `MIGRATION-REPORT.md` for the complete list. The most important current
limitations are:

- Only the creative tab, item, recipe, block and procedure mod elements are
  implemented.
- Item procedure triggers, inventories, GUI binding, ranged behavior, music
  discs, banner patterns, attribute modifiers, custom JSON/OBJ/Java models and
  the other post-1.12.2 item features are not available yet.
- Block bases not listed above (leaves, trapdoors, panes, doors, fence gates,
  end rods, pressure plates, buttons, flower pots and signs), custom block
  states, multipart state editing, inventories, world generation and tool tiers
  are not available yet.
- Procedure coverage is a preview: only the blocks listed in the README have
  code templates, and global triggers are not implemented.
- Tags are limited to `ITEMS` and `BLOCKS` and are stored in the Forge 1.12.2
  Ore Dictionary; nested tag entries and non-item/block tag types have no
  1.12.2 equivalent.
- Forge 1.12.2 still has one default creative tab per item; the first selected
  tab is used as the default, while additional tabs are populated through an
  item `getSubItems` override.
- Workspace variables are not supported yet and stop code generation with an
  explicit error message.
- Blasting, Smoking, Campfire cooking, Stone cutting and Smithing recipes fail
  generation explicitly because those recipe types do not exist in Forge 1.12.2.
