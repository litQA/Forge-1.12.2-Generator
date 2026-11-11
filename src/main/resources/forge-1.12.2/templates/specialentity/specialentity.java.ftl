<#-- @formatter:off -->
<#include "/procedures.ftl">
package ${package}.entity;

import net.minecraft.entity.Entity;
import net.minecraft.entity.item.EntityBoat;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.entity.player.EntityPlayerMP;
import net.minecraft.inventory.IInventory;
import net.minecraft.inventory.InventoryBasic;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;
import net.minecraft.nbt.NBTTagCompound;
import net.minecraft.nbt.NBTTagList;
import net.minecraft.util.DamageSource;
import net.minecraft.util.EnumHand;
import net.minecraft.world.World;

import ${package}.${JavaModName};
import ${package}.init.${JavaModName}GUIs;
import ${package}.init.${JavaModName}Items;

public class ${name}Entity extends EntityBoat <#if data.isBoatChestVariant()>implements IInventory</#if> {

	<#if data.isBoatChestVariant()>
	private final IInventory inventory = new InventoryBasic("container.chest", false, 27);
	</#if>

	public ${name}Entity(World world) {
		super(world);
		this.setBoatType(EntityBoat.Type.OAK);
	}

	public ${name}Entity(World world, double x, double y, double z) {
		super(world, x, y, z);
		this.setBoatType(EntityBoat.Type.OAK);
	}

	@Override public Item getItemBoat() {
		return ${JavaModName}Items.${specialentity.getModElement().getRegistryNameUpper()};
	}

	<#if data.isBoatChestVariant()>
	@Override public boolean processInitialInteract(EntityPlayer player, EnumHand hand) {
		if (!player.world.isRemote && player.isSneaking()) {
			((EntityPlayerMP) player).openGui(${JavaModName}.instance, ${JavaModName}GUIs.CHEST_BOAT_ID,
					player.world, this.getEntityId(), 0, 0);
			return true;
		}
		return super.processInitialInteract(player, hand);
	}

	@Override public void setDead() {
		if (!this.world.isRemote) {
			for (int i = 0; i < this.inventory.getSizeInventory(); ++i) {
				ItemStack stack = this.inventory.getStackInSlot(i);
				if (!stack.isEmpty())
					this.entityDropItem(stack, 0.0F);
			}
		}
		super.setDead();
	}

	private void writeInventory(NBTTagCompound compound) {
		NBTTagList list = new NBTTagList();
		for (int i = 0; i < this.inventory.getSizeInventory(); ++i) {
			ItemStack stack = this.inventory.getStackInSlot(i);
			if (!stack.isEmpty()) {
				NBTTagCompound entry = new NBTTagCompound();
				entry.setByte("Slot", (byte) i);
				stack.writeToNBT(entry);
				list.appendTag(entry);
			}
		}
		compound.setTag("Items", list);
	}

	private void readInventory(NBTTagCompound compound) {
		NBTTagList list = compound.getTagList("Items", 10);
		for (int i = 0; i < list.tagCount(); ++i) {
			NBTTagCompound entry = list.getCompoundTagAt(i);
			int slot = entry.getByte("Slot") & 255;
			if (slot < this.inventory.getSizeInventory())
				this.inventory.setInventorySlotContents(slot, new ItemStack(entry));
		}
	}

	@Override public void writeEntityToNBT(NBTTagCompound compound) {
		super.writeEntityToNBT(compound);
		this.writeInventory(compound);
	}

	@Override public void readEntityFromNBT(NBTTagCompound compound) {
		super.readEntityFromNBT(compound);
		this.readInventory(compound);
	}

	@Override public int getSizeInventory() { return this.inventory.getSizeInventory(); }
	@Override public boolean isEmpty() { return this.inventory.isEmpty(); }
	@Override public ItemStack getStackInSlot(int index) { return this.inventory.getStackInSlot(index); }
	@Override public ItemStack decrStackSize(int index, int count) { return this.inventory.decrStackSize(index, count); }
	@Override public ItemStack removeStackFromSlot(int index) { return this.inventory.removeStackFromSlot(index); }
	@Override public void setInventorySlotContents(int index, ItemStack stack) { this.inventory.setInventorySlotContents(index, stack); }
	@Override public int getInventoryStackLimit() { return this.inventory.getInventoryStackLimit(); }
	@Override public void markDirty() { this.inventory.markDirty(); }
	@Override public boolean isUsableByPlayer(EntityPlayer player) { return this.inventory.isUsableByPlayer(player); }
	@Override public void openInventory(EntityPlayer player) { this.inventory.openInventory(player); }
	@Override public void closeInventory(EntityPlayer player) { this.inventory.closeInventory(player); }
	@Override public boolean isItemValidForSlot(int index, ItemStack stack) { return this.inventory.isItemValidForSlot(index, stack); }
	@Override public int getField(int id) { return this.inventory.getField(id); }
	@Override public void setField(int id, int value) { this.inventory.setField(id, value); }
	@Override public int getFieldCount() { return this.inventory.getFieldCount(); }
	@Override public void clear() { this.inventory.clear(); }
	@Override public String getName() { return this.inventory.getName(); }
	@Override public boolean hasCustomName() { return this.inventory.hasCustomName(); }
	</#if>

	<#if hasProcedure(data.onTickUpdate)>
	@Override public void onUpdate() {
		super.onUpdate();
		<@procedureCode data.onTickUpdate, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onPlayerCollidesWith)>
	@Override public void onCollideWithPlayer(EntityPlayer player) {
		super.onCollideWithPlayer(player);
		<@procedureCode data.onPlayerCollidesWith, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"sourceentity": "player",
			"world": "this.world"
		}/>
	}
	</#if>

}
<#-- @formatter:on -->
