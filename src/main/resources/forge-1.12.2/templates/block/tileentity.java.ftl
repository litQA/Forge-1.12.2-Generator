<#-- @formatter:off -->
package ${package}.block.entity;

import java.util.Arrays;

import net.minecraft.block.state.IBlockState;
import net.minecraft.entity.player.EntityPlayer;
import net.minecraft.inventory.IInventory;
import net.minecraft.item.ItemStack;
import net.minecraft.nbt.NBTTagCompound;
import net.minecraft.nbt.NBTTagList;
import net.minecraft.tileentity.TileEntity;
import net.minecraft.util.math.BlockPos;
import net.minecraft.util.text.ITextComponent;
import net.minecraft.util.text.TextComponentString;
import net.minecraft.world.World;

public class ${name}BlockEntity extends TileEntity implements IInventory {

	private final ItemStack[] inventory = new ItemStack[${data.inventorySize?c}];

	public ${name}BlockEntity() {
		Arrays.fill(inventory, ItemStack.EMPTY);
	}

	@Override public int getSizeInventory() {
		return inventory.length;
	}

	@Override public boolean isEmpty() {
		for (ItemStack stack : inventory) {
			if (!stack.isEmpty()) {
				return false;
			}
		}
		return true;
	}

	@Override public ItemStack getStackInSlot(int index) {
		return index >= 0 && index < inventory.length ? inventory[index] : ItemStack.EMPTY;
	}

	@Override public ItemStack decrStackSize(int index, int count) {
		ItemStack stack = getStackInSlot(index);
		if (stack.isEmpty()) {
			return ItemStack.EMPTY;
		}
		if (stack.getCount() <= count) {
			setInventorySlotContents(index, ItemStack.EMPTY);
			return stack;
		}
		ItemStack result = stack.splitStack(count);
		markDirty();
		return result;
	}

	@Override public ItemStack removeStackFromSlot(int index) {
		ItemStack stack = getStackInSlot(index);
		setInventorySlotContents(index, ItemStack.EMPTY);
		return stack;
	}

	@Override public void setInventorySlotContents(int index, ItemStack stack) {
		if (index >= 0 && index < inventory.length) {
			inventory[index] = stack;
			if (!stack.isEmpty() && stack.getCount() > getInventoryStackLimit()) {
				stack.setCount(getInventoryStackLimit());
			}
			markDirty();
		}
	}

	@Override public int getInventoryStackLimit() {
		return ${data.inventoryStackSize?c};
	}

	@Override public boolean isUsableByPlayer(EntityPlayer player) {
		return world != null && world.getTileEntity(pos) == this
				&& player.getDistanceSq(pos.getX() + 0.5D, pos.getY() + 0.5D, pos.getZ() + 0.5D) <= 64.0D;
	}

	@Override public boolean shouldRefresh(World world, BlockPos pos, IBlockState oldState, IBlockState newState) {
		return oldState.getBlock() != newState.getBlock();
	}

	@Override public void openInventory(EntityPlayer player) {
	}

	@Override public void closeInventory(EntityPlayer player) {
	}

	@Override public boolean isItemValidForSlot(int index, ItemStack stack) {
		return true;
	}

	@Override public int getField(int id) {
		return 0;
	}

	@Override public void setField(int id, int value) {
	}

	@Override public int getFieldCount() {
		return 0;
	}

	@Override public void clear() {
		Arrays.fill(inventory, ItemStack.EMPTY);
	}

	@Override public String getName() {
		return "${name}";
	}

	@Override public boolean hasCustomName() {
		return false;
	}

	@Override public ITextComponent getDisplayName() {
		return new TextComponentString(getName());
	}

	@Override public NBTTagCompound writeToNBT(NBTTagCompound compound) {
		super.writeToNBT(compound);
		NBTTagList items = new NBTTagList();
		for (int i = 0; i < inventory.length; i++) {
			if (!inventory[i].isEmpty()) {
				NBTTagCompound item = new NBTTagCompound();
				item.setByte("Slot", (byte) i);
				inventory[i].writeToNBT(item);
				items.appendTag(item);
			}
		}
		compound.setTag("Items", items);
		return compound;
	}

	@Override public void readFromNBT(NBTTagCompound compound) {
		super.readFromNBT(compound);
		Arrays.fill(inventory, ItemStack.EMPTY);
		NBTTagList items = compound.getTagList("Items", 10);
		for (int i = 0; i < items.tagCount(); i++) {
			NBTTagCompound item = items.getCompoundTagAt(i);
			int slot = item.getByte("Slot") & 255;
			if (slot < inventory.length) {
				inventory[slot] = new ItemStack(item);
			}
		}
	}

}
<#-- @formatter:on -->
