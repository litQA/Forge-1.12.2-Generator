<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 */
package ${package}.init;

import java.util.ArrayList;
import java.util.List;

import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.common.registry.VillagerRegistry;

@Mod.EventBusSubscriber
public class ${JavaModName}VillagerProfessions {

	private static final List<VillagerRegistry.VillagerProfession> REGISTRY = new ArrayList<>();

	<#list (types.villagerprofessions![]) as profession>
	public static final VillagerRegistry.VillagerProfession ${profession.getModElement().getRegistryNameUpper()} = register(
			new VillagerRegistry.VillagerProfession("${modid}:${profession.getModElement().getRegistryName()}",
					"${modid}:textures/entity/villager/profession/${profession.getModElement().getRegistryName()}.png",
					"${modid}:textures/entity/zombie_villager/profession/${profession.getModElement().getRegistryName()}.png"));
	public static final VillagerRegistry.VillagerCareer ${profession.getModElement().getRegistryNameUpper()}_CAREER = new VillagerRegistry.VillagerCareer(
			${profession.getModElement().getRegistryNameUpper()}, "${modid}.${profession.getModElement().getRegistryName()}");
	</#list>

	private static VillagerRegistry.VillagerProfession register(VillagerRegistry.VillagerProfession profession) {
		REGISTRY.add(profession);
		return profession;
	}

	@SubscribeEvent
	public static void registerVillagerProfessions(RegistryEvent.Register<VillagerRegistry.VillagerProfession> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new VillagerRegistry.VillagerProfession[0]));
	}
}
<#-- @formatter:on -->
