<#-- @formatter:off -->
package ${package}.init;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import net.minecraft.block.Block;

public class ${JavaModName}BlockTags {

	private static final Map<String, Set<Block>> TAGS = new HashMap<>();

	public static void add(String tag, Block block) {
		if (block == null)
			return;
		Set<Block> blocks = TAGS.get(tag);
		if (blocks == null) {
			blocks = new HashSet<>();
			TAGS.put(tag, blocks);
		}
		blocks.add(block);
	}

	public static boolean contains(String tag, Block block) {
		Set<Block> blocks = TAGS.get(tag);
		return blocks != null && blocks.contains(block);
	}

}
<#-- @formatter:on -->
