<#-- @formatter:off -->
package ${package}.procedures;

import java.util.Map;

import net.minecraft.advancements.Advancement;
import net.minecraft.advancements.AdvancementProgress;
import net.minecraft.block.Block;
import net.minecraft.block.material.Material;
import net.minecraft.block.properties.IProperty;
import net.minecraft.block.properties.PropertyDirection;
import net.minecraft.block.properties.PropertyEnum;
import net.minecraft.block.properties.PropertyInteger;
import net.minecraft.block.state.IBlockState;
import net.minecraft.client.Minecraft;
import net.minecraft.client.network.NetworkPlayerInfo;
import net.minecraft.enchantment.Enchantment;
import net.minecraft.enchantment.EnchantmentHelper;
import net.minecraft.init.Enchantments;
import net.minecraft.entity.Entity;
import net.minecraft.entity.IProjectile;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.SharedMonsterAttributes;
import net.minecraft.entity.ai.attributes.AttributeModifier;
import net.minecraft.entity.item.EntityItem;
import net.minecraft.entity.item.EntityXPOrb;
import net.minecraft.entity.monster.EntityZombie;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.entity.projectile.EntityArrow;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.init.MobEffects;
import net.minecraft.inventory.EntityEquipmentSlot;
import net.minecraft.item.Item;
import net.minecraft.item.ItemFood;
import net.minecraft.item.ItemStack;
import net.minecraft.item.crafting.FurnaceRecipes;
import net.minecraft.nbt.NBTTagCompound;
import net.minecraft.potion.PotionEffect;
import net.minecraft.util.FoodStats;
import net.minecraft.util.math.MathHelper;
import net.minecraft.util.DamageSource;
import net.minecraft.util.EnumActionResult;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.EnumHand;
import net.minecraft.util.EnumParticleTypes;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.text.TextComponentString;
import net.minecraft.util.text.TextComponentTranslation;
import net.minecraft.util.text.ITextComponent;
import net.minecraft.command.ICommandSender;
import net.minecraft.server.MinecraftServer;
import net.minecraft.util.math.AxisAlignedBB;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.math.RayTraceResult;
import net.minecraft.util.math.Vec3d;
import net.minecraft.world.GameType;
import net.minecraft.world.World;
import net.minecraft.world.WorldServer;
import net.minecraftforge.oredict.OreDictionary;
import net.minecraftforge.fml.common.ObfuscationReflectionHelper;
import net.minecraftforge.fml.common.registry.ForgeRegistries;

import net.minecraftforge.event.world.*;
import net.minecraftforge.event.entity.*;
import net.minecraftforge.event.entity.living.*;
import net.minecraftforge.event.entity.player.*;
import net.minecraftforge.event.terraingen.*;
import net.minecraftforge.fml.common.event.*;
import net.minecraftforge.fml.common.gameevent.*;
import net.minecraftforge.fml.common.eventhandler.*;
import net.minecraftforge.fml.common.eventhandler.Event;
import net.minecraftforge.fml.common.network.simpleimpl.*;
import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.fml.relauncher.*;
import net.minecraftforge.event.CommandEvent;
import net.minecraftforge.event.ServerChatEvent;

import net.minecraftforge.event.entity.living.AnimalTameEvent;
import net.minecraftforge.event.entity.living.LivingAttackEvent;
import net.minecraftforge.event.entity.living.LivingDeathEvent;
import net.minecraftforge.event.entity.living.LivingDestroyBlockEvent;
import net.minecraftforge.event.entity.living.LivingEntityUseItemEvent;
import net.minecraftforge.event.entity.living.LivingEquipmentChangeEvent;
import net.minecraftforge.event.entity.living.LivingEvent;
import net.minecraftforge.event.entity.living.LivingExperienceDropEvent;
import net.minecraftforge.event.entity.living.LivingFallEvent;
import net.minecraftforge.event.entity.living.LivingHealEvent;
import net.minecraftforge.event.entity.living.LivingHurtEvent;
import net.minecraftforge.event.entity.living.LivingSetAttackTargetEvent;
import net.minecraftforge.event.entity.EntityJoinWorldEvent;
import net.minecraftforge.event.entity.EntityMobGriefingEvent;
import net.minecraftforge.event.entity.EntityStruckByLightningEvent;
import net.minecraftforge.event.entity.EntityTravelToDimensionEvent;
import net.minecraftforge.event.entity.item.ItemExpireEvent;
import net.minecraftforge.event.entity.item.ItemTossEvent;
import net.minecraftforge.event.entity.player.AdvancementEvent;
import net.minecraftforge.event.entity.player.BonemealEvent;
import net.minecraftforge.event.entity.player.CriticalHitEvent;
import net.minecraftforge.event.entity.player.EntityItemPickupEvent;
import net.minecraftforge.event.entity.player.FillBucketEvent;
import net.minecraftforge.event.entity.player.ItemFishedEvent;
import net.minecraftforge.event.entity.player.PlayerDestroyItemEvent;
import net.minecraftforge.event.entity.player.PlayerInteractEvent;
import net.minecraftforge.event.entity.player.PlayerPickupXpEvent;
import net.minecraftforge.event.entity.player.PlayerSleepInBedEvent;
import net.minecraftforge.event.entity.player.PlayerWakeUpEvent;
import net.minecraftforge.event.entity.player.UseHoeEvent;
import net.minecraftforge.event.terraingen.SaplingGrowTreeEvent;
import net.minecraftforge.event.village.VillageSiegeEvent;
import net.minecraftforge.event.world.BlockEvent;
import net.minecraftforge.event.world.ExplosionEvent;
import net.minecraftforge.event.world.WorldEvent;
import net.minecraftforge.fml.common.event.FMLInitializationEvent;
import net.minecraftforge.fml.common.eventhandler.SubscribeEvent;
import net.minecraftforge.fml.common.gameevent.TickEvent;
import net.minecraftforge.fml.common.network.simpleimpl.IMessage;
import net.minecraftforge.fml.common.network.simpleimpl.IMessageHandler;
import net.minecraftforge.fml.common.network.simpleimpl.MessageContext;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;
import io.netty.buffer.ByteBuf;

<#if trigger_code?has_content>
${trigger_code}
<#else>
public class ${name}Procedure {

	public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> execute(
			<#list dependencies as dependency>${dependency.getType(generator.getWorkspace())} ${dependency.getName()}<#sep>, </#list>) {
</#if>
<#if trigger_code?has_content>
	public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> execute(
			<#list dependencies as dependency>${dependency.getType(generator.getWorkspace())} ${dependency.getName()}<#sep>, </#list>) {
		<#if return_type??>return </#if>execute(null<#if dependencies?has_content>,</#if><#list dependencies as dependency>${dependency.getName()}<#sep>, </#list>);
	}

	private static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> execute(net.minecraftforge.fml.common.eventhandler.Event event<#if dependencies?has_content>,</#if>
			<#list dependencies as dependency>${dependency.getType(generator.getWorkspace())} ${dependency.getName()}<#sep>, </#list>) {
</#if>

		<#list localvariables as var>
		<@var.getType().getScopeDefinition(generator.getWorkspace(), "LOCAL")['init']?interpret/>
		</#list>

		${procedurecode}
		${additional_code}
	}

	<#if trigger_code?has_content>
	public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> executeProcedure(Map<String, Object> dependencies) {
		if (dependencies == null) {
			System.err.println("Procedure ${name} called without dependencies");
			return<#if return_type??> <#if return_type.getJavaType(generator.getWorkspace()) == "boolean">false<#else>${return_type.getDefaultValue(generator.getWorkspace())}</#if></#if>;
		}
		<#list dependencies as dependency>
		if (dependencies.get("${dependency.getName()}") == null) {
			System.err.println("Failed to load dependency ${dependency.getName()} for procedure ${name}");
			return<#if return_type??> <#if return_type.getJavaType(generator.getWorkspace()) == "boolean">false<#else>${return_type.getDefaultValue(generator.getWorkspace())}</#if></#if>;
		}
		</#list>
		<#if return_type??>return </#if>execute(<#list dependencies as dependency>(${dependency.getType(generator.getWorkspace())}) dependencies.get("${dependency.getName()}")<#sep>, </#list>);
	}
	<#else>
	public static <#if return_type??>${return_type.getJavaType(generator.getWorkspace())}<#else>void</#if> executeProcedure(Map<String, Object> dependencies) {
		if (dependencies == null) {
			System.err.println("Procedure ${name} called without dependencies");
			return<#if return_type??><#if return_type.getJavaType(generator.getWorkspace()) == "boolean"> false<#else> ${return_type.getDefaultValue(generator.getWorkspace())}</#if></#if>;
		}

		<#list dependencies as dependency>
		if (dependencies.get("${dependency.getName()}") == null) {
			System.err.println("Failed to load dependency ${dependency.getName()} for procedure ${name}");
			return<#if return_type??><#if return_type.getJavaType(generator.getWorkspace()) == "boolean"> false<#else> ${return_type.getDefaultValue(generator.getWorkspace())}</#if></#if>;
		}
		</#list>

		<#if return_type??>return </#if>execute(<#list dependencies as dependency>(${dependency.getType(generator.getWorkspace())}) dependencies.get("${dependency.getName()}")<#sep>, </#list>);
	}
	</#if>

	private static EntityEquipmentSlot getEquipmentSlot(int slot) {
		switch (slot) {
			case 0: return EntityEquipmentSlot.FEET;
			case 1: return EntityEquipmentSlot.LEGS;
			case 2: return EntityEquipmentSlot.CHEST;
			case 3: return EntityEquipmentSlot.HEAD;
			default: return EntityEquipmentSlot.MAINHAND;
		}
	}

	private static boolean isBlockInOreDictionary(String tag, Block block) {
		for (ItemStack stack : OreDictionary.getOres(tag)) {
			if (Block.getBlockFromItem(stack.getItem()) == block) {
				return true;
			}
		}
		return false;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static IBlockState withEnumProperty(IBlockState state, String property, String value) {
		IProperty _property = state.getBlock().getBlockState().getProperty(property);
		if (_property instanceof net.minecraft.block.properties.PropertyEnum) {
			com.google.common.base.Optional<?> _value = ((net.minecraft.block.properties.PropertyEnum) _property).parseValue(value);
			if (_value.isPresent()) {
				return state.withProperty(_property, (Comparable) _value.get());
			}
		}
		return state;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private static IBlockState withIntegerProperty(IBlockState state, String property, int value) {
		IProperty _property = state.getBlock().getBlockState().getProperty(property);
		if (_property instanceof net.minecraft.block.properties.PropertyInteger) {
			return state.withProperty((net.minecraft.block.properties.PropertyInteger) _property, value);
		}
		return state;
	}

	${extra_templates_code}
}
<#-- @formatter:on -->
