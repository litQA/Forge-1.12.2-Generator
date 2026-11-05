<#-- @formatter:off -->
package ${package}.init;

import net.minecraft.entity.*;
import net.minecraft.entity.boss.*;
import net.minecraft.entity.monster.*;
import net.minecraft.entity.passive.*;
import net.minecraft.entity.projectile.*;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.ai.attributes.IAttribute;
import net.minecraft.entity.ai.attributes.RangedAttribute;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraftforge.event.entity.EntityEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;

public class ${JavaModName}Attributes {

	<#list (types.attributes![]) as attribute>
	public static final IAttribute ${attribute.getModElement().getRegistryNameUpper()} =
			new RangedAttribute(null, "attribute.${modid}.${attribute.getModElement().getRegistryName()}",
					${attribute.defaultValue?c}d, ${attribute.minValue?c}d, ${attribute.maxValue?c}d);
	</#list>

	@SubscribeEvent public static void onEntityConstructing(EntityEvent.EntityConstructing event) {
		<#list (types.attributes![]) as attribute>
		if (event.getEntity() instanceof EntityLivingBase) {
			EntityLivingBase living = (EntityLivingBase) event.getEntity();
			<#if attribute.addToAllEntities>
			living.getAttributeMap().registerAttribute(${attribute.getModElement().getRegistryNameUpper()});
			<#else>
			<#if attribute.addToPlayers>
			if (event.getEntity() instanceof EntityPlayer) {
				living.getAttributeMap().registerAttribute(${attribute.getModElement().getRegistryNameUpper()});
			}
			</#if>
			<#if attribute.entities?has_content>
			<#list attribute.entities as entity>
			if (event.getEntity() instanceof ${generator.map(entity.getUnmappedValue(), "entities")}) {
				living.getAttributeMap().registerAttribute(${attribute.getModElement().getRegistryNameUpper()});
			}
			</#list>
			</#if>
			</#if>
		}
		</#list>
	}

}
<#-- @formatter:on -->
