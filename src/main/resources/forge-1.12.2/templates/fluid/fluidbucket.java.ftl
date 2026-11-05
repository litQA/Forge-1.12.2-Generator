<#-- @formatter:off -->
<#include "/creativeTabs.ftl">
package ${package}.item;

import net.minecraft.block.Block;
import net.minecraft.creativetab.CreativeTabs;
import net.minecraft.item.ItemBucket;

public class ${name}Bucket extends ItemBucket {

	public ${name}Bucket(Block block) {
		super(block);
		setUnlocalizedName("${modid}.${registryname}_bucket");
		<#if data.creativeTabs?has_content>
		setCreativeTab(${creativeTabValue([data.creativeTabs[0]])});
		</#if>
		setMaxStackSize(1);
	}

}
<#-- @formatter:on -->
