/datum/map/aeolus
	name = "Aeolus"
	full_name = "FTV Aeolus"
	path = "aeolus"

	station_levels = list(1)
	admin_levels = list(1)
	contact_levels = list(1,3)
	player_levels = list(1,3)

	shuttle_docked_message = "Spooling complete. The scheduled wave jump will occur in approximately %ETD%. All hands, please prepare for departure."
	shuttle_leaving_dock = "Wave jump initiated. Please do not depart the vessel until the jump is complete. Estimate %ETA% until arrival at %dock_name%."
	shuttle_called_message = "Gravity drive spooling has begun for scheduled wave jump. Estimated completion time is %ETA%."
	shuttle_recall_message = "The scheduled wave jump has been cancelled."
	emergency_shuttle_docked_message = "Emergency gravity drive spooling complete. Emergency jump will occur in approximately %ETD%. All hands, prepare for departure."
	emergency_shuttle_leaving_dock = "Emergency wave jump initiated. Estimate %ETA% until arrival at %dock_name%."
	emergency_shuttle_called_message = "An emergency wave jump has been initiated. This is not a drill. Drive spooling will be complete in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency wave jump has been cancelled."
	evac_controller_type = /datum/evacuation_controller

	var/datum/trade_destination/destination_location
	var/initial_announcement

/datum/map/aeolus/perform_map_generation()
	stellar_location.build_level(3)
	return 1

/datum/map/aeolus/update_locations()
	. = ..()
	destination_location = pick(all_trade_destinations - stellar_location)
	if(stellar_location.flavour_locations && stellar_location.flavour_locations.len)
		specific_location = pick(stellar_location.flavour_locations)
		initial_announcement = "Wave jump complete. The [station_name()] has safely arrived in the vicinity of [specific_location], [stellar_location.is_a_planet ? "orbiting" : "within"] [stellar_location.name]. Gravity drive systems are fully disengaged and all crewmembers are cleared to resume their regular duties."
	else
		specific_location = stellar_location.name
		initial_announcement = "Wave jump complete. The [station_name()] has safely arrived at [specific_location]. Gravity drive systems are fully disengaged and all crewmembers are cleared to resume their regular duties."

/datum/map/aeolus/do_roundstart_intro()
	. = ..()
	if(initial_announcement)
		priority_announcement.Announce(initial_announcement)
	sleep(600)
	if(destination_location)
		priority_announcement.Announce("Vector plotting for scheduled jump complete. Departure for [destination_location.name] will be undertaken in two standard hours.")

/obj/effect/landmark/map_data/aeolus
	name = "FTV Aeolus"
	desc = "A Free Trade Union freight vessel."
	height = 1
