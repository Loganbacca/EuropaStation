var/datum/map/using_map = new USING_MAP_DATUM
var/list/all_maps = list()

var/const/MAP_HAS_BRANCH = 1	//Branch system for occupations, togglable
var/const/MAP_HAS_RANK = 2		//Rank system, also togglable

/hook/startup/proc/initialise_map_list()
	for(var/type in typesof(/datum/map) - /datum/map)
		var/datum/map/M
		if(type == using_map.type)
			M = using_map
			M.setup_map()
		else
			M = new type
		if(!M.path)
			world << "<span class=danger>Map '[M]' does not have a defined path, not adding to map list!</span>"
			world.log << "Map '[M]' does not have a defined path, not adding to map list!"
		else
			all_maps[M.path] = M
	return 1

/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	proc/setup_map()
	var/path

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.
	var/list/shallow_levels = list()

	var/default_role = "Crewman"
	var/list/default_job_type = /datum/job/assistant
	var/list/allowed_jobs          //Job datums to use.
	                               //Works a lot better so if we get to a point where three-ish maps are used
	                               //We don't have to C&P ones that are only common between two of them
	                               //That doesn't mean we have to include them with the rest of the jobs though, especially for map specific ones.
	                               //Also including them lets us override already created jobs, letting us keep the datums to a minimum mostly.
	                               //This is probably a lot longer explanation than it needs to be.
	// Unit test vars
	var/list/exempt_areas = list()
	var/const/NO_APC = 1
	var/const/NO_VENT = 2
	var/const/NO_SCRUBBER = 4

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_called_message
	var/emergency_shuttle_recall_message
	var/single_card_authentication = FALSE

	var/datum/trade_destination/stellar_location
	var/specific_location

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list() // map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
                                                  // this is in order to support multiple holodeck program listings for different holodecks
	                                              // second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
	                                              // as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/flags = 0
	var/evac_controller_type = /datum/evacuation_controller
	var/overmap_z = 0		//If 0 will generate overmap zlevel on init. Otherwise will populate the zlevel provided.

	var/test_x = 20
	var/test_y = 20
	var/test_z = 1

/datum/map/New()
	..()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!allowed_jobs)
		allowed_jobs = subtypesof(/datum/job)

// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/perform_map_generation()
	return

/datum/map/proc/refresh_mining_turfs()
	return

// Can be overridden/updated to be more interesting later.
/datum/map/proc/do_roundstart_intro()
	set waitfor = 0
	set background = 1

/datum/map/proc/update_locations()
	stellar_location = pick(all_trade_destinations)

/datum/map/proc/get_specific_location()
	return (specific_location ? specific_location : (stellar_location ? stellar_location.name : "Unknown"))

/proc/layer_is_shallow(var/layer)
	return using_map && (layer in using_map.shallow_levels)

/datum/map/proc/handle_captain_join(var/mob/living/carbon/human/captain)
	return