<#include "/mcitems.ftl">
<#assign pos = "new net.minecraft.util.math.BlockPos((int) ${input$x}, (int) ${input$y}, (int) ${input$z})">
{
    net.minecraft.block.state.IBlockState _state = world.getBlockState(${pos});
    if (_state.getBlock().getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyInteger) {
        world.setBlockState(${pos}, _state.withProperty((net.minecraft.block.properties.PropertyInteger) _state.getBlock().getBlockState().getProperty(${input$property}), ${input$value}), 3);
    }
}
