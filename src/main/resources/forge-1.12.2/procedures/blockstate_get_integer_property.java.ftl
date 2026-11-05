<#include "/mcitems.ftl">
/*@int*/(${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyInteger
    ? ${mappedBlockToBlockStateCode(input$block)}.getValue((net.minecraft.block.properties.PropertyInteger) ${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property})) : -1)