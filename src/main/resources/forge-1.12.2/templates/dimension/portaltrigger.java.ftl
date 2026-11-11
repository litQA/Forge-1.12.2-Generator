<#-- @formatter:off -->
<#include "/creativeTabs.ftl">
package ${package}.item;

import ${package}.init.${JavaModName}Blocks;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.item.EnumRarity;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumActionResult;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.EnumHand;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.World;

public class ${name}Item extends Item {

	public ${name}Item() {
		setUnlocalizedName("${modid}.${registryname}");
		<#if data.creativeTabs?has_content>setCreativeTab(${creativeTabValue(data.creativeTabs)});</#if>
		setMaxStackSize(1);
		setMaxDamage(64);
	}

	<#if data.igniterRarity != "COMMON">
	@Override public EnumRarity getRarity(ItemStack stack) {
		return EnumRarity.${data.igniterRarity};
	}
	</#if>

	@Override public EnumActionResult onItemUse(EntityPlayer entity, World world, BlockPos pos, EnumHand hand,
			EnumFacing facing, float hitX, float hitY, float hitZ) {
		BlockPos spawnPos = pos.offset(facing);
		ItemStack itemstack = entity.getHeldItem(hand);
		if (!entity.canPlayerEdit(spawnPos, facing, itemstack) || !world.isAirBlock(spawnPos)) {
			return EnumActionResult.FAIL;
		}
		if ((((${package}.block.${name}PortalBlock) ${JavaModName}Blocks.${REGISTRYNAME}_PORTAL)).portalSpawn(world, spawnPos)) {
			itemstack.damageItem(1, entity);
			return EnumActionResult.SUCCESS;
		}
		return EnumActionResult.FAIL;
	}
}
<#-- @formatter:on -->
