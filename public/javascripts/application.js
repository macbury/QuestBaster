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
	
	$('.object_id').keyup(function () {
		var self = $(this);
		jQuery.getJSON('/quest_templates/suggest_game_object?entry='+$(this).val(), function (data) {
			self.siblings('a').attr('href','http://www.wowhead.com/?object='+data.entry).text(data.name);
		});
	});
	
	$('#quest_template_quest_giver_id').keyup(function () {
		var self = $(this);
		
		if ($('#quest_template_quest_giver_type :selected').val() == 1) {
			jQuery.getJSON('/quest_templates/suggest_game_object?entry='+$(this).val(), function (data) {
				self.siblings('a').attr('href','http://www.wowhead.com/?object='+data.entry).text(data.name);
			});
		}else{
			jQuery.getJSON('/quest_templates/suggest_monster.json?q='+$(this).val(), function (data) {
				self.siblings('a').attr('href','http://www.wowhead.com/?npc='+data.entry).text(data.name);
			});
			
			if ($('#quest_template_quest_involver_id').val() == "") {
				$('#quest_template_quest_involver_id').val(self.val());
			}
		}

	});
	
	$('#quest_template_quest_giver_type').change(function () {
		$('#quest_template_quest_giver_id').keyup();
	});
	
	$('#quest_template_quest_involver_id').keyup(function () {
		var self = $(this);
		
		if ($('#quest_template_quest_involver_type :selected').val() == 1) {
			jQuery.getJSON('/quest_templates/suggest_game_object?entry='+$(this).val(), function (data) {
				self.siblings('a').attr('href','http://www.wowhead.com/?object='+data.entry).text(data.name);
			});
		}else{
			jQuery.getJSON('/quest_templates/suggest_monster.json?q='+$(this).val(), function (data) {
				self.siblings('a').attr('href','http://www.wowhead.com/?npc='+data.entry).text(data.name);
			});

		}

	});
	
	$('#quest_template_quest_involver_type').change(function () {
		$('#quest_template_quest_involver_id').keyup();
	});
	
	$('#quest_template_reqItemName1, #quest_template_reqItemName2, #quest_template_reqItemName3, #quest_template_reqItemName4, #quest_template_rewardItemName1, #quest_template_rewardItemName2, #quest_template_rewardItemName3, #quest_template_rewardItemName4, #quest_template_rewardChoiceItemName1, #quest_template_rewardItemName2, #quest_template_rewardItemName3, #quest_template_rewardItemName4').autocomplete('/quest_templates/suggest_item');
	
	$('#quest_template_reqCreature1, #quest_template_reqCreature2, #quest_template_reqCreature3, #quest_template_reqCreature4').autocomplete('/quest_templates/suggest_monster');
	
	$("#quest_template_required_min_faction_name, #quest_template_required_max_faction_name, #quest_template_rewardFactionName1, #quest_template_rewardFactionName2, #quest_template_rewardFactionName3, #quest_template_rewardFactionName4").autocomplete('/quest_templates/sugest_faction');
	$("#quest_template_zone_or_sort_name").autocomplete('/quest_templates/sugest_zone_or_sort');
	
	$('#quest_template_QuestFlags').change(function () {
		var selected = $(this).find(':selected').val();
		$('#quest_flag_desc').text(Quest_Flags[selected]);
	}).change();
});