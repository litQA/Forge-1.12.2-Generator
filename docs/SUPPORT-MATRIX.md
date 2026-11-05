# Forge 1.12.2 Generator - Support Matrix

Generator id: `forge-1.12.2`
Plugin id: `generator-forge-1.12.2`
Target: MCreator EAP `2026.3.44621`, Minecraft `1.12.2`, Forge `14.23.5.2847`

Status vocabulary:

- **Direct** - implemented with a native Forge 1.12.2 equivalent.
- **Degraded** - implemented with a documented semantic difference.
- **Unavailable** - not implemented in the current batch. The generator never
  emits silent invalid code for these features.

`新功能列表.txt` in the workspace root remains the canonical 2021.1-2026.3
feature list. This matrix records how the generator handles each feature group.

## Mod elements

| Mod element | Status | Notes |
| --- | --- | --- |
| Creative tab | Direct | Name, icon, search bar. `hideTitle` has no 1.12.2 API and is excluded. |
| Item | Degraded | Supported: normal/tool model, texture, name, rarity, creative tabs, stack size, durability, enchantability, use duration, use animation, destroy speed, destroy any block, melee damage, attack speed, recipe remainder, container item behaviour, food, creative tabs. Unavailable: procedures/triggers, inventories, GUI binding, ranged behaviour, JSON/OBJ/Java models, glow conditions, music disc, banner patterns, attribute modifier entries, repair items, fire immunity, piglin currency. Multiple creative tabs are supported through a `getSubItems` override; the first selected tab remains the item default tab. |
| Recipe | Direct | Crafting (shaped/shapeless) as 1.12.2 JSON; furnace smelting and brewing registered through generated Java code (`GameRegistry.addSmelting`, `BrewingRecipeRegistry`). Blasting, Smoking, Campfire cooking, Stone cutting and Smithing do not exist in Forge 1.12.2 and fail generation explicitly. |
| Block | Degraded | Batch 3 supports basic cubes with per-face textures, boolean/integer/enum custom properties and per-state models/textures, plus cutout/translucent layers, stairs, slabs (bottom/top/double), fences and walls. All support block items with multi-tab support, self/custom drops and XP. Remaining bases, multipart state editing, inventories, energy, fluids, worldgen, redstone behavior, tool tiers and loot-table drops are unavailable. |
| Plant | Degraded | Batch 4 supports normal, sapling, growable and double plants with cross/crop/custom models, item textures, tooltips, drops, placement conditions and bonemeal procedures. Tree growth and world generation are unavailable. |
| Fluid | Degraded | Batch 4 supports `Fluid`/`BlockFluidClassic`, still/flowing textures, bucket generation, bucket models and client fluid state mapping. Fog, overlays, custom flow conditions and fluid procedures are unavailable. |
| Dimension | Unavailable | Planned for batch 4, including portal, void world gen and sky parameters. |
| Biome | Unavailable | Planned for batch 4. |
| Living entity | Unavailable | Planned for batch 5 (AI tasks, attributes, model layers, synced data). |
| Special entity | Unavailable | Planned for batch 5 (boat, raft, chest raft). |
| Projectile | Unavailable | Planned for batch 5. |
| Armor | Unavailable | Planned for batch 3. |
| Tool | Unavailable | Planned for batch 3. |
| Item extension | Unavailable | Planned for batch 3. |
| GUI / Overlay | Unavailable | Planned for batch 6. |
| Key binding | Unavailable | Planned for batch 6. |
| Particle | Unavailable | Planned for batch 6. |
| Procedure | Degraded | Preview in batch 3: chat, set/remove block, get current blockstate, get/set boolean and integer blockstate properties, play sound, give item, call procedure and return values. Block triggers: right click, added, destroyed by player, entity walk, scheduled/random tick and neighbour change. Global triggers and the remaining procedure block catalog are unavailable. |
| Advancement / achievement | Unavailable | Planned for batch 8. |
| Loot table | Unavailable | Planned for batch 2/8. |
| Enchantment | Unavailable | Planned for batch 3. |
| Attribute | Unavailable | Planned for batch 3. |
| Damage type | Unavailable | No native 1.12.2 damage-type registry; planned as a degraded implementation over `DamageSource` subclasses. |
| Potion effect | Unavailable | Planned for batch 3/5. |
| Potion item | Unavailable | Planned for batch 3/5. |
| Structure / Feature | Unavailable | 1.12.2 has no data-driven worldgen registries; planned as Java-based generation in batch 8. |
| Villager trade / profession | Unavailable | Planned for batch 8. |
| Command / Function | Unavailable | Planned for batch 8. |
| Game rule | Unavailable | Planned for batch 8. |
| Painting / Banner pattern / Armor trim | Unavailable | Painting can be implemented in batch 8; banner patterns as recipes/materials; armor trims do not exist in 1.12.2 (Unavailable permanently). |
| Music disc / Fuel / Tag (2021.1 legacy elements) | Unavailable | Music disc and fuel were merged into the item model in later MCreator versions and are not present as separate 2026.3 definitions. Tag elements are represented by 1.12.2 Ore Dictionary entries since batch 2. |

## Cross-cutting features

| Area | Status | Notes |
| --- | --- | --- |
| 2026.3 plugin metadata (`id`, `weight`, `supportedversions`, EAP build number) | Direct | Plugin id `generator-forge-1.12.2`, weight 100, supported versions `[202600344621, 2026003]`. |
| 2026.3 `generator.yaml` | Direct | Base templates, language file, resource folders, Java model key, Gradle tasks and export path are declared. |
| YAML merge semantics | Direct | The generator is self-contained; plugin weight guarantees precedence if another plugin ships the same `forge-1.12.2` resources. |
| Generator fragments | Unavailable | The loader supports fragments, but the 1.12.2 build has no mixin/accesstransformer pipeline. No fragments are declared so no invalid mixin code can be generated. |
| Empty `types` lists | Direct | All templates read `types.*` and guard with `?has_content`. |
| Field inclusions / exclusions | Direct | Item, recipe and block definitions use field exclusions so unsupported fields are hidden without hiding grouped editor controls. |
| MCP name mappings | Degraded | Full 1.12.2 lists are shipped for the implemented elements; unimplemented elements have no runtime mapping consumers yet. Unavailable modern values fall back to documented vanilla approximations. |
| Resource generation (models, language, block states, loot tables, tags) | Degraded | Item models, block models/block states, block item models and language keys are generated. Loot tables are replaced by `getDrops` in batch 2; tag JSON is inert because the Ore Dictionary is the backend. |
| Tags / Ore Dictionary | Degraded | MCreator's tag editor is preserved. `ITEMS` and `BLOCKS` tags are registered through `OreDictionary.registerOre` with conventional names for common `forge:` paths; nested tags and non-item/block tag types are ignored. |
| Gradle build chain | Direct | Plugin: Gradle 9.8.0 + Java 25. Generated mod: RetroFuturaGradle 2.0.6 + Gradle 9.8.0 + Java 8 toolchain, Forge `14.23.5.2847`. Gradle 9.8 is required because MCreator 2026.3 sends a Java 25 synchronization action (class file major version 69) that legacy Gradle cannot parse or load. |
| Forge `14.23.5.2864` | Unavailable | RetroFuturaGradle 2.0.6 targets `1.12.2-14.23.5.2847` for 1.12.2. 2864 is planned with a later RFG upgrade. |
| Workspace-local caches | Direct for wrapper builds | `gradlew` sets `GRADLE_USER_HOME=<project>/caches/gradle`; wrapper distributions point to local files. MCreator's own Tooling API build cannot be redirected from generator resources (platform limitation). |
| Server-side build safety | Direct | No client-only classes are referenced from common code paths except `@SideOnly(Side.CLIENT)` model registration, which is standard 1.12.2 practice. |
| Generator validator | Direct | YAML, mappings, FreeMarker syntax, includes and template references are validated by `gradlew validateGenerator`. |
| MCP tool compatibility | Direct | All definitions use standard 2026.3 YAML formats and do not add generator-specific keys that would fail standard YAML parsing. The generator does not implement an MCP server. |
| Generation diagnostics | Degraded | MCreator reports the mod element name and template path on failure; unsupported features raise explicit `<#stop>` messages. Missing name mappings fall back to documented values instead of raising, so no mapping error can be produced for the implemented elements. |
| Java 8 compatibility of generated code | Direct | RetroFuturaGradle compiles and runs the mod with a Java 8 toolchain; all emitted code targets Java 8 APIs. Gradle itself runs on Java 25. |

## Feature deltas 2021.1 - 2026.3

The table lists representative feature groups from `新功能列表.txt`. A feature
is marked Unavailable until its owning mod element is implemented.

| Version | Representative new features | Status in this batch |
| --- | --- | --- |
| 2021.2 | Fluids, potion effects, buttons, extra redstone and fluid parameters, GUI checkbox | Unavailable |
| 2021.3 | Fluid tick rate, direction iterators, dungeon structure options | Unavailable |
| 2022.1 | Villager trades, food merged into items, random and vector procedure blocks, entity models | Food: Direct (item). Other: Unavailable. |
| 2022.2 | Item extension, features, projectile blocks, command arguments, block state procedures | Unavailable |
| 2022.3 | Terrain adaptation (duplicate entry in the canonical list) | Unavailable |
| 2022.4 | Feature mod element, entity ranged attacks, GUI text localization, item type blocks | Unavailable |
| 2023.1 | Rendered entity GUIs, loot table procedure blocks, feature placements, armor JSON/OBJ models | Unavailable |
| 2023.2 | Villager profession, geode/ore features, step height, block bounding box generator | Unavailable |
| 2023.3 | Shield events, damage source dependencies, item property overrides | Unavailable |
| 2023.4 | Damage type element, synced entity data, team procedures, shields, tags in selectors | Unavailable |
| 2024.1 | Jigsaw structures, tree features, tag management, debugging tools | Unavailable |
| 2024.2 | Multiple creative tabs, vanilla textures, spring feature, team blocks | Multiple creative tabs: Direct. Other features: Unavailable. |
| 2024.3 | Attribute element, custom block state properties, projectile hitbox, more worldgen features | Unavailable |
| 2024.4 | Resource pack workspace, sapling, waterlogging, dimension parameters, GUI sprite component | Unavailable |
| 2025.1 | Attribute sentiment, structure/game event tags, potion triggers, emissive particles | Unavailable |
| 2025.2 | Item/model display textures, archaeology loot, banner patterns, Java models for blocks/items, decimal division, global trigger parameters | Unavailable |
| 2025.3 | Fall-on trigger, piglin currency, attribute blocks, GUI slider, item triggers, vector blocks, auto tags | Unavailable; the item `creativeTabs` and `animation` fields from this era are Direct. |
| 2025.4 | Mouse buttons in key binds, cave biomes, GUI text shadow, translucent armor, entity session data | Unavailable |
| 2026.1 | SemVer mod versioning, tool/armor rarity and repair items, item attack speed, block states driven by properties, sign bases, global vector scope | SemVer: Direct (workspace version is written to `mcmod.info`). Item attack speed: Direct. Other: Unavailable. |
| 2026.2 | Advancement import/export, enchantment builder, armor attribute modifiers, dimension skybox, armor trims, raft, advancement predicates, clamp/lerp blocks, eye position, tick triggers, block inventory procedure blocks | Unavailable |
| 2026.3 | Multipart block states, synced-data conditions, enchantment attribute effects, hide tab title, custom attack AI, item procedure blocks, void dimension, enchantment value modifiers, ray trace reset modes, strong power face, vector products, entity line of sight, force attack, dry foliage tint | Unavailable; `hideTitle` is explicitly excluded from the creative tab editor. |

## Batch plan

| Batch | Scope |
| --- | --- |
| 1 (this batch) | Foundation, creative tab, item, crafting/smelting/brewing recipes, mappings, build chain, validator, documentation |
| 2 (this batch) | Basic cube blocks, block items, custom drops/XP, Ore Dictionary bridge for the tag editor |
| 3 (this batch) | Stairs/slabs/fences/walls, per-face textures, transparent cubes, minimal procedures and block interaction triggers |
| 4 (this batch) | Plants (normal/sapling/growable/double) and basic fluids with buckets |
| 5 | Living entities, special entities, projectiles, AI tasks, synced data |
| 6 | GUIs, overlays, key binds, particles, rendered entities |
| 7 | Remaining procedure blocks, global triggers, workspace variables (WorldSavedData) |
| 8 | Advancements, structures, worldgen, commands, functions, game rules, villager trades and professions, paintings |
| 9 | Forge 2864 / RetroFuturaGradle upgrade, full coverage audit and stable-status promotion |
