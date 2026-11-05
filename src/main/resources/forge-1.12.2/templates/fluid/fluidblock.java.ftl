<#-- @formatter:off -->
package ${package}.block;

import net.minecraft.block.material.Material;
import net.minecraftforge.fluids.BlockFluidClassic;

public class ${name}Block extends BlockFluidClassic {

	public ${name}Block() {
		super(${package}.init.${JavaModName}Fluids.${registryname?upper_case}, Material.${data.type!"WATER"});
		setUnlocalizedName("${modid}.${registryname}");
		setRegistryName("${modid}:${registryname}");
	}

}
<#-- @formatter:on -->
