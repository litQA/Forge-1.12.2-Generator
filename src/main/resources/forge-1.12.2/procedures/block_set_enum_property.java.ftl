<#include "/mcitems.ftl">
<#assign pos = "new net.minecraft.util.math.BlockPos((int) ${input$x}, (int) ${input$y}, (int) ${input$z})">
{
    net.minecraft.block.state.IBlockState _state = world.getBlockState(${pos});
    net.minecraft.block.properties.IProperty _property = _state.getBlock().getBlockState().getProperty(${input$property});
    if (_property instanceof net.minecraft.block.properties.PropertyEnum) {
        java.util.Optional<?> _value = ((net.minecraft.block.properties.PropertyEnum) _property).parseValue(${input$value});
        if (_value.isPresent()) {
            world.setBlockState(${pos}, _state.withProperty(_property, (Enum) _value.get()), 3);
        }
    }
}
