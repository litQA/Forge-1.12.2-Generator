<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import net.minecraftforge.fml.common.registry.GameRegistry;

public class ${JavaModName}WorldGen {

	public static void register() {
		<#list (types.structures![]) as structure>
		GameRegistry.registerWorldGenerator(new ${package}.worldgen.${structure.getModElement().getName()}StructureGenerator(), 10);
		</#list>
		<#list (types.features![]) as feature>
		<#if feature.hasConfiguredFeature() && !feature.skipPlacement>
		GameRegistry.registerWorldGenerator(new ${package}.worldgen.${feature.getModElement().getName()}FeatureGenerator(), 20);
		</#if>
		</#list>
	}
}
<#-- @formatter:on -->
