;; initiating global varibales
globals [vision max-separate-turn max-align-turn max-cohere-turn catch-radius no-fish max-age no-caught no-red-fish no-yellow-fish no-green-fish catch-age
  days season year green-bycatch yellow-bycatch red-bycatch hook-caught pureseine-caught trawler-caught pureseine-bycatch hook-bycatch trawler-bycatch]


;; creating breeds for fish and types of boats
breed [fish fish-all]
fish-own [friends closest-friend age]

breed [trawler trawlers]
trawler-own [fish-in-radius]

breed [hook_and_line hook_and_lines]
hook_and_line-own [fish-in-radius]

breed [pureseine pureseines]
pureseine-own [fish-in-radius friends]



to setup
  clear-all
  ;; sea background import
  import-drawing "sea.jpeg"

  ;; creating fish
  create-fish no_fish_yellow [
    set color YELLOW
    set heading random 360
    set shape "fish 2"
    set xcor random-xcor
    set ycor random-ycor
    set age 2 + random-float 1
    set size age
  ]

  create-fish no_fish_red [
    set color RED
    set heading random 360
    set shape "fish 2"
    set xcor random-xcor
    set ycor random-ycor
    set age 2 + random-float 1
    set size age
  ]

  create-fish no_fish_green [
    set color GREEN
    set heading random 360
    set shape "fish 2"
    set xcor random-xcor
    set ycor random-ycor
    set age 2 + random-float 1
    set size age
  ]

  ;; creating trawlers
  create-trawler no_trawlers[
    set color GREY
    set heading random 360
    set shape "net"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_trawler
  ]

  ;; creating hook and line
  create-hook_and_line no_red_hook_and_line[
    set color RED
    set heading random 360
    set shape "fishing pole"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_hook_and_line
  ]

  create-hook_and_line no_yellow_hook_and_line[
    set color YELLOW
    set heading random 360
    set shape "fishing pole"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_hook_and_line
  ]

  create-hook_and_line no_green_hook_and_line[
    set color GREEN
    set heading random 360
    set shape "fishing pole"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_hook_and_line
  ]

  ;; creating pure seine
  create-pureseine no_red_pure_seine[
    set color RED
    set heading random 360
    set shape "boat"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_pure_seine
    set fish-in-radius 0
  ]

  create-pureseine no_yellow_pure_seine[
    set color YELLOW
    set heading random 360
    set shape "boat"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_pure_seine
    set fish-in-radius 0
  ]

  create-pureseine no_green_pure_seine[
    set color GREEN
    set heading random 360
    set shape "boat"
    set xcor random-xcor
    set ycor random-ycor
    set size net_size_pure_seine
    set fish-in-radius 0
  ]

  ;; if fishing season on, change all pure seine and hook and line boats to the color of the fish in season
  ifelse fish_season = true [
    if season_one_fish = "Red"[
      ask pureseine[set color RED]
      ask hook_and_line [set color RED]
    ]
    if season_one_fish = "Green" [
      ask pureseine[set color GREEN]
      ask hook_and_line [set color GREEN]
    ]
    if season_one_fish = "Yellow" [
      ask pureseine[set color YELLOW]
      ask hook_and_line [set color YELLOW]
    ]
    output-print "Season 1 - Catching fish type:"
    output-print season_one_fish
  ][output-print "No seasonal fishing"]

  ;; set global variables
  ;; fish flocking variables
  set vision 10
  set max-separate-turn 1.5
  set max-align-turn 10
  set max-cohere-turn 6
  set catch-radius 100
  ;; fishing variables
  set no-fish count fish
  set no-red-fish 0
  set no-green-fish 0
  set no-yellow-fish 0
  set max-age 3
  set no-caught 0
  set days 0
  set season 1
  set year 1
  set red-bycatch 0
  set green-bycatch 0
  set yellow-bycatch 0
  set pureseine-bycatch 0
  set hook-bycatch 0
  set trawler-bycatch 0
  set catch-age 2.1

  reset-ticks

end

to go
  shoal
  ;; fish move 1 m in 1 hour
  ask fish [forward 1]

  ;; if during the day allow fishing
  if ticks < 12[
    ;; trawler moves slowly pulling the net - 5 m in 1 hour
    ask trawler [wiggle]
    ask trawler [forward 5]
    ;; trawler catches fish in it's radius
    ask trawler [trawler-catch]
    ;; hook and line catch fish in radius ( they don't move)
    ask hook_and_line [hook_and_line-catch]
    ;; pureseine align themselves with fish in their vision radius
    follow-fish
    ;; move forward 10 m in 1 hour
    ask pureseine [forward 10]
    ;; if enough fish in radius drop net and catch
    ask pureseine [puresiene-catch]
  ]
  ;; recalculate fish count
  count-fish

  ;; everyday increase fish age, allow fish to reproduce and die naturally, reset ticks for new day
  if ticks = 24 [
    new-fish
    increase-age
    old-fish
    set days  days + 1
    reset-ticks
  ]

  ;; if in season two change boats to new season fish color
  if days = 122 and ticks = 1[
    set season 2
    if fish_season = true [
      if season_two_fish = "Red"[
        ask pureseine[set color RED]
        ask hook_and_line [set color RED]
      ]
      if season_two_fish = "Green" [
        ask pureseine[set color GREEN]
        ask hook_and_line [set color GREEN]
      ]
      if season_two_fish = "Yellow" [
        ask pureseine[set color YELLOW]
        ask hook_and_line [set color YELLOW]
      ]

      output-print "Season 2 - Catching fish type:"
      output-print season_two_fish]]

  ;; if in season three change boats to new season fish color
  if days = 244 and ticks = 1 [
    set season 3
    if fish_season = true [
      if season_three_fish = "Red"[
        ask pureseine[set color RED]
        ask hook_and_line [set color RED]
      ]
      if season_three_fish = "Green" [
        ask pureseine[set color GREEN]
        ask hook_and_line [set color GREEN]
      ]
      if season_three_fish = "Yellow" [
        ask pureseine[set color YELLOW]
        ask hook_and_line [set color YELLOW]
      ]

      output-print "Season 3 - Catching fish type:"
      output-print season_three_fish]]

  ;; if new year set back to season 1 and increase year
  if days = 366 [
    set year year + 1
    set days 1
    set season 1
    if fish_season = true [
      if season_one_fish = "Red"[
        ask pureseine[set color RED]
        ask hook_and_line [set color RED]
      ]
      if season_one_fish = "Green" [
        ask pureseine[set color GREEN]
        ask hook_and_line [set color GREEN]
      ]
      if season_one_fish = "Yellow" [
        ask pureseine[set color YELLOW]
        ask hook_and_line [set color YELLOW]
      ]
      output-print "Season 1 - Catching fish type:"
      output-print season_one_fish]]

  ;; checking the fishing limits and removing or re-adding the boats accordingly for non-season fishing
  if fish_season = FALSE [
    ifelse count fish with[color = RED and age > catch-age] < red_lower_limit [
      if count pureseine with[color = RED] > 0 or count hook_and_line with[color = RED] > 0 [
        output-print "Red fishing prohibited"]
      ask pureseine with[color = RED] [DIE]
      ask hook_and_line with[color = RED] [DIE]
    ][
      if  count pureseine with[color = RED] = 0 and count hook_and_line with[color = RED] = 0 and (count fish with[color = RED and age > catch-age] > red_regenerated) [
        if no_red_pure_seine > 0 or no_red_hook_and_line > 0[
          output-print "Red fishing allowed"]

        create-pureseine no_red_pure_seine[
          set color RED
          set heading random 360
          set shape "boat"
          set xcor random-xcor
          set ycor random-ycor
          set size net_size_pure_seine
          set fish-in-radius 0
        ]

        create-hook_and_line no_red_hook_and_line[
          set color RED
          set heading random 360
          set shape "fishing pole"
          set xcor random-xcor
          set ycor random-ycor
          set size net_size_hook_and_line
        ]
      ]

    ]
    ifelse count fish with[color = GREEN and age > catch-age] < green_lower_limit [
      if count pureseine with[color = GREEN] > 0 or count hook_and_line with[color = GREEN] > 0 [
        output-print "Green fishing prohibited"]
      ask pureseine with[color = GREEN] [DIE]
      ask hook_and_line with[color = GREEN] [DIE]
    ][
      if count pureseine with[color = GREEN] = 0 and count hook_and_line with[color = GREEN] = 0 and  (count fish with[color = GREEN and age > catch-age] > green_regenerated) [
        if no_green_pure_seine > 0 or no_green_hook_and_line > 0[
          output-print "Green fishing allowed"]
        create-pureseine no_green_pure_seine[
          set color GREEN
          set heading random 360
          set shape "boat"
          set xcor random-xcor
          set ycor random-ycor
          set size net_size_pure_seine
          set fish-in-radius 0
        ]
        create-hook_and_line no_green_hook_and_line[
          set color GREEN
          set heading random 360
          set shape "fishing pole"
          set xcor random-xcor
          set ycor random-ycor
          set size net_size_hook_and_line
        ]
    ]]
    ifelse count fish with[color = YELLOW and age > catch-age] < yellow_lower_limit [
      if count pureseine with[color = YELLOW] > 0 or count hook_and_line with[color = YELLOW] > 0 [
        output-print "Yellow fishing prohibited"]
      ask pureseine with[color = YELLOW] [DIE]
      ask hook_and_line with[color = YELLOW] [DIE]
    ][
      if count pureseine with[color = YELLOW] = 0 and count hook_and_line with[color = YELLOW] = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated [
        if no_yellow_pure_seine > 0 or no_yellow_hook_and_line > 0[
          output-print "Yellow fishing allowed"]
        create-pureseine no_yellow_pure_seine[
          set color YELLOW
          set heading random 360
          set shape "boat"
          set xcor random-xcor
          set ycor random-ycor
          set size net_size_pure_seine
          set fish-in-radius 0
        ]
        create-hook_and_line no_yellow_hook_and_line[
          set color YELLOW
          set heading random 360
          set shape "fishing pole"
          set xcor random-xcor
          set ycor random-ycor
          set size net_size_hook_and_line
        ]
    ]]

  ]

  ;; if fishing seasonal add limits - regenerating  boats all for fish in season
  if fish_season = true [
    ;; for season one checks which color the seasonal fish is and kills/ regenerates boats accordingly
    if season = 1[

      if season_one_fish = "Red" [
        ifelse count fish with[color = RED and age > catch-age] < red_lower_limit [
          if count pureseine with[color = RED] > 0 or count hook_and_line with[color = RED] > 0 [
            output-print "Red fishing prohibited"]
          ask pureseine with[color = RED] [DIE]
          ask hook_and_line with[color = RED] [DIE]
        ][
          if  count pureseine with[color = RED] = 0 and count hook_and_line with[color = RED] = 0 and count fish with[color = RED and age < catch-age] > red_regenerated [
        if no_red_pure_seine > 0 or no_red_hook_and_line > 0[
          output-print "Red fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color RED
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color RED
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]

        ]]
      ]

      if season_one_fish = "Green" [
        ifelse count fish with[color = GREEN and age > catch-age] < green_lower_limit [
          if count pureseine with[color = GREEN] > 0 or count hook_and_line with[color = GREEN] > 0 [
            output-print "Green fishing prohibited"]
          ask pureseine with[color = GREEN] [DIE]
          ask hook_and_line with[color = GREEN] [DIE]
        ][
          if  count pureseine with[color = GREEN] = 0 and count hook_and_line with[color = GREEN] = 0 and count fish with[color = GREEN and age > catch-age] > green_regenerated [
        if no_green_pure_seine > 0 or no_green_hook_and_line > 0[
          output-print "Green fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color GREEN
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color GREEN
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]
        ]]
      ]

      if season_one_fish = "Yellow" [
        ifelse count fish with[color = YELLOW and age > catch-age] < yellow_lower_limit [
          if count pureseine with[color = YELLOW] > 0 or count hook_and_line with[color = YELLOW] > 0 [
            output-print "Yellow fishing prohibited"]
          ask pureseine with[color = YELLOW] [DIE]
          ask hook_and_line with[color = YELLOW] [DIE]
        ][
          if  count pureseine with[color = YELLOW] = 0 and count hook_and_line with[color = YELLOW] = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated [
        if no_yellow_pure_seine > 0 or no_yellow_hook_and_line > 0[
          output-print "Yellow fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color YELLOW
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color YELLOW
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]
        ]]
      ]


    ]

    if season = 2[
      if season_two_fish = "Red" [
        ifelse count fish with[color = RED and age > catch-age] < red_lower_limit [
          if count pureseine with[color = RED] > 0 or count hook_and_line with[color = RED] > 0 [
            output-print "Red fishing prohibited"]
          ask pureseine with[color = RED] [DIE]
          ask hook_and_line with[color = RED] [DIE]
        ][
          if  count pureseine with[color = RED] = 0 and count hook_and_line with[color = RED] = 0 and count fish with[color = RED and age > catch-age] > red_regenerated [
        if no_red_pure_seine > 0 or no_red_hook_and_line > 0[
          output-print "Red fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color RED
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color RED
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]

        ]]
      ]

      if season_two_fish = "Green" [
        ifelse count fish with[color = GREEN and age > catch-age] < green_lower_limit [
          if count pureseine with[color = GREEN] > 0 or count hook_and_line with[color = GREEN] > 0 [
            output-print "Green fishing prohibited"]
          ask pureseine with[color = GREEN] [DIE]
          ask hook_and_line with[color = GREEN] [DIE]
        ][
          if  count pureseine with[color = GREEN] = 0 and count hook_and_line with[color = GREEN] = 0 and count fish with[color = GREEN and age > catch-age] > green_regenerated [
        if no_green_pure_seine > 0 or no_green_hook_and_line > 0[
          output-print "Green fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color GREEN
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color GREEN
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]
        ]]
      ]

      if season_two_fish = "Yellow" [
        ifelse count fish with[color = YELLOW and age > catch-age] < yellow_lower_limit [
          if count pureseine with[color = YELLOW] > 0 or count hook_and_line with[color = YELLOW] > 0 [
            output-print "Yellow fishing prohibited"]
          ask pureseine with[color = YELLOW] [DIE]
          ask hook_and_line with[color = YELLOW] [DIE]
        ][
          if  count pureseine with[color = YELLOW] = 0 and count hook_and_line with[color = YELLOW] = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated [
        if no_yellow_pure_seine > 0 or no_yellow_hook_and_line > 0[
          output-print "Yellow fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color YELLOW
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color YELLOW
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]
        ]]
      ]


    ]

    if season = 3[
      if season_three_fish = "Red" [
        ifelse count fish with[color = RED and age > catch-age] < red_lower_limit [
          if count pureseine with[color = RED] > 0 or count hook_and_line with[color = RED] > 0 [
            output-print "Red fishing prohibited"]
          ask pureseine with[color = RED] [DIE]
          ask hook_and_line with[color = RED] [DIE]
        ][
          if  count pureseine with[color = RED] = 0 and count hook_and_line with[color = RED] = 0 and count fish with[color = RED and age > catch-age] > red_regenerated [
        if no_red_pure_seine > 0 or no_red_hook_and_line > 0[
          output-print "Red fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color RED
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color RED
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]

        ]]
      ]

      if season_three_fish = "Green" [
        ifelse count fish with[color = GREEN and age > catch-age] < green_lower_limit [
          if count pureseine with[color = GREEN] > 0 or count hook_and_line with[color = GREEN] > 0 [
            output-print "Green fishing prohibited"]
          ask pureseine with[color = GREEN] [DIE]
          ask hook_and_line with[color = GREEN] [DIE]
        ][
          if  count pureseine with[color = GREEN] = 0 and count hook_and_line with[color = GREEN] = 0 and count fish with[color = GREEN and age > catch-age] > green_regenerated [
        if no_green_pure_seine > 0 or no_green_hook_and_line > 0[
          output-print "Green fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color GREEN
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color GREEN
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]
        ]]
      ]

      if season_three_fish = "Yellow" [
        ifelse count fish with[color = YELLOW and age > catch-age] < yellow_lower_limit [
          if count pureseine with[color = YELLOW] > 0 or count hook_and_line with[color = YELLOW] > 0 [
            output-print "Yellow fishing prohibited"]
          ask pureseine with[color = YELLOW] [DIE]
          ask hook_and_line with[color = YELLOW] [DIE]
        ][
          if  count pureseine with[color = YELLOW] = 0 and count hook_and_line with[color = YELLOW] = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated [
        if no_yellow_pure_seine > 0 or no_yellow_hook_and_line > 0[
          output-print "Yellow fishing allowed"]
            create-pureseine no_red_pure_seine + no_green_pure_seine + no_yellow_pure_seine[
              set color YELLOW
              set heading random 360
              set shape "boat"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_pure_seine
              set fish-in-radius 0
            ]
            create-hook_and_line no_yellow_hook_and_line + no_green_hook_and_line + no_red_hook_and_line[
              set color YELLOW
              set heading random 360
              set shape "fishing pole"
              set xcor random-xcor
              set ycor random-ycor
              set size net_size_hook_and_line
            ]
        ]]
      ]


    ]
  ]

  ;; trawler limitations
  ifelse count fish with[color = YELLOW  and age > catch-age] < yellow_lower_limit [
    if count trawler > 0 [
      output-print "Trawlers prohibited"]
    ask trawler [DIE]][
    if  count trawler  = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated
    and count fish with[color = RED and age > catch-age] > red_regenerated and count fish with[color = GREEN and age > catch-age] > green_regenerated[
      ;;output-print "Trawler fishing allowed"
      create-trawler no_trawlers[
        set color GREY
        set heading random 360
        set shape "net"
        set xcor random-xcor
        set ycor random-ycor
        set size net_size_trawler
  ]]]

  ifelse count fish with[color = RED  and age > catch-age] < red_lower_limit [
    if count trawler > 0 [
      output-print "Trawlers prohibited"]
    ask trawler [DIE]][
    if  count trawler  = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated
    and count fish with[color = RED and age > catch-age] > red_regenerated and count fish with[color = GREEN and age > catch-age] > green_regenerated[
      ;;output-print "Trawler fishing allowed"
      create-trawler no_trawlers[
        set color GREY
        set heading random 360
        set shape "net"
        set xcor random-xcor
        set ycor random-ycor
        set size net_size_trawler
  ]]]

  ifelse count fish with[color = GREEN  and age > catch-age] < green_lower_limit [
    if count trawler > 0 [
      output-print "Trawlers prohibited"]
    ask trawler [DIE]][
    if  count trawler  = 0 and count fish with[color = YELLOW and age > catch-age] > yellow_regenerated
    and count fish with[color = RED and age > catch-age] > red_regenerated and count fish with[color = GREEN and age > catch-age] > green_regenerated[
      ;;output-print "Trawler fishing allowed"
      create-trawler no_trawlers[
        set color GREY
        set heading random 360
        set shape "net"
        set xcor random-xcor
        set ycor random-ycor
        set size net_size_trawler
  ]]]



  tick
end


;; function to count fish
to count-fish
  set no-fish count fish
end


;; function to allow older fish to die naturally
to old-fish
  ask fish[if age > 1.9 [
    if random-float 10 < death_rate [
      die]
  ]]

end

;; increases fish age
to increase-age
  ask fish [
    set age age + 0.01
    if age > max-age[
      set age max-age
    ]
    set size age
  ]
end

;; allows for fish of breeding age to reproduce
to new-fish
  ask fish [
    if age > 1.5 [
      if random-float 10 < reproduction_rate [
        hatch 1 [
          set color color
          set heading random 360
          set shape "fish 2"
          set xcor xcor
          set ycor ycor
          set age 2
          set size age
        ]
      ]
    ]
  ]
end

;; find fish of species in radius vision-var
to find-close-fish-friends [vision-var]
  if color = RED [
    set friends other fish with[color = RED] in-radius vision-var
  ]
  if color = YELLOW [
    set friends other fish with[color = YELLOW] in-radius vision-var
  ]
  if color = GREEN [
    set friends other fish with[color = GREEN] in-radius vision-var
  ]

end

;; finds the closest agent to itself
to find-closest-friend
  set closest-friend min-one-of friends [distance myself]
end

;; aligns and coheres pureseine to close fish, otherwise they move randomly
to follow-fish
  ask pureseine [
    find-close-fish-friends 40
    ifelse any? friends
    [;;align
      cohere
    ][wiggle]
  ]
end

;; aligns and coheres close fish, if too close they repel
to shoal
  ask fish [
    find-close-fish-friends vision
    if any? friends [find-closest-friend
      ifelse distance closest-friend < 2[
        separate]
      [align
        cohere]]]
end


;; catches fish in trawler's radius
to trawler-catch
  if season = 1[
    if season_one_fish = "Red"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = GREEN or color = YELLOW)] in-radius (net_size_trawler / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius (net_size_trawler / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
    if season_one_fish = "Green"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = RED or color = YELLOW)] in-radius (net_size_trawler / 2)
      set red-bycatch red-bycatch + count fish with[age > catch-age and color = RED] in-radius (net_size_trawler / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
    if season_one_fish = "Yellow"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = GREEN or color = RED)] in-radius (net_size_trawler / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius (net_size_trawler / 2)
      set red-bycatch red-bycatch + count fish with[age > catch-age and color = RED] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
  ]

    if season = 2[
    if season_two_fish = "Red"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = GREEN or color = YELLOW)] in-radius (net_size_trawler / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius (net_size_trawler / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
    if season_two_fish = "Green"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = RED or color = YELLOW)] in-radius (net_size_trawler / 2)
      set red-bycatch green-bycatch + count fish with[age > catch-age and color = RED] in-radius (net_size_trawler / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
    if season_two_fish = "Yellow"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = GREEN or color = RED)] in-radius (net_size_trawler / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius (net_size_trawler / 2)
      set red-bycatch yellow-bycatch + count fish with[age > catch-age and color = RED] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
  ]

    if season = 3[
    if season_three_fish = "Red"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = GREEN or color = YELLOW)] in-radius (net_size_trawler / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius (net_size_trawler / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
    if season_three_fish = "Green"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = RED or color = YELLOW)] in-radius (net_size_trawler / 2)
      set red-bycatch green-bycatch + count fish with[age > catch-age and color = RED] in-radius (net_size_trawler / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
    if season_three_fish = "Yellow"[
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set trawler-caught trawler-caught + count fish with[age > catch-age] in-radius ((net_size_trawler ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_trawler ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_trawler ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_trawler ) / 2)
      set trawler-bycatch trawler-bycatch + count fish with[age > catch-age and (color = GREEN or color = RED)] in-radius (net_size_trawler / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius (net_size_trawler / 2)
      set red-bycatch yellow-bycatch + count fish with[age > catch-age and color = RED] in-radius (net_size_trawler / 2)
      ask fish with[age > catch-age] in-radius ((net_size_trawler ) / 2) [die]
    ]
  ]
end

;; if enough fish in pureseine radius, net is dropped and fish in radius are caught
to puresiene-catch
  if color = RED [
    ifelse (count friends in-radius ((net_size_pure_seine ) / 2)) > 2[
      set shape "net"
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2)
      set pureseine-caught pureseine-caught + count fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_pure_seine) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_pure_seine ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_pure_seine ) / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_pure_seine ) / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_pure_seine ) / 2)
      set pureseine-bycatch pureseine-bycatch + count fish with[age > catch-age and (color = GREEN or color = YELLOW)] in-radius ((net_size_pure_seine ) / 2)
      ask fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2) [die]]
    [set shape "boat"]]
  if color = YELLOW [
    ifelse (count friends in-radius ((net_size_pure_seine ) / 2)) > catch-age [
      set shape "net"
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2)
      set pureseine-caught pureseine-caught + count fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_pure_seine ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_pure_seine ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_pure_seine ) / 2)
      set red-bycatch red-bycatch + count fish with[age > catch-age and color = RED] in-radius ((net_size_pure_seine ) / 2)
      set green-bycatch green-bycatch + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_pure_seine ) / 2)
      set pureseine-bycatch pureseine-bycatch + count fish with[age > catch-age and (color = GREEN or color = RED)] in-radius ((net_size_pure_seine ) / 2)
      ask fish  with[age > catch-age] in-radius ((net_size_pure_seine ) / 2) [die]]
    [set shape "boat"]]
  if color = GREEN [
    ifelse (count friends in-radius ((net_size_pure_seine ) / 2)) > 3[
      set shape "net"
      set no-caught no-caught + count fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2)
      set pureseine-caught pureseine-caught + count fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2)
      set no-red-fish no-red-fish + count fish with[age > catch-age and color = RED] in-radius ((net_size_pure_seine ) / 2)
      set no-yellow-fish no-yellow-fish + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_pure_seine ) / 2)
      set no-green-fish no-green-fish + count fish with[age > catch-age and color = GREEN] in-radius ((net_size_pure_seine ) / 2)
      set red-bycatch red-bycatch + count fish with[age > catch-age and color = RED] in-radius ((net_size_pure_seine ) / 2)
      set yellow-bycatch yellow-bycatch + count fish with[age > catch-age and color = YELLOW] in-radius ((net_size_pure_seine ) / 2)
      set pureseine-bycatch pureseine-bycatch + count fish with[age > catch-age and (color = RED or color = YELLOW)] in-radius ((net_size_pure_seine ) / 2)
      ask fish with[age > catch-age] in-radius ((net_size_pure_seine ) / 2) [die]]
    [set shape "boat"]]
end

;; catch fish of species in radius
to hook_and_line-catch
  if color = RED[
    set no-caught no-caught + count fish with [color = RED and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    set hook-caught hook-caught + count fish with [color = RED and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    set no-red-fish no-red-fish + count fish with[color = RED and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    ask fish with [color = RED and age > catch-age] in-radius ((net_size_hook_and_line ) / 2) [die]]
  if color = YELLOW[
    set no-caught no-caught + count fish with [color = YELLOW and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    set hook-caught hook-caught + count fish with [color = YELLOW and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    set no-yellow-fish no-yellow-fish + count fish with[color = YELLOW and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    ask fish with [color = YELLOW and age > catch-age] in-radius ((net_size_hook_and_line ) / 2) [die]]
  if color = GREEN[
    set no-caught no-caught + count fish with [color = GREEN and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    set hook-caught hook-caught + count fish with [color = GREEN and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    set no-green-fish no-green-fish + count fish with[color = GREEN and age > catch-age] in-radius ((net_size_hook_and_line ) / 2)
    ask fish with [color = GREEN and age > catch-age] in-radius ((net_size_hook_and_line ) / 2) [die]]
end


;; taken from flocking model
to turn-at-most [turn max-turn]
  ifelse abs turn > max-turn
    [ ifelse turn > 0
      [ rt max-turn ]
      [ lt max-turn ] ]
  [ rt turn ]
end

;; taken from flocking model
to turn-towards [new-heading max-turn]  ;; turtle procedure
  turn-at-most (subtract-headings new-heading heading) max-turn
end

;; taken from flocking model
to turn-away [new-heading max-turn]  ;; turtle procedure
  turn-at-most (subtract-headings heading new-heading) max-turn
end

;; taken from flocking model
to separate  ;; turtle procedure
  turn-away ([heading] of closest-friend) max-separate-turn
end

;; taken from flocking model
to align
  turn-towards average-shoal-heading max-align-turn
end

;; taken from flocking model
to cohere  ;; turtle procedure
  turn-towards average-heading-towards-friends max-cohere-turn
end

;; taken from sheep and wolf model
to wiggle
  ;; turn right then left, so the average is straight ahead
  rt random 90
  lt random 90
end

;; taken from flocking model
to-report average-shoal-heading  ;; turtle procedure
                                 ;; We can't just average the heading variables here.
                                 ;; For example, the average of 1 and 359 should be 0,
                                 ;; not 180.  So we have to use trigonometry.
  let x-component sum [dx] of friends
  let y-component sum [dy] of friends
  ifelse x-component = 0 and y-component = 0
    [ report heading ]
  [ report atan x-component y-component ]
end

;; taken from flocking model
to-report average-heading-towards-friends  ;; turtle procedure
                                           ;; "towards myself" gives us the heading from the other turtle
                                           ;; to me, but we want the heading from me to the other turtle,
                                           ;; so we add 180
  let x-component mean [sin (towards myself + 180)] of friends
  let y-component mean [cos (towards myself + 180)] of friends
  ifelse x-component = 0 and y-component = 0
    [ report heading ]
  [ report atan x-component y-component ]
end
@#$#@#$#@
GRAPHICS-WINDOW
467
62
1078
674
-1
-1
3.0
1
10
1
1
1
0
1
1
1
-100
100
-100
100
1
1
1
ticks
30.0

BUTTON
167
23
233
56
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
248
23
311
56
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
26
95
165
128
no_fish_yellow
no_fish_yellow
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
169
96
308
129
no_fish_red
no_fish_red
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
312
96
453
129
no_fish_green
no_fish_green
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
28
402
232
435
no_trawlers
no_trawlers
0
10
0.0
1
1
NIL
HORIZONTAL

MONITOR
1086
527
1239
572
total fish available
no-fish
17
1
11

PLOT
1085
186
1248
336
Fish available
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot count fish with[color = RED]"
"pen-1" 1.0 0 -1184463 true "" "plot count fish with[color = YELLOW]"
"pen-2" 1.0 0 -10899396 true "" "plot count fish with[color = GREEN]"

PLOT
1253
186
1413
336
Number caught
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot no-red-fish"
"pen-1" 1.0 0 -1184463 true "" "plot no-yellow-fish"
"pen-2" 1.0 0 -10899396 true "" "plot no-green-fish"

SLIDER
29
159
233
192
reproduction_rate
reproduction_rate
0
1
0.4
0.05
1
NIL
HORIZONTAL

TEXTBOX
576
18
1017
65
AT WHAT POINT IS FISHING SUSTAINABLE?  ><(((*>
17
0.0
1

TEXTBOX
181
194
331
213
FISHING METHODS
14
0.0
1

TEXTBOX
184
73
334
92
NUMBER OF FISH
14
0.0
1

SLIDER
238
158
447
191
death_rate
death_rate
0
1
0.35
0.05
1
NIL
HORIZONTAL

TEXTBOX
186
134
336
153
FISH VARIABLES\n
14
0.0
1

TEXTBOX
169
440
331
474
SUSTAINABLE FISHING 
14
0.0
1

CHOOSER
18
522
225
567
season_one_fish
season_one_fish
"Red" "Yellow" "Green"
1

SWITCH
18
481
225
514
fish_season
fish_season
1
1
-1000

MONITOR
1093
11
1161
56
hours
ticks
17
1
11

OUTPUT
1092
59
1410
182
13

MONITOR
1176
10
1243
55
day
days
17
1
11

MONITOR
1343
11
1408
56
season
season
17
1
11

MONITOR
1259
11
1325
56
year
year
17
1
11

CHOOSER
19
575
226
620
season_two_fish
season_two_fish
"Red" "Yellow" "Green"
0

CHOOSER
20
627
226
672
season_three_fish
season_three_fish
"Red" "Yellow" "Green"
2

SLIDER
26
231
233
264
no_green_hook_and_line
no_green_hook_and_line
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
26
268
233
301
no_red_hook_and_line
no_red_hook_and_line
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
26
305
232
338
no_yellow_hook_and_line
no_yellow_hook_and_line
0
10
0.0
1
1
NIL
HORIZONTAL

TEXTBOX
97
215
247
233
Hook and Line
11
0.0
1

SLIDER
25
342
232
375
net_size_hook_and_line
net_size_hook_and_line
15
30
15.0
1
1
NIL
HORIZONTAL

SLIDER
238
230
444
263
no_green_pure_seine
no_green_pure_seine
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
238
267
446
300
no_red_pure_seine
no_red_pure_seine
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
238
305
446
338
no_yellow_pure_seine
no_yellow_pure_seine
0
10
0.0
1
1
NIL
HORIZONTAL

SLIDER
238
342
446
375
net_size_pure_seine
net_size_pure_seine
15
30
15.0
1
1
NIL
HORIZONTAL

TEXTBOX
319
211
469
229
Pure Seine\n
11
0.0
1

INPUTBOX
237
612
342
672
green_lower_limit
0.0
1
0
Number

INPUTBOX
236
548
342
608
red_lower_limit
0.0
1
0
Number

INPUTBOX
236
486
344
546
yellow_lower_limit
0.0
1
0
Number

SLIDER
238
402
446
435
net_size_trawler
net_size_trawler
15
30
15.0
1
1
NIL
HORIZONTAL

MONITOR
1259
527
1411
572
total fish caught
no-caught
17
1
11

INPUTBOX
348
487
461
547
yellow_regenerated
0.0
1
0
Number

INPUTBOX
347
550
462
610
red_regenerated
0.0
1
0
Number

INPUTBOX
346
613
461
673
green_regenerated
0.0
1
0
Number

TEXTBOX
207
381
357
399
Trawlers\n
11
0.0
1

TEXTBOX
69
459
219
477
Fishing seasonallly
11
0.0
1

TEXTBOX
313
462
463
480
Adding limits
11
0.0
1

MONITOR
1084
378
1159
423
green fish
count fish with[color = GREEN]
17
1
11

MONITOR
1085
428
1158
473
red fish
count fish with[color = RED]
17
1
11

MONITOR
1086
477
1158
522
yellow fish
count fish with[color = YELLOW]
17
1
11

MONITOR
1166
378
1236
423
green fish
count fish with[color = GREEN and age > catch-age]
17
1
11

TEXTBOX
1097
347
1139
365
All fish
11
0.0
1

TEXTBOX
1164
342
1236
369
Fish above catch age
11
0.0
1

MONITOR
1167
428
1236
473
red fish
count fish with[color = RED and age > catch-age]
17
1
11

MONITOR
1167
477
1237
522
yellow fish
count fish with[color = YELLOW and age > catch-age]
17
1
11

MONITOR
1256
377
1325
422
green fish
no-green-fish
17
1
11

MONITOR
1258
427
1325
472
red fish
no-red-fish
17
1
11

MONITOR
1259
477
1326
522
yellow fish
no-yellow-fish
17
1
11

TEXTBOX
1273
350
1326
368
All fish
11
0.0
1

MONITOR
1334
377
1409
422
green fish
green-bycatch
17
1
11

MONITOR
1335
426
1409
471
red fish
red-bycatch
17
1
11

MONITOR
1335
476
1410
521
yellow fish
yellow-bycatch
17
1
11

TEXTBOX
1346
350
1496
368
Bycatch\n
11
0.0
1

TEXTBOX
1098
575
1182
593
Hook and line
11
0.0
1

TEXTBOX
1216
574
1276
592
Pure Seine\n
11
0.0
1

TEXTBOX
1333
574
1483
592
Trawler\n
11
0.0
1

MONITOR
1094
589
1181
634
total caught
hook-caught
17
1
11

MONITOR
1094
637
1181
682
bycatch
hook-bycatch
17
1
11

MONITOR
1204
589
1291
634
total caught
pureseine-caught
17
1
11

MONITOR
1205
638
1292
683
bycatch
pureseine-bycatch
17
1
11

MONITOR
1312
589
1399
634
total caught
trawler-caught
17
1
11

MONITOR
1312
638
1399
683
bycatch
trawler-bycatch
17
1
11

@#$#@#$#@
## WHAT IS IT?

With fish populations dwindling as a result of over fishing, it is a necessity to put in place rules for the purpose of sustaining both the fish population and the fishing industry. This model therefore aims to assist decision makers when determining which regulations should be enacted, allowing them to run a simulated model and visualize how the fish population would deplete/grow if different fishing regulations were implemented. Sustainibilty includes both the catching of specific fish species and the amount of bycatch inevitably caught.

## HOW IT WORKS

Fish agents are given rules depicting their movement, reproduction and life span. Their movement is based on their species; fish of the same species flock together resulting in schools of fish. Different fish species do not repel each other and this results in shoals being formed. Once a fish reaches a certain age, it has a probability of reproducing each day which is detmined by the user, similarly when a fish reaches near the end of it's lifespan it has a probaility of dying each day. Since the amount of fish needed cannot not be modelled effectively, it must be assumed that 1 fish represents 100 fish.

The other agents are the fishing boats, there are three different types each having their own specific behavior. A fishing boat's size depends on it's net size, as specified by the user. All fishing is limited to the day, and no fishing occurs between hours 13:00 - 24:00.

Trawlers move around randomly catching fish of all species in their net radius, once a fish is caught it dies. The trawlers do not catch young fish, as generally they would slip through the holes in the net.

Hook-and-line fishing vessels remain stationary and only catch fish of a certain species (other species are assumed to be released) in their catchment radius. It is assumed there are multiple fisherman on the boat to form the radius. The hook-and-line fisherman are assumed to not catch fish which are too young.

Purse-seine fishing targets specific species, they pick up fish of the target species in their vision range and follow them, if there are more than 2 fish in thier vision radius the net is "dropped" and they catch fish of all species in their radius. They are not able to catch fish that are too young as they are assumed to be able to escape through the holes in the net.

The model ticks on the hour, each day a fish grows and has a probability of reproducing or dying. There are three fishing seasons, season 1 (day 1 to day 122), season 2 (day 123 to day 244) and season 3 (day 245 to 365). 

The user can decide if fishing should be seasonal, if seasonal, all purse-seine vessels and hook-and-line vessels will be changed to target the seasonal fish. 

The user can add in fishing limitations; if lower limits are implemented, then when a species reaches below their threshold all targeted fishing and trawlers are banned. These forms of fishing are only re-permitted when the fish have recovered to above a target population again. Note, trawlers are banned if any species is below their threshold level.

Each patch represents 1 m^2 of sea.


## HOW TO USE IT

### SETTING UP THE MODEL

1. Press the setup up button twice in order to load the background.

1. Choose the number of fish, there are three species and so you can choose the ratios between the fish, for example, if there is a fish species currently under threat then one may include only a few of them. The number of fish can be set using the sliders **green_fish**, **red_fish** and **yellow_fish**, the colors represent how the species will be represented in the visualisation.

2. Set up the reproduction and death rates of the fish in order to replicate whether the fish are rapidly growing, naturally dwindling, or at equallibrium. This can be done using **death_rate** and **reproduction_rate**

3. Choose how many hook-and-line vessels you want in the area for each specific species using **no_green_hook_and_line**, **no_red_hook_and_line** and **no_yellow_hook_and_line**. And set their net size using **net_size_hook_and_line**

4. Choose how many purse-seine vessels you want in the area for each specific species using **no_green_pure_seine**, **no_red_pure_seine** and **no_yellow_pure_seine**. And set their net size using **net_size_pure_seine**.

5. Choose the number of trawlers you want using **no_trawlers** and set their catch radius using **net_size_trawler**.

6. Now that the agents are set up, you can choose what sustainable fishing regulations to implement. You can choose whether the purse-seine and hook-and-line should fish seasonly using the swich **fish_season**. If fishing seasonly, you can choose which color fish should be fished in which season using the drop down menus, **season_one_fish**, **season_two_fish** and **season_three_fish**. 

7. Limitations can be set for each species in order to stop the over depletion of a specific species. **yellow_lower_limit**, **green_lower_limit** and **red_lower_limit** indicate the number of fish which will trigger the ban of purse-seine, hook-and-line for that specific species and trawlers as they target all the species. These fishing methods will be banned until the species population has reached a level of **yellow_regenerated**, **green_regenerated** and **red_regenerated**. If there are no limitations, the inputs can be set to 0.


### MONITORING THE OUTPUTS

1. The monitors at the top represent the year, day, hour and season.

2. The text output informs you when a fishing season changes, a fishing method is banned or a fishing method's fishing rights are reinstated.

3. The graphs show the amount of fish currently in the sea and how many have been caught for each species.

4. The monitors below the graphs show the numbers of the fish in the sea and how many of those are at catching age (a fish becomes of catching age after 10 days). They also show how many have been caught and how many of those have been bycatch. Bycatch for purse-seine and hook-and-line is defined as any fish caught by the boat that is not the boat's targeted species. Bycatch for trawlers is defined as any fish caught that is not in season as set up by the drop down menus.

5. The monitors at the bottom show how many fish have been caught by each fishing method and how many of them were bycatch.


## THINGS TO NOTICE

1. If one is just looking at the fish, they start off scattered randomly but start to flock together in their same species, this allows schools (tight groups of the same species) to be formed, since the different species do not repel each other shoals (loose groups of different species) are also formed. If you turn off the fishing and slow the model down, you can see these phenomena. 

2. If you monitor the bycatch, the amount of bycatch caused by the trawlers is much higher than the purse seine

3. Purse-seine fishing, despite being targeted, can get in the way of another species regeneration if the species population is low.

4. Trawlers tend to lead to quickened overfishing, when fishing limitations are added        trawlers tend to be prohibited for the majority of the year.


## THINGS TO TRY

1. Setting all fishing methods to 0, and number of fish species to 33, 66 and 100,
	1. Set the **death_rate** and **reproduction_rate** to 0.3 to see an on average              stable fish population and how the initial number of fish affects it.
	2. Set the **death_rate** to 0.35 and **reproduction_rate** to 0.4 to see an on              average increasing fish population and how the initial number of fish affects             it.

2. Leave the **death_rate** at 0.35 and the **reproduction_rate** at 0.4 and set all fish    populations to 100, try individual fishing methods one at a time to see their effect.
	1. Set **no_green_hook_and_line**, **no_red_hook_and_line** and                              **no_yellow_hook_and_line** to 1
	2. Set **no_green_pure_seine**, **no_red_pure_seine** and                                    **no_yellow_pure_seine** to 1
	3. Set **no_trawlers** to 1

3. Run number 2, with different net sizes, to see the effect on number of fish caught.


4.  Set **no_green_hook_and_line**, **no_red_pure_seine**, **no_yellow_pure_seine** and       **no_trawler** to 1 in order to see the combined effect of the fishing methods.

5. Leaving the previously chosen fishing methods in place, add in fishing limitations, try 20 for **yellow_lower_limit**, **green_lower_limit** and **red_lower_limit** and 30       for **yellow_regenerated**, **green_regenerated** and **red_regenerated**

6. Remove the fishing limitations by setting all limitations to 0, and turn                   **fish_season** on in order to see the effect of seasonal fishing.

7. Add the limitations back, in order to see the combination of seasonal fishing and         fishing bans. 


## EXTENDING THE MODEL

A recommendation for extending the model would be to include:

1. The ability to allow for more species,
2. The ability to add coral areas,
3. The ability to add police boats and rogue fisherman,
4. The ability to have shorter fishing seasons,
5. The ability to add a bigger fishing area, at the moment the model is dictated by the      fish size, if you go any smaller the fish can't be seen.

## RELATED MODELS

The movement of the fish is very similar to the flocking model, in order to further adjust the fish's movement in the code (they parameters are set in the globals), the flocking model can be looked into.

## CREDITS AND REFERENCES

1. The flocking model was used in order to implement the flocking of the fish.

2. The wolf and sheep model was used for the wiggle function which is used for random movement.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat 2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat 3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

fish 2
false
0
Polygon -1 true false 56 133 34 127 12 105 21 126 23 146 16 163 10 194 32 177 55 173
Polygon -7500403 true true 156 229 118 242 67 248 37 248 51 222 49 168
Polygon -7500403 true true 30 60 45 75 60 105 50 136 150 53 89 56
Polygon -7500403 true true 50 132 146 52 241 72 268 119 291 147 271 156 291 164 264 208 211 239 148 231 48 177
Circle -1 true false 237 116 30
Circle -16777216 true false 241 127 12
Polygon -1 true false 159 228 160 294 182 281 206 236
Polygon -7500403 true true 102 189 109 203
Polygon -1 true false 215 182 181 192 171 177 169 164 152 142 154 123 170 119 223 163
Line -16777216 false 240 77 162 71
Line -16777216 false 164 71 98 78
Line -16777216 false 96 79 62 105
Line -16777216 false 50 179 88 217
Line -16777216 false 88 217 149 230

fish 3
false
0
Polygon -7500403 true true 137 105 124 83 103 76 77 75 53 104 47 136
Polygon -7500403 true true 226 194 223 229 207 243 178 237 169 203 167 175
Polygon -7500403 true true 137 195 124 217 103 224 77 225 53 196 47 164
Polygon -7500403 true true 40 123 32 109 16 108 0 130 0 151 7 182 23 190 40 179 47 145
Polygon -7500403 true true 45 120 90 105 195 90 275 120 294 152 285 165 293 171 270 195 210 210 150 210 45 180
Circle -1184463 true false 244 128 26
Circle -16777216 true false 248 135 14
Line -16777216 false 48 121 133 96
Line -16777216 false 48 179 133 204
Polygon -7500403 true true 241 106 241 77 217 71 190 75 167 99 182 125
Line -16777216 false 226 102 158 95
Line -16777216 false 171 208 225 205
Polygon -1 true false 252 111 232 103 213 132 210 165 223 193 229 204 247 201 237 170 236 137
Polygon -1 true false 135 98 140 137 135 204 154 210 167 209 170 176 160 156 163 126 171 117 156 96
Polygon -16777216 true false 192 117 171 118 162 126 158 148 160 165 168 175 188 183 211 186 217 185 206 181 172 171 164 156 166 133 174 121
Polygon -1 true false 40 121 46 147 42 163 37 179 56 178 65 159 67 128 59 116

fishing pole
false
0
Polygon -7500403 false true 210 240 225 225 240 240 210 240
Circle -7500403 false true 210 195 30
Line -7500403 true 225 195 225 105
Line -7500403 true 15 210 135 210
Line -7500403 true 45 255 105 255
Line -7500403 true 105 255 135 210
Line -7500403 true 45 255 15 210
Polygon -1 true false 15 210 135 210 105 255 45 255
Line -7500403 true 225 105 105 210
Circle -7500403 true true 210 195 30
Polygon -7500403 true true 210 240 225 225 240 240

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

net
true
0
Circle -7500403 false true 41 41 218
Circle -7500403 false true 63 63 175
Circle -7500403 false true 88 88 124
Circle -7500403 false true 116 116 67
Line -7500403 true 150 255 150 45
Line -7500403 true 45 150 255 150
Line -7500403 true 75 225 225 75
Line -7500403 true 75 75 225 225

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269
Circle -7500403 false true 59 59 182
Circle -7500403 false true 74 74 153
Circle -7500403 false true 88 88 124
Circle -7500403 false true 105 105 90
Circle -7500403 false true 44 44 212

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>year = 2</exitCondition>
    <metric>no-red-fish</metric>
    <metric>no-green-fish</metric>
    <metric>no-yellow-fish</metric>
    <metric>count fish with[color = RED]</metric>
    <metric>count fish with[color = GREEN]</metric>
    <metric>count fish with[color = YELLOW]</metric>
    <metric>hook-caught</metric>
    <metric>pureseine-caught</metric>
    <metric>pureseine-bycatch</metric>
    <metric>trawler-caught</metric>
    <metric>trawler-bycatch</metric>
    <enumeratedValueSet variable="no_green_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_three_fish">
      <value value="&quot;Green&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_lower_limit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_lower_limit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproduction_rate">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_one_fish">
      <value value="&quot;Yellow&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_hook_and_line">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_regenerated">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_pure_seine">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_green_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_lower_limit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_regenerated">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_trawler">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_red">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_regenerated">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_two_fish">
      <value value="&quot;Red&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_trawlers">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish_season">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_green">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_hook_and_line">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death_rate">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_pure_seine">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_yellow">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="limits" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>year = 2</exitCondition>
    <metric>no-red-fish</metric>
    <metric>no-green-fish</metric>
    <metric>no-yellow-fish</metric>
    <metric>count fish with[color = RED]</metric>
    <metric>count fish with[color = GREEN]</metric>
    <metric>count fish with[color = YELLOW]</metric>
    <metric>hook-caught</metric>
    <metric>pureseine-caught</metric>
    <metric>pureseine-bycatch</metric>
    <metric>trawler-caught</metric>
    <metric>trawler-bycatch</metric>
    <enumeratedValueSet variable="no_green_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_three_fish">
      <value value="&quot;Green&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_lower_limit">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_lower_limit">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproduction_rate">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_one_fish">
      <value value="&quot;Yellow&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_hook_and_line">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_regenerated">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_pure_seine">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_green_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_lower_limit">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_regenerated">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_trawler">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_red">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_regenerated">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_two_fish">
      <value value="&quot;Red&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_trawlers">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish_season">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_green">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_hook_and_line">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death_rate">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_pure_seine">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_yellow">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="season" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>year = 2</exitCondition>
    <metric>no-red-fish</metric>
    <metric>no-green-fish</metric>
    <metric>no-yellow-fish</metric>
    <metric>count fish with[color = RED]</metric>
    <metric>count fish with[color = GREEN]</metric>
    <metric>count fish with[color = YELLOW]</metric>
    <metric>hook-caught</metric>
    <metric>pureseine-caught</metric>
    <metric>pureseine-bycatch</metric>
    <metric>trawler-caught</metric>
    <metric>trawler-bycatch</metric>
    <enumeratedValueSet variable="no_green_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_three_fish">
      <value value="&quot;Green&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_lower_limit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_lower_limit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproduction_rate">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_one_fish">
      <value value="&quot;Yellow&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_hook_and_line">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_regenerated">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_pure_seine">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_green_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_lower_limit">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_regenerated">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_trawler">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_red">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_regenerated">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_two_fish">
      <value value="&quot;Red&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_trawlers">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish_season">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_green">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_hook_and_line">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death_rate">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_pure_seine">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_yellow">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="seasonlimit" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <exitCondition>year = 2</exitCondition>
    <metric>no-red-fish</metric>
    <metric>no-green-fish</metric>
    <metric>no-yellow-fish</metric>
    <metric>count fish with[color = RED]</metric>
    <metric>count fish with[color = GREEN]</metric>
    <metric>count fish with[color = YELLOW]</metric>
    <metric>hook-caught</metric>
    <metric>pureseine-caught</metric>
    <metric>pureseine-bycatch</metric>
    <metric>trawler-caught</metric>
    <metric>trawler-bycatch</metric>
    <enumeratedValueSet variable="no_green_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_three_fish">
      <value value="&quot;Green&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_lower_limit">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_lower_limit">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="reproduction_rate">
      <value value="0.4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_one_fish">
      <value value="&quot;Yellow&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_hook_and_line">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_regenerated">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_red_pure_seine">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_green_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="yellow_lower_limit">
      <value value="50"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_pure_seine">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="red_regenerated">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_trawler">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_red">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="green_regenerated">
      <value value="80"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="season_two_fish">
      <value value="&quot;Red&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_trawlers">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish_season">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_yellow_hook_and_line">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_green">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_hook_and_line">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="death_rate">
      <value value="0.35"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="catch_radius_pure_seine">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_fish_yellow">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
