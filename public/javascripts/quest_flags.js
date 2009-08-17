var Quest_Flags = {
	0: 'No flags, so no groups assigned to this quest.',
	1: 'If the player dies, the quest is failed. (?)',
	2: ' Escort quests or any other event-driven quests. If player in party, all players that can accept this quest will receive confirmation box to accept quest.',
	4: 'Involves the activation of an areatrigger.',
	8: 'Allows the quest to be shared with other players.',
	16: 'Unknown at this time and not used.',
	32: 'Epic class quests (hunter) (??)',
	64: 'Raid or similar player group needed for quest.',	 
	128: 'Added with or after TBC.',
	256: 'Quest needs extra non-objective items dropped (eg. ReqSourceID fields) (?)',
	512: 'Item and monetary rewards are hidden in the initial quest details page and in the quest log but will appear once ready to be rewarded.',
	1024: 'These quests are automatically rewarded on quest complete and they will never appear in quest log client side.', 
	2048: ' Blood elf/draenei starting zone quests.',
	4096: 'Daily repeatable quests (only flag that the core applies specific behavior for)',
	8192: 'Grizzly Hills PvP daily? Once quest is accepted the players PvP is enabled.'
};