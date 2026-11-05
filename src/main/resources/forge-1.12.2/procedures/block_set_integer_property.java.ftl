<#include "/mcitems.ftl">
/*@BlockState*/(${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyInteger
    ? ${mappedBlockToBlockStateCode(input$block)}.withProperty((net.minecraft.block.properties.PropertyInteger) ${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property}), ${input$value})
    : ${mappedBlockToBlockStateCode(input$block)})