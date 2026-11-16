<#-- @formatter:off -->
<#include "/tags.ftl">
package ${package}.init;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.ItemStack;

public class ${JavaModName}OreDictionary {

	private static void registerBlockTag(String tag, net.minecraft.block.Block block) {
		if (block == null)
			return;
		${JavaModName}BlockTags.add(tag, block);
		if (block == Blocks.WATER) {
			${JavaModName}BlockTags.add(tag, Blocks.FLOWING_WATER);
		} else if (block == Blocks.LAVA) {
			${JavaModName}BlockTags.add(tag, Blocks.FLOWING_LAVA);
		}
		if (net.minecraft.item.Item.getItemFromBlock(block) != Items.AIR) {
			net.minecraftforge.oredict.OreDictionary.registerOre(tag, block);
		}
	}

	public static void init() {
<#assign tagElements = w.getWorkspace().getTagElements()>
<#list tagElements.entrySet() as tagEntry>
	<#assign tag = tagEntry.getKey()>
	<#assign tagType = tag.type().name()>
	<#if tagType == "ITEMS" || tagType == "BLOCKS">
	<#assign oreName = oreDictionaryName(tag)>
	<#list collectTagEntries(tag) as entry>
		<#if tagType == "BLOCKS">
		<@registerBlockTagEntry entry=entry oreName=oreName/>
		<#else>
		<@registerItemTagEntry entry=entry oreName=oreName/>
		</#if>
	</#list>
	<#else>
		// 1.12.2 Ore Dictionary has no equivalent for ${tagType} tag: ${tag.resourcePath()}
	</#if>
</#list>
	}

}
<#-- @formatter:on -->
