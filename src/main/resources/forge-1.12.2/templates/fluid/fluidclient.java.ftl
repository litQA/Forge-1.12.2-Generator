<#-- @formatter:off -->
package ${package}.client;

import net.minecraft.client.renderer.block.model.ModelResourceLocation;
import net.minecraftforge.client.model.ModelLoader;
import net.minecraft.client.renderer.block.statemap.StateMapperBase;
import net.minecraft.block.state.IBlockState;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

@SideOnly(Side.CLIENT)
public class ${name}FluidClient {

	public static void register() {
		ModelLoader.setCustomStateMapper(${package}.init.${JavaModName}Blocks.${registryname?upper_case},
				new StateMapperBase() {
					@Override protected ModelResourceLocation getModelResourceLocation(IBlockState state) {
						return new ModelResourceLocation("${modid}:${registryname}", "fluid");
					}
				});
		<#if data.generateBucket>
		ModelLoader.registerItemVariants(${package}.init.${JavaModName}Items.${registryname?upper_case}_BUCKET);
		ModelLoader.setCustomModelResourceLocation(${package}.init.${JavaModName}Items.${registryname?upper_case}_BUCKET, 0,
				new ModelResourceLocation("${modid}:${registryname}_bucket", "inventory"));
		</#if>
	}

}
<#-- @formatter:on -->
