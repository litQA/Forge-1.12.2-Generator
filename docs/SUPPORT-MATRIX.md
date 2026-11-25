<img width="1000" alt="forge generator banner 1 12 2" src="https://github.com/user-attachments/assets/147e8a32-d5cf-4a7d-88be-e4475f840045" />

# Forge 1.12.2 Generator - Feature Support Matrix

## Document purpose

This document states what the Forge 1.12.2 generator supports relative to the
MCreator 2026.3 NeoForge generator feature set. It is intended for project
planning, scope review and stakeholder communication.

The levels describe implementation quality and implementation risk, not just whether
a field is visible in the editor. A feature can be present in generated code and
still be unsuitable for a critical gameplay path if it depends on emulation or
an injected runtime layer.

This is a support statement for the current snapshot. It is not a guarantee of
complete behavioral parity with the NeoForge generator. Every project still
needs normal build, client/server and gameplay acceptance testing.

## Applicable versions

| Item | Value |
| --- | --- |
| Generator | `forge-1.12.2` |
| Plugin | `generator-forge-1.12.2` |
| Generator snapshot | `2026.3-1.0.49.116-beta` |
| MCreator target | EAP `2026.3.44621` (`EAP2026344621`) |
| Minecraft | `1.12.2` |
| Forge | `14.23.5.2864` requested; generated mod declares `14.23.5.2847`–`14.23.5.2864` |
| Generated Java target | Java 8 |
| Gradle | Gradle 9.8.0 with RetroFuturaGradle 2.0.6 |

The matrix applies to elements generated with this plugin and to converted
workspaces using the shipped workspace base. It does not describe third-party
generators, hand-written mods or later Forge versions.

## Contents

1. [Native API](#native-api)
2. [Mixin or other equivalent implementation](#mixin-or-other-equivalent-implementation)
3. [Downgraded/emulated support using alternative methods](#downgradedemulated-support-using-alternative-methods)
4. [Not implemented - very high effort](#not-implemented---very-high-effort)
5. [Not implemented - major rework required](#not-implemented---major-rework-required)

## Support levels

| Level | Name | Guidance |
| --- | --- | --- |
| 1 | **Native API** | **Safe. Use with confidence.** Implemented with native 1.12.2/Forge APIs, without Mixin, reflection injection or a behavioral substitute. |
| 2 | **Mixin or other equivalent implementation** | **Usable. Be aware of possible compatibility issues with other mods.** Implemented with Mixin, enum extension, reflection or another runtime-level equivalent. Test alongside the project's mod list. |
| 3 | **Downgraded/emulated support using alternative methods** | **Risky. The result may not be fully equivalent to the expected feature. Avoid large-scale use, as behavior may be unexpected.** The implementation method is stated for every row in this tier. |
| 4 | **Not implemented - very high effort** | **Not implemented. Very difficult, with unknown stability; there is a low probability of adding this in the future.** Do not include it in a committed scope without a separate feasibility phase. |
| 5 | **Not implemented - major rework required** | **Not implemented. Requires major code changes. Consider implementing the requirement with another mod or accepting the limitation.** |

Levels 4 and 5 are not promises of future support. They are included so that
the missing parts of the NeoForge feature set are explicit in a scope
discussion.

## Native API

**Safe. Use with confidence.**

Native rows use only 1.12.2/Forge APIs that are present in the target runtime.
They do not depend on Mixin, enum extension or a semantic fallback. Normal
project testing is still required.

### Project and build infrastructure

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Generator metadata | Full | `plugin.json` id, weight, supported MCreator versions and generator id. |
| Generator definition | Full | `generator.yaml` base templates, language file, resource folders, Java model key, Gradle tasks and export path. |
| Base mod templates | Full | Main mod class, proxies, `mcmod.info`, pack metadata and element initializers generated from workspace data. |
| Dedicated-server safety | Full | Client-only renderers, key mappings, particles and skyboxes are isolated behind `@SideOnly`/client proxy paths. |
| Network channel | Full | One Forge `SimpleNetworkWrapper` channel exposed through the generated mod class, with deterministic discriminator allocation. |
| Gradle build chain | Full | Generated workspaces build with Gradle 9.8.0 and RetroFuturaGradle 2.0.6; generated mod Java target is 8. |
| Java 8 source compatibility | Full | Generated sources use Java 8 language and API levels. Java 25 is only the Gradle/MCreator runtime. |
| Generator validator | Full | Validates YAML, mappings, FreeMarker syntax/includes and template references. It does not replace `javac` or gameplay testing. |

### Creative tabs

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Creative tab registration | Full | `CreativeTabs` subclass with localized label and icon. |
| Search bar | Full | Native `hasSearchBar` handling. |
| Item ordering and tab membership | Full | Native tab item lists and multi-tab item registration. |

The NeoForge `hideTitle` field has no 1.12.2 equivalent and is hidden.

### Items

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Basic item | Full | `Item` generation with model, texture, localization, rarity, stack size and creative tabs. |
| Food item | Full | `ItemFood` generation with nutrition, saturation, eating animation and food effects where represented by the element. |
| Durability and enchantability | Full | Native `setMaxDamage`, `setMaxStackSize`, `setHarvestLevel`/enchantability fields. |
| Use duration and use animation | Full | Native `setMaxDamage`-independent use duration and `EnumAction` handling. |
| Container item | Full | Native `setContainerItem` usage. |
| Tooltips | Full | Localized fixed tooltips and procedure-driven tooltip hooks. |
| Item use hooks | Full | `onItemUse` and `onItemRightClick` call the configured procedures; on-block actions return `EnumActionResult.SUCCESS` after execution. |
| Item sub-items and multiple tabs | Full | `getSubItems` generation for multiple creative tabs. |
| Music disc base item | Full | `ItemRecord` with a native sound event and description. |
| Item extension: fuel | Full | Forge `FurnaceFuelBurnTimeEvent`, including fixed and procedure values. |
| Item extension: dispenser | Full | `BlockDispenser.DISPENSE_BEHAVIOR_REGISTRY` and `IBehaviorDispenseItem`. |

### Recipes

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Shaped crafting | Full | 1.12.2 JSON recipe under `assets/<modid>/recipes`. |
| Shapeless crafting | Full | 1.12.2 JSON recipe. |
| Furnace smelting | Full | `GameRegistry.addSmelting`. |
| Brewing | Full | `BrewingRecipeRegistry`. |

### Blocks and block entities

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Base block, stairs, slab, fence, wall, door, trapdoor and fence gate | Full | Native `Block` subclasses and 1.12.2 blockstate/model layouts. |
| Block item | Full | Native block item generation, including creative tabs and localized name. |
| Per-face textures and simple models | Full | 1.12.2 JSON models and blockstates. |
| Simple boolean, integer and enum properties | Full | Native `PropertyBool`, `PropertyInteger` and `PropertyEnum`. |
| Blockstate JSON and per-state models | Full | Generated `blockstates` and model variants for the supported property combinations. |
| Drops and XP | Full | Native loot/drop generation and `dropXpOnBlockBreak` handling. |
| Tool class, harvest level and placement checks | Full | Native `setHarvestLevel`, `canPlaceBlockAt` and placement procedure hooks. |
| Block tooltips | Full | Fixed and procedure-driven tooltip hooks. |
| NBT-backed block inventory | Full | Generated `IInventory` tile entity with `Items` NBT persistence. |
| Bound block GUI | Full | Generated `GuiContainer`/`Container` opens from the block and binds the tile entity inventory. |
| Inventory drop on break | Full | Inventory contents are dropped according to the block's configured drop settings. |
| Tick scheduling | Full | `tickRandomly` selects `randomTick`; non-random blocks use `updateTick`, and self-rescheduling occurs only for a positive `tickRate`. |
| Custom multi-box AABB | Full | Native `AxisAlignedBB` lists, per-box `addCollisionBoxToList`, and selection/collision boxes for supported states. |

Pressure plates, buttons, signs, flower pots, end rods, leaves and multipart
blockstates are not generated; see Levels 4 and 5.

### Plants

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Normal, sapling, growable and double plants | Full | Native plant block classes with 1.12.2 placement and growth hooks. |
| Cross, crop and custom plant models | Full | 1.12.2 JSON models and item textures. |
| Placement restrictions | Full | Native `canBlockStay` and block/plant tag checks. |
| Drops, XP, light, sound and creative tabs | Full | Native block item and drop behavior. |
| Bonemeal procedures | Full | Native `onBonemeal`/growth procedure dispatch. |
| NBT and forced update ticks | Full | Native `TileEntity`/`updateTick` handling where the element requests it. |

Saplings do not generate a tree feature chain in this snapshot; see Level 4.

### Fluids

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Custom fluid | Full | Forge `Fluid` plus `BlockFluidClassic`. |
| Still and flowing textures | Full | Native fluid icon and blockstate generation. |
| Bucket item and model | Full | Native bucket item and item model. |
| Client blockstate mapping | Full | Generated fluid blockstate mapping for still and flowing states. |

### Dimensions, portals and world providers

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Custom dimension registration | Full | `WorldProvider` subclass and `DimensionType` registration. |
| Dimension ID and biome provider | Full | Generated provider and `BiomeProvider` from the element's biome list. |
| Void dimension | Full | Empty chunk generator. |
| Custom terrain | Full | `IChunkGenerator` with absolute-coordinate noise, filler/fluid blocks, sea level, aquifers and biome surface rules. |
| Caves and ravines | Full | Native `MapGenCaves`/`MapGenRavine` adaptation. |
| Sky light, fog, clouds, fixed time and ambient light | Full | Native `WorldProvider` fields. |
| Respawn, bed and weather behavior | Full | Native provider flags. |
| Player enter/leave procedures | Full | Native dimension travel hooks. |
| Portal block and igniter | Full | `BlockPortal` plus generated item/igniter behavior. |
| Teleporter | Full | Generated `ITeleporter`. |
| Skybox | Full | Client `IRenderHandler` installed through the proxy. |
| Portal sounds | Full | Native `SoundEvent`. |

### Biomes

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Biome registration | Full | 1.12.2 `Biome` registration. |
| Climate and rainfall | Full | Native biome climate fields. |
| Top, filler, water, grass, foliage and sky colors | Full | Native biome color fields. |
| Entity spawn lists | Full | Native `Biome.SpawnListEntry` data. |
| Vanilla tree types | Full | Native `WorldGenTrees` and related vanilla generators. |
| Stronghold and village registration | Full | Native biome flags. |
| Ambient and addition sounds | Full | Native `SoundEvent` fields. |
| Overworld `BiomeManager` registration | Full | Native `BiomeManager.addBiome`. |

### Armor, tools and shields

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Four-piece armor set | Full | `ArmorMaterial` and native `ItemArmor` subclasses. |
| Armor durability, armor points, toughness and enchantability | Full | Native `ArmorMaterial` values. |
| Armor repair material and rarity | Full | Native item fields. |
| Armor tick behavior and attribute modifiers | Full | Native `onArmorTick` and attribute modifier application. |
| Armor tooltips and creative tabs | Full | Native item hooks. |
| Pickaxe, axe, spade, hoe, sword and shears | Full | Native `ToolMaterial`/`ItemTool` family. |
| Special and multitool behavior | Full | Native `Item`/`ItemTool` composition. |
| Shield | Full | Native `ItemShield`, blocking behavior and generated blocking model predicate. |
| Tool durability, efficiency, damage, attack speed, enchantability and repair item | Full | Native tool fields. |
| Tool right-click, block, entity and destroy triggers | Full | Native item/tool hooks. |
| Deterministic attribute UUIDs | Full | Stable UUID generation for tool modifiers. |

### Loot table definitions

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Native loot-table JSON | Full | `assets/<modid>/loot_tables`. |
| Built-in table replacement | Full | `LootTableLoadEvent` replacement and registration. |
| Named pools and rolls | Full | Native 1.12.2 loot-table structures. |
| Item and empty entries, weights and count ranges | Full | Native table entries. |
| Enchantment levels on entries | Full | Native enchantment functions. |

### Enchantments

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Enchantment registration | Full | Native `Enchantment` and Forge registry. |
| Max level, weight and rarity | Full | Native enchantment values. |
| Incompatible enchantments | Full | Native `Enchantment` incompatibility checks. |
| Supported slots and supported items | Full | Native `EnumEnchantmentType`, item and Ore Dictionary checks. |

### Potion effects and potion items

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Custom potion effect | Full | `Potion` subclass with category, color, icon and instant/beneficial flags. |
| Attribute modifiers | Full | Native attribute map and UUID-based removal. |
| Start, tick, expire, hurt and death procedures | Full | Native potion hooks. |
| Milk/cure and natural-expiry handling | Full | Expiry logic guards against recursive milk re-entry and removes a same-effect re-add. |
| Custom potion type | Full | `PotionType` registration. |
| Vanilla potion, splash, lingering and tipped-arrow items | Full | Native items and generated brewing conversions. |

### Living entities, projectiles and special entities

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Mob, creature, animal and tameable bases | Full | Native `EntityMob`, `EntityCreature`, `EntityAnimal` and `EntityTameable` subclasses. |
| Selected vanilla entity base | Full | Native subclass of the chosen `Entity<AI base>` class. |
| Attributes, equipment, drops, sounds and boss bar | Full | Native entity fields and Forge events. |
| Spawn egg, biome and dungeon spawn entries | Full | Native spawn registration. |
| Ridable controls, flying/water movement and ranged attacks | Full | Native entity/AI behavior. |
| Breeding, taming and entity data | Full | Native `DataParameter` and AI goals. |
| Entity immunities | Full | Native damage-source handling. |
| Built-in and custom Java model rendering | Full | Native renderers and legacy `ModelRenderer` models. |
| Arrow projectile | Full | `EntityArrow` subclass with item or Java-model rendering. |
| Projectile damage, knockback, power, gravity, fire and particles | Full | Native entity fields and hooks. |
| Block, player, entity and flying-tick procedures | Full | Native projectile callbacks. |
| Boat and chest boat | Full | `EntityBoat` subclass, spawn item and vanilla `GuiChest` inventory for chest variants. |

### GUIs, overlays and key bindings

| Feature | Scope | Native implementation |
| --- | --- | --- |
| `GuiContainer`/`Container` pair | Full | Native Forge GUI/container classes. |
| Background, labels, images and sprites | Full | Native GUI drawing. |
| Buttons, image buttons, text fields, checkboxes and sliders | Full | Native widget classes and generated callbacks. |
| Tooltips and entity previews | Full | Native `GuiScreen`/`GuiContainer` rendering. |
| Open, tick, close, button, slider and slot procedures | Full | Native GUI lifecycle hooks. |
| Block-bound slot inventory | Full | Container binds the owning block's `IInventory` tile entity. |
| In-game overlay | Full | `RenderGameOverlayEvent` handler with configurable priority and target screen. |
| Vanilla-screen overlay | Full | `GuiScreenEvent` handler with configurable target screen. |
| Overlay labels, images, sprites and entity previews | Full | Native overlay rendering. |
| Keyboard and mouse key bindings | Full | Forge `KeyBinding` and client registry. |
| Press/release handling and server-bound message | Full | Native key input plus the generated network channel. |

### Procedures

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Global triggered procedures | Full | Generated procedure classes and dependency maps. |
| Baseline procedure blocks | Full | 1.12.2-native procedure templates. |

### Trigger coverage

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Block interaction, placement, break, tick and neighbor triggers | Full | Forge block events and hooks. |
| Entity, player, world and mod-lifecycle triggers | Full | Forge events and lifecycle hooks. |
| Native advancement, item-use and projectile triggers | Full | Forge events and entity hooks. |

### Advancements, functions and game rules

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Advancement JSON | Full | 1.12.2 `assets/<modid>/advancements`. |
| Title, description, icon, frame and background | Full | Native advancement JSON. |
| Toast, chat and hidden flags | Full | Native display fields. |
| Parent, rewards and common 1.12.2 triggers | Full | Native advancement JSON. |
| Null-safe advancement checks | Full | Generated advancement helpers return safely when an ID is missing. |
| `.mcfunction` generation | Full | `data/<namespace>/functions/<name>.mcfunction`. |
| Game rule registration | Full | Native `GameRules` entry and get/set procedure blocks. |

### Commands

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Command registration | Full | 1.12.2 `CommandBase` registration. |
| Permission level | Full | Native command permission checks. |
| Standard, singleplayer, multiplayer and client targeting | Full | Native command dispatch. |
| Literal, blockstate and item arguments | Full | Sequential 1.12.2 argument parsing into typed command parameters. |

### Villager professions and trades

| Feature | Scope | Native implementation |
| --- | --- | --- |
| Villager profession | Full | `VillagerRegistry.VillagerProfession` and profession/zombie textures. |
| Villager career | Full | `VillagerCareer` registration. |
| Merchant trades | Full | `VillagerCareer#addTrade` with native `MerchantRecipe` NBT. |

## Mixin or other equivalent implementation

**Usable. Be aware of possible compatibility issues with other mods.**

These features work through runtime injection or registry extension. They are
tested in the target environment, but a project's mod list, coremods or
conflicting mixins can affect them.

### World generation injection

| Feature | Scope | Implementation method | Compatibility note |
| --- | --- | --- | --- |
| Cave and Nether biome lookup | Partial | Mixin `0.7.11-SNAPSHOT` on `World#getBiome`. | Column-based injection, not per-Y biome storage. Overworld lookup is limited to `0 < y < 50`; `y=0` is excluded because 1.12.2 decoration queries that position. |
| Mixin packaging | Full | Embedded Mixin, RFG refmap, `MixinTweaker`, `MixinConfigs`, `ForceLoadAsMod` and a generated `mixins.<modid>.json`. | Conflicts with another mod that transforms the same world/biome path are possible. |

### Registry extensions

| Feature | Scope | Implementation method | Compatibility note |
| --- | --- | --- | --- |
| Custom particle type | Partial | Reflection extension of `EnumParticleTypes` plus native `TextureStitchEvent.Pre` registration. | Enum size/ordinal assumptions can conflict with mods that also extend the enum. `renderType` is hidden. |
| Custom banner pattern | Partial | `EnumHelper.addEnum` on `BannerPattern` plus native banner/shield textures and pattern item. | `BannerPattern.byHash` scans the enum, so added entries are recognized. `requireItem=false` is effectively unsupported because 1.12.2 `RecipesBanners` requires a pattern item. |

## Downgraded/emulated support using alternative methods

**Risky. The result may not be fully equivalent to the expected feature. Avoid
large-scale use, as behavior may be unexpected.**

Every row states the implementation method and its practical limitation. These
features are supported for normal projects but should not be presented as exact
NeoForge parity.

### Recipe compatibility

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Blasting | Partial | Mapped to 1.12.2 furnace smelting. | No blast-furnace speed or fuel semantics. |
| Smoking | Partial | Mapped to 1.12.2 furnace smelting. | No smoker speed or food-only semantics. |
| Campfire cooking | Partial | Mapped to 1.12.2 furnace smelting. | No campfire cooking time, particles or visual state. |

### Block states, metadata and AABBs

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Multi-property blockstates | Partial | Generated property combinations, `getMetaFromState`/`getStateFromMeta`, and clamped 4-bit metadata. | More than the supported property/metadata combinations need manual blockstate work. |
| Per-state collision boxes | Partial | Custom per-state integer AABBs, first box for the base selection/collision AABB, and per-box `addCollisionBoxToList`. | Subtract boxes are ignored. Complex unions are represented as box lists, not constructive solid geometry. |
| Suffixed integer properties | Partial | `getIntegerProperty` falls back from `age` to properties such as `age_7`. | Only integer properties with the expected prefix are resolved automatically. |
| Inventory retention across state updates | Partial | Generated tile entity overrides `shouldRefresh` and retains NBT for same-block state changes. | Converted commands or a stale built jar can still replace/clear the tile; verify with a freshly built jar. |
| Itemless block tags | Partial | Generated `BlockTags` map in addition to Ore Dictionary entries. | The map is a generator-side compatibility layer, not a native 1.12.2 registry. |

### Tag and Ore Dictionary compatibility

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Item and block tags | Partial | Ore Dictionary registration plus the generated itemless-block `BlockTags` map. | No native 1.12.2 tag system. Only item and block semantics are represented. |
| Nested/custom tags | Partial | Recursive flattening, parent/leaf registration and cycle protection. | Names are flattened; tag identity and inheritance graphs are not preserved at runtime. |
| Water and lava fluid tags | Partial | Water/lava entries also register flowing variants. | Other fluid-tag semantics and fluid-state queries need explicit procedures. |
| Tag JSON files | None | Not emitted; legacy `data/<modid>/tags` directories should be removed. | The tag editor remains available, but 1.12.2 has no tag file format. |

### Climate, biomes and dimensions

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Five-range biome climate fields | Partial | Each range is converted to a `BiomeManager.BiomeEntry` weight based on `abs(max-min)/4`; weights sum to 0..500. | This is a weight proxy, not a 1.18 climate/noise engine. |
| Custom dimension terrain | Partial | `IChunkGenerator` with Perlin noise, filler/fluid blocks, sea level, 2D aquifers and biome surface rules. | Height is fixed at 256 and terrain semantics are not equivalent to modern dimension JSON. |
| Custom caves and ravines | Partial | Native `MapGenCaves`/`MapGenRavine` adapted to the filler block. | No modern noise-cave or carver configuration parity. |
| Biome surface blending | Partial | Generated per-column biome top/filler rules. | No modern multi-noise biome source or 3D climate sampling. |

### Loot table conversion

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Top-level loot-table types | Partial | 1.12.2 JSON conversion. | Some modern table types have no 1.12.2 form and are ignored. |
| Silk touch, fortune and explosion-decay conditions | Partial | Only the 1.12.2-representable subset is emitted. | Modern conditions without a 1.12.2 equivalent are ignored. |

### Enchantments and attributes

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Damage, armor, knockback, XP and equipment-drop enchantment effects | Partial | Forge 1.12.2 events. | The full modern condition/value-effect/XML model is not interpreted. |
| Item-tag-based enchantment applicability | Partial | `EnumEnchantmentType`, item checks and Ore Dictionary. | Modern item tags are flattened into legacy checks. |
| Custom attributes | Partial | `RangedAttribute` injected through `EntityConstructing`. | 1.12.2 has no global attribute registry; `sentiment`, complete modifier mapping and modern synchronization are unavailable. |

### Procedures and command compatibility

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| GUI state channel | Partial | Generated `SimpleNetworkWrapper` message for text fields, checkboxes and sliders. | This is a small custom channel, not the modern menu-state API. |
| Converted `data get block` commands | Partial | Generator compatibility bridge reads the tile `IInventory`. | The command is not native 1.12.2 syntax. Reads are non-destructive; only explicit `data remove block` clears a slot. |
| Converted `data remove block` commands | Partial | Explicit inventory clear in the generated command path. | Only the first non-empty slot is cleared. |

### Polling triggers

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| XP-change and XP-level-change triggers | Partial | Per-tick XP/level delta tracking. | The listener is generated only into procedures that use those triggers. It is polling, not a native event. |

### Damage sources

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Custom damage type | Partial | Per-element 1.12.2 `DamageSource` subclass and death-message keys. | No damage-type registry. Fire/magic/explosion/difficulty adapters are limited to 1.12.2 fields. |

### Advancements

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Common advancement triggers | Partial | Native 1.12.2 advancement JSON templates. | Modern item predicates and data-component conditions have no 1.12.2 form. |
| Missing advancement IDs | Full | Null-safe generated helpers return false or skip progress updates. | This is a code-safety fix, not a claim that every modern trigger is available. |

### Structures and features

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| NBT structure placement | Partial | Java `IWorldGenerator` loading `assets/<modid>/structures/<name>.nbt`. | Biome restriction, spacing, separation and fixed start height only; no jigsaw pools or terrain adaptation. |
| Simple block, random-patch, ore and scattered-ore features | Partial | Java `IWorldGenerator` with 1.12.2 placement logic. | No modern configured/placed feature registries. Other feature types stop generation. |

### Villagers, commands and game rules

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Villager professions and careers | Partial | Legacy `VillagerRegistry.VillagerProfession`/`VillagerCareer`. | No point of interest, work sound or hat layer. |
| Villager trades | Partial | `VillagerCareer#addTrade` and 1.12.2 `MerchantRecipe` NBT. | No wandering-trader or price-multiplier form. |
| Commands with nested branches | Partial | Sequential `CommandBase` parsing and legacy `if` branches. | No Brigadier suggestions or tab completion. |
| Game rule category | Partial | The 1.12.2 `GameRules` entry is generated; the modern category field is hidden. | Categories are not represented in the 1.12.2 UI. |

### GUI, entities and compatibility layers

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Chest boat inventory | Partial | Native `EntityBoat` plus persisted 27-slot `IInventory` exposed through vanilla `GuiChest`. | Only the chest-boat form; rafts are rendered as boats and custom entity textures are ignored. |
| Legacy Java entity models | Partial | `ModelRenderer` model key and native renderer classes. | No modern model loaders or animation systems. |
| Texture compatibility | Partial | Processed-resource rewriting of newer vanilla texture names to 1.12.2 names. | Unmatched textures fall back to documented stone/obsidian/wool substitutes. |
| Workspace conversion | Partial | `setupWorkspaceBase`, source rewrite and generator `subversion` refresh. | Converted workspaces can still contain unsupported higher-version commands or fields; these are reported as workspace issues. |
| Legacy MCP mappings | Partial | Shipped element mappings and documented vanilla/Ore Dictionary fallbacks. | Unsupported modern values cannot be translated automatically. |

### Workspace variables

| Feature | Scope | Implementation method | Limitation |
| --- | --- | --- | --- |
| Number, logic, string, direction, blockstate, itemstack and registryname variables | Full | Static fields, `WorldSavedData` and a Forge player capability with login/respawn/dimension synchronization. | Serialization follows the selected scope. |
| World and map variables | Partial | `WorldSavedData` for world scope; session-only `HashMap` for map scope. | Map scope is not serialized. |
| Entity variables | Partial | Session-backed entity storage. | Persistent entity scope is not provided. |

## Not implemented - very high effort

**Not implemented. Very difficult, with unknown stability; there is a low
probability of adding this in the future.**

These items require substantial engine work, a fragile injection point or an
unproven compatibility path. They should be handled as explicit exclusions or
separate R&D items.

### World, dimensions and biomes

| Feature | Why it is not implemented | Suggested alternative |
| --- | --- | --- |
| World height above 256 | 1.12.2 hard-codes 256-height chunk storage and client handling. | Use a dedicated height-extension mod or keep terrain at/below 252. |
| True per-Y / 3D biome storage | 1.12.2 stores biomes per column; a per-Y implementation needs chunk and client changes. | Use a mod with 3D biome support or approximate with cave-only biome lookup. |
| Sapling-to-tree generation | Saplings are generated as plants but do not run a tree feature chain. | Use a custom tree feature or a hand-written growth procedure. |
| Custom sun and moon rendering | 1.12.2 uses fixed celestial renderers; no generated replacement is provided. | Use a client renderer mod or keep the vanilla sky. |
| Biome particles, mood and music | 1.12.2 biome fields do not expose the modern ambient-particle/mood/music configuration. | Use a client/event procedure or a dedicated biome mod. |

### Blocks and tile entities

| Feature | Why it is not implemented | Suggested alternative |
| --- | --- | --- |
| Pressure plates, buttons, signs, flower pots, end rods, leaves and multipart blockstates | These block families have no template implementation in this snapshot. | Use vanilla blocks or hand-written block classes. |
| Custom fluidlogging/waterlogging | 1.12.2 has no native waterlogged blockstate contract. | Add a hand-written blockstate/procedure layer. |
| Plant custom hitboxes | Plant templates generate standard plant shapes, not per-plant hitbox definitions. | Use a custom block element or hand-written `AxisAlignedBB`. |
| Full tile-entity synchronization | The generated `IInventory` persists NBT but does not provide a complete modern container-data sync layer. | Use native `Container` slot sync or a custom packet. |

### Items and equipment

| Feature | Why it is not implemented | Suggested alternative |
| --- | --- | --- |
| Item-bound containers | 1.12.2 item containers require a custom GUI/container and item NBT ownership; not generated. | Use a block container or a backpack/container mod. |
| Custom armor model parts | 1.12.2 armor rendering uses fixed layer textures; no modern armor model loader. | Ship the required `textures/models/armor/*_layer_1.png`/`_layer_2.png` textures. |
| OBJ/Java item models and advanced item renderers | Only standard item/handheld and custom JSON parent models are generated. | Use a dedicated model loader or hand-written renderer. |
| Ranged item behavior | No generated bow/crossbow/throwable item base. | Use a projectile element plus a hand-written item. |
| Fishing rods | No generated `ItemFishingRod` base or cast/hook behavior. | Use a hand-written fishing-rod item or a fishing mod. |
| Advanced item fields: repair material, glow, attribute-modifier entries, fire immunity and piglin currency | The element fields have no generated 1.12.2 item-field mapping. | Add item NBT/procedure behavior or a hand-written item. |

### Entities and rendering

| Feature | Why it is not implemented | Suggested alternative |
| --- | --- | --- |
| Custom painting rendering | The 1.12.2 painting renderer and `EnumArt` extension could not be made reliable; the painting element is disabled. | Use vanilla paintings or a dedicated painting mod. |
| Entity animations | No animation model loader is generated. | Use a dedicated animation library/mod and hand-written renderer. |
| Accurate fish entity models | Fish elements use the generic entity model path; vanilla fish shapes and schooling behavior are not generated. | Use a hand-written fish entity/renderer or a dedicated fish mod. |
| Embedded entity inventories | Living-entity GUI/inventory binding is hidden; only block and chest-boat inventories are generated. | Use a block inventory or a separate entity-inventory mod. |
| Custom shield renderer/banner patterns | Shield rendering and banner-pattern composition are not exposed by the generated item. | Use a dedicated shield/banner mod. |
| Custom mob-effect particles | Only the potion icon/color is generated. | Use a particle procedure or a hand-written effect. |
| Fluid fog, overlays and custom flow conditions | `BlockFluidClassic` covers the base fluid; custom rendering/flow is not generated. | Use a dedicated fluid mod or hand-written renderer. |

### Loot, damage and enchantments

| Feature | Why it is not implemented | Suggested alternative |
| --- | --- | --- |
| Full enchantment condition/value-effect/XML interpretation | The generated enchantment uses a partial event mapping. | Implement the missing effect as a procedure or hand-written enchantment. |
| Loot modifiers | The generated loot-table loader does not interpret modern modifier chains. | Implement via `LootTableLoadEvent` in a hand-written mod or a procedure hook. |
| Exhaustion damage | `DamageSource` has no dedicated exhaustion setter or type registry in 1.12.2. | Use a gameplay procedure that applies hunger/saturation directly. |

### UI and triggers

| Feature | Why it is not implemented | Suggested alternative |
| --- | --- | --- |
| Editable overlay widgets | Overlays support drawing only; buttons and editable widgets are not rendered. | Put interactive controls in a `GuiScreen` or `GuiContainer`. |
| Entity switch-hand and totem-use triggers | Requires Mixin into entity use paths. | Use a dedicated trigger mod or a manual Mixin project. |
| Creative tab title hiding | No 1.12.2 API for the modern `hideTitle` field. | Accept the standard tab title or custom-render the tab. |

## Not implemented - major rework required

**Not implemented. Requires major code changes. Consider implementing the
requirement with another mod or accepting the limitation.**

These features belong to later Minecraft/NeoForge architectures and cannot be
added by extending the current template layer without replacing core systems.

### Items and data

| Feature | Architectural reason | Suggested alternative |
| --- | --- | --- |
| Data components and modern item components | 1.12.2 items use NBT and fixed fields, not the component registry. | Use item NBT plus procedures; use a components/backport mod if required. |
| Armor trims | No 1.12.2 trim registry, smithing UI or trim rendering path. | Use a dedicated armor/trim mod or omit the feature. |

### World generation and dimensions

| Feature | Architectural reason | Suggested alternative |
| --- | --- | --- |
| Data-driven dimensions, climate and noise settings | 1.12.2 dimensions are code-driven `WorldProvider`/chunk generators. | Use the generated provider or a modern worldgen mod. |
| Configured/placed features, biome sources and jigsaw structures | 1.12.2 uses `IWorldGenerator` and NBT templates, not the modern registry pipeline. | Use a worldgen mod or hand-written generators. |
| Modern fluid types, fluid tags and fluid-state API | 1.12.2 uses `Fluid`/`BlockFluidClassic` with a limited fluid state model. | Use the generated Forge fluid layer or a dedicated fluid mod. |

### Gameplay registries and recipes

| Feature | Architectural reason | Suggested alternative |
| --- | --- | --- |
| Data-driven damage-type registry | 1.12.2 has no damage-type registry; only `DamageSource` objects. | Use the generated `DamageSource` compatibility layer or a combat mod. |
| Biome, entity-type, fluid and damage-type tags | The legacy tag backend only covers item/block Ore Dictionary plus the generated `BlockTags` map. | Use explicit procedures or a tag-backport mod. |
| Modern recipe types and workstation recipes (stonecutting, smithing) | 1.12.2 has no equivalent recipe registry/workstation contract. | Use a custom GUI/block or a dedicated workstation mod. |
| Composting | 1.12.2 has no composter block or compostable-item registry. | Use a custom block/procedure or a composting mod. |

### Platform and architecture

| Feature | Architectural reason | Suggested alternative |
| --- | --- | --- |
| Modern menu/network/container-data APIs | 1.12.2 uses `Container`/`GuiContainer` and a custom `SimpleNetworkWrapper` channel. | Use the generated legacy GUI/container layer. |
| Modern item model system and custom model loaders | 1.12.2 uses JSON item models and the legacy `ModelRenderer`. | Use JSON models or a dedicated model-loader mod. |
| Full NeoForge event, capability and registry parity | The target is Forge 1.12.2, not NeoForge. | Target a supported NeoForge version for features that depend on NeoForge APIs. |

## Validation basis and usage guidance

This snapshot was validated with:

- Generator validator: 82 YAML documents, 759 FreeMarker templates and 144
  template references.
- Four converted test workspaces regenerated with `failed=0`.
- Generated workspace builds with Gradle 9.8.0 on Java 25 and a Java 8 mod
  toolchain.
- Client startup smoke tests through Forge mod loading, with no generated-mod
  crash in the latest run.

Recommended use:

1. Scope Level 1 and Level 2 features as supported functionality.
2. Treat Level 3 features as compatibility features. Include an acceptance test
   for each one and avoid making them a critical dependency without a fallback.
3. Do not include Level 4 or Level 5 features in a committed scope without a separate feasibility phase.
4. Rebuild the generated workspace jar after every regeneration. `runClient`
   loads the built jar, so a stale jar can mask or reproduce bugs that are no
   longer present in generated sources.

[![MCreator](https://mcreator.net/image/brand/mcreator300s.png)](https://mcreator.net/)

MCreator is an open-source software used to make Minecraft Java Edition mods, Minecraft Bedrock Edition Add-Ons, resource packs, and data packs using an intuitive easy-to-learn interface or with an integrated code editor. It is used worldwide by Minecraft players, aspiring mod developers, for education, online classes, and STEM workshops.
