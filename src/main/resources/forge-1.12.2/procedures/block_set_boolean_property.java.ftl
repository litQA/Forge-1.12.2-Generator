<#include "/mcitems.ftl">
<#assign pos = "new net.minecraft.util.math.BlockPos((int) ${input$x}, (int) ${input$y}, (int) ${input$z})">
{
    net.minecraft.block.state.IBlockState _state = world.getBlockState(${pos});
    if (_state.getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyBool) {
        world.setBlockState(${pos}, _state.withProperty((net.minecraft.block.properties.PropertyBool) _state.getProperty(${input$property}), ${input$value}), 3);
    }
}
