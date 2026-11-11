<#-- @formatter:off -->
package ${package};

import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.fml.common.event.FMLInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPostInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPreInitializationEvent;
import net.minecraftforge.fml.common.event.FMLServerStartingEvent;

public class ClientProxy${JavaModName} implements IProxy${JavaModName} {

	@Override public void preInit(FMLPreInitializationEvent event) {
		<#if (types.biomes![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.client.${JavaModName}BiomeSounds.class);
		</#if>
	}

	@Override public void init(FMLInitializationEvent event) {
	}

	@Override public void postInit(FMLPostInitializationEvent event) {
	}

	@Override public void serverLoad(FMLServerStartingEvent event) {
	}

}
<#-- @formatter:on -->
