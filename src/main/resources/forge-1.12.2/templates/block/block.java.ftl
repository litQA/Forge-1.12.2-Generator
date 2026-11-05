<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#include "/procedures.ftl">
<#assign blockBase = data.blockBase!"">
<#assign customProps = data.customProperties![]>
<#assign customBool = []>
<#if customProps?has_content && customProps[0].value()?is_boolean>
    <#assign customBool = [customProps[0]]>
</#if>
package ${package}.block;

import net.minecraft.block.Block;
import net.minecraft.block.BlockFence;
import net.minecraft.block.BlockStairs;
import net.minecraft.block.BlockWall;
import net.minecraft.block.SoundType;
import net.minecraft.block.material.MapColor;
import net.minecraft.block.material.Material;
import net.minecraft.block.properties.PropertyBool;
import net.minecraft.block.properties.PropertyEnum;
import net.minecraft.block.state.BlockStateContainer;
import net.minecraft.block.state.IBlockState;
import net.minecraft.entity.Entity;
import net.minecraft.entity.EntityLivingBase;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.init.Blocks;
import net.minecraft.init.Items;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.util.EnumFacing;
import net.minecraft.util.EnumHand;
import net.minecraft.util.IStringSerializable;
import net.minecraft.util.NonNullList;
import net.minecraft.util.math.AxisAlignedBB;
import net.minecraft.util.math.BlockPos;
import net.minecraft.world.IBlockAccess;
import net.minecraft.world.World;
import net.minecraftforge.fml.relauncher.Side;
import net.minecraftforge.fml.relauncher.SideOnly;

<#if blockBase == "Stairs">
public class ${name}Block extends BlockStairs {

	public ${name}Block() {
		super(Blocks.STONE.getDefaultState());
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
	}
<#elseif blockBase == "Fence">
public class ${name}Block extends BlockFence {

	public ${name}Block() {
		super(Material.WOOD, MapColor.WOOD);
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
	}
<#elseif blockBase == "Wall">
public class ${name}Block extends BlockWall {

	public ${name}Block() {
		super(Blocks.COBBLESTONE);
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
	}
<#elseif blockBase == "Slab">
public class ${name}Block extends Block {

	public static final PropertyEnum<SlabPart> HALF = PropertyEnum.create("half", SlabPart.class);
	private static final AxisAlignedBB BOTTOM_AABB = new AxisAlignedBB(0.0D, 0.0D, 0.0D, 1.0D, 0.5D, 1.0D);
	private static final AxisAlignedBB TOP_AABB = new AxisAlignedBB(0.0D, 0.5D, 0.0D, 1.0D, 1.0D, 1.0D);
	private static final AxisAlignedBB FULL_AABB = new AxisAlignedBB(0.0D, 0.0D, 0.0D, 1.0D, 1.0D, 1.0D);

	public ${name}Block() {
		super(Material.ROCK);
		setDefaultState(this.blockState.getBaseState().withProperty(HALF, SlabPart.BOTTOM));
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
	}

	@Override protected BlockStateContainer createBlockState() {
		return new BlockStateContainer(this, HALF);
	}

	@Override public IBlockState getStateFromMeta(int meta) {
		return getDefaultState().withProperty(HALF, SlabPart.values()[meta % 3]);
	}

	@Override public int getMetaFromState(IBlockState state) {
		return state.getValue(HALF).ordinal();
	}

	@Override public AxisAlignedBB getBoundingBox(IBlockState state, IBlockAccess world, BlockPos pos) {
		SlabPart part = state.getValue(HALF);
		return part == SlabPart.DOUBLE ? FULL_AABB : (part == SlabPart.TOP ? TOP_AABB : BOTTOM_AABB);
	}

	@Override public AxisAlignedBB getCollisionBoundingBox(IBlockState state, IBlockAccess world, BlockPos pos) {
		return getBoundingBox(state, world, pos);
	}

	@Override public boolean isOpaqueCube(IBlockState state) {
		return state.getValue(HALF) == SlabPart.DOUBLE;
	}

	@Override public boolean isFullCube(IBlockState state) {
		return state.getValue(HALF) == SlabPart.DOUBLE;
	}

	@Override public IBlockState getStateForPlacement(World world, BlockPos pos, EnumFacing facing, float hitX, float hitY, float hitZ, int meta, EntityLivingBase placer) {
		return getDefaultState().withProperty(HALF, hitY > 0.5D ? SlabPart.TOP : SlabPart.BOTTOM);
	}

	@Override public boolean onBlockActivated(World world, BlockPos pos, IBlockState state, EntityPlayer player, EnumHand hand, EnumFacing facing, float hitX, float hitY, float hitZ) {
		ItemStack held = player.getHeldItem(hand);
		if (held.getItem() == Item.getItemFromBlock(this) && state.getValue(HALF) != SlabPart.DOUBLE) {
			if (!world.isRemote) {
				world.setBlockState(pos, state.withProperty(HALF, SlabPart.DOUBLE), 3);
				if (!player.capabilities.isCreativeMode) {
					held.shrink(1);
				}
			}
			return true;
		}
		return super.onBlockActivated(world, pos, state, player, hand, facing, hitX, hitY, hitZ);
	}

	@Override public void getDrops(NonNullList<ItemStack> drops, IBlockAccess world, BlockPos pos, IBlockState state, int fortune) {
		int count = state.getValue(HALF) == SlabPart.DOUBLE ? 2 : 1;
		<#if data.customDrop?? && !data.customDrop.isEmpty()>
		ItemStack drop = ${mappedMCItemToItemStackCode(data.customDrop, 1)};
		drop.setCount(drop.getCount() * count * ${data.dropAmount});
		drops.add(drop);
		<#else>
		drops.add(new ItemStack(this, count));
		</#if>
	}

	public enum SlabPart implements IStringSerializable {
		BOTTOM, TOP, DOUBLE;

		@Override public String getName() {
			return name().toLowerCase(java.util.Locale.ROOT);
		}
	}
<#else>
public class ${name}Block extends Block {

	public ${name}Block() {
		super(Material.ROCK);
		setUnlocalizedName("${modid}.${registryname}");
		setHardness(${data.hardness?c}f);
		setResistance(${data.resistance?c}f);
		setSoundType(SoundType.${generator.map(data.soundOnStep.getUnmappedValue(), "stepsounds")});
		<#if customBool?has_content>
		<#assign propName = customBool[0].property().getName()?replace("CUSTOM:", "")>
		setDefaultState(this.blockState.getBaseState().withProperty(${propName?upper_case}, ${customBool[0].value()?c}));
		</#if>
	}

	<#if customBool?has_content>
	<#assign propName = customBool[0].property().getName()?replace("CUSTOM:", "")>
	public static final PropertyBool ${propName?upper_case} = PropertyBool.create("${propName}");

	@Override protected BlockStateContainer createBlockState() {
		return new BlockStateContainer(this, ${propName?upper_case});
	}

	@Override public IBlockState getStateFromMeta(int meta) {
		return getDefaultState().withProperty(${propName?upper_case}, (meta & 1) != 0);
	}

	@Override public int getMetaFromState(IBlockState state) {
		return state.getValue(${propName?upper_case}) ? 1 : 0;
	}
	</#if>
</#if>

	<#if blockBase != "Slab" && data.customDrop?? && !data.customDrop.isEmpty()>
	@Override public void getDrops(NonNullList<ItemStack> drops, IBlockAccess world, BlockPos pos, IBlockState state, int fortune) {
		drops.add(${mappedMCItemToItemStackCode(data.customDrop, data.dropAmount)});
	}
	</#if>

	<#if blockBase != "Slab" && data.xpAmountMax gt 0>
	@Override public int getExpDrop(IBlockState state, IBlockAccess world, BlockPos pos, int fortune) {
		return ${data.xpAmountMin} + (int) (Math.random() * ${data.xpAmountMax - data.xpAmountMin + 1});
	}
	</#if>

	<#if hasProcedure(data.onRandomUpdateEvent)>
	{
		setTickRandomly(true);
	}
	</#if>

	<#if hasProcedure(data.onTickUpdate)>
	@Override public int tickRate(World world) {
		return ${data.tickRate?c};
	}

	@Override public void updateTick(World world, BlockPos pos, IBlockState state, java.util.Random rand) {
		super.updateTick(world, pos, state, rand);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		<@procedureOBJToCode data.onTickUpdate/>
		world.scheduleUpdate(pos, this, this.tickRate(world));
	}
	</#if>

	<#if hasProcedure(data.onRandomUpdateEvent)>
	@Override public void randomTick(World world, BlockPos pos, IBlockState state, java.util.Random rand) {
		super.randomTick(world, pos, state, rand);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		<@procedureOBJToCode data.onRandomUpdateEvent/>
	}
	</#if>

	<#if hasProcedure(data.onBlockAdded) || hasProcedure(data.onTickUpdate)>
	@Override public void onBlockAdded(World world, BlockPos pos, IBlockState state) {
		super.onBlockAdded(world, pos, state);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		<@procedureOBJToCode data.onBlockAdded/>
		<#if hasProcedure(data.onTickUpdate)>
		world.scheduleUpdate(pos, this, this.tickRate(world));
		</#if>
	}
	</#if>

	<#if hasProcedure(data.onNeighbourBlockChanges)>
	@Override public void neighborChanged(IBlockState state, World world, BlockPos pos, Block block, BlockPos fromPos) {
		super.neighborChanged(state, world, pos, block, fromPos);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = null;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		<@procedureOBJToCode data.onNeighbourBlockChanges/>
	}
	</#if>

	<#if hasProcedure(data.onEntityWalksOn)>
	@Override public void onEntityWalk(World world, BlockPos pos, Entity walker) {
		super.onEntityWalk(world, pos, walker);
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = world.getBlockState(pos);
		Entity entity = walker;
		EnumFacing direction = null;
		ItemStack itemstack = ItemStack.EMPTY;
		<@procedureOBJToCode data.onEntityWalksOn/>
	}
	</#if>

	<#if hasProcedure(data.onDestroyedByPlayer)>
	@Override public boolean removedByPlayer(IBlockState state, World world, BlockPos pos, EntityPlayer player, boolean willHarvest) {
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = player;
		EnumFacing direction = null;
		ItemStack itemstack = player.getHeldItemMainhand();
		<@procedureOBJToCode data.onDestroyedByPlayer/>
		return super.removedByPlayer(state, world, pos, player, willHarvest);
	}
	</#if>

	<#if blockBase != "Slab" && hasProcedure(data.onRightClicked)>
	@Override public boolean onBlockActivated(World world, BlockPos pos, IBlockState state, EntityPlayer player, EnumHand hand, EnumFacing facing, float hitX, float hitY, float hitZ) {
		double x = pos.getX(), y = pos.getY(), z = pos.getZ();
		IBlockState blockstate = state;
		Entity entity = player;
		EnumFacing direction = facing;
		ItemStack itemstack = player.getHeldItem(hand);
		<@procedureOBJToCode data.onRightClicked/>
		return true;
	}
	</#if>
}
<#-- @formatter:on -->
