<#-- @formatter:off -->
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

import net.minecraft.world.DimensionType;
import net.minecraft.world.WorldProvider;
<#list dimensions as dimension>
import ${package}.world.dimension.${dimension.getModElement().getName()}WorldProvider;
</#list>
import net.minecraftforge.common.DimensionManager;

public class ${JavaModName}Dimensions {

	<#list dimensions as dimension>
	public static DimensionType ${dimension.getModElement().getRegistryNameUpper()};
	</#list>

	public static void load() {
		<#list dimensions as dimension>
		${dimension.getModElement().getRegistryNameUpper()} =
				register("${dimension.getModElement().getRegistryName()}", ${dimension.getModElement().getName()}WorldProvider.class);
		</#list>
	}

	private static DimensionType register(String name, Class<? extends WorldProvider> provider) {
		int id = DimensionManager.getNextFreeDimId();
		DimensionType type = DimensionType.register(name, "_" + name, id, provider, true);
		DimensionManager.registerDimension(id, type);
		return type;
	}
}
<#-- @formatter:on -->
