# Changelog

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
