private static IBlockState blockStateWithEnum(IBlockState blockState, String property, String newValue) {
	IProperty prop = blockState.getBlock().getBlockState().getProperty(property);
	if (prop instanceof PropertyEnum) {
		java.util.Optional<? extends Enum> parsed = ((PropertyEnum) prop).parseValue(newValue);
		if (parsed.isPresent()) return blockState.withProperty((PropertyEnum) prop, (Enum) parsed.get());
	}
	return blockState;
}