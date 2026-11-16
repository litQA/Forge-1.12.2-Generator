<#include "/mcitems.ftl">
<#assign pos = "new net.minecraft.util.math.BlockPos((int) ${input$x}, (int) ${input$y}, (int) ${input$z})">
{
    net.minecraft.block.state.IBlockState _state = world.getBlockState(${pos});
    net.minecraft.block.properties.PropertyInteger _property = getIntegerProperty(_state.getBlock(), ${input$property});
    if (_property != null) {
        world.setBlockState(${pos}, _state.withProperty(_property, (int) (${input$value})), 3);
    }
}
