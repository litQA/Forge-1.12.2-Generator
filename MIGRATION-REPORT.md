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
   combination; the mod must be built with ForgeGradle 2.3, Gradle 4.10.3 and
   JDK 8.
5. **Modern-only mappings in data lists.** For example the baseline biome data
   list contains 1.19+ biomes (`mangrove_swamp`, `windswept hills`) that do not
   exist in 1.12.2.

The project therefore uses the Apache-2.0 licensed official
`MCreator/Generator-Forge-1.12.2` reference repository (tag `2021.1-v4.0.1`) as
the source of proven 1.12.2 API code, and re-applies the 2026.3 generator format
and mod element data model on top of it.

## 2026.3 architecture adaptations

| 2026.3 change | Handling in this generator |
| --- | --- |
| Definitions are merged across plugins by YAML merge policy. | The plugin ships one self-contained `forge-1.12.2` generator. `plugin.json` uses `weight: 100` so its resources win over same-named resources from lower-weight plugins. |
| `types` is provided as an empty list when no element of a type exists. | All templates iterate `types.<plural>` and guard with `?has_content`; base templates use `condition: "${types.tabs?has_content}"` style conditions. |
| Mod element base types are declared by YAML (`base_types`). | Not required for the batch-1 element set (creative tab, item, recipe). The item registry is generated from `types.items` in `elementinits/items.java.ftl`. |
| Generator fragments (`*.fragment.yaml`). | The loader supports fragments, but ForgeGradle 2.3 has no mixin/accesstransformer integration. This generator declares no fragments and therefore cannot accidentally emit 1.13+ mixin artefacts. The design allows adding fragments in later batches when a 1.12.2 use case exists. |
| Field availability is configured per generator (`field_inclusions` / `field_exclusions`). | The item and recipe definitions use `field_inclusions` to expose only the fields implemented by this batch. Unsupported fields are absent from the editor instead of silently generating incomplete code. |
| Gradle task names and export path are configured in `generator.yaml`. | `runClient`, `runServer` and `build/libs/modid-1.0.jar` are used. The workspace wrapper pins Gradle 4.10.3. |

## Mod element support (batch 1)

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
- creative tab selection.

Degraded behaviour:

- MCreator 2026.3 supports multiple creative tabs per item. Forge 1.12.2
  `Item` has a single `setCreativeTab` call, so only the first selected tab is
  used.
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

Direct implementation for shaped and shapeless crafting JSON and for furnace
smelting registration (generated through `GameRegistry.addSmelting`).

Degraded implementation:

- Blasting, Smoking, and Campfire cooking recipes are registered as regular
  furnace smelting recipes. Their type-specific cooking times cannot be
  represented in 1.12.2.

Explicitly unavailable: Stone cutting, Smithing and Brewing recipes stop code
generation with a message that names the unsupported recipe type.

### Other mod elements

All other 2026.3 mod elements (blocks, plants, fluids, dimensions, biomes,
living entities, special entities, projectiles, GUIs, overlays, procedures,
triggers, advancements, loot tables, structures, features, enchantments,
attributes, potions, commands, functions, key bindings, particles, paintings,
banner patterns, armor trims, tools, armor, item extensions, etc.) are planned
for later batches. They are not silently generated: MCreator reports that no
definition exists for the type in this generator, and the support matrix marks
them as unavailable.

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
- Generated mod: ForgeGradle 2.3-SNAPSHOT, Gradle 4.10.3, JDK 8 compile, Forge
  `14.23.5.2847`.
- `14.23.5.2847` is chosen because Forge stopped publishing the `-userdev`
  artifact required by ForgeGradle 2.3 after build `2847`. Build `2864` is
  therefore unusable with the required ForgeGradle 2.3 toolchain; switching to
  2864 requires moving to ForgeGradle 3+ in a later batch.
- MCreator 2026.3 runs on Java 25. Its Gradle integration accepts a Java home
  override in the preferences; it must be set to a JDK 8 installation before
  building a 1.12.2 workspace. This is a platform prerequisite, documented in
  the README.

## Known Limitations

1. **Batch scope.** Only creative tab, item and recipe definitions exist in this
   batch. The generator is marked `status: dev`; it does not claim full coverage
   of the 2026.3 feature surface yet.
2. **Item feature coverage.** Procedures, GUI inventories, ranged behaviour,
   custom models and the other item features listed above are unavailable and
   the corresponding editor fields are hidden.
3. **Single creative tab per item.** Forge 1.12.2's item API supports only one
   creative tab; additional selections are ignored.
4. **Recipe degradation.** Blasting, Smoking and Campfire cooking become
   furnace smelting recipes. Stone cutting, Smithing and Brewing fail code
   generation explicitly.
5. **Workspace variables.** Global workspace variables have no WorldSavedData
   implementation in this batch. If variables exist, `variableslist.java.ftl`
   stops generation with an explicit error instead of emitting broken code.
6. **Procedures and triggers.** No procedure blocks, global triggers or element
   triggers are implemented, so no procedure code can be generated yet.
7. **Java 8 prerequisite.** MCreator's Gradle Java home override must point to a
   JDK 8 installation. MCreator still needs Java 25 to run its own UI.
8. **Cache redirection under MCreator.** The wrapper-based builds created by
   this project keep all Gradle caches in `<project>/caches/gradle`. MCreator's
   Tooling API removes `GRADLE_USER_HOME` from the environment and does not
   provide a generator-level setting for the Gradle user home, so a build
   started by MCreator's own Gradle integration uses MCreator's cache location.
   No generator resource can override that without patching MCreator.
9. **Sound and language resources.** Sound definitions are only generated when
   sound elements exist; the sound element type itself belongs to a later
   batch. The language file is written by MCreator's localization system from
   the localization keys declared by the definitions, not by a template.
10. **No in-game verification in this batch.** Per the delivery specification,
    the generator stops after a zero-error compile/build and waits for the
    user's real-device test.

## Verification log

| Step | Result |
| --- | --- |
| Plugin build (`gradlew build`, JDK 25) | `BUILD SUCCESSFUL` |
| Static validator | `VALIDATION PASSED` (28 YAML documents, 18 templates, 15 template references) |
| Plugin discovery in MCreator 2026.3.44621 | Plugin loaded, `compatible=true`, weight 100 |
| Workspace creation with `forge-1.12.2` | Succeeded in headless MCreator harness |
| Base and element template rendering | Succeeded; tab, item and recipe sources and JSON generated |
| ForgeGradle 2.3 / Gradle 4.10.3 / JDK 8 compile | `BUILD SUCCESSFUL`; `build/libs/modid-1.0.jar` produced. Only deprecation notes for `setUnlocalizedName` (expected on 1.12.2). |

The generated-mod build used the exact workspace base, templates and generated
sources that are packaged in the plugin archive. The build was started through
the generated workspace wrapper with `JAVA_HOME` pointing to JDK 8 and
`GRADLE_USER_HOME` pointing to the workspace-local `caches/gradle` folder.

Remaining acceptance item: launch the Forge 1.12.2 client and verify the test
item, creative tab and recipe in game. Per the delivery specification this
real-device test is performed by the user before the next batch starts.

