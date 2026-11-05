<#-- @formatter:off -->
<#include "/mcitems.ftl">
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

public class ${JavaModName}Tabs {

	<#list types.tabs as tab>
	public static CreativeTabs TAB_${tab.getModElement().getRegistryNameUpper()};
	</#list>

	public static void load() {
		<#list types.tabs as tab>
		TAB_${tab.getModElement().getRegistryNameUpper()} = new CreativeTabs("${modid}.${tab.getModElement().getRegistryName()}") {
			@Override @SideOnly(Side.CLIENT) public ItemStack getTabIconItem() {
				return ${mappedMCItemToItemStackCode(tab.icon, 1)};
			}

			@Override @SideOnly(Side.CLIENT) public boolean hasSearchBar() {
				return ${tab.showSearch?c};
			}
		}<#if tab.showSearch>.setBackgroundImageName("item_search.png")</#if>;
		</#list>
	}

	// Start of user code block custom creative tabs
	// End of user code block custom creative tabs

}
<#-- @formatter:on -->
