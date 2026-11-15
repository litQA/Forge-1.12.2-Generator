<#-- @formatter:off -->
package ${package}.command;

import java.util.HashMap;
import java.util.Map;

import net.minecraft.block.Block;
import net.minecraft.block.state.IBlockState;
import net.minecraft.command.CommandBase;
import net.minecraft.command.CommandException;
import net.minecraft.command.ICommandSender;
import net.minecraft.init.Blocks;
import net.minecraft.item.Item;
import net.minecraft.item.ItemStack;

/**
 * Carries typed command arguments into procedure code on the server thread.
 */
public final class CommandParameters {

	public static final Map<String, String> VALUES = new HashMap<>();
	public static ICommandSender SENDER;

	private CommandParameters() {
	}

	public static IBlockState blockState(String value) {
		if (value == null || SENDER == null)
			return Blocks.AIR.getDefaultState();
		try {
			Block block = CommandBase.getBlockByText(SENDER, value);
			return CommandBase.convertArgToBlockState(block, value);
		} catch (CommandException exception) {
			return Blocks.AIR.getDefaultState();
		}
	}

	public static ItemStack itemStack(String value) {
		if (value == null || SENDER == null)
			return ItemStack.EMPTY;
		try {
			Item item = CommandBase.getItemByText(SENDER, value);
			return item == null ? ItemStack.EMPTY : new ItemStack(item);
		} catch (CommandException exception) {
			return ItemStack.EMPTY;
		}
	}
}
<#-- @formatter:on -->
