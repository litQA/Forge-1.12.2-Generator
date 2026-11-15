private static IBlockState blockStateWithDirection(IBlockState blockState, EnumFacing newValue) {
	IProperty prop = blockState.getBlock().getBlockState().getProperty("facing");
	if (prop instanceof PropertyDirection && ((PropertyDirection) prop).getAllowedValues().contains(newValue)) return blockState.withProperty((PropertyDirection) prop, newValue);
	prop = blockState.getBlock().getBlockState().getProperty("axis");
	return prop instanceof PropertyEnum && ((PropertyEnum) prop).getAllowedValues().contains(newValue.getAxis()) ? blockState.withProperty((PropertyEnum) prop, newValue.getAxis()) : blockState;
}