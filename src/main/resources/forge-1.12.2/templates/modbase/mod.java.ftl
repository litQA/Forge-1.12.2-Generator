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

	public static final net.minecraftforge.fml.common.network.simpleimpl.SimpleNetworkWrapper PACKET_HANDLER =
			net.minecraftforge.fml.common.network.NetworkRegistry.INSTANCE.newSimpleChannel(MODID);
	private static int networkId = 0;

	public static <REQ extends net.minecraftforge.fml.common.network.simpleimpl.IMessage,
			REPLY extends net.minecraftforge.fml.common.network.simpleimpl.IMessage>
			void addNetworkMessage(
					Class<? extends net.minecraftforge.fml.common.network.simpleimpl.IMessageHandler<REQ, REPLY>> handler,
					Class<REQ> message, net.minecraftforge.fml.relauncher.Side side) {
		PACKET_HANDLER.registerMessage(handler, message, networkId++, side);
	}

	@Mod.EventHandler public void preInit(FMLPreInitializationEvent event) {
		<#if (types.tabs![])?has_content>
		${package}.init.${JavaModName}Tabs.load();
		</#if>
		<#if (types.biomes![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Biomes.class);
		</#if>
		<#if (types.dimensions![])?has_content>
		${package}.init.${JavaModName}Dimensions.load();
		</#if>
		<#if (types.fluids![])?has_content>
		${package}.init.${JavaModName}Fluids.init();
		</#if>
		<#if (types.enchantments![])?has_content>
		${package}.init.${JavaModName}Enchantments.init();
		</#if>
		<#if (types.attributes![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Attributes.class);
		</#if>
		<#if (types.blocks![])?has_content || (types.plants![])?has_content || (types.fluids![])?has_content || (types.dimensions![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Blocks.class);
		</#if>
		<#if (types.items![])?has_content || (types.blocks![])?has_content || (types.plants![])?has_content || (types.fluids![])?has_content || (types.tools![])?has_content || (types.armors![])?has_content || (types.dimensions![])?has_content || (types.specialentities![])?has_content || (types.bannerpatterns![])?has_content || (types.paintings![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Items.class);
		</#if>
		<#if (types.bannerpatterns![])?has_content>
		${package}.init.${JavaModName}BannerPatterns.init();
		</#if>
		<#if (types.paintings![])?has_content>
		${package}.init.${JavaModName}Paintings.init();
		</#if>
		<#if (types.livingentities![])?has_content || (types.projectiles![])?has_content || (types.specialentities![])?has_content>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Entities.class);
		</#if>
		<#if (types.guis![])?has_content || (types.specialentities![])?has_content>
		${package}.init.${JavaModName}GUIs.init();
		net.minecraftforge.fml.common.network.NetworkRegistry.INSTANCE.registerGuiHandler(instance, new ${package}.init.${JavaModName}GuiHandler());
		</#if>
		<#if (types.keybinds![])?has_content>
		${package}.init.${JavaModName}KeyMessages.register();
		</#if>
		<#if w.hasElementsOfType("itemextension")>
		MinecraftForge.EVENT_BUS.register(${package}.init.${JavaModName}Fuels.class);
		</#if>
		<#if w.hasElementsOfType("potioneffect")>
		${package}.init.${JavaModName}MobEffects.init();
		</#if>
		<#if w.hasElementsOfType("potion")>
		${package}.init.${JavaModName}Potions.init();
		</#if>

		proxy.preInit(event);
	}

	@Mod.EventHandler public void init(FMLInitializationEvent event) {
		<#if (types.biomes![])?has_content>
		${package}.init.${JavaModName}Biomes.init();
		</#if>
		<#if (types.blocks![])?has_content>
		${package}.init.${JavaModName}Blocks.initTileEntities();
		</#if>
		<#if w.getWorkspace().getTagElements()?size != 0>
		${package}.init.${JavaModName}OreDictionary.init();
		</#if>
		<#if (types.recipes![])?has_content>
		${package}.init.${JavaModName}Recipes.init();
		</#if>
		<#if (types.livingentities![])?has_content || (types.projectiles![])?has_content || (types.specialentities![])?has_content>
		${package}.init.${JavaModName}Entities.init();
		</#if>
		<#if (types.villagertrades![])?has_content>
		${package}.init.${JavaModName}Trades.load();
		</#if>
		<#if (types.structures![])?has_content || (types.features![])?has_content>
		${package}.init.${JavaModName}WorldGen.register();
		</#if>

		proxy.init(event);
	}

	@Mod.EventHandler public void postInit(FMLPostInitializationEvent event) {
		proxy.postInit(event);
		<#if w.hasElementsOfType("loottable")>
		${package}.init.${JavaModName}Loottables.load();
		</#if>
		<#if w.hasElementsOfType("itemextension")>
		${package}.init.${JavaModName}ItemExtensions.load();
		</#if>
	}

	@Mod.EventHandler public void serverLoad(FMLServerStartingEvent event) {
		<#list (types.commands![]) as command>
		<#if command.type != "CLIENTSIDE">
		${package}.command.${command.getModElement().getName()}Command.registerCommand(event);
		</#if>
		</#list>
		proxy.serverLoad(event);
	}

}
<#-- @formatter:on -->
