<#-- @formatter:off -->
<#--
  Forge 1.12.2 base mod class.

  This template is regenerated on each build unless base mod element files are locked in
  the workspace settings.
-->
package ${package};

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
		${JavaModName}Tabs.load();
		</#if>
		<#if (types.items![])?has_content>
		MinecraftForge.EVENT_BUS.register(${JavaModName}Items.class);
		</#if>

		proxy.preInit(event);
	}

	@Mod.EventHandler public void init(FMLInitializationEvent event) {
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
