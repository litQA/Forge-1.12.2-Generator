<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.block;

import ${package}.init.${JavaModName}Dimensions;
import net.minecraft.block.Block;
import net.minecraft.block.BlockPortal;
import net.minecraft.block.SoundType;
import net.minecraft.block.state.IBlockState;
import net.minecraft.entity.Entity;
import net.minecraft.init.Blocks;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.SoundCategory;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;
import net.minecraft.world.Teleporter;
import net.minecraftforge.fml.common.registry.ForgeRegistries;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import java.util.Random;

public class ${name}PortalBlock extends BlockPortal {

	public ${name}PortalBlock() {
		setHardness(-1.0F);
		setSoundType(SoundType.GLASS);
		setLightLevel(${data.portalLuminance?c}f);
		setUnlocalizedName("${modid}.${registryname}_portal");
	}

	<#if data.portalSound?has_content>
	@SideOnly(Side.CLIENT)
	@Override public void randomDisplayTick(IBlockState state, World world, BlockPos pos, Random rand) {
		super.randomDisplayTick(state, world, pos, rand);
		if (rand.nextInt(100) == 0) {
			SoundEvent sound = ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.portalSound}"));
			if (sound != null) {
				world.playSound(pos.getX() + 0.5D, pos.getY() + 0.5D, pos.getZ() + 0.5D, sound,
						SoundCategory.BLOCKS, 0.5F, rand.nextFloat() * 0.4F + 0.8F, false);
			}
		}
	}
	</#if>

	@Override public void onEntityCollidedWithBlock(World world, BlockPos pos, IBlockState state, Entity entity) {
		if (world.isRemote || entity.isRiding() || entity.isBeingRidden() || !entity.isNonBoss() || entity.timeUntilPortal > 0) {
			return;
		}

		int target = entity.dimension == ${JavaModName}Dimensions.${REGISTRYNAME}.getId() ? 0
				: ${JavaModName}Dimensions.${REGISTRYNAME}.getId();
		entity.timeUntilPortal = entity.getPortalCooldown();
		if (world.getMinecraftServer() != null && world.getMinecraftServer().getWorld(target) != null) {
			entity.changeDimension(target, new Teleporter(world.getMinecraftServer().getWorld(target)));
		}
	}

	public boolean portalSpawn(World world, BlockPos pos) {
		return this.trySpawn(world, pos, EnumFacing.Axis.X) || this.trySpawn(world, pos, EnumFacing.Axis.Z);
	}

	private boolean trySpawn(World world, BlockPos pos, EnumFacing.Axis axis) {
		EnumFacing right = axis == EnumFacing.Axis.X ? EnumFacing.EAST : EnumFacing.SOUTH;
		Block frame;
		<#if data.portalFrame?is_string>
			<#if data.portalFrame?has_content>
			frame = ${mappedBlockToBlock(data.portalFrame)};
			<#else>
			frame = net.minecraft.init.Blocks.OBSIDIAN;
			</#if>
		<#else>
			<#if data.portalFrame?? && !data.portalFrame.isEmpty()>
			frame = ${mappedBlockToBlock(data.portalFrame)};
			<#else>
			frame = net.minecraft.init.Blocks.OBSIDIAN;
			</#if>
		</#if>

		BlockPos bottom = pos;
		for (int i = 0; i < 5 && world.isAirBlock(bottom.down()); i++) {
			bottom = bottom.down();
		}
		BlockPos left = bottom;
		for (int i = 0; i < 5 && world.isAirBlock(left.offset(right.getOpposite())); i++) {
			left = left.offset(right.getOpposite());
		}

		for (int width = 2; width <= 4; width++) {
			for (int height = 3; height <= 5; height++) {
				if (!this.isFrame(world, left, right, width, height, frame)) {
					continue;
				}
				for (int x = 0; x < width; x++) {
					for (int y = 0; y < height; y++) {
						world.setBlockState(left.offset(right, x).up(y),
								this.getDefaultState().withProperty(AXIS, axis), 2);
					}
				}
				return true;
			}
		}
		return false;
	}

	private boolean isFrame(World world, BlockPos left, EnumFacing right, int width, int height, Block frame) {
		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				if (!world.isAirBlock(left.offset(right, x).up(y))) {
					return false;
				}
			}
		}
		for (int y = 0; y < height; y++) {
			if (world.getBlockState(left.offset(right.getOpposite()).up(y)).getBlock() != frame
					|| world.getBlockState(left.offset(right, width).up(y)).getBlock() != frame) {
				return false;
			}
		}
		for (int x = 0; x < width; x++) {
			if (world.getBlockState(left.offset(right, x).down()).getBlock() != frame
					|| world.getBlockState(left.offset(right, x).up(height)).getBlock() != frame) {
				return false;
			}
		}
		return true;
	}
}
<#-- @formatter:on -->
