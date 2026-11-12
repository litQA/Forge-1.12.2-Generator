# MCreator 2026.3 trigger support classification

This classification covers the 65 trigger templates shipped by the
MCreator 2026.3 NeoForge generator. It reflects what the Forge 1.12.2
generator can expose safely, not the existence of a modern registry/API.

## Level 1 - simple / native Forge 1.12.2 support (61)

These triggers map directly to a Forge 1.12.2 event or lifecycle callback.
The generator supplies a native trigger template and does not require a
Mixin, reflection, or a client/server packet workaround.

### Block and world

`block_break`, `block_multiplace`, `block_place`, `bonemeal_used`,
`bucket_filled`, `crop_attempts_growth`, `explosion_occurs`,
`farmland_trampled`, `minecraft_world_loaded`, `minecraft_world_unloaded`,
`sapling_glow`, `village_siege`, `world_ticks`

### Entity

`entity_attacked`, `entity_blocks`, `entity_change_equipment`, `entity_dies`,
`entity_dropxp`, `entity_falls`, `entity_grief`, `entity_healed`,
`entity_item_pickup`, `entity_joins_world`, `entity_jumps`, `entity_pickupxp`,
`entity_pre_hurt`, `entity_sets_attack_target`, `entity_spawns`,
`entity_struck_by_lightning`, `entity_tamed`, `entity_ticks`,
`entity_travels_to_dimension`

### Player and interaction

`chat_sent`, `command_executed`, `item_crafted`, `item_destroyed`,
`item_smelted`, `player_completes_advancement`, `player_critical_hit`,
`player_fishes_item`, `player_in_bed`, `player_left_click_air`,
`player_left_click_block`, `player_log_in`, `player_log_out`,
`player_respawn`, `player_right_click_block`,
`player_right_click_empty_hand`, `player_right_click_entity`,
`player_right_click_item`, `player_ticks`, `player_use_hoe`,
`player_useitem_finish`, `player_useitem_start`, `player_useitem_stop`,
`player_wakes_up`

### Mod lifecycle

`mod_clientload`, `mod_load`, `mod_serverload`

## Level 2 - complex / possible with Mixin or an adapter (4)

These 2026.3 triggers have no matching Forge 1.12.2 event. They can be
implemented later with a narrowly scoped Mixin or a state-tracking adapter.

| Trigger | Required adapter |
| --- | --- |
| `entity_switch_hand` | Mixin/injection around hand swapping; no 1.12.2 event exists. |
| `entity_uses_totem` | Mixin around totem death protection or a controlled item-use adapter. |
| `player_xp_change` | Mixin around `EntityPlayer#addExperience`, or per-player XP tracking on tick. |
| `player_xp_level_change` | Mixin around `EntityPlayer#addExperienceLevel`, or per-player level tracking on tick. |

## Level 3 - unsupported (0)

All 65 classified 2026.3 triggers have either a native 1.12.2 mapping or a
feasible Mixin/adapter path. No trigger is classified as permanently
unsupported at this point.

## Notes

- `entity_blocks` is native through Forge's `LivingDestroyBlockEvent`.
- `entity_grief` is native through `EntityMobGriefingEvent`.
- `mod_clientload` and `mod_serverload` are called from the client/server
  proxy `init` methods; `mod_load` is called from the mod `init` method.
- The two empty-hand click triggers use MCreator's existing packet wrapper
  and must have `registerMessage()` called during pre-initialization.
- The 2025.3 Forge 1.12.2 reference already contains the 60 baseline trigger
  templates; 2026.3 adds `entity_blocks`, `entity_switch_hand`,
  `entity_uses_totem`, `player_xp_change`, and `player_xp_level_change`.
