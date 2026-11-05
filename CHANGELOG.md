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

## Fixes

Fixed 4 bug(s).

- Creative tab selections after the first entry were ignored for items.
- Recipe elements could not be created because the recipe slot grid, result and
  input selectors were hidden by the previous field inclusion configuration.
- The plugin export file name changed with every version instead of staying
  `generator-forge-1.12.2.zip`.
- Furnace smelting recipes were never registered because the recipes
  initialization template was not part of the base templates and was not called
  from the mod init event.

## Known Limitations

See `MIGRATION-REPORT.md` for the complete list. The most important current
limitations are:

- Only the creative tab, item and recipe mod elements are implemented.
- Item procedure triggers, inventories, GUI binding, ranged behavior, music
  discs, banner patterns, attribute modifiers, custom JSON/OBJ/Java models and
  the other post-1.12.2 item features are not available yet.
- Forge 1.12.2 still has one default creative tab per item; the first selected
  tab is used as the default, while additional tabs are populated through an
  item `getSubItems` override.
- Workspace variables are not supported yet and stop code generation with an
  explicit error message.
- Blasting, Smoking, Campfire cooking, Stone cutting and Smithing recipes fail
  generation explicitly because those recipe types do not exist in Forge 1.12.2.
