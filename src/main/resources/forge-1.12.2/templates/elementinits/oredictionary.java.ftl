<#-- @formatter:off -->
<#include "/tags.ftl">
package ${package}.init;

import net.minecraft.init.Blocks;
import net.minecraft.init.Items;

public class ${JavaModName}OreDictionary {

	public static void init() {
<#assign tagElements = w.getWorkspace().getTagElements()>
<#list tagElements.entrySet() as tagEntry>
	<#assign tag = tagEntry.getKey()>
	<#assign tagType = tag.type().name()>
	<#if tagType == "ITEMS" || tagType == "BLOCKS">
	<#assign oreName = oreDictionaryName(tag)>
	<#list tagEntry.getValue() as entry>
		<#if tagType == "BLOCKS">
		<@registerBlockTagEntry entry=entry oreName=oreName/>
		<#else>
		<@registerItemTagEntry entry=entry oreName=oreName/>
		</#if>
	</#list>
	</#if>
</#list>
	}

}
<#-- @formatter:on -->
