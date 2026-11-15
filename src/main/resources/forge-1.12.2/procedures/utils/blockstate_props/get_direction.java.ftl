<@addTemplate file="utils/blockstate_props/property_from_string.java.ftl"/>
private static EnumFacing getDirectionFromBlockState(IBlockState blockState) {
	IProperty prop = getPropertyByName(blockState, "facing");
	if (prop instanceof PropertyDirection) return blockState.getValue((PropertyDirection) prop);
	prop = getPropertyByName(blockState, "axis");
	if (prop instanceof PropertyEnum && ((PropertyEnum) prop).getAllowedValues().toArray()[0] instanceof EnumFacing.Axis) {
		EnumFacing.Axis axis = (EnumFacing.Axis) blockState.getValue((PropertyEnum) prop);
		return EnumFacing.getFacingFromAxis(EnumFacing.AxisDirection.POSITIVE, axis);
	}
	return EnumFacing.NORTH;
}