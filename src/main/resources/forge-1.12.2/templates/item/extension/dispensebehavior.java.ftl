<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
package ${package}.item.extension;

import net.minecraft.block.BlockDispenser;
import net.minecraft.dispenser.IBehaviorDispenseItem;
import net.minecraft.dispenser.IBlockSource;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumFacing;
import net.minecraft.world.World;

public class ${name}ItemExtension {

	public static void init() {
		BlockDispenser.DISPENSE_BEHAVIOR_REGISTRY.putObject(${mappedMCItemToItem(data.item)}, new IBehaviorDispenseItem() {
			@Override public ItemStack dispense(IBlockSource source, ItemStack stack) {
				World world = source.getWorld();
				double x = source.getBlockPos().getX();
				double y = source.getBlockPos().getY();
				double z = source.getBlockPos().getZ();
				EnumFacing direction = source.getBlockState().getValue(BlockDispenser.FACING);
				ItemStack itemstack = stack;
				<#if hasProcedure(data.dispenseSuccessCondition)>
				boolean success = <@procedureOBJToConditionCode data.dispenseSuccessCondition/>;
				<#else>
				boolean success = true;
				</#if>
				<#if hasProcedure(data.dispenseResultItemstack)>
				if (success) {
					ItemStack result = <@procedureOBJToItemstackCode data.dispenseResultItemstack/>;
					if (result != null && !result.isEmpty()) {
						return result;
					}
				}
				</#if>
				if (success) {
					stack.shrink(1);
				}
				return stack;
			}
		});
	}

}
<#-- @formatter:on -->
