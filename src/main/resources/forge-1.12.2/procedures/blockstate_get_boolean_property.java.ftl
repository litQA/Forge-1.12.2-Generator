<#include "/mcitems.ftl">
/*@logic*/(${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property}) instanceof net.minecraft.block.properties.PropertyBool
    && ${mappedBlockToBlockStateCode(input$block)}.getValue((net.minecraft.block.properties.PropertyBool) ${mappedBlockToBlock(input$block)}.getBlockState().getProperty(${input$property})))