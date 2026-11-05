<#-- @formatter:off -->
package ${package}.init;

import net.minecraftforge.fluids.Fluid;
import net.minecraftforge.fluids.FluidRegistry;

public class ${JavaModName}Fluids {

	<#list types.fluids as fluid>
	public static final Fluid ${fluid.getModElement().getRegistryNameUpper()} =
			new ${package}.fluid.${fluid.getModElement().getName()}Fluid();
	</#list>

	public static void init() {
		<#list types.fluids as fluid>
		FluidRegistry.registerFluid(${fluid.getModElement().getRegistryNameUpper()});
		<#if fluid.generateBucket>
		FluidRegistry.addBucketForFluid(${fluid.getModElement().getRegistryNameUpper()});
		</#if>
		</#list>
	}

}
<#-- @formatter:on -->
