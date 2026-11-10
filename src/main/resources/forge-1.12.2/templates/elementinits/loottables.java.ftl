<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.util.ResourceLocation;
import net.minecraft.world.storage.loot.LootTableList;

public class ${JavaModName}Loottables {

	public static void load() {
		<#list (loottables![]) as loottable>
		LootTableList.register(new ResourceLocation("${loottable.getNamespace()}:${loottable.getName()}"));
		</#list>
	}

}
<#-- @formatter:on -->
