# Changelog

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
