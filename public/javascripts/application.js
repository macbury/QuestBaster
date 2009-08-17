$.fn.insertAtCaret = function (myValue) {
        return this.each(function(){
                //IE support
                if (document.selection) {
                        this.focus();
                        sel = document.selection.createRange();
                        sel.text = myValue;
                        this.focus();
                }
                //MOZILLA/NETSCAPE support
                else if (this.selectionStart || this.selectionStart == '0') {
                        var startPos = this.selectionStart;
                        var endPos = this.selectionEnd;
                        var scrollTop = this.scrollTop;
                        this.value = this.value.substring(0, startPos)
                                      + myValue
                              + this.value.substring(endPos,
this.value.length);
                        this.focus();
                        this.selectionStart = startPos + myValue.length;
                        this.selectionEnd = startPos + myValue.length;
                        this.scrollTop = scrollTop;
                } else {
                        this.value += myValue;
                        this.focus();
                }
        });

};

$(document).ready(function () {
	$('#quest_template_entry').change(function () {
		$('#wow_desc').attr('href', 'http://www.wowhead.com/?quest='+$(this).val());
	}).change();
	
	$('#quest_template_reqItemName1, #quest_template_reqItemName2, #quest_template_reqItemName3, #quest_template_reqItemName4').autocomplete('/quest_templates/suggest_item');
	
	$('#quest_template_reqCreature1, #quest_template_reqCreature2, #quest_template_reqCreature3, #quest_template_reqCreature4').autocomplete('/quest_templates/suggest_monster');
	
	$("#quest_template_required_min_faction_name, #quest_template_required_max_faction_name").autocomplete('/quest_templates/sugest_faction');
	$("#quest_template_zone_or_sort_name").autocomplete('/quest_templates/sugest_zone_or_sort');
	
	$('#quest_template_QuestFlags').change(function () {
		var selected = $(this).find(':selected').val();
		$('#quest_flag_desc').text(Quest_Flags[selected]);
	}).change();
});