/mob/living/carbon/human/examine(mob/user)
	var/skipgloves = 0
	var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipears = 0
	var/skipeyes = 0
	var/skipface = 0

	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE

	if(wear_mask)
		skipface |= wear_mask.flags_inv & HIDEFACE

	var/list/msg = list("<span class='info'>*---------*\nThis is ")

	var/datum/gender/T = gender_datums[get_gender()]
	if(skipjumpsuit && skipface) //big suits/masks/helmets make it hard to tell their gender
		T = gender_datums[PLURAL]
	else
		if(icon)
			msg += "\icon[icon] " //fucking BYOND: this should stop dreamseeker crashing if we -somehow- examine somebody before their icon is generated

	if(!T)
		// Just in case someone VVs the gender to something strange. It'll runtime anyway when it hits usages, better to CRASH() now with a helpful message.
		CRASH("Gender datum was null; key was '[(skipjumpsuit && skipface) ? PLURAL : gender]'")

	msg += "<EM>[src.name]</EM>"

	var/is_synth = isSynthetic()
	if(!(skipjumpsuit && skipface))
		var/species_name = "\improper "
		if(is_synth)
			species_name += "Cyborg "
		species_name += "[species.name]"
		msg += ", <b><font color='[species.get_flesh_colour(src)]'> \a [species_name]!</font></b>"
	var/extra_species_text = species.get_additional_examine_text(src)
	if(extra_species_text)
		msg += "[extra_species_text]<br>"

	msg += "<br>"

	//uniform
	if(w_uniform && !skipjumpsuit)
		//Ties
		var/tie_msg
		if(istype(w_uniform,/obj/item/clothing/under))
			var/obj/item/clothing/under/U = w_uniform
			if(U.accessories.len)
				tie_msg += ". Attached to it is [lowertext(english_list(U.accessories))]"

		if(w_uniform.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] [(w_uniform.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [w_uniform.name][tie_msg]!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[w_uniform] \a [w_uniform][tie_msg].\n"

	//head
	if(head)
		if(head.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[head] [head.gender==PLURAL?"some":"a"] [(head.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [head.name] on [T.his] head!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[head] \a [head] on [T.his] head.\n"

	//suit/armour
	if(wear_suit)
		if(wear_suit.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] [(wear_suit.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [wear_suit.name]!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[wear_suit] \a [wear_suit].\n"

		//suit/armour storage
		if(s_store && !skipsuitstorage)
			if(s_store.blood_DNA)
				msg += "<span class='warning'>[T.He] [T.is] carrying \icon[s_store] [s_store.gender==PLURAL?"some":"a"] [(s_store.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [s_store.name] on [T.his] [wear_suit.name]!</span>\n"
			else
				msg += "[T.He] [T.is] carrying \icon[s_store] \a [s_store] on [T.his] [wear_suit.name].\n"

	//back
	if(back)
		if(back.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[back] [back.gender==PLURAL?"some":"a"] [(back.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [back] on [T.his] back.</span>\n"
		else
			msg += "[T.He] [T.has] \icon[back] \a [back] on [T.his] back.\n"

	//left hand
	if(l_hand)
		if(l_hand.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] holding \icon[l_hand] [l_hand.gender==PLURAL?"some":"a"] [(l_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [l_hand.name] in [T.his] left hand!</span>\n"
		else
			msg += "[T.He] [T.is] holding \icon[l_hand] \a [l_hand] in [T.his] left hand.\n"

	//right hand
	if(r_hand)
		if(r_hand.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] holding \icon[r_hand] [r_hand.gender==PLURAL?"some":"a"] [(r_hand.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [r_hand.name] in [T.his] right hand!</span>\n"
		else
			msg += "[T.He] [T.is] holding \icon[r_hand] \a [r_hand] in [T.his] right hand.\n"

	//gloves
	if(gloves && !skipgloves)
		if(gloves.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[gloves] [gloves.gender==PLURAL?"some":"a"] [(gloves.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [gloves.name] on [T.his] hands!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[gloves] \a [gloves] on [T.his] hands.\n"
	else if(blood_DNA)
		msg += "<span class='warning'>[T.He] [T.has] [(hand_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained hands!</span>\n"

	//handcuffed?

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/handcuffs/cable))
			msg += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>[T.He] [T.is] \icon[handcuffed] handcuffed!</span>\n"

	//buckled
	if(buckled)
		msg += "<span class='warning'>[T.He] [T.is] \icon[buckled] buckled to [buckled]!</span>\n"

	//belt
	if(belt)
		if(belt.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[belt] [belt.gender==PLURAL?"some":"a"] [(belt.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [belt.name] about [T.his] waist!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[belt] \a [belt] about [T.his] waist.\n"

	//shoes
	if(shoes && !skipshoes)
		if(shoes.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[shoes] [shoes.gender==PLURAL?"some":"a"] [(shoes.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [shoes.name] on [T.his] feet!</span>\n"
		else
			msg += "[T.He] [T.is] wearing \icon[shoes] \a [shoes] on [T.his] feet.\n"
	else if(feet_blood_DNA)
		msg += "<span class='warning'>[T.He] [T.has] [(feet_blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained feet!</span>\n"

	//mask
	if(wear_mask && !skipmask)
		if(wear_mask.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] [(wear_mask.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [wear_mask.name] on [T.his] face!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[wear_mask] \a [wear_mask] on [T.his] face.\n"

	//eyes
	if(glasses && !skipeyes)
		if(glasses.blood_DNA)
			msg += "<span class='warning'>[T.He] [T.has] \icon[glasses] [glasses.gender==PLURAL?"some":"a"] [(glasses.blood_color != SYNTH_BLOOD_COLOUR) ? "blood" : "oil"]-stained [glasses] covering [T.his] eyes!</span>\n"
		else
			msg += "[T.He] [T.has] \icon[glasses] \a [glasses] covering [T.his] eyes.\n"

	//left ear
	if(l_ear && !skipears)
		msg += "[T.He] [T.has] \icon[l_ear] \a [l_ear] on [T.his] left ear.\n"

	//right ear
	if(r_ear && !skipears)
		msg += "[T.He] [T.has] \icon[r_ear] \a [r_ear] on [T.his] right ear.\n"

	//ID
	if(wear_id)
		/*var/id
		if(istype(wear_id, /obj/item/device/radio/headset/pda))
			var/obj/item/device/radio/headset/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/weapon/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/weapon/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, usr) <= 1) && prob(10))
			msg += "<span class='warning'>[T.He] [T.is] wearing \icon[wear_id] \a [wear_id] yet something doesn't seem right...</span>\n"
		else*/
		msg += "[T.He] [T.is] wearing \icon[wear_id] \a [wear_id].\n"

	//Jitters
	if(is_jittery)
		if(jitteriness >= 300)
			msg += "<span class='warning'><B>[T.He] [T.is] convulsing violently!</B></span>\n"
		else if(jitteriness >= 200)
			msg += "<span class='warning'>[T.He] [T.is] extremely jittery.</span>\n"
		else if(jitteriness >= 100)
			msg += "<span class='warning'>[T.He] [T.is] twitching ever so slightly.</span>\n"

	//splints
	for(var/organ in list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM))
		var/obj/item/organ/external/o = get_organ(organ)
		if(o && o.splinted && o.splinted.loc == o)
			msg += "<span class='warning'>[T.He] [T.has] \a [o.splinted] on [T.his] [o.name]!</span>\n"

	if(mSmallsize in mutations)
		msg += "[T.He] [T.is] small halfling!\n"

	var/distance = get_dist(usr,src)
	if(isghost(usr) || usr.stat == DEAD) // ghosts can see anything
		distance = 1
	if (src.stat)
		msg += "<span class='warning'>[T.He] [T.is]n't responding to anything around [T.him] and seems to be asleep.</span>\n"
		if((stat == DEAD || src.losebreath) && distance <= 3)
			msg += "<span class='warning'>[T.He] [T.does] not appear to be breathing.</span>\n"
		if(istype(usr, /mob/living/carbon/human) && !usr.stat && Adjacent(usr))
			usr.visible_message("<b>[usr]</b> checks [src]'s pulse.", "You check [src]'s pulse.")
		spawn(15)
			if(distance <= 1 && usr.stat != 1)
				if(pulse() == PULSE_NONE)
					usr << "<span class='deadsay'>[T.He] [T.has] no pulse[src.client ? "" : " and [T.his] soul has departed"]...</span>"
				else
					usr << "<span class='deadsay'>[T.He] [T.has] a pulse!</span>"

	if(fire_stacks)
		msg += "[T.He] [T.is] covered in some liquid.\n"
	if(on_fire)
		msg += "<span class='warning'>[T.He] [T.is] on fire!.</span>\n"
	msg += "<span class='warning'>"

	/*
	if(nutrition < 100)
		msg += "[T.He] [T.is] severely malnourished.\n"
	else if(nutrition >= 500)
		/*if(usr.nutrition < 100)
			msg += "[T.He] [T.is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else*/
		msg += "[T.He] [T.is] quite chubby.\n"
	*/

	msg += "</span>"

	var/ssd_msg = species.get_ssd(src)
	if(ssd_msg && (!should_have_organ(BP_BRAIN) || has_brain()) && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg]. It doesn't look like [T.he] [T.is] waking up anytime soon.</span>\n"
		else if(!client)
			msg += "<span class='deadsay'>[T.He] [T.is] [ssd_msg].</span>\n"

	var/list/wound_flavor_text = list()
	var/list/is_bleeding = list()
	var/applying_pressure = ""

	for(var/organ_tag in species.has_limbs)

		var/list/organ_data = species.has_limbs[organ_tag]
		var/organ_descriptor = organ_data["descriptor"]

		var/obj/item/organ/external/E = organs_by_name[organ_tag]
		if(!E)
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.is] missing [T.his] [organ_descriptor].</b></span>\n"
		else if(E.is_stump())
			wound_flavor_text["[organ_descriptor]"] = "<span class='warning'><b>[T.He] [T.has] a stump where [T.his] [organ_descriptor] should be.</b></span>\n"
		else
			continue

	for(var/obj/item/organ/external/temp in organs)
		if(temp)
			if(!is_synth && temp.robotic >= ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] a [temp.name]!</span>\n"
					continue
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] a [temp.name]. It has[temp.get_wounds_desc()]!</span>\n"
			else if(temp.wounds.len > 0 || temp.open)
				if(temp.is_stump() && temp.parent_organ && organs_by_name[temp.parent_organ])
					var/obj/item/organ/external/parent = organs_by_name[temp.parent_organ]
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [parent.name].</span><br>"
				else
					wound_flavor_text["[temp.name]"] = "<span class='warning'>[T.He] [T.has] [temp.get_wounds_desc()] on [T.his] [temp.name].</span><br>"
			else
				wound_flavor_text["[temp.name]"] = ""
			if(temp.dislocated == 2)
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.joint] is dislocated!</span><br>"
			if(((temp.status & ORGAN_BROKEN) && temp.brute_dam > temp.min_broken_damage) || (temp.status & ORGAN_MUTATED))
				wound_flavor_text["[temp.name]"] += "<span class='warning'>[T.His] [temp.name] is dented and swollen!</span><br>"

			if(temp.applied_pressure == src)
				applying_pressure = "<span class='info'>[T.He] is applying pressure to [T.his] [temp.name].</span><br>"

	for(var/limb in wound_flavor_text)
		msg += wound_flavor_text[limb]
	for(var/limb in is_bleeding)
		msg += is_bleeding[limb]
	for(var/implant in get_visible_implants(0))
		msg += "<span class='danger'>[src] [T.has] \a [implant] sticking out of [T.his] flesh!</span>\n"
	if(digitalcamo || has_aspect(ASPECT_UNCANNY))
		msg += "[T.He] [T.is] repulsively uncanny!\n"

	if(hasHUD(usr,"security"))
		var/perpname = "wot"
		var/criminal = "None"

		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
		else
			perpname = name

		if(perpname)
			for (var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]

			msg += "<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>\n"
			msg += "<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"

	if(hasHUD(usr,"medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(wear_id)
			if(istype(wear_id,/obj/item/weapon/card/id))
				perpname = wear_id:registered_name
			else if(istype(wear_id,/obj/item/device/radio/headset/pda))
				var/obj/item/device/radio/headset/pda/tempPda = wear_id
				perpname = tempPda.owner
		else
			perpname = src.name

		for (var/datum/data/record/E in data_core.general)
			if (E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.general)
					if (R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]

		msg += "<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n"
		msg += "<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"


	if(print_flavor_text()) msg += "[print_flavor_text()]\n"

	msg += "*---------*</span><br>"
	msg += applying_pressure

	if (pose)
		if( findtext(pose,".",lentext(pose)) == 0 && findtext(pose,"!",lentext(pose)) == 0 && findtext(pose,"?",lentext(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "[T.He] [T.is] [pose]"

	user << jointext(msg, null)

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/sec) || istype(R.module_state_2, /obj/item/borg/sight/hud/sec) || istype(R.module_state_3, /obj/item/borg/sight/hud/sec)
			if("medical")
				return istype(R.module_state_1, /obj/item/borg/sight/hud/med) || istype(R.module_state_2, /obj/item/borg/sight/hud/med) || istype(R.module_state_3, /obj/item/borg/sight/hud/med)
			else
				return 0
	else
		return 0
