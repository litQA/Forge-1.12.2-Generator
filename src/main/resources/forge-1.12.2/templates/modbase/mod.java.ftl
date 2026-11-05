<#-- @formatter:off -->
<#--
  Forge 1.12.2 base mod class.

  This template is regenerated on each build unless base mod element files are locked in
  the workspace settings.
-->
package ${package};

import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.SidedProxy;
import net.minecraftforge.fml.common.event.FMLInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPostInitializationEvent;
import net.minecraftforge.fml.common.event.FMLPreInitializationEvent;
import net.minecraftforge.fml.common.event.FMLServerStartingEvent;

@Mod(modid = ${JavaModName}.MODID, name = ${JavaModName}.NAME, version = ${JavaModName}.VERSION,
		acceptedMinecraftVersions = "[1.12.2]"<#if settings.isServerSideOnly()>, acceptableRemoteVersions = "*"</#if>)
public class ${JavaModName} {

	public static final String MODID = "${modid}";
	public static final String NAME = "${JavaConventions.escapeStringForJava(settings.getModName())}";
	public static final String VERSION = "${JavaConventions.escapeStringForJava(settings.getVersion())}";

	@SidedProxy(clientSide = "${package}.ClientProxy${JavaModName}", serverSide = "${package}.ServerProxy${JavaModName}")
	public static IProxy${JavaModName} proxy;

	@Mod.Instance(MODID) public static ${JavaModName} instance;

	@Mod.EventHandler public void preInit(FMLPreInitializationEvent event) {
		<#if (types.tabs![])?has_content>
		${package}.init.${JavaModName}Tabs.load();
		</#if>
		<#if (types.items![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Items.class);
		</#if>

		proxy.preInit(event);
	}

	@Mod.EventHandler public void init(FMLInitializationEvent event) {
		<#if (types.recipes![])?has_content>
		${package}.init.${JavaModName}Recipes.init();
		</#if>

		proxy.init(event);
	}

	@Mod.EventHandler public void postInit(FMLPostInitializationEvent event) {
		proxy.postInit(event);
	}

	@Mod.EventHandler public void serverLoad(FMLServerStartingEvent event) {
		proxy.serverLoad(event);
	}

}
<#-- @formatter:on -->
