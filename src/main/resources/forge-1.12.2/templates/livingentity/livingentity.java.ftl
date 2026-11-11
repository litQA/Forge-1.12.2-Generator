<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
package ${package}.entity;

import java.util.List;
import java.util.Random;
import net.minecraft.block.Block;
import net.minecraft.block.state.IBlockState;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityAgeable;
import net.minecraft.entity.EntityCreature;
import net.minecraft.entity.EntityLiving;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.IEntityLivingData;
import net.minecraft.entity.EnumCreatureAttribute;
import net.minecraft.entity.SharedMonsterAttributes;
import net.minecraft.entity.ai.EntityAIBase;
import net.minecraft.entity.ai.EntityAIAttackMelee;
import net.minecraft.entity.ai.EntityAIAttackRanged;
import net.minecraft.entity.ai.EntityAIHurtByTarget;
import net.minecraft.entity.ai.EntityAIMoveIndoors;
import net.minecraft.entity.ai.EntityAIOpenDoor;
import net.minecraft.entity.ai.EntityAIRestrictSun;
import net.minecraft.entity.ai.EntityAISwimming;
import net.minecraft.entity.ai.EntityAIWander;
import net.minecraft.entity.ai.EntityAIWatchClosest;
import net.minecraft.entity.item.EntityBoat;
import net.minecraft.entity.monster.EntityMob;
import net.minecraft.entity.passive.EntityAnimal;
import net.minecraft.entity.passive.EntityTameable;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.entity.projectile.EntityArrow;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.inventory.EntityEquipmentSlot;
import net.minecraft.item.Item;
import net.minecraft.item.ItemFood;
import net.minecraft.item.ItemMonsterPlacer;
import net.minecraft.item.ItemStack;
import net.minecraft.nbt.NBTTagCompound;
import net.minecraft.network.datasync.DataParameter;
import net.minecraft.network.datasync.DataSerializers;
import net.minecraft.network.datasync.EntityDataManager;
import net.minecraft.pathfinding.PathNavigate;
import net.minecraft.pathfinding.PathNavigateFlying;
import net.minecraft.pathfinding.PathNavigateSwimmer;
import net.minecraft.pathfinding.PathNodeType;
import net.minecraft.util.DamageSource;
import net.minecraft.util.EnumHand;
import net.minecraft.util.ResourceLocation;
import net.minecraft.util.SoundEvent;
import net.minecraft.util.math.AxisAlignedBB;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.math.MathHelper;
import net.minecraft.util.text.TextComponentString;
import net.minecraft.world.DifficultyInstance;
import net.minecraft.world.World;
import net.minecraftforge.common.DungeonHooks;
import net.minecraftforge.event.ForgeEventFactory;
import net.minecraftforge.fml.common.registry.EntityRegistry;
import net.minecraftforge.fml.common.registry.IEntityAdditionalSpawnData;

<#assign extendsClass = "EntityMob">
<#assign humanoidBase = true>
<#if data.tameable>
	<#assign extendsClass = "EntityTameable">
<#elseif data.breedable>
	<#assign extendsClass = "EntityAnimal">
<#elseif data.aiBase != "(none)">
	<#assign extendsClass = "Entity" + data.aiBase>
	<#if data.aiBase == "Bat" || data.aiBase == "Squid" || data.aiBase == "Villager" || data.aiBase == "IronGolem" || data.aiBase == "Slime" || data.aiBase == "MagmaCube" || data.aiBase == "Ghast">
		<#assign humanoidBase = false>
	</#if>
<#elseif data.mobBehaviourType == "Creature">
	<#assign extendsClass = "EntityCreature">
	<#assign humanoidBase = false>
<#elseif data.mobBehaviourType == "Raider">
	<#assign extendsClass = "EntityMob">
</#if>

public class ${name}Entity extends ${extendsClass} <#if data.ranged>implements net.minecraft.entity.IRangedAttackMob</#if> {

	<#list (data.entityDataEntries![]) as entry>
		<#if entry.value().getClass().getSimpleName() == "Integer">
	public static final DataParameter<Integer> DATA_${entry.property().getName()} = EntityDataManager.createKey(${name}Entity.class, DataSerializers.VARINT);
		<#elseif entry.value().getClass().getSimpleName() == "Boolean">
	public static final DataParameter<Boolean> DATA_${entry.property().getName()} = EntityDataManager.createKey(${name}Entity.class, DataSerializers.BOOLEAN);
		<#elseif entry.value().getClass().getSimpleName() == "String">
	public static final DataParameter<String> DATA_${entry.property().getName()} = EntityDataManager.createKey(${name}Entity.class, DataSerializers.STRING);
		</#if>
	</#list>

	<#if data.isBoss>
	private final net.minecraft.world.BossInfoServer bossInfo = new net.minecraft.world.BossInfoServer(
			this.getDisplayName(), net.minecraft.world.BossInfo.Color.${data.bossBarColor},
			net.minecraft.world.BossInfo.Overlay.${data.bossBarType});
	</#if>

	<#assign boundingBoxScaleFixed = "1.0">
	<#if data.boundingBoxScale?? && !hasProcedure(data.boundingBoxScale)>
		<#assign boundingBoxScaleFixed = data.boundingBoxScale.getFixedValue()?c>
	</#if>

	public ${name}Entity(World world) {
		super(world);
		this.setSize((float) (${data.modelWidth} * ${boundingBoxScaleFixed}f), (float) (${data.modelHeight} * ${boundingBoxScaleFixed}f));
		this.stepHeight = ${data.stepHeight}f;
		this.experienceValue = ${data.xpAmount};
		this.isImmuneToFire = ${data.immuneToFire?c};
		this.setNoAI(${(!data.hasAI)?c});

		<#if data.mobLabel?has_content>
		this.setCustomNameTag("${JavaConventions.escapeStringForJava(data.mobLabel)}");
		this.setAlwaysRenderNameTag(true);
		</#if>

		<#if !data.doesDespawnWhenIdle>
		this.enablePersistence();
		</#if>

		<#if !data.equipmentMainHand.isEmpty()>
		this.setItemStackToSlot(EntityEquipmentSlot.MAINHAND, ${mappedMCItemToItemStackCode(data.equipmentMainHand, 1)});
		</#if>
		<#if !data.equipmentOffHand.isEmpty()>
		this.setItemStackToSlot(EntityEquipmentSlot.OFFHAND, ${mappedMCItemToItemStackCode(data.equipmentOffHand, 1)});
		</#if>
		<#if !data.equipmentHelmet.isEmpty()>
		this.setItemStackToSlot(EntityEquipmentSlot.HEAD, ${mappedMCItemToItemStackCode(data.equipmentHelmet, 1)});
		</#if>
		<#if !data.equipmentBody.isEmpty()>
		this.setItemStackToSlot(EntityEquipmentSlot.CHEST, ${mappedMCItemToItemStackCode(data.equipmentBody, 1)});
		</#if>
		<#if !data.equipmentLeggings.isEmpty()>
		this.setItemStackToSlot(EntityEquipmentSlot.LEGS, ${mappedMCItemToItemStackCode(data.equipmentLeggings, 1)});
		</#if>
		<#if !data.equipmentBoots.isEmpty()>
		this.setItemStackToSlot(EntityEquipmentSlot.FEET, ${mappedMCItemToItemStackCode(data.equipmentBoots, 1)});
		</#if>

		<#if data.flyingMob>
		this.moveHelper = new net.minecraft.entity.ai.EntityFlyHelper(this);
		</#if>
		<#if data.waterMob>
		this.setPathPriority(PathNodeType.WATER, 0.0F);
		</#if>
	}

	<#if (data.entityDataEntries![])?has_content>
	@Override protected void entityInit() {
		super.entityInit();
		<#list (data.entityDataEntries![]) as entry>
			<#if entry.value().getClass().getSimpleName() == "String">
		this.dataManager.register(DATA_${entry.property().getName()}, "${JavaConventions.escapeStringForJava(entry.value()?string)}");
			<#else>
		this.dataManager.register(DATA_${entry.property().getName()}, ${entry.value()?c});
			</#if>
		</#list>
	}
	</#if>

	<#if data.flyingMob>
	@Override protected PathNavigate createNavigator(World world) {
		return new PathNavigateFlying(this, world);
	}
	<#elseif data.waterMob>
	@Override protected PathNavigate createNavigator(World world) {
		return new PathNavigateSwimmer(this, world);
	}
	</#if>

	@Override protected void applyEntityAttributes() {
		super.applyEntityAttributes();

		if (this.getEntityAttribute(SharedMonsterAttributes.MAX_HEALTH) != null)
			this.getEntityAttribute(SharedMonsterAttributes.MAX_HEALTH).setBaseValue(${data.health}D);
		if (this.getEntityAttribute(SharedMonsterAttributes.MOVEMENT_SPEED) != null)
			this.getEntityAttribute(SharedMonsterAttributes.MOVEMENT_SPEED).setBaseValue(${data.movementSpeed}D);
		if (this.getEntityAttribute(SharedMonsterAttributes.ARMOR) != null)
			this.getEntityAttribute(SharedMonsterAttributes.ARMOR).setBaseValue(${data.armorBaseValue}D);
		if (this.getEntityAttribute(SharedMonsterAttributes.FOLLOW_RANGE) != null)
			this.getEntityAttribute(SharedMonsterAttributes.FOLLOW_RANGE).setBaseValue(${data.followRange}D);
		if (this.getEntityAttribute(SharedMonsterAttributes.KNOCKBACK_RESISTANCE) == null)
			this.getAttributeMap().registerAttribute(SharedMonsterAttributes.KNOCKBACK_RESISTANCE);
		this.getEntityAttribute(SharedMonsterAttributes.KNOCKBACK_RESISTANCE).setBaseValue(${data.knockbackResistance}D);

		if (this.getEntityAttribute(SharedMonsterAttributes.ATTACK_DAMAGE) == null)
			this.getAttributeMap().registerAttribute(SharedMonsterAttributes.ATTACK_DAMAGE);
		this.getEntityAttribute(SharedMonsterAttributes.ATTACK_DAMAGE).setBaseValue(${data.attackStrength}D);

		<#if data.flyingMob>
		if (this.getEntityAttribute(SharedMonsterAttributes.FLYING_SPEED) == null)
			this.getAttributeMap().registerAttribute(SharedMonsterAttributes.FLYING_SPEED);
		this.getEntityAttribute(SharedMonsterAttributes.FLYING_SPEED).setBaseValue(${data.movementSpeed}D);
		</#if>
	}

	<#if data.hasAI>
	@Override protected void initEntityAI() {
		super.initEntityAI();

		<#if aiblocks?? && (aiblocks?seq_contains("doors_open") || aiblocks?seq_contains("doors_close"))>
		this.getNavigator().getNodeProcessor().setCanOpenDoors(true);
		</#if>
		<#if aicode?? && aicode?has_content>
		${aicode}
		</#if>

		<#if data.ranged>
		this.tasks.addTask(1, new EntityAIAttackRanged(this, 1.25D, ${data.rangedAttackInterval}, ${data.rangedAttackRadius?c}F) {
			@Override public boolean shouldContinueExecuting() {
				return this.shouldExecute();
			}
		});
		</#if>
	}
	</#if>

	@Override public EnumCreatureAttribute getCreatureAttribute() {
		<#if data.mobCreatureType?string == "WATER">
		return EnumCreatureAttribute.UNDEFINED;
		<#else>
		return EnumCreatureAttribute.${data.mobCreatureType};
		</#if>
	}

	<#if !data.doesDespawnWhenIdle>
	@Override public boolean canDespawn() {
		return false;
	}
	</#if>

	<#if data.mobModelName == "Biped">
	@Override public double getYOffset() {
		return -0.35D;
	}
	<#elseif data.mobModelName == "Silverfish">
	@Override public double getYOffset() {
		return 0.1D;
	}
	</#if>

	<#if data.mountedYOffset != 0>
	@Override public double getMountedYOffset() {
		return super.getMountedYOffset() + ${data.mountedYOffset?c};
	}
	</#if>

	<#if data.hasDrop()>
	@Override protected Item getDropItem() {
		return ${mappedMCItemToItem(data.mobDrop)};
	}
	</#if>

	<#if data.livingSound?has_content && data.livingSound.getUnmappedValue()?has_content>
	@Override public SoundEvent getAmbientSound() {
		return SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.livingSound.getUnmappedValue()}"));
	}
	</#if>

	<#if data.stepSound?has_content && data.stepSound.getUnmappedValue()?has_content>
	@Override public void playStepSound(BlockPos pos, Block block) {
		this.playSound(SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.stepSound.getUnmappedValue()}")), 0.15F, 1.0F);
	}
	</#if>

	<#if data.hurtSound?has_content && data.hurtSound.getUnmappedValue()?has_content>
	@Override public SoundEvent getHurtSound(DamageSource source) {
		return SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.hurtSound.getUnmappedValue()}"));
	}
	</#if>

	<#if data.deathSound?has_content && data.deathSound.getUnmappedValue()?has_content>
	@Override public SoundEvent getDeathSound() {
		return SoundEvent.REGISTRY.getObject(new ResourceLocation("${data.deathSound.getUnmappedValue()}"));
	}
	</#if>

	<#if hasProcedure(data.onStruckByLightning)>
	@Override public void onStruckByLightning(net.minecraft.entity.effect.EntityLightningBolt lightningBolt) {
		super.onStruckByLightning(lightningBolt);
		<@procedureCode data.onStruckByLightning, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.whenMobFalls) || data.flyingMob>
	@Override public void fall(float distance, float damageMultiplier) {
		<#if !data.flyingMob>
		super.fall(distance, damageMultiplier);
		</#if>
		<#if hasProcedure(data.whenMobFalls)>
		<@procedureCode data.whenMobFalls, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"world": "this.world",
			"damagesource": "this.getLastDamageSource()"
		}/>
		</#if>
	}
	</#if>

	<#if hasProcedure(data.whenMobIsHurt) || data.immuneToArrows || data.immuneToFallDamage
		|| data.immuneToCactus || data.immuneToDrowning || data.immuneToLightning || data.immuneToPotions
		|| data.immuneToPlayer || data.immuneToExplosion || data.immuneToAnvil || data.immuneToWither
		|| data.immuneToDragonBreath>
	@Override public boolean attackEntityFrom(DamageSource source, float amount) {
		<#if hasProcedure(data.whenMobIsHurt)>
		<#if hasReturnValueOf(data.whenMobIsHurt, "logic")>
		if (<@procedureOBJToConditionCode data.whenMobIsHurt/>)
			return false;
		<#else>
		<@procedureOBJToCode data.whenMobIsHurt/>
		</#if>
		</#if>
		<#if data.immuneToArrows>
		if (source.getImmediateSource() instanceof EntityArrow)
			return false;
		</#if>
		<#if data.immuneToPlayer>
		if (source.getImmediateSource() instanceof EntityPlayer)
			return false;
		</#if>
		<#if data.immuneToPotions>
		if (source.getImmediateSource() instanceof net.minecraft.entity.projectile.EntityPotion
				|| source.getImmediateSource() instanceof net.minecraft.entity.EntityAreaEffectCloud)
			return false;
		</#if>
		<#if data.immuneToFallDamage>
		if (source == DamageSource.FALL)
			return false;
		</#if>
		<#if data.immuneToCactus>
		if (source == DamageSource.CACTUS)
			return false;
		</#if>
		<#if data.immuneToDrowning>
		if (source == DamageSource.DROWN)
			return false;
		</#if>
		<#if data.immuneToLightning>
		if (source == DamageSource.LIGHTNING_BOLT)
			return false;
		</#if>
		<#if data.immuneToExplosion>
		if (source.isExplosion())
			return false;
		</#if>
		<#if data.immuneToAnvil>
		if (source == DamageSource.ANVIL)
			return false;
		</#if>
		<#if data.immuneToDragonBreath>
		if (source == DamageSource.DRAGON_BREATH)
			return false;
		</#if>
		<#if data.immuneToWither>
		if (source == DamageSource.WITHER || (source.getDamageType().equals("mob")
				&& source.getImmediateSource() instanceof net.minecraft.entity.projectile.EntityWitherSkull))
			return false;
		</#if>
		return super.attackEntityFrom(source, amount);
	}
	</#if>

	<#if data.immuneToExplosion>
	@Override public boolean isImmuneToExplosions() {
		return true;
	}
	</#if>

	<#if hasProcedure(data.whenMobDies)>
	@Override public void onDeath(DamageSource source) {
		super.onDeath(source);
		<@procedureCode data.whenMobDies, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"sourceentity": "source.getTrueSource()",
			"immediatesourceentity": "source.getImmediateSource()",
			"entity": "this",
			"world": "this.world",
			"damagesource": "source"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onInitialSpawn)>
	@Override public IEntityLivingData onInitialSpawn(DifficultyInstance difficulty, IEntityLivingData livingdata) {
		IEntityLivingData retval = super.onInitialSpawn(difficulty, livingdata);
		<@procedureCode data.onInitialSpawn, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"world": "this.world",
			"entity": "this"
		}/>
		return retval;
	}
	</#if>

	<#if hasProcedure(data.onRightClickedOn) || data.ridable || (data.tameable && data.breedable)>
	@Override public boolean processInteract(EntityPlayer sourceentity, EnumHand hand) {
		ItemStack itemstack = sourceentity.getHeldItem(hand);

		<#if (data.tameable && data.breedable)>
		Item item = itemstack.getItem();
		if (itemstack.getItem() instanceof ItemMonsterPlacer) {
			return super.processInteract(sourceentity, hand);
		} else if (this.world.isRemote) {
			return (this.isTamed() && this.isOwner(sourceentity) || this.isBreedingItem(itemstack))
					|| super.processInteract(sourceentity, hand);
		} else {
			if (this.isTamed()) {
				if (this.isOwner(sourceentity)) {
					if (item.isFood() && this.isBreedingItem(itemstack) && this.getHealth() < this.getMaxHealth()) {
						this.consumeItemFromStack(sourceentity, itemstack);
						this.heal((float) item.getFood().getHealing());
						return true;
					} else if (this.isBreedingItem(itemstack) && this.getHealth() < this.getMaxHealth()) {
						this.consumeItemFromStack(sourceentity, itemstack);
						this.heal(4);
						return true;
					}
					return super.processInteract(sourceentity, hand);
				}
			} else if (this.isBreedingItem(itemstack)) {
				this.consumeItemFromStack(sourceentity, itemstack);
				if (this.rand.nextInt(3) == 0 && !ForgeEventFactory.onAnimalTame(this, sourceentity)) {
					this.setTamedBy(sourceentity);
					this.world.setEntityState(this, (byte) 7);
				} else {
					this.world.setEntityState(this, (byte) 6);
				}
				this.enablePersistence();
				return true;
			}
			return super.processInteract(sourceentity, hand);
		}
		<#else>
		super.processInteract(sourceentity, hand);
		</#if>

		<#if data.ridable>
		sourceentity.startRiding(this);
		</#if>

		<#if hasProcedure(data.onRightClickedOn)>
		<#if hasReturnValueOf(data.onRightClickedOn, "actionresulttype")>
		return <@procedureOBJToInteractionResultCode data.onRightClickedOn/> != net.minecraft.util.EnumActionResult.FAIL;
		<#else>
		<@procedureOBJToCode data.onRightClickedOn/>
		return true;
		</#if>
		<#else>
		return true;
		</#if>
	}
	</#if>

	<#if hasProcedure(data.whenThisMobKillsAnother)>
	@Override public void onKillEntity(EntityLivingBase entity) {
		super.onKillEntity(entity);
		<@procedureCode data.whenThisMobKillsAnother, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "entity",
			"sourceentity": "this",
			"immediatesourceentity": "entity.getLastDamageSource().getImmediateSource()",
			"world": "this.world",
			"damagesource": "entity.getLastDamageSource()"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onMobTickUpdate)>
	@Override public void onEntityUpdate() {
		super.onEntityUpdate();
		<@procedureCode data.onMobTickUpdate, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onPlayerCollidesWith)>
	@Override public void onCollideWithPlayer(EntityPlayer sourceentity) {
		super.onCollideWithPlayer(sourceentity);
		<@procedureCode data.onPlayerCollidesWith, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"sourceentity": "sourceentity",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if data.ranged>
	@Override public void setSwingingArms(boolean swingingArms) {
	}

	@Override public void attackEntityWithRangedAttack(EntityLivingBase target, float distanceFactor) {
		<#if data.rangedItemType == "Default item">
			<#if data.hasCustomProjectile()>
		${name}EntityProjectile projectile = new ${name}EntityProjectile(this, this.world);
			<#else>
		EntityArrow projectile = new EntityArrow(this.world, this);
			</#if>
		double d0 = target.posY + target.getEyeHeight() - 1.1D;
		double d1 = target.posX - this.posX;
		double d3 = target.posZ - this.posZ;
		projectile.shoot(d1, d0 - projectile.posY + MathHelper.sqrt(d1 * d1 + d3 * d3) * 0.2F, d3, 1.6F, 12.0F);
		this.world.spawnEntity(projectile);
		<#elseif data.rangedItemType?has_content>
		${data.rangedItemType}Entity.shoot(this, target);
		</#if>
	}
	</#if>

	<#if data.breedable || data.tameable>
	@Override public ${extendsClass} createChild(EntityAgeable ageable) {
		${name}Entity child = new ${name}Entity(this.world);
		child.onInitialSpawn(this.world.getDifficultyForLocation(child.getPosition()), null);
		return child;
	}

	@Override public boolean isBreedingItem(ItemStack stack) {
		if (stack.isEmpty())
			return false;
		<#list (data.breedTriggerItems![]) as breedTriggerItem>
			<#if hasMetadata(breedTriggerItem)>
		if (${mappedMCItemToItemStackCode(breedTriggerItem, 1)}.getItem() == stack.getItem()
				&& ${mappedMCItemToItemStackCode(breedTriggerItem, 1)}.getMetadata() == stack.getMetadata())
			return true;
			<#else>
		if (${mappedMCItemToItemStackCode(breedTriggerItem, 1)}.getItem() == stack.getItem())
			return true;
			</#if>
		</#list>
		return false;
	}
	</#if>

	<#if data.waterMob>
	@Override public boolean isNotColliding() {
		return this.world.checkNoEntityCollision(this.getEntityBoundingBox(), this)
				&& this.world.getCollisionBoxes(this, this.getEntityBoundingBox()).isEmpty();
	}
	</#if>

	<#if data.breatheUnderwater?? && (hasProcedure(data.breatheUnderwater) || data.breatheUnderwater.getFixedValue())>
	@Override public boolean canBreatheUnderwater() {
		return <@procedureOBJToConditionCode data.breatheUnderwater/>;
	}
	</#if>

	<#if data.pushedByFluids?? && (hasProcedure(data.pushedByFluids) || !data.pushedByFluids.getFixedValue())>
	@Override public boolean isPushedByWater() {
		<#if hasProcedure(data.pushedByFluids)>
		return <@procedureOBJToConditionCode data.pushedByFluids/>;
		<#else>
		return ${data.pushedByFluids.getFixedValue()?c};
		</#if>
	}
	</#if>

	<#if data.disableCollisions>
	@Override public boolean canBePushed() {
		return false;
	}

	@Override public boolean canBeCollidedWith() {
		return false;
	}
	</#if>

	<#if data.solidBoundingBox?? && (hasProcedure(data.solidBoundingBox) || data.solidBoundingBox.getFixedValue())>
	@Override public AxisAlignedBB getCollisionBox(Entity entity) {
		return entity.getEntityBoundingBox();
	}

	@Override public AxisAlignedBB getCollisionBoundingBox() {
		return <@procedureOBJToConditionCode data.solidBoundingBox/> ? this.getEntityBoundingBox() : null;
	}
	</#if>

	<#if data.isBoss>
	@Override public boolean isNonBoss() {
		return false;
	}

	@Override public void addTrackingPlayer(EntityPlayerMP player) {
		super.addTrackingPlayer(player);
		this.bossInfo.addPlayer(player);
	}

	@Override public void removeTrackingPlayer(EntityPlayerMP player) {
		super.removeTrackingPlayer(player);
		this.bossInfo.removePlayer(player);
	}

	@Override public void updateAITasks() {
		super.updateAITasks();
		this.bossInfo.setPercent(this.getHealth() / this.getMaxHealth());
	}
	</#if>

	<#if data.ridable && (data.canControlForward || data.canControlStrafe)>
	@Override public void travel(float strafe, float vertical, float forward) {
		Entity passenger = this.getPassengers().isEmpty() ? null : this.getPassengers().get(0);
		if (this.isBeingRidden() && passenger != null) {
			this.rotationYaw = passenger.rotationYaw;
			this.prevRotationYaw = this.rotationYaw;
			this.rotationPitch = passenger.rotationPitch * 0.5F;
			this.setRotation(this.rotationYaw, this.rotationPitch);
			this.jumpMovementFactor = this.getAIMoveSpeed() * 0.15F;
			this.renderYawOffset = passenger.rotationYaw;
			this.rotationYawHead = passenger.rotationYaw;

			if (passenger instanceof EntityLivingBase) {
				this.setAIMoveSpeed((float) this.getEntityAttribute(SharedMonsterAttributes.MOVEMENT_SPEED).getAttributeValue());
				<#if data.canControlForward>
				float moveForward = ((EntityLivingBase) passenger).moveForward;
				<#else>
				float moveForward = 0;
				</#if>
				<#if data.canControlStrafe>
				float moveStrafe = ((EntityLivingBase) passenger).moveStrafing;
				<#else>
				float moveStrafe = 0;
				</#if>
				super.travel(moveStrafe, 0, moveForward);
			}

			this.prevLimbSwingAmount = this.limbSwingAmount;
			double dx = this.posX - this.prevPosX;
			double dz = this.posZ - this.prevPosZ;
			float f1 = (float) MathHelper.sqrt(dx * dx + dz * dz) * 4.0F;
			if (f1 > 1.0F) f1 = 1.0F;
			this.limbSwingAmount += (f1 - this.limbSwingAmount) * 0.4F;
			this.limbSwing += this.limbSwingAmount;
			return;
		}
		this.jumpMovementFactor = 0.02F;
		super.travel(strafe, vertical, forward);
	}
	</#if>

	<#if data.flyingMob>
	@Override protected void updateFallState(double y, boolean onGroundIn, IBlockState state, BlockPos pos) {
	}

	@Override public void setNoGravity(boolean ignored) {
		super.setNoGravity(true);
	}

	@Override public void onLivingUpdate() {
		super.onLivingUpdate();
		this.setNoGravity(true);
	}
	</#if>

	<#if data.spawnThisMob>
	@Override public boolean getCanSpawnHere() {
			<#if hasProcedure(data.spawningCondition)>
		int x = MathHelper.floor(this.posX);
		int y = MathHelper.floor(this.getEntityBoundingBox().minY);
		int z = MathHelper.floor(this.posZ);
		return <@procedureOBJToConditionCode data.spawningCondition/>;
			<#elseif data.mobSpawningType?string == "waterCreature" || data.mobSpawningType?string == "waterAmbient" || data.mobSpawningType?string == "undergroundWaterCreature">
		return this.posY > 45.0D && this.posY < (double) this.world.getSeaLevel() && super.getCanSpawnHere();
			<#elseif data.mobSpawningType?string == "creature">
		int i = MathHelper.floor(this.posX);
		int j = MathHelper.floor(this.getEntityBoundingBox().minY);
		int k = MathHelper.floor(this.posZ);
		BlockPos blockpos = new BlockPos(i, j, k);
		return this.world.getBlockState(blockpos.down()).getBlock() == Blocks.GRASS
				&& this.world.getLight(blockpos) > 8 && super.getCanSpawnHere();
			<#elseif extendsClass == "EntityMob">
		return this.world.getDifficulty() != net.minecraft.world.EnumDifficulty.PEACEFUL
				&& this.isValidLightLevel() && super.getCanSpawnHere();
			<#else>
		return super.getCanSpawnHere();
			</#if>
	}
	</#if>

	<#if (data.entityDataEntries![])?has_content>
	@Override public void writeEntityToNBT(NBTTagCompound compound) {
		super.writeEntityToNBT(compound);
		<#list (data.entityDataEntries![]) as entry>
			<#if entry.value().getClass().getSimpleName() == "Integer">
		compound.setInteger("Data${entry.property().getName()}", this.dataManager.get(DATA_${entry.property().getName()}));
			<#elseif entry.value().getClass().getSimpleName() == "Boolean">
		compound.setBoolean("Data${entry.property().getName()}", this.dataManager.get(DATA_${entry.property().getName()}));
			<#elseif entry.value().getClass().getSimpleName() == "String">
		compound.setString("Data${entry.property().getName()}", this.dataManager.get(DATA_${entry.property().getName()}));
			</#if>
		</#list>
	}

	@Override public void readEntityFromNBT(NBTTagCompound compound) {
		super.readEntityFromNBT(compound);
		<#list (data.entityDataEntries![]) as entry>
		if (compound.hasKey("Data${entry.property().getName()}"))
			<#if entry.value().getClass().getSimpleName() == "Integer">
			this.dataManager.set(DATA_${entry.property().getName()}, compound.getInteger("Data${entry.property().getName()}"));
			<#elseif entry.value().getClass().getSimpleName() == "Boolean">
			this.dataManager.set(DATA_${entry.property().getName()}, compound.getBoolean("Data${entry.property().getName()}"));
			<#elseif entry.value().getClass().getSimpleName() == "String">
			this.dataManager.set(DATA_${entry.property().getName()}, compound.getString("Data${entry.property().getName()}"));
			</#if>
		</#list>
	}
	</#if>

	<#list (data.entityDataEntries![]) as entry>
	<#if entry.value().getClass().getSimpleName() == "Integer">
	public int getData${entry.property().getName()}() {
		return this.dataManager.get(DATA_${entry.property().getName()});
	}

	public void setData${entry.property().getName()}(int value) {
		this.dataManager.set(DATA_${entry.property().getName()}, value);
	}
	<#elseif entry.value().getClass().getSimpleName() == "Boolean">
	public boolean getData${entry.property().getName()}() {
		return this.dataManager.get(DATA_${entry.property().getName()});
	}

	public void setData${entry.property().getName()}(boolean value) {
		this.dataManager.set(DATA_${entry.property().getName()}, value);
	}
	<#elseif entry.value().getClass().getSimpleName() == "String">
	public String getData${entry.property().getName()}() {
		return this.dataManager.get(DATA_${entry.property().getName()});
	}

	public void setData${entry.property().getName()}(String value) {
		this.dataManager.set(DATA_${entry.property().getName()}, value);
	}
	</#if>
	</#list>

}
<#-- @formatter:on -->
