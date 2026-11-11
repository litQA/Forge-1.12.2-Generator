<#-- @formatter:off -->
<#include "/creativeTabs.ftl">
package ${package}.item;

import net.minecraft.block.Block;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.util.ActionResult;
import net.minecraft.util.EnumActionResult;
import net.minecraft.util.EnumHand;
import net.minecraft.util.NonNullList;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.math.RayTraceResult;
import net.minecraft.world.World;

public class ${name}Item extends Item {

	<#if (data.creativeTabs?size > 1)>
	private static final CreativeTabs[] CREATIVE_TABS = new CreativeTabs[] {
		<#list data.creativeTabs as creativeTab>
		${creativeTabValue([creativeTab])}<#if creativeTab?has_next>,</#if>
		</#list>
	};
	</#if>

	public ${name}Item() {
		this.setMaxStackSize(1);
		this.setUnlocalizedName("${modid}.${registryname}");
		<#if creativeTabValue(data.creativeTabs) != "null">
		this.setCreativeTab(${creativeTabValue(data.creativeTabs)});
		</#if>
	}

	<#if (data.creativeTabs?size > 1)>
	@Override public void getSubItems(CreativeTabs tab, NonNullList<ItemStack> items) {
		for (CreativeTabs supportedTab : CREATIVE_TABS) {
			if (supportedTab == tab) {
				items.add(new ItemStack(this));
				return;
			}
		}
	}
	</#if>

	@Override public ActionResult<ItemStack> onItemRightClick(World world, EntityPlayer player, EnumHand hand) {
		ItemStack stack = player.getHeldItem(hand);
		RayTraceResult rayTrace = this.rayTrace(world, player, true);
		if (rayTrace == null || rayTrace.typeOfHit != RayTraceResult.Type.BLOCK)
			return new ActionResult<>(EnumActionResult.PASS, stack);

		BlockPos pos = rayTrace.getBlockPos();
		Block block = world.getBlockState(pos).getBlock();
		if (!block.isReplaceable(world, pos))
			pos = pos.offset(rayTrace.sideHit);

		if (!player.canPlayerEdit(pos, rayTrace.sideHit, stack))
			return new ActionResult<>(EnumActionResult.PASS, stack);

		if (!world.isRemote) {
			${package}.entity.${name}Entity entity = new ${package}.entity.${name}Entity(world, pos.getX() + 0.5D, pos.getY() + 0.5D, pos.getZ() + 0.5D);
			entity.rotationYaw = player.rotationYaw;
			world.spawnEntity(entity);
		}

		stack.shrink(1);
		return new ActionResult<>(EnumActionResult.SUCCESS, stack);
	}

}
<#-- @formatter:on -->
