var quests={}, _result="", x;
var area = $("div.comment-edit-body textarea");
$("table.listview-mode-default tr").find("td div a").each(function (){
    if ($(this).text() != "") quests[$(this).text()]= "";
});
for(x in quests) {
  _result += "['"+x+"']=\"\",\n"  
}
if (area.length) {
    area.removeAttr("disabled").val(_result);
} else  {
    $("body").append('<textarea class="comment-editbox" name="commentbody" cols="40" rows="10">'+_result+'</textarea>');
}