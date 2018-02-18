function onHover(mainImageId, pathToImage)
{
    $("#"+mainImageId).attr('src', pathToImage);
}

function offHover(source)
{
    $("#menuImg").attr('src', 'img/about.png');
}
