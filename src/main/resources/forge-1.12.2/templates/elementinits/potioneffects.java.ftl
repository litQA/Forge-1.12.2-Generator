<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.init;

import net.minecraft.entity.EntityLivingBase;
import net.minecraft.potion.Potion;
import net.minecraft.world.World;
import net.minecraftforge.common.MinecraftForge;
import net.minecraftforge.event.entity.living.LivingDeathEvent;
import net.minecraftforge.event.entity.living.LivingHurtEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.common.registry.ForgeRegistries;

public class ${JavaModName}MobEffects {

	<#list (potioneffects![]) as effect>
	public static final Potion ${effect.getModElement().getRegistryNameUpper()} =
			new ${package}.potion.${effect.getModElement().getName()}MobEffect();
	</#list>

	public static void init() {
		<#list (potioneffects![]) as effect>
		${effect.getModElement().getRegistryNameUpper()}.setRegistryName("${modid}", "${effect.getModElement().getRegistryName()}");
		ForgeRegistries.POTIONS.register(${effect.getModElement().getRegistryNameUpper()});
		</#list>
		MinecraftForge.EVENT_BUS.register(${JavaModName}MobEffects.class);
	}

	<#assign mobHurt = (potioneffects![])?filter(effect -> hasProcedure(effect.onMobHurt))>
	<#if mobHurt?has_content>
	@SubscribeEvent public static void onMobHurt(LivingHurtEvent event) {
		EntityLivingBase entity = event.getEntityLiving();
		<#list mobHurt as effect>
		if (entity.isPotionActive(${effect.getModElement().getRegistryNameUpper()})) {
			int amplifier = entity.getActivePotionEffect(${effect.getModElement().getRegistryNameUpper()}).getAmplifier();
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			World world = entity.world;
			net.minecraft.util.DamageSource damagesource = event.getSource();
			float amount = event.getAmount();
			<@procedureOBJToCode effect.onMobHurt/>
		}
		</#list>
	}
	</#if>

	<#assign mobRemoved = (potioneffects![])?filter(effect -> hasProcedure(effect.onMobRemoved))>
	<#if mobRemoved?has_content>
	@SubscribeEvent public static void onMobRemoved(LivingDeathEvent event) {
		EntityLivingBase entity = event.getEntityLiving();
		<#list mobRemoved as effect>
		if (entity.isPotionActive(${effect.getModElement().getRegistryNameUpper()})) {
			int amplifier = entity.getActivePotionEffect(${effect.getModElement().getRegistryNameUpper()}).getAmplifier();
			double x = entity.posX;
			double y = entity.posY;
			double z = entity.posZ;
			World world = entity.world;
			<@procedureOBJToCode effect.onMobRemoved/>
		}
		</#list>
	}
	</#if>

}
<#-- @formatter:on -->
