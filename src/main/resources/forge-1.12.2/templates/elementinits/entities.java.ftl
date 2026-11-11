<#-- @formatter:off -->
/*
 *    MCreator note: This file is regenerated on each build.
 *
 *    Forge 1.12.2 entity registration is performed through the entity
 *    registry event. Spawn entries are added during FMLInitializationEvent.
 */
package ${package}.init;

import java.util.ArrayList;
import java.util.List;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityLiving;
import net.minecraft.entity.EnumCreatureType;
import net.minecraft.entity.EntitySpawnPlacementRegistry;
import net.minecraft.util.ResourceLocation;
import net.minecraft.world.biome.Biome;
import net.minecraftforge.event.RegistryEvent;
import net.minecraftforge.common.DungeonHooks;
import net.minecraftforge.fml.common.registry.EntityEntry;
import net.minecraftforge.fml.common.registry.EntityEntryBuilder;
import net.minecraftforge.fml.common.registry.EntityRegistry;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

import ${package}.${JavaModName};

public class ${JavaModName}Entities {

	private static final List<EntityEntry> REGISTRY = new ArrayList<>();
	private static int entityId = 0;

	<#list (types.livingentities![]) as entity>
	public static final EntityEntry ${entity.getModElement().getRegistryNameUpper()} = EntityEntryBuilder.<${package}.entity.${entity.getModElement().getName()}Entity>create()
			.entity(${package}.entity.${entity.getModElement().getName()}Entity.class)
			.id(new ResourceLocation(${JavaModName}.MODID, "${entity.getModElement().getRegistryName()}"), entityId++)
			.name("${entity.getModElement().getRegistryName()}")
			.tracker(${entity.trackingRange}, 3, true)
			<#if entity.hasSpawnEgg>.egg(${entity.spawnEggBaseColor.getRGB()?c}, ${entity.spawnEggDotColor.getRGB()?c})</#if>
			.build();
	<#if entity.hasCustomProjectile()>
	public static final EntityEntry ${entity.getModElement().getRegistryNameUpper()}_PROJECTILE = EntityEntryBuilder.<${package}.entity.${entity.getModElement().getName()}EntityProjectile>create()
			.entity(${package}.entity.${entity.getModElement().getName()}EntityProjectile.class)
			.id(new ResourceLocation(${JavaModName}.MODID, "${entity.getModElement().getRegistryName()}_projectile"), entityId++)
			.name("${entity.getModElement().getRegistryName()}_projectile")
			.tracker(64, 1, true)
			.build();
	</#if>
	</#list>

	<#list (types.projectiles![]) as projectile>
	public static final EntityEntry ${projectile.getModElement().getRegistryNameUpper()} = EntityEntryBuilder.<${package}.entity.${projectile.getModElement().getName()}Entity>create()
			.entity(${package}.entity.${projectile.getModElement().getName()}Entity.class)
			.id(new ResourceLocation(${JavaModName}.MODID, "${projectile.getModElement().getRegistryName()}"), entityId++)
			.name("${projectile.getModElement().getRegistryName()}")
			.tracker(64, 1, true)
			.build();
	</#list>

	<#list (types.specialentities![]) as specialentity>
	public static final EntityEntry ${specialentity.getModElement().getRegistryNameUpper()} = EntityEntryBuilder.<${package}.entity.${specialentity.getModElement().getName()}Entity>create()
			.entity(${package}.entity.${specialentity.getModElement().getName()}Entity.class)
			.id(new ResourceLocation(${JavaModName}.MODID, "${specialentity.getModElement().getRegistryName()}"), entityId++)
			.name("${specialentity.getModElement().getRegistryName()}")
			.tracker(80, 3, true)
			.build();
	</#list>

	static {
		<#list (types.livingentities![]) as entity>
		REGISTRY.add(${entity.getModElement().getRegistryNameUpper()});
		<#if entity.hasCustomProjectile()>
		REGISTRY.add(${entity.getModElement().getRegistryNameUpper()}_PROJECTILE);
		</#if>
		</#list>
		<#list (types.projectiles![]) as projectile>
		REGISTRY.add(${projectile.getModElement().getRegistryNameUpper()});
		</#list>
		<#list (types.specialentities![]) as specialentity>
		REGISTRY.add(${specialentity.getModElement().getRegistryNameUpper()});
		</#list>
	}

	public static void init() {
		<#list (types.livingentities![]) as entity>
		<#if entity.spawnThisMob>
		EntityRegistry.addSpawn(${package}.entity.${entity.getModElement().getName()}Entity.class, ${entity.spawningProbability},
				${entity.minNumberOfMobsPerGroup}, ${entity.maxNumberOfMobsPerGroup},
				<#if entity.mobSpawningType??>${generator.map(entity.mobSpawningType, "mobspawntypes")}<#else>EnumCreatureType.MONSTER</#if>,
				resolveBiomes(<#if entity.restrictionBiomes?has_content><#list w.filterBrokenReferences(entity.restrictionBiomes) as biome>"${biome}"<#sep>, </#sep></#list></#if>));
		EntitySpawnPlacementRegistry.setPlacementType(${package}.entity.${entity.getModElement().getName()}Entity.class,
				<#if entity.mobSpawningType??>
				<#if entity.mobSpawningType?string == "waterCreature" || entity.mobSpawningType?string == "waterAmbient" || entity.mobSpawningType?string == "undergroundWaterCreature">
				EntityLiving.SpawnPlacementType.IN_WATER
				<#elseif entity.mobSpawningType?string == "creature">
				EntityLiving.SpawnPlacementType.ON_GROUND
				<#else>
				EntityLiving.SpawnPlacementType.NO_RESTRICTIONS
				</#if>
				<#else>
				EntityLiving.SpawnPlacementType.ON_GROUND
				</#if>);
		</#if>
		<#if entity.spawnInDungeons>
		DungeonHooks.addDungeonMob(new ResourceLocation(${JavaModName}.MODID, "${entity.getModElement().getRegistryName()}"), 180);
		</#if>
		</#list>
	}

	private static Biome[] resolveBiomes(String... names) {
		List<Biome> biomes = new ArrayList<>();
		for (String name : names) {
			if (name == null || name.isEmpty() || name.startsWith("#"))
				continue;
			Biome biome = Biome.REGISTRY.getObject(new ResourceLocation(name));
			if (biome != null && !biomes.contains(biome))
				biomes.add(biome);
		}

		if (biomes.isEmpty()) {
			for (Biome biome : Biome.REGISTRY)
				biomes.add(biome);
		}

		return biomes.toArray(new Biome[0]);
	}

	@SubscribeEvent public static void registerEntities(RegistryEvent.Register<EntityEntry> event) {
		event.getRegistry().registerAll(REGISTRY.toArray(new EntityEntry[0]));
	}

}
<#-- @formatter:on -->

