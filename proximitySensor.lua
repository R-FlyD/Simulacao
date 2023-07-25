function sysCall_init()
    -- do some initialization here
end

function sysCall_actuation()
    -- put your actuation code here
end

function sysCall_sensing()
    sim.handleProximitySensor(sim.handle_all_except_explicit)
end

function sysCall_cleanup()
    sim.handleChildScripts(sim.syscb_cleanup)
    sim.resetProximitySensor(sim.handle_all_except_explicit)
end

-- See the user manual or the available code snippets for additional callback functions and details