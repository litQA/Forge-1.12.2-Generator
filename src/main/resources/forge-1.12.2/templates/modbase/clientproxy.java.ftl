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
		<#if (types.livingentities![])?has_content || (types.projectiles![])?has_content || (types.specialentities![])?has_content>
		${package}.init.${JavaModName}EntityRenderers.register();
		</#if>
		<#if (types.paintings![])?has_content>
		${package}.client.${JavaModName}PaintingRenderers.register();
		</#if>
		<#if (types.keybinds![])?has_content>
		${package}.init.${JavaModName}KeyMappings.registerKeyBindings();
		</#if>
		<#if (types.particles![])?has_content>
		${package}.init.${JavaModName}Particles.load();
		</#if>
	}

	@Override public void init(FMLInitializationEvent event) {
		<#if (types.particles![])?has_content>
		${package}.init.${JavaModName}Particles.registerFactories();
		</#if>
		<#list (types.commands![]) as command>
		<#if command.type == "CLIENTSIDE">
		${package}.command.${command.getModElement().getName()}Command.registerClientCommand();
		</#if>
		</#list>
	}

	@Override public void postInit(FMLPostInitializationEvent event) {
	}

	@Override public void serverLoad(FMLServerStartingEvent event) {
	}

}
<#-- @formatter:on -->
