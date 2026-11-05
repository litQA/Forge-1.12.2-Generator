<#include "/mcitems.ftl">
/*@BlockState*/(${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyBool
    ? ${mappedBlockToBlockStateCode(input$block)}.withProperty((net.minecraft.block.properties.PropertyBool) ${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property}), ${input$value})
    : ${mappedBlockToBlockStateCode(input$block)})