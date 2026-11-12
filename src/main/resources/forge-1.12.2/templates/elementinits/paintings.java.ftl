<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.entity.item.EntityPainting;
import net.minecraft.util.ResourceLocation;
import net.minecraftforge.common.util.EnumHelper;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.common.registry.EntityEntry;
import net.minecraftforge.fml.common.registry.EntityEntryBuilder;

@Mod.EventBusSubscriber
public class ${JavaModName}Paintings {

	private static final Class<?>[] PARAMETERS = new Class<?>[] { String.class, int.class, int.class, int.class, int.class };
	<#assign paintingEntityId = 1000>

	<#list (types.paintings![]) as painting>
	public static EntityPainting.EnumArt ${painting.getModElement().getRegistryNameUpper()};
	</#list>

	public static void init() {
		<#list (types.paintings![]) as painting>
		${painting.getModElement().getRegistryNameUpper()} = EnumHelper.addEnum(EntityPainting.EnumArt.class,
				"${painting.getModElement().getRegistryNameUpper()}", PARAMETERS,
				"${painting.getModElement().getRegistryName()}",
				${(painting.width / 16)?int?c}, ${(painting.height / 16)?int?c}, 0, 0);
		if (${painting.getModElement().getRegistryNameUpper()} == null)
			throw new IllegalStateException("Failed to register painting ${painting.getModElement().getRegistryName()}");
		</#list>
	}

	@SubscribeEvent
	public static void registerEntities(RegistryEvent.Register<EntityEntry> event) {
		<#list (types.paintings![]) as painting>
		event.getRegistry().register(EntityEntryBuilder.<${package}.entity.${painting.getModElement().getName()}PaintingEntity>create()
				.entity(${package}.entity.${painting.getModElement().getName()}PaintingEntity.class)
				.id(new ResourceLocation("${modid}", "${painting.getModElement().getRegistryName()}_painting"), ${paintingEntityId?c})
				.name("${painting.getModElement().getRegistryName()}_painting")
				.tracker(64, Integer.MAX_VALUE, true)
				.build());
		<#assign paintingEntityId = paintingEntityId + 1>
		</#list>
	}
}
<#-- @formatter:on -->
