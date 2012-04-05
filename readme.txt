== AutoTurnIn ==
author: lurkerrr
http://wow.curseforge.com/addons/autoturnin/
Accepts and turn in quest to NPC. May handle any quests or specified list. 
May turn in quests with rewards and choose most expensive one for future selling.

/au 		- for GUI
/au all 	- any quest would by accepted and turned in
/au list 	- only specified quest
/au off 	- turns addon off
/au on 		- turns addon on
/au help 	- brief help and active settings

that's all for now. 
If you feel yourself in a mood to make localization to another language, let me know through 
curseforge site. 


Short script to extract quests name from wowhead.com. Just open the list with the quest and run it through Firefox web development console.
============================
var quests={}, _result="", x;
var area = $("div.comment-edit-body textarea");
$("table.listview-mode-default tr").find("td:first div a").each(function (){
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
==============================