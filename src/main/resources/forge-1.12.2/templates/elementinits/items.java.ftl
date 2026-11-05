<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

public class ${JavaModName}Items {

	private static final List<Item> REGISTRY = new ArrayList<>();

	<#list items as item>
	public static final Item ${item.getModElement().getRegistryNameUpper()} = register("${item.getModElement().getRegistryName()}", new ${item.getModElement().getName()}Item());
	</#list>

	// Start of user code block custom items
	// End of user code block custom items

	private static Item register(String name, Item item) {
		item.setRegistryName(${JavaModName}.MODID, name);
		REGISTRY.add(item);
		return item;
	}

	@SubscribeEvent public static void registerItems(RegistryEvent.Register<Item> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new Item[0]));
	}

	@SideOnly(Side.CLIENT) @SubscribeEvent public static void registerModels(ModelRegistryEvent event) {
		for (Item item : REGISTRY) {
			ModelLoader.setCustomModelResourceLocation(item, 0, new ModelResourceLocation(item.getRegistryName(), "inventory"));
		}
	}

}
<#-- @formatter:on -->
