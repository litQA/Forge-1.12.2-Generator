<#-- @formatter:off -->
package ${package}.block;

import net.minecraft.block.material.Material;
import net.minecraftforge.fluids.BlockFluidClassic;

public class ${name}Block extends BlockFluidClassic {

	public ${name}Block() {
		super(${package}.init.${JavaModName}Fluids.${registryname?upper_case}, Material.${data.type!"WATER"});
		setUnlocalizedName("${modid}.${registryname}");
		setDensity(${data.density});
		setTemperature(${data.temperature});
		<#if data.flowRate gt 0>
		setQuantaPerBlock(${data.flowRate});
		</#if>
		<#if data.tickRate gt 0>
		setTickRate(${data.tickRate});
		</#if>
		<#if data.luminance gt 0>
		setMaxScaledLight(${data.luminance});
		</#if>
	}

}
<#-- @formatter:on -->
