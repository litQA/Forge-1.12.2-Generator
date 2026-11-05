<#include "/mcitems.ftl">
world.setBlockState(new net.minecraft.util.math.BlockPos((int) ${input$x}, (int) ${input$y}, (int) ${input$z}), ${mappedBlockToBlockStateCode(input$block)}, 3);
