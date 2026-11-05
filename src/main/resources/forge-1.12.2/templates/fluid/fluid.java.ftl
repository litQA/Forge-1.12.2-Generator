<#-- @formatter:off -->
package ${package}.fluid;

import net.minecraft.util.ResourceLocation;
import net.minecraftforge.fluids.Fluid;

public class ${name}Fluid extends Fluid {

	public ${name}Fluid() {
		super("${registryname}", new ResourceLocation("${data.textureStill.format("%s:blocks/%s")}"),
				new ResourceLocation("${data.textureFlowing.format("%s:blocks/%s")}"));
		setLuminosity(${data.luminosity});
		setDensity(${data.density});
		setViscosity(${data.viscosity});
	}

}
<#-- @formatter:on -->
