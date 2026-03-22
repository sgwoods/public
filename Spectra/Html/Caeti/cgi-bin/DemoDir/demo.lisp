(load "forms-to-planner-utils.fasl")
(load "forms-to-planner.fasl")
(load-planner)
(demo 
:theStartForm "Herringbone"
:theStartCoords "390175"
:MinDuration "60"
:MaxDuration "180"
:one-leg? "on"
:Leg1Tform "Column"
:Leg1TravT "Traveling_technique"
:Leg1BDrill "Contact_w_small_arms"
:Leg1StopForm "NONE"
:two-legs? "on"
:Leg2Tform "NONE_bounding_overwatch"
:Leg2TravT "Bounding_overwatch"
:Leg2BDrill "Defend_against_popup_air_attack"
:Leg2StopForm "NONE"
:three-legs? "on"
:Leg3Tform "Vee"
:Leg3TravT "Traveling_overwatch"
:Leg3BDrill "NONE"
:Leg3StopForm "Coil"
)
:exit