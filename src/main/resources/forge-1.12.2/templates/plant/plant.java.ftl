<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
package ${package}.block;

import java.util.List;
import net.minecraft.block.Block;
import net.minecraft.block.BlockBush;
import net.minecraft.block.BlockDoublePlant;
import net.minecraft.block.BlockReed;
import net.minecraft.block.SoundType;
import net.minecraft.block.material.Material;
import net.minecraft.block.state.IBlockState;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.EnumHand;
import net.minecraft.util.NonNullList;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.IBlockAccess;
import net.minecraft.world.World;

<#if data.plantType == "growapable">
public class ${name}Block extends BlockReed {
<#elseif data.plantType == "double">
public class ${name}Block extends BlockDoublePlant {
<#else>
public class ${name}Block extends BlockBush {
</#if>

	public ${name}Block() {
		<#if data.plantType == "double">
		super();
		<#elseif data.plantType == "growapable">
		super();
		</#if>
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
		<#if data.luminance gt 0>
		setLightLevel(${(data.luminance / 15.0)?c}f);
		</#if>
		<#if data.unbreakable>
		setBlockUnbreakable();
		</#if>
	}

	<#if data.plantType == "normal" || data.plantType == "sapling">
	<#if data.canBePlacedOn?has_content>
	@Override protected boolean canSustainBush(IBlockState state) {
		return <#list data.canBePlacedOn as allowed>state.getBlock() == ${mappedBlockToBlock(allowed)}<#sep> || </#list>;
	}
	</#if>
	</#if>

	<#if data.isReplaceable>
	@Override public boolean isReplaceable(IBlockAccess world, BlockPos pos) {
		return true;
	}
	</#if>

	<#if data.flammability gt 0>
	@Override public int getFlammability(IBlockAccess world, BlockPos pos, EnumFacing face) {
		return ${data.flammability};
	}
	</#if>

	<#if data.fireSpreadSpeed gt 0>
	@Override public int getFireSpreadSpeed(IBlockAccess world, BlockPos pos, EnumFacing face) {
		return ${data.fireSpreadSpeed};
	}
	</#if>

	<#if data.customDrop?? && !data.customDrop.isEmpty()>
	@Override public void getDrops(NonNullList<ItemStack> drops, IBlockAccess world, BlockPos pos, IBlockState state, int fortune) {
		<#if data.plantType == "double">
		if (state.getValue(net.minecraft.block.BlockDoublePlant.HALF) == net.minecraft.block.BlockDoublePlant.EnumBlockHalf.LOWER) {
		</#if>
		drops.add(${mappedMCItemToItemStackCode(data.customDrop, data.dropAmount)});
		<#if data.plantType == "double">
		}
		</#if>
	}
	</#if>

	<#if data.xpAmountMax gt 0>
	@Override public int getExpDrop(IBlockState state, IBlockAccess world, BlockPos pos, int fortune) {
		return ${data.xpAmountMin} + (int) (Math.random() * ${data.xpAmountMax - data.xpAmountMin + 1});
	}
	</#if>

	<#if hasProcedure(data.placingCondition)>
	@Override public boolean canPlaceBlockAt(World world, BlockPos pos) {
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = getDefaultState();
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		return <@procedureOBJToConditionCode data.placingCondition/>;
	}

	<#if data.plantType == "growapable">
	@Override public boolean canBlockStay(World world, BlockPos pos) {
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = world.getBlockState(pos);
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		return <@procedureOBJToConditionCode data.placingCondition/>;
	}
	<#else>
	@Override public boolean canBlockStay(World world, BlockPos pos, IBlockState state) {
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		return <@procedureOBJToConditionCode data.placingCondition/>;
	}
	</#if>
	</#if>

	<#if data.isBonemealable>
	@Override public boolean onBlockActivated(World world, BlockPos pos, IBlockState state, EntityPlayer player, EnumHand hand, EnumFacing facing, float hitX, float hitY, float hitZ) {
		ItemStack held = player.getHeldItem(hand);
		if (held.getItem() == Items.DYE && held.getMetadata() == 15) {
			if (!world.isRemote) {
				double x = pos.getX(), y = pos.getY(), z = pos.getZ();
				IBlockState blockstate = state;
				Entity entity = player;
				EnumFacing direction = facing;
				ItemStack itemstack = held;
				<@procedureOBJToCode data.onBonemealSuccess/>
			}
			if (!player.capabilities.isCreativeMode) {
				held.shrink(1);
			}
			return true;
		}
		return super.onBlockActivated(world, pos, state, player, hand, facing, hitX, hitY, hitZ);
	}
	</#if>

}
<#-- @formatter:on -->
