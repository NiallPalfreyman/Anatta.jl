function ntm()
	tfs = [
		180, 45, 39, 156, 54, 198, 177, 147, 27, 135,
		99, 201, 228, 30, 210, 108, 225, 141, 78, 75,
		120, 216, 57, 114, 135, 108, 78, 225, 210, 198,
		156, 216, 27, 39, 75, 141, 45, 30, 54, 177,
		114, 57, 99, 120, 201, 147, 180, 228, 78, 39,
		120, 108
	]
	switches = "00"			# initial switch settings
	z = 0					# uniselector position (internal state)

    while true
        println("\x1bcAshby Box:\n\n+----+\n| $(switches) |\n|    |")
        tf_bin = lpad(bitstring(tfs[z+1]), 8, '0')
        idx = parse(Int, switches, base=2) * 2 + 1
        lamps = tf_bin[idx:idx+1]
        println("| $lamps |\n+----+")
        print("\nSwitches on top, lamps at the bottom.\nToggle switches [1] or [2] or [q]uit. ")
        k = readline()
        if k == "1"
            switches = string(Int(switches[1]) ⊻ 1, switches[2])
        elseif k == "2"
            switches = string(switches[1], Int(switches[2]) ⊻ 1)
        elseif k == "q"
            break
        end
        z = (z + 1) % length(tfs)
    end
end
