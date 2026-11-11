# Forge 1.12.2 Generator - Support Matrix

Generator id: `forge-1.12.2`

Plugin id: `generator-forge-1.12.2`

Target: MCreator EAP `2026.3.44621`, Minecraft `1.12.2`, Forge `14.23.5.2847`

Current plugin snapshot: `2026.3-1.0.25.64-beta`

Status vocabulary:

- **Direct** - native Forge 1.12.2 implementation.
- **Degraded** - implemented with a documented semantic or API difference.
- **Unavailable** - no implementation in the current snapshot; generation
  either stops explicitly or the field is hidden.

This file is current as of `2026.3-1.0.25.64-beta`. `新功能列表.txt` remains the
canonical 2021.1-2026.3 feature list; this matrix describes the implemented
subset and its implementation method.

## Implemented mod elements

| Mod element | Status | Implementation and current coverage |
| --- | --- | --- |
| Creative tab | Direct | Generated `CreativeTabs` subclass with name, icon and search bar. `hideTitle` has no 1.12.2 API and is excluded. |
| Item | Degraded | `Item`/`ItemFood` generation with `item/generated` or `item/handheld` models, textures, names, rarity, creative tabs, stack size, durability, enchantability, use duration/animation, destroy speed, destroy-any-block, melee damage, attack speed, recipe remainder, container behavior, food, tooltips and multi-tab `getSubItems`. Item procedure triggers, GUI/inventory, ranged behavior, JSON/OBJ/Java models, glow conditions, music discs, banner patterns, item attribute-modifier entries, repair items, fire immunity and piglin-currency fields remain unavailable. |
| Recipe | Direct | Shaped/shapeless crafting as 1.12.2 JSON; furnace smelting via `GameRegistry.addSmelting`; brewing via `BrewingRecipeRegistry`. Blasting, smoking, campfire cooking, stonecutting and smithing have no native 1.12.2 equivalent and stop generation explicitly. |
| Block | Degraded | Native `Block` subclasses for cube, stairs, slab, fence and wall; per-face textures, custom JSON/cross/crop models, cutout/translucent layers, boolean/integer/enum properties, per-state models/blockstates and `getMetaFromState`. Supports block items, multi-tab listing, self/custom drops, XP, tool class/level, placement checks, simple TileEntity via `hasInventory`, and fixed/procedure tooltips. Doors, trapdoors, fence gates, pressure plates, buttons, signs, flower pots, end rods, leaves and multipart blockstates are not generated; inventories, Forge energy, fluid containers, redstone behavior and full TileEntity synchronization remain unavailable. |
| Plant | Degraded | Normal, sapling, growable and double plants with cross/crop/custom models, independent item texture, tooltips, drops, XP, light, sound, creative tabs, placement restrictions, bonemeal procedures, NBT and forced update ticks. Saplings currently do not grow trees; plant world generation, custom hitboxes, waterlogging and advanced sapling behavior are unavailable. |
| Fluid | Degraded | Forge `Fluid` plus `BlockFluidClassic`, still/flowing textures, bucket item/model and client blockstate mapping. Fog, overlays, custom flow conditions and fluid procedures are unavailable. |
| Dimension | Degraded | Generates `WorldProvider`, `DimensionType` registration and a custom `BiomeProvider` from `biomesInDimension`. Non-Void dimensions use a custom `IChunkGenerator`: absolute-coordinate `NoiseGeneratorPerlin` height/detail fields, configurable `mainFillerBlock`, `fluidBlock`, `seaLevel`, 2D-noise aquifers, biome top/filler surface, and native `MapGenCaves`/`MapGenRavine` carving adapted to the filler block. Void keeps an empty generator. Supports sky light, fog/clouds/fixed time/ambient light, respawn/bed/weather and player enter/leave. Portals/igniters use `BlockPortal` and a generated `ITeleporter`; skyboxes use a client `IRenderHandler`; portal sounds use native `SoundEvent`. World height remains 256; custom sun/moon, ore veins, modern dimension JSON, real 1.18 climate/spline semantics and main-world/Nether worldgen hooks are unavailable. |
| Biome | Degraded | Registered `Biome` with climate/rainfall, top/filler/water/grass/foliage/sky colors, spawn lists, vanilla tree types, stronghold/village registration, custom tree subset, ambient/additions sounds and Overworld `BiomeManager` registration. Five climate-range fields are a 1.12.2 weight proxy: each maps `abs(max-min)/4` to 0..100 and the sum is 0..500 (minimum 1); see `Mixin/worldgen` below. Modern climate/noise semantics, true per-Y cave biome storage, particles, mood/music fields and modern structures are unavailable. |
| Mixin / worldgen injection | Degraded | Self-contained Mixin `0.7.11-SNAPSHOT` is embedded in generated jars; RFG `modUtils.enableMixins` generates the refmap. A generated `World#getBiome` Mixin returns the configured cave biome for Overworld `0 < y < 50` and the configured Nether biome for dimension `-1`. Config/refmap/manifest names are derived from the actual mod id. This is column-based lookup injection, not per-Y biome storage. `y=0` is intentionally excluded because 1.12.2 biome decoration commonly queries that position. Height extension is not implemented. |
| Armor | Degraded | Four armor pieces with custom `ArmorMaterial`, durability/armor/toughness, enchantability, rarity, repair material, creative tabs, tooltips, tick behavior and attribute modifiers. Custom armor model parts are not supported; the project must provide `textures/models/armor/*_layer_1.png` and `_layer_2.png`. |
| Tool | Degraded | Pickaxe/axe/spade/hoe/sword/shears/special/multitool plus shield generation. Supports `ToolMaterial`, durability, efficiency, damage, attack speed, enchantability, repair item, rarity, tooltips, right-click/block/entity/destroy triggers and deterministic attribute-modifier UUIDs. Shields use `ItemShield` with native blocking, shield damage handling, sounds, durability and a generated `blocking` model predicate. Fishing rods, custom tool models/textures beyond the generated model, custom shield blocking renderers/banner patterns and some trigger types are unavailable. |
| Item extension | Degraded | Fuel burn time via `FurnaceFuelBurnTimeEvent` (fixed/procedure values and conditions) and dispenser behavior via `BlockDispenser.DISPENSE_BEHAVIOR_REGISTRY`/`IBehaviorDispenseItem` (conditions and result stacks). Composting has no 1.12.2 equivalent. |
| Loot table | Degraded | Native 1.12.2 JSON under `assets/<modid>/loot_tables`, registered through `LootTableList`; supports named pools, rolls, bonus rolls, item/empty entries, weights, count ranges and enchant levels. Top-level table types, entry silk-touch/fortune/explosion-decay conditions and loot modifiers are ignored. |
| Enchantment | Degraded | Generated `Enchantment` registered through `ForgeRegistries.ENCHANTMENTS`; max level, weight/rarity, incompatibility, supported slots, supported items/tags and a partial effect implementation. Damage/armor, knockback, XP and equipment-drop effects map to Forge 1.12.2 events; modern item tags map to `EnumEnchantmentType`/Ore Dictionary. Full condition/value-effect/XML interpretation is not implemented. |
| Attribute | Degraded | Generated `RangedAttribute` with default/min/max, injected through `EntityConstructing` for all LivingEntity, players or selected entities. 1.12.2 has no global attribute registry; `sentiment`, full modifier mapping and network synchronization are unavailable. |
| Potion effect | Degraded | Custom `Potion` subclass with category, color, icon, attribute modifiers, instant/beneficial flags and start/tick/expire/hurt/death procedures. Attribute modifiers are removed by UUID on expiry/cure. Honey curing and custom particle rendering are unavailable. |
| Potion item | Degraded | Registers `PotionType` entries and uses vanilla potion, splash, lingering and tipped-arrow items; generates splash/lingering brewing conversions. It does not create a new potion item class. |
| Procedure | Degraded | Current procedure subset: chat, set/remove block, get current blockstate, get/set boolean/integer properties, play sound, give item, call procedure and return. Block triggers: right click, added, destroyed by player, entity walk, scheduled/random tick and neighbor change. Global triggers, entity triggers, many 2026.3 procedure blocks and some block-specific contexts are unavailable. |

## Unsupported mod elements

These elements have no current definition/template implementation and must not be
advertised as supported:

| Element group | Status | Notes |
| --- | --- | --- |
| Living entity / special entity / projectile | Unavailable | No entity AI, model layer, synced data, projectile or boat/raft implementation. |
| GUI / overlay / key binding / particle | Unavailable | No screen, overlay, keybind or custom particle pipeline. |
| Advancement / structure / feature | Unavailable | 1.12.2 lacks data-driven equivalents. Custom dimension terrain/caves and custom biome trees are implemented Java worldgen subsets; native structure/feature registries are not generated. |
| Villager trade/profession / command / function / game rule | Unavailable | No generated Java equivalents in this snapshot. |
| Damage type / painting / banner pattern / armor trim | Unavailable | No native 1.12.2 registry or API for the modern forms. |
| Music disc / fuel / tag legacy elements | Unavailable | Fuel is handled by item extension; tags map to Ore Dictionary. |

## Cross-cutting features

| Area | Status | Implementation |
| --- | --- | --- |
| Plugin metadata | Direct | `plugin.json` id `generator-forge-1.12.2`, weight 100, supported 2026.3 EAP versions. |
| `generator.yaml` | Direct | Declares base templates, language file, resource folders, Java model key, Gradle task names and export path. |
| Base templates | Direct | `modbase/mod.java.ftl`, proxies, `mcmod.info`, pack metadata, Mixin sources/config and element initializers are generated from workspace data. |
| Generator fragments | Direct / unused | The generator uses direct base templates; no fragment declarations are needed. Mixin support is provided by the generated Mixin build/resource pipeline, not by generator fragments. |
| Empty `types` lists | Direct | All base templates use `(types.xxx![])?has_content` guards. |
| Field exclusions | Direct | Unsupported fields are hidden or explicitly stopped; for dynamically created list entries, MCreator cannot hide subfields and those values are ignored with documented limitations. |
| Localization keys | Direct | Item/block/tool/armor keys use `.name`; enchantments use `enchantment.<modid>.<name>` and fluids `fluid.<modid>.<name>` to match 1.12.2 translation prefixes. |
| MCP name mappings | Degraded | Implemented element mappings are shipped; unsupported modern values use documented vanilla/Ore Dictionary fallbacks. |
| Resource generation | Degraded | Generates item/block models, blockstates, metadata, language files, native loot-table JSON and Mixin resources. Tag JSON is inert because Ore Dictionary is the 1.12.2 backend. |
| Tags / Ore Dictionary | Degraded | Item/block tags register through `OreDictionary`; nested and non-item/block tag types are ignored. |
| Mixin pipeline | Degraded | Embedded Mixin `0.7.11-SNAPSHOT`, RFG refmap, `MixinTweaker`/`MixinConfigs`/`ForceLoadAsMod`, dynamic `mixins.<modid>.json`, `World#getBiome` injection. See `HANDOFF.md` section 3.14 for the build contract. |
| Gradle build chain | Direct | Plugin builds with JDK 17; generated workspaces use JDK 25 + Gradle 9.8.0 + RetroFuturaGradle 2.0.6; generated mods compile/run with Java 8 toolchain. |
| Forge `14.23.5.2864` | Unavailable | Current RFG 2.0.6 target is 2847; a separate toolchain upgrade is required. |
| Workspace-local caches | Direct for wrapper builds | The documented workflow sets `GRADLE_USER_HOME` to `caches/gradle`; MCreator's Tooling API build is a platform-controlled exception. |
| Server-side safety | Direct | Common code uses server-safe Forge APIs; skybox/sound client logic is isolated behind `@SideOnly`/client proxy paths. |
| Generator validator | Direct | `gradlew validateGenerator` validates YAML, mappings, FTL syntax/includes and template references. It does not replace `javac` or runtime tests. |
| Generation diagnostics | Degraded | MCreator reports element/template failures; unsupported choices stop explicitly where a safe fallback does not exist. Mapping fallbacks are documented rather than silently invented. |
| Java 8 compatibility | Direct | Generated Java targets Java 8 APIs; Java 25 is only the Gradle/MCreator runtime. |

## Feature-family coverage (2021.1-2026.3)

This table is intentionally implementation-oriented rather than a promise of
full modern parity.

| Feature family | Status | Current implementation |
| --- | --- | --- |
| Food/item attributes and multiple creative tabs | Degraded | Item fields, item attack speed and `getSubItems` multi-tab support. |
| Fluids and potion effects/items | Degraded | `Fluid`/`BlockFluidClassic`; custom `Potion`/`PotionType`; native bucket and brewing paths. |
| Item extension (fuel/dispense) | Degraded | Forge fuel and dispense events/registry. |
| Block states / block-state textures / multiple tabs | Degraded | Custom properties, per-state model/blockstate generation, `getMetaFromState`; multi-tab block items. |
| Shield behavior | Degraded | `ItemShield`, native blocking and generated blocking model; no custom shield renderer/banner. |
| Attributes | Degraded | `RangedAttribute` + `EntityConstructing`; no global registry. |
| Dimensions and custom skyboxes | Degraded | `WorldProvider`/`DimensionType`, custom terrain, portal/teleporter, `IRenderHandler` skybox. |
| Cave/Nether biome injection | Degraded | Mixin `World#getBiome`; Overworld `0 < y < 50`, Nether dimension `-1`; column-based. |
| Custom tree subset | Degraded | `WorldGenAbstractTree` with trunk/branch/vines/fruits/min height; no modern tree feature/decorator chain. |
| Biome weight proxy | Degraded | Five climate ranges map to `BiomeManager.BiomeEntry` weight 0..500; not a 1.18 climate engine. |
| 256+ world height | Unavailable | 1.12.2 hard-codes 256-height chunk storage and client handling; current terrain clamps at 252. |
| Entities, GUIs, structures, advancements, commands | Unavailable | No implementation in this snapshot. |

## Current development gaps

1. Re-test the `1.0.25.64` cave `y=0` exclusion on a new world/new chunks:
   verify no custom tree leakage into vanilla biomes, vanilla tree restoration,
   and surface custom-biome generation.
2. Verify five-range weight 500 in a fresh world; old chunks do not regenerate.
3. Re-test custom-dimension caves/ravines and the 252 height clamp.
4. Height extension to 320+64 needs a separate Mixin/chunk/IO/rendering project;
   it is not a small change and remains unimplemented.
5. Complete real-device regression for the older armor/tool/enchantment/fluid/
   potion/loot modules.
