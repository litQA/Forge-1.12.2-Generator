package ${package}.damage;

import net.minecraft.entity.EntityLivingBase;
import net.minecraft.util.DamageSource;
import net.minecraft.util.text.ITextComponent;
import net.minecraft.util.text.TextComponentTranslation;

public class ${name} {

	public static final DamageSource DAMAGE_SOURCE = new DamageSource("${modid}.${registryname}") {
		@Override public ITextComponent getDeathMessage(EntityLivingBase entity) {
			return new TextComponentTranslation("death.attack.${modid}.${registryname}", entity.getDisplayName());
		}
	};

	static {
		<#if data.effects == "burning">DAMAGE_SOURCE.setFireDamage();</#if>
		<#if data.effects == "magic">DAMAGE_SOURCE.setMagicDamage();</#if>
		<#if data.effects == "explosion">DAMAGE_SOURCE.setExplosion();</#if>
		<#if data.scaling != "never">DAMAGE_SOURCE.setDifficultyScaled();</#if>
	}
}
