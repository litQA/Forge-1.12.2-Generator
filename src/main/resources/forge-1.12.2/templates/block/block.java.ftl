<#-- @formatter:off -->
<#include "/mcitems.ftl">
package ${package}.block;

import net.minecraft.block.Block;
import net.minecraft.block.SoundType;
import net.minecraft.block.material.Material;
import net.minecraft.block.state.IBlockState;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.util.NonNullList;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.IBlockAccess;

public class ${name}Block extends Block {

	public ${name}Block() {
		super(Material.ROCK);
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
	}

	<#if data.customDrop?? && !data.customDrop.isEmpty()>
	@Override public void getDrops(NonNullList<ItemStack> drops, IBlockAccess world, BlockPos pos, IBlockState state, int fortune) {
		drops.add(${mappedMCItemToItemStackCode(data.customDrop, data.dropAmount)});
	}
	</#if>

	<#if data.xpAmountMax gt 0>
	@Override public int getExpDrop(IBlockState state, IBlockAccess world, BlockPos pos, int fortune) {
		return ${data.xpAmountMin} + (int) (Math.random() * ${data.xpAmountMax - data.xpAmountMin + 1});
	}
	</#if>

}
<#-- @formatter:on -->
