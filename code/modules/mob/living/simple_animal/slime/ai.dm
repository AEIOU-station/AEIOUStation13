/mob/living/simple_animal/slime/FindTarget()
	if(victim) // Don't worry about finding another target if we're eatting someone.
		return
	if(follow_mob && can_command(follow_mob)) // If following someone, don't attack until the leader says so, something hits you, or the leader is no longer worthy.
		return
	..()

/mob/living/simple_animal/slime/Found(mob/living/L)
	if(isliving(L))
		if(SA_attackable(L))
			if(L.faction == faction && !attack_same)
				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
						return H // Monkeys are always food.
					else
						return

			if(L in friends)
				return

			if(istype(L, /mob/living/simple_animal/slime))
				var/mob/living/simple_animal/slime/buddy = L
				if(buddy.slime_color == src.slime_color || discipline || unity || buddy.unity)
					return // Don't hurt same colored slimes.
				else
					return buddy	//do hurt others

			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
					return H // Monkeys are always food.

			if(issilicon(L) || isbot(L))
				if(discipline && !rabid)
					return // We're a good slime.  For now at least.
			return
	return

/mob/living/simple_animal/slime/special_target_check(mob/living/L)
	if(L.faction == faction && !attack_same && !istype(L, /mob/living/simple_animal/slime))
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
				return TRUE // Monkeys are always food.
			else
				return FALSE
	if(L in friends)
		return FALSE

	if(istype(L, /mob/living/simple_animal/slime))
		var/mob/living/simple_animal/slime/buddy = L
		if(buddy.slime_color == src.slime_color || discipline || unity || buddy.unity)
			return FALSE // Don't hurt same colored slimes.

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species && H.species.name == "Promethean")
			return FALSE // Prometheans are always our friends.
		else if(istype(H.species, /datum/species/monkey)) // istype() is so they'll eat the alien monkeys too.
			return TRUE // Monkeys are always food.
		if(discipline && !rabid)
			return FALSE // We're a good slime.  For now at least

	if(issilicon(L) || isbot(L) )
		if(discipline && !rabid)
			return FALSE // We're a good slime.  For now at least.
	return ..() // Other colors and nonslimes are jerks however.

/mob/living/simple_animal/slime/ClosestDistance()
	if(target_mob.stat == DEAD)
		return 1 // Melee (eat) the target if dead, don't shoot it.
	return ..()

/mob/living/simple_animal/slime/HelpRequested(var/mob/living/simple_animal/slime/buddy)
	if(istype(buddy))
		if(buddy.slime_color != src.slime_color && (!unity || !buddy.unity)) // We only help slimes of the same color, if it's another slime calling for help.
			ai_log("HelpRequested() by [buddy] but they are a [buddy.slime_color] while we are a [src.slime_color].",2)
			return
		if(buddy.target_mob)
			if(!special_target_check(buddy.target_mob))
				ai_log("HelpRequested() by [buddy] but special_target_check() failed when passed [buddy.target_mob].",2)
				return
	..()


/mob/living/simple_animal/slime/handle_resist()
	if(buckled && victim && isliving(buckled) && victim == buckled) // If it's buckled to a living thing it's probably eating it.
		return
	else
		..()
